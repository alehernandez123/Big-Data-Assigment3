# Optional SIMD extension - controlled design

This extension evaluates explicit OpenMP SIMD on the innermost j loop. That
loop updates distinct output columns and has no loop-carried dependencies;
A and B are separate read-only allocations and C is a separate allocation.
The integer input restriction and overflow bounds remain unchanged.
ENABLE_SIMD enables the directive; ordinary builds retain the previous kernel.

## Build and correctness evidence

```powershell
python experiments/build_simd.py
```

Both variants use -O2 -Wall -Wextra -Werror -fopenmp
-fno-tree-slp-vectorize. The scalar control adds
-fno-tree-loop-vectorize. The SIMD variant adds -ftree-loop-vectorize
-DENABLE_SIMD. No -march=native, fast-math, layout, data or algorithm change is
introduced. Basic-block vectorisation is disabled in both; loop vectorisation
and the explicit SIMD directive form the treatment. These settings differ
from the mandatory campaign, which must not be used as the scalar control.

GCC's vectorisation diagnostics identify successful vectorised loops and vector
widths; generated assembly is retained for inspection. The build fails if the
SIMD report has no vectorised loop or the scalar report reports vectorisation.
Inspect the reported source lines to confirm they identify the multiplication
loop, rather than relying on the mere presence of SIMD registers in assembly.
Each variant runs 28 independent full-output correctness checks, including
odd sizes that exercise scalar tails. No performance results are produced here.

## Planned measurements after build validation

Use the same sizes, shared generated matrices, warmups, repetitions, timing
boundary, integer type, memory estimate and budgets as the mandatory protocol.
Measure both variants at each fixed configuration: sequential and OpenMP with
1, 2, 4, 8, 16 threads. Compare scalar median / SIMD median only at the same
size, method and thread count. Report SIMD gains separately from thread
speedup; never attribute a change in threads to vectorisation. Keep raw samples,
metadata and compiler evidence in a separate results/simd campaign.
The README and final report will be updated at the end.

Run `python experiments/run_simd_experiments.py` for 60 configurations and
300 samples, in seeded shuffled order, with the same 600-second campaign and
60-second process limits. The runner rebuilds and checks both variants before
measuring and copies compiler evidence into its timestamped output folder.
Then run `python experiments/analyze_simd.py --run results/simd/runs/TIMESTAMP`
using the exact folder reported by the runner. The analysis refuses incomplete
campaigns and reports median, IQR and scalar/SIMD gain for each matched pair.

## Sources

- GCC optimisation flags: https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html
- GCC OpenMP options: https://gcc.gnu.org/onlinedocs/gcc/OpenMP-and-OpenACC-Options.html
- GCC diagnostic options: https://gcc.gnu.org/onlinedocs/gcc/Developer-Options.html

AI assistance: Codex helped prepare the optional variants, controlled design,
build script and correctness verification.
