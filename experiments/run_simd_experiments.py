"""Run paired scalar/SIMD configurations; keep thread counts fixed in each comparison."""
import argparse
import csv
import ctypes
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import platform
import random
import subprocess
import sys
import shutil
import time

ROOT = Path(__file__).resolve().parents[1]

def command(args, **kwargs):
    return subprocess.run(args, cwd=ROOT, check=True, capture_output=True,
                          text=True, timeout=30, **kwargs).stdout.strip()

def hardware():
    script = """@{
        cpu = @(Get-CimInstance Win32_Processor | Select-Object Name,NumberOfCores,NumberOfLogicalProcessors)
        computer = Get-CimInstance Win32_ComputerSystem | Select-Object TotalPhysicalMemory
        os = Get-CimInstance Win32_OperatingSystem | Select-Object Caption,Version
    } | ConvertTo-Json -Depth 4"""
    return json.loads(command(["powershell.exe", "-NoProfile", "-Command", script]))

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()
    config = json.loads((ROOT / "experiments/config.json").read_text())
    configurations = [(n, method, threads, variant) for variant in ("scalar", "simd") for n in config["sizes"]
                      for method, threads in [("sequential", 1)] +
                      [("parallel", t) for t in config["threads"]]]
    if args.dry_run:
        print(json.dumps(config, indent=2))
        print(f"{len(configurations)} configurations; {len(configurations)*5} measured samples")
        return
    environment = hardware()  # Fail rather than silently invent hardware details.
    logical = sum(cpu["NumberOfLogicalProcessors"] for cpu in environment["cpu"])
    if max(config["threads"]) > logical:
        raise ValueError("Configured thread counts exceed available logical processors")
    assert ctypes.sizeof(ctypes.c_int) == 4, "This protocol requires 32-bit C int"
    assert config["repetitions"] == 5 and config["warmups"] == 2
    for n in config["sizes"]:
        if 12*n*n > config["matrix_storage_budget_bytes"] or 100*n > 2147483647:
            raise ValueError("Configured size exceeds declared memory/arithmetic budget")
    output = ROOT / "results/simd/runs" / datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S%fZ")
    output.mkdir(parents=True)
    (ROOT / "build").mkdir(exist_ok=True)
    (ROOT / "experiments/matrix").mkdir(parents=True, exist_ok=True)
    env = os.environ.copy()
    # Remove inherited affinity/thread controls before setting the declared ones.
    for key in list(env):
        if key.startswith(("OMP_", "GOMP_", "KMP_")):
            del env[key]
    env.update(config["openmp_environment"])
    command([sys.executable, "experiments/build_simd.py"])
    shutil.copytree(ROOT / "results/simd/build", output / "build_evidence")
    build_metadata = json.loads((output / "build_evidence/metadata.json").read_text())
    config["compiler_flags"] = {v: build_metadata["base_flags"] + flags
                                for v, flags in build_metadata["variants"].items()}
    correctness = build_metadata["correctness"]
    inputs = {}
    for n in config["sizes"]:
        rng = random.Random(config["seed"])
        for label in ("A", "B"):
            path = ROOT / f"experiments/matrix/{label}_{n}.csv"
            with path.open("w", newline="") as f:
                writer = csv.writer(f)
                for _ in range(n):
                    writer.writerow([rng.randint(config["minimum"], config["maximum"])
                                     for _ in range(n)])
            inputs[path.name] = hashlib.sha256(path.read_bytes()).hexdigest()
    random.Random(config["order_seed"]).shuffle(configurations)
    metadata = {"config": config, "build_metadata": build_metadata, "hardware": environment, "python": sys.version,
                "platform": platform.platform(), "compiler": command(["gcc", "--version"]),
                "correctness": correctness, "input_sha256": inputs,
                "configuration_order": configurations,
                "source_sha256": {str(f.relative_to(ROOT)): hashlib.sha256(f.read_bytes()).hexdigest()
                                  for f in sorted((ROOT / "c").glob("*")) if f.is_file()},
                "note": "Memory is matrix storage only. Affinity is not pinned. No BLAS library is used."}
    (output / "environment.json").write_text(json.dumps(metadata, indent=2))
    deadline = time.monotonic() + config["campaign_timeout_seconds"]
    checksums = {}
    with (output / "raw.csv").open("w", newline="") as raw, (output / "status.csv").open("w", newline="") as status:
        writer = csv.writer(raw)
        writer.writerow(["method", "size", "requested_threads", "actual_threads", "repetition",
                         "seconds", "checksum", "numeric_type", "matrix_storage_bytes", "variant"])
        states = csv.writer(status)
        states.writerow(["size", "method", "threads", "variant", "status", "detail"])
        for n, method, threads, variant in configurations:
            remaining = deadline-time.monotonic()
            if remaining <= 0:
                states.writerow([n, method, threads, variant, "not_attempted", "campaign time budget reached"])
                status.flush()
                continue
            executable = ROOT / f"build/simd/{variant}/matrix_{method}.exe"
            argv = [str(executable), str(n)] + ([str(threads)] if method == "parallel" else [])
            label = f"{variant}_{method}_{n}_t{threads}"
            print(f"Running {label}", flush=True)
            limit = min(config["process_timeout_seconds"], remaining)
            try:
                run = subprocess.run(argv, cwd=ROOT, env=env, capture_output=True,
                                     text=True, timeout=limit)
            except subprocess.TimeoutExpired as exc:
                (output / f"{label}.stdout.txt").write_bytes(exc.stdout or b"")
                (output / f"{label}.stderr.txt").write_bytes(exc.stderr or b"")
                states.writerow([n, method, threads, variant, "timeout", f"process limit {limit:.3f} seconds; includes I/O and warmups"])
                status.flush()
                continue
            (output / f"{label}.stdout.txt").write_text(run.stdout)
            (output / f"{label}.stderr.txt").write_text(run.stderr)
            if run.returncode:
                states.writerow([n, method, threads, variant, "failed", f"exit code {run.returncode}; see stderr"])
                status.flush()
                continue
            rows = [line.split(",")[1:] for line in run.stdout.splitlines() if line.startswith("RESULT,")]
            if len(rows) != config["repetitions"]:
                raise RuntimeError(f"Unexpected sample count for {label}")
            for repetition, row in enumerate(rows, 1):
                if (row[:4] != [method, str(n), str(threads), str(threads)] or
                    int(row[4]) != repetition or float(row[5]) <= 0):
                    raise RuntimeError(f"Invalid measurement: {row}")
                if n in checksums and checksums[n] != row[6]:
                    raise RuntimeError(f"Result checksum mismatch for {label}")
                checksums[n] = row[6]
                writer.writerow(row + ["int32", 12*n*n, variant])
            states.writerow([n, method, threads, variant, "completed", "5 samples; 2 excluded warmups"])
            raw.flush()
            status.flush()
    print(f"Saved measurements and metadata to {output}")

if __name__ == "__main__":
    main()
