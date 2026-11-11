"""Analyze one explicitly selected complete optional campaign, never pooled with mandatory data."""
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

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run", required=True, help="Repository-relative results/simd/runs directory")
    args = parser.parse_args()
    source = ROOT / args.run
    meta = json.loads((source/"environment.json").read_text())
    config = meta["config"]
    raw = list(csv.DictReader((source/"raw.csv").open()))
    status = list(csv.DictReader((source/"status.csv").open()))
    expected = {(v,n,m,t) for v in ("scalar","simd") for n in config["sizes"]
                for m,t in [("sequential",1)] + [("parallel",t) for t in config["threads"]]}
    completed = {(r["variant"],int(r["size"]),r["method"],int(r["threads"])) for r in status if r["status"]=="completed"}
    if len(status)!=len(expected) or completed!=expected:
        raise ValueError("Incomplete campaign: inspect status.csv")
    groups = {}
    checksums = {}
    for r in raw:
        n,t = int(r["size"]),int(r["actual_threads"])
        key = (r["variant"],n,r["method"],t)
        value = float(r["seconds"])
        if key not in expected or r["requested_threads"]!=str(t) or not math.isfinite(value) or value<=0:
            raise ValueError(f"Invalid sample {r}")
        if n in checksums and checksums[n]!=r["checksum"]:
            raise ValueError("Checksum mismatch")
        checksums[n]=r["checksum"]
        groups.setdefault(key,[]).append(r)
    if set(groups)!=expected:
        raise ValueError("Missing groups")
    stats={}
    for key,rows in groups.items():
        if sorted(int(r["repetition"]) for r in rows)!=[1,2,3,4,5]:
            raise ValueError("Repetitions must be 1..5")
        values=[float(r["seconds"]) for r in rows]
        q1,_,q3=statistics.quantiles(values,n=4,method="inclusive")
        stats[key]=(statistics.median(values),q3-q1)
    summary=[]
    for n in config["sizes"]:
        for m,t in [("sequential",1)]+[("parallel",t) for t in config["threads"]]:
            scalar,scalar_iqr=stats["scalar",n,m,t]
            simd,simd_iqr=stats["simd",n,m,t]
            summary.append(dict(size=n,method=m,threads=t,repetitions_per_variant=5,
                                scalar_median_seconds=scalar,scalar_iqr_seconds=scalar_iqr,
                                simd_median_seconds=simd,simd_iqr_seconds=simd_iqr,
                                simd_gain=scalar/simd,matrix_storage_bytes=12*n*n))
    out=source/"analysis"
    out.mkdir(exist_ok=True)
    with (out/"summary.csv").open("w",newline="") as f:
        writer=csv.DictWriter(f,fieldnames=list(summary[0]))
        writer.writeheader();writer.writerows(summary)
    plt.rcParams.update({"font.size":10,"axes.grid":True,"grid.alpha":.25})
    fig,axes=plt.subplots(1,2,figsize=(12,4.8))
    seq=[r for r in summary if r["method"]=="sequential"]
    axes[0].plot([r["size"] for r in seq],[r["simd_gain"] for r in seq],marker="o")
    axes[0].set(xlabel="Matrix side length n",ylabel="SIMD gain: scalar median / SIMD median",title="Sequential: thread count fixed at one")
    for n in config["sizes"]:
        rows=[r for r in summary if r["size"]==n and r["method"]=="parallel"]
        axes[1].plot([r["threads"] for r in rows],[r["simd_gain"] for r in rows],marker="o",label=f"n={n}")
    axes[1].set(xlabel="Fixed OpenMP threads",ylabel="SIMD gain: scalar median / SIMD median",title="OpenMP: paired comparisons at the same threads")
    axes[1].set_xticks(config["threads"]);axes[1].legend(fontsize=8)
    for ax in axes:ax.axhline(1,color="black",linestyle="--",alpha=.5)
    fig.tight_layout();fig.savefig(out/"simd_gain.png",dpi=200);plt.close(fig)
    fig,axes=plt.subplots(1,2,figsize=(12,4.8))
    for ax,method,t in [(axes[0],"sequential",1),(axes[1],"parallel",16)]:
        rows=[r for r in summary if r["method"]==method and r["threads"]==t]
        for variant in ("scalar","simd"):
            ax.plot([r["size"] for r in rows],[r[f"{variant}_median_seconds"] for r in rows],marker="o",label=variant)
        ax.set(yscale="log",xlabel="Matrix side length n",ylabel="Median kernel runtime (s)",title=f"{method.capitalize()}, {t} thread(s)")
        ax.legend()
    fig.tight_layout();fig.savefig(out/"simd_runtime.png",dpi=200);plt.close(fig)
    lines=["# Optional SIMD results","",f"Campaign: `{args.run}`.","",
           "60 configurations, 300 measured samples; 5 repetitions and 2 excluded warmups each.",
           "SIMD gain = scalar median / SIMD median at identical size, method and thread count.",
           "The CSV reports inclusive-quartile IQR for both variants. IQR is not a confidence interval.","",
           "| n | Method | Fixed threads | Scalar median (s) | SIMD median (s) | SIMD gain |",
           "|---:|---|---:|---:|---:|---:|"]
    for r in summary:
        lines.append(f"| {r['size']} | {r['method']} | {r['threads']} | {r['scalar_median_seconds']:.9f} | {r['simd_median_seconds']:.9f} | {r['simd_gain']:.3f} |")
    lines += ["","## Interpretation limits","",
              "Values above one favour SIMD; values below one favour the scalar control.",
              "This comparison estimates the effect of the declared vectorisation treatment,",
              "including compiler loop transformations. It is not a pure instruction-latency test.",
              "The compiler reports and assembly establish SIMD generation; measurements",
              "establish the observed gain. Changes in thread count are not SIMD gains.",
              "Other loops such as the checksum may also be vectorised, but the checksum is",
              "outside the measured region. The arithmetic multiplication loop is vectorised.","",
              "Mandatory measurements are not used as scalar controls. Both optional variants",
              "are rebuilt with their declared flags. Inputs, integer bounds, data layout,",
              "timing boundary and estimated matrix storage remain equivalent.",
              "No affinity pinning, five samples, short small-size tasks and uncontrolled",
              "background load limit precision. Do not generalise a small difference.",
              "Memory is matrix-element storage only, not peak process memory or thread stacks.","",
              "Compiler evidence and build metadata are copied into this campaign's build_evidence.",
              "AI assistance: Codex authored the runner/analysis and executed real measurements."]
    (out/"RESULTS.md").write_text("\n".join(lines)+"\n")
    (out/"provenance.json").write_text(json.dumps({"source":args.run,"raw_sha256":hashlib.sha256((source/"raw.csv").read_bytes()).hexdigest(),"matplotlib":matplotlib.__version__,"samples":len(raw)},indent=2)+"\n")
    print(f"PASS: {len(raw)} valid samples; {len(summary)} paired SIMD comparisons in {out}")
    for r in summary:
        if r["size"]==1500: print(r)

if __name__=="__main__":main()
