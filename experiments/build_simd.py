"""Build isolated scalar/SIMD variants and retain compiler evidence; no timings."""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]

def run(args, **kwargs):
    return subprocess.run(args, cwd=ROOT, text=True, capture_output=True,
                          check=True, timeout=60, **kwargs)

def main():
    evidence = ROOT / "results/simd/build"
    evidence.mkdir(parents=True, exist_ok=True)
    base = ["-O2", "-Wall", "-Wextra", "-Werror", "-fopenmp", "-fno-tree-slp-vectorize"]
    variants = {"scalar": ["-fno-tree-loop-vectorize"],
                "simd": ["-ftree-loop-vectorize", "-DENABLE_SIMD"]}
    metadata = {"compiler": run(["gcc", "--version"]).stdout,
                "base_flags": base, "variants": variants,
                "sources": {str(f.relative_to(ROOT)): hashlib.sha256(f.read_bytes()).hexdigest()
                            for f in sorted((ROOT/"c").glob("*")) if f.is_file()},
                "commands": [], "correctness": {}}
    env = os.environ.copy()
    for key in list(env):
        if key.startswith(("OMP_", "GOMP_", "KMP_")):
            del env[key]
    env.update(OMP_DYNAMIC="FALSE", OMP_THREAD_LIMIT="16", OMP_PROC_BIND="FALSE")
    for variant, extra in variants.items():
        build = ROOT / f"build/simd/{variant}"
        build.mkdir(parents=True, exist_ok=True)
        for method in ("sequential", "parallel"):
            source = f"c/matrix_{method}.c"
            prefix = evidence / f"{variant}_{method}"
            args = ["gcc", *base, *extra, "-fopt-info-vec-optimized", source,
                    "-o", str(build/f"matrix_{method}.exe")]
            result = run(args)
            metadata["commands"].append(args)
            prefix.with_suffix(".vectorization.txt").write_text(result.stderr or "No successful vectorizations reported.\n")
            if variant == "simd" and "loop vectorized" not in result.stderr:
                raise RuntimeError(f"No vectorized loop reported for {method}")
            if variant == "scalar" and "vectorized" in result.stderr:
                raise RuntimeError("Unexpected vectorization in scalar control")
            run(["gcc", *base, *extra, "-S", source, "-o", str(prefix.with_suffix(".s"))])
        check = run([sys.executable, "experiments/check_correctness.py", "--build-dir", str(build)], env=env)
        metadata["correctness"][variant] = check.stdout.strip()
        print(variant, check.stdout.strip())
    (evidence/"metadata.json").write_text(json.dumps(metadata, indent=2)+"\n")
    print(f"Saved vectorization diagnostics, assembly and build metadata to {evidence}")

if __name__ == "__main__":
    main()
