# Measured results

Source campaign: `results/runs/20261111T181210712569Z`.

Median and inclusive interpolated quartiles (Python statistics.quantiles).
Five samples per configuration; IQR describes spread, not a confidence interval.
Speedup and efficiency are ratios of medians, without propagated uncertainty.

| n | Sequential median (s) | OpenMP 1-thread / sequential | Fastest tested threads | Speedup | Efficiency |
|---:|---:|---:|---:|---:|---:|
| 100 | 0.000186100 | 2.228 | 8 | 1.371 | 0.171 |
| 250 | 0.002905500 | 1.911 | 16 | 3.524 | 0.220 |
| 500 | 0.024503200 | 1.780 | 16 | 4.093 | 0.256 |
| 1000 | 0.190261300 | 1.916 | 16 | 3.932 | 0.246 |
| 1500 | 0.667404600 | 1.861 | 16 | 4.141 | 0.259 |

## Interpretation and limits

The one-thread OpenMP version is slower than the sequential counterpart.
This exposes framework/implementation overhead, but does not isolate thread
creation: compiler code generation, synchronisation and runtime behaviour can
also contribute. Both use the same i-k-j arithmetic and compiler flags.

For n=100, runtime is very short and more threads do not consistently help.
For the larger tested sizes, parallel execution reduces median runtime, but
speedup remains below ideal linear scaling. These observations alone cannot
isolate memory bandwidth, CPU frequency, scheduling or cache bottlenecks.
Eight physical cores and sixteen logical processors are distinct resources.

One campaign and five repetitions limit uncertainty assessment; affinity is
not pinned and background system load is not controlled. No results are
excluded from this completed campaign. Inspect IQR and raw values before
interpreting small differences. No claim of universal performance follows.

Memory is a representation estimate, identical across thread counts; no
thread-related process-memory conclusion can be drawn. Size 1500 is the
largest attempted and completed planned size, not an absolute capacity limit.

The incomplete earlier timer campaign is preserved but excluded explicitly.
No superlinear speedup is observed in the completed campaign.

Regenerate with `python experiments/analyze_results.py` from the repository root.
AI assistance: Codex authored the analysis and plots from actual raw samples.
