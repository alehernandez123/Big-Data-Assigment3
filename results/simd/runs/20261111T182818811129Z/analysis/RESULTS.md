# Optional SIMD results

Campaign: `results/simd/runs/20261111T182818811129Z`.

60 configurations, 300 measured samples; 5 repetitions and 2 excluded warmups each.
SIMD gain = scalar median / SIMD median at identical size, method and thread count.
The CSV reports inclusive-quartile IQR for both variants. IQR is not a confidence interval.

| n | Method | Fixed threads | Scalar median (s) | SIMD median (s) | SIMD gain |
|---:|---|---:|---:|---:|---:|
| 100 | sequential | 1 | 0.000406900 | 0.000186800 | 2.178 |
| 100 | parallel | 1 | 0.000416000 | 0.000199800 | 2.082 |
| 100 | parallel | 2 | 0.000248600 | 0.000133300 | 1.865 |
| 100 | parallel | 4 | 0.000162300 | 0.000104900 | 1.547 |
| 100 | parallel | 8 | 0.000184600 | 0.000133200 | 1.386 |
| 100 | parallel | 16 | 0.000187700 | 0.000190900 | 0.983 |
| 250 | sequential | 1 | 0.005432000 | 0.002849300 | 1.906 |
| 250 | parallel | 1 | 0.005415300 | 0.002884900 | 1.877 |
| 250 | parallel | 2 | 0.002764100 | 0.001516300 | 1.823 |
| 250 | parallel | 4 | 0.001416300 | 0.000921900 | 1.536 |
| 250 | parallel | 8 | 0.001391000 | 0.000549400 | 2.532 |
| 250 | parallel | 16 | 0.001113300 | 0.000650800 | 1.711 |
| 500 | sequential | 1 | 0.043784700 | 0.024404100 | 1.794 |
| 500 | parallel | 1 | 0.043903900 | 0.023953400 | 1.833 |
| 500 | parallel | 2 | 0.021944700 | 0.012171100 | 1.803 |
| 500 | parallel | 4 | 0.011388600 | 0.006177900 | 1.843 |
| 500 | parallel | 8 | 0.010546000 | 0.005855700 | 1.801 |
| 500 | parallel | 16 | 0.005855700 | 0.005336500 | 1.097 |
| 1000 | sequential | 1 | 0.354586500 | 0.189616700 | 1.870 |
| 1000 | parallel | 1 | 0.355200800 | 0.187824500 | 1.891 |
| 1000 | parallel | 2 | 0.176419000 | 0.092969600 | 1.898 |
| 1000 | parallel | 4 | 0.097098700 | 0.053971600 | 1.799 |
| 1000 | parallel | 8 | 0.061197600 | 0.033733400 | 1.814 |
| 1000 | parallel | 16 | 0.046599000 | 0.025616100 | 1.819 |
| 1500 | sequential | 1 | 1.221100900 | 0.637168500 | 1.916 |
| 1500 | parallel | 1 | 1.228106300 | 0.637086100 | 1.928 |
| 1500 | parallel | 2 | 0.605749600 | 0.317574500 | 1.907 |
| 1500 | parallel | 4 | 0.322695200 | 0.160097400 | 2.016 |
| 1500 | parallel | 8 | 0.208032600 | 0.102951400 | 2.021 |
| 1500 | parallel | 16 | 0.158490700 | 0.081782200 | 1.938 |

## Interpretation limits

Values above one favour SIMD; values below one favour the scalar control.
This comparison estimates the effect of the declared vectorisation treatment,
including compiler loop transformations. It is not a pure instruction-latency test.
The compiler reports and assembly establish SIMD generation; measurements
establish the observed gain. Changes in thread count are not SIMD gains.
Other loops such as the checksum may also be vectorised, but the checksum is
outside the measured region. The arithmetic multiplication loop is vectorised.

Mandatory measurements are not used as scalar controls. Both optional variants
are rebuilt with their declared flags. Inputs, integer bounds, data layout,
timing boundary and estimated matrix storage remain equivalent.
No affinity pinning, five samples, short small-size tasks and uncontrolled
background load limit precision. Do not generalise a small difference.
Memory is matrix-element storage only, not peak process memory or thread stacks.

Compiler evidence and build metadata are copied into this campaign's build_evidence.
AI assistance: Codex authored the runner/analysis and executed real measurements.
