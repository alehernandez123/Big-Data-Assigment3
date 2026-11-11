# Incomplete diagnostic campaign

This campaign aborted when parallel size 100, two threads, returned a zero
elapsed duration with the original omp_get_wtime timer on Windows. Only three
configurations (15 samples) reached raw.csv. The fourth configuration's stdout
contains the zero-duration sample; no runtime was invented or replaced.
The process exited through the runner's Invalid measurement exception.
Do not use this folder in the final performance comparison. It is retained to
explain the timer correction and preserve all original observations.
