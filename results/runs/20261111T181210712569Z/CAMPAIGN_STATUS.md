# Completed campaign

All 30 declared configurations completed: 150 measured samples, with two
excluded warmups per configuration. The runner's 28 full-output correctness
checks passed before measurement. Actual thread counts match requested counts,
all recorded elapsed durations are positive, and checksums agree across every
configuration of the same size. Recorded C source hashes match the current
sources. Windows timing uses QueryPerformanceCounter in both executables.

This campaign alone is the input for the forthcoming statistical analysis.
The earlier incomplete folder is diagnostic evidence and must not be pooled.
Size 1500 is both the largest attempted and largest completed planned size;
it uses 27000000 bytes of estimated matrix storage, below the 256 MiB budget.
No configuration timed out or failed in this completed campaign. This does not
establish an absolute maximum matrix size for this machine.

Small sizes and five repetitions limit precision; analysis must report IQR and
avoid treating tiny differences as conclusive. Memory values describe array
storage only, excluding the process, runtime and thread stacks.

AI assistance: Codex executed the declared campaign, corrected the timer after
the observed zero-duration failure and checked sample integrity. All performance
values in raw.csv are actual program outputs, not generated estimates.
