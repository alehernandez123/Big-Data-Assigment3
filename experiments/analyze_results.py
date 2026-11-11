"""Reproduce tables and figures from the completed, explicitly selected campaign."""
import argparse
import csv
import hashlib
import json
import math
from pathlib import Path
import statistics
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[1]
DEFAULT = "results/runs/20261111T181210712569Z"

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run", default=DEFAULT)
    args = parser.parse_args()
    source = ROOT / args.run
    meta = json.loads((source / "environment.json").read_text())
    config = meta["config"]
    statuses = list(csv.DictReader((source / "status.csv").open()))
    raw = list(csv.DictReader((source / "raw.csv").open()))
    expected = {(n, m, t) for n in config["sizes"] for m, t in
                [("sequential", 1)] + [("parallel", t) for t in config["threads"]]}
    completed = {(int(s["size"]), s["method"], int(s["threads"]))
                 for s in statuses if s["status"] == "completed"}
    if len(statuses) != len(expected) or completed != expected:
        raise ValueError("This analysis requires a complete campaign; inspect status.csv")
    groups = {}
    checksums = {}
    for r in raw:
        n, t = int(r["size"]), int(r["actual_threads"])
        key = (n, r["method"], t)
        seconds = float(r["seconds"])
        if (key not in expected or int(r["requested_threads"]) != t or
            not math.isfinite(seconds) or seconds <= 0 or r["numeric_type"] != "int32" or
            int(r["matrix_storage_bytes"]) != 12*n*n):
            raise ValueError(f"Invalid sample: {r}")
        if n in checksums and checksums[n] != r["checksum"]:
            raise ValueError("Checksum mismatch")
        checksums[n] = r["checksum"]
        groups.setdefault(key, []).append(r)
    if set(groups) != expected:
        raise ValueError("Missing configurations")
    summary = []
    for (n, method, t), samples in sorted(groups.items()):
        if sorted(int(r["repetition"]) for r in samples) != list(range(1, 6)):
            raise ValueError("Expected exactly repetitions 1..5")
        times = [float(r["seconds"]) for r in samples]
        q1, _, q3 = statistics.quantiles(times, n=4, method="inclusive")
        median = statistics.median(times)
        baseline = statistics.median(float(r["seconds"]) for r in groups[n, "sequential", 1])
        summary.append(dict(size=n, method=method, threads=t, repetitions=len(times),
                            median_seconds=median, q1_seconds=q1, q3_seconds=q3,
                            iqr_seconds=q3-q1, min_seconds=min(times), max_seconds=max(times),
                            speedup=baseline/median, efficiency=baseline/median/t,
                            matrix_storage_bytes=12*n*n))
    output = ROOT / "results/analysis"
    output.mkdir(parents=True, exist_ok=True)
    with (output / "summary.csv").open("w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=list(summary[0]))
        writer.writeheader()
        writer.writerows(summary)
    def save(fig, name):
        fig.savefig(output / name, dpi=200, bbox_inches="tight")
        plt.close(fig)
    plt.rcParams.update({"font.size": 10, "axes.grid": True, "grid.alpha": .25})
    fig, ax = plt.subplots(figsize=(9, 5))
    styles = [("sequential", 1)] + [("parallel", t) for t in config["threads"]]
    for method, t in styles:
        data = sorted((r for r in summary if r["method"] == method and r["threads"] == t), key=lambda r:r["size"])
        y = [r["median_seconds"] for r in data]
        ax.errorbar([r["size"] for r in data], y,
                    yerr=[[r["median_seconds"]-r["q1_seconds"] for r in data],
                          [r["q3_seconds"]-r["median_seconds"] for r in data]],
                    marker="o", capsize=3, label="Sequential" if method == "sequential" else f"OpenMP {t} thread(s)")
    ax.set(xscale="log", yscale="log", xlabel="Matrix side length n", ylabel="Kernel runtime (seconds)",
           title="Runtime: median and interquartile range (5 repetitions)")
    ax.legend(fontsize=8)
    fig.tight_layout()
    save(fig, "runtime.png")
    for metric, ylabel, name in [("speedup", "Speedup Tseq / Tp", "speedup.png"),
                                  ("efficiency", "Efficiency (Tseq / Tp) / p", "efficiency.png")]:
        fig, ax = plt.subplots(figsize=(8, 5))
        for n in config["sizes"]:
            data = sorted((r for r in summary if r["size"] == n and r["method"] == "parallel"), key=lambda r:r["threads"])
            ax.plot([r["threads"] for r in data], [r[metric] for r in data], marker="o", label=f"n={n}")
        if metric == "speedup":
            ax.plot(config["threads"], config["threads"], "k--", alpha=.5, label="Ideal S=p")
        else:
            ax.axhline(1, color="black", linestyle="--", alpha=.5, label="Ideal E=1")
        ax.set(xlabel="Actual OpenMP threads p", ylabel=ylabel, title="Ratios of measured median runtimes")
        ax.set_xticks(config["threads"])
        ax.legend(fontsize=8)
        fig.tight_layout()
        save(fig, name)
    fig, ax = plt.subplots(figsize=(8, 4))
    ax.plot(config["sizes"], [12*n*n/2**20 for n in config["sizes"]], marker="o")
    ax.set(xlabel="Matrix side length n", ylabel="Estimated matrix storage (MiB)",
           title="Three int32 matrices: same estimate for all thread counts")
    fig.text(.5, .01, "Excludes process/runtime memory and thread stacks; not peak resident memory.", ha="center", fontsize=8)
    fig.tight_layout(rect=(0,.04,1,1))
    save(fig, "memory.png")
    lines = ["# Measured results", "", f"Source campaign: `{args.run}`.", "",
             "Median and inclusive interpolated quartiles (Python statistics.quantiles).",
             "Five samples per configuration; IQR describes spread, not a confidence interval.",
             "Speedup and efficiency are ratios of medians, without propagated uncertainty.", "",
             "| n | Sequential median (s) | OpenMP 1-thread / sequential | Fastest tested threads | Speedup | Efficiency |",
             "|---:|---:|---:|---:|---:|---:|"]
    for n in config["sizes"]:
        seq = next(r for r in summary if r["size"]==n and r["method"]=="sequential")
        par = [r for r in summary if r["size"]==n and r["method"]=="parallel"]
        one = next(r for r in par if r["threads"]==1)
        best = min(par, key=lambda r:r["median_seconds"])
        lines.append(f"| {n} | {seq['median_seconds']:.9f} | {one['median_seconds']/seq['median_seconds']:.3f} | {best['threads']} | {best['speedup']:.3f} | {best['efficiency']:.3f} |")
    lines += ["", "## Interpretation and limits", "",
              "The one-thread OpenMP version is slower than the sequential counterpart.",
              "This exposes framework/implementation overhead, but does not isolate thread",
              "creation: compiler code generation, synchronisation and runtime behaviour can",
              "also contribute. Both use the same i-k-j arithmetic and compiler flags.", "",
              "For n=100, runtime is very short and more threads do not consistently help.",
              "For the larger tested sizes, parallel execution reduces median runtime, but",
              "speedup remains below ideal linear scaling. These observations alone cannot",
              "isolate memory bandwidth, CPU frequency, scheduling or cache bottlenecks.",
              "Eight physical cores and sixteen logical processors are distinct resources.", "",
              "One campaign and five repetitions limit uncertainty assessment; affinity is",
              "not pinned and background system load is not controlled. No results are",
              "excluded from this completed campaign. Inspect IQR and raw values before",
              "interpreting small differences. No claim of universal performance follows.", "",
              "Memory is a representation estimate, identical across thread counts; no",
              "thread-related process-memory conclusion can be drawn. Size 1500 is the",
              "largest attempted and completed planned size, not an absolute capacity limit.", "",
              "The incomplete earlier timer campaign is preserved but excluded explicitly.",
              "No superlinear speedup is observed in the completed campaign.", "",
              "Regenerate with `python experiments/analyze_results.py` from the repository root.",
              "AI assistance: Codex authored the analysis and plots from actual raw samples."]
    (output / "RESULTS.md").write_text("\n".join(lines)+"\n")
    (output / "provenance.json").write_text(json.dumps({"campaign":args.run,
        "raw_sha256":hashlib.sha256((source/"raw.csv").read_bytes()).hexdigest(),
        "matplotlib":matplotlib.__version__, "quartiles":"inclusive", "sample_count":len(raw)}, indent=2)+"\n")
    print(f"Validated {len(raw)} samples; wrote {len(summary)} summary rows and 4 figures to {output}")
    print("\n".join(lines[7:15]))

if __name__ == "__main__":
    main()
