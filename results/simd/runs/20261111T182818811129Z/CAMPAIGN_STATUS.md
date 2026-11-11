# Completed optional SIMD campaign

All 60 configurations completed without timeout or failure: 300 measured
samples, five per configuration, after two excluded warmups. Both variants
passed 28 independent full-output correctness checks before the campaign.
Checksums match across variants and thread configurations for every size;
actual threads match requested counts. All elapsed samples are positive.
Recorded C source hashes match the current sources. Exact compiler flags for
each variant are recorded in environment.json and build_evidence/metadata.json.
The inherited mandatory compiler_flags field was clarified to list the actual
per-variant flags already recorded in build metadata; measurements are unchanged.

Largest attempted and completed planned size: 1500. Estimated matrix storage
is 27000000 bytes, below the declared 256 MiB array-storage budget. This is
not a process-memory peak or an absolute machine capacity result.

The optional campaign is separate from all mandatory measurements. Its
analysis compares scalar and SIMD at fixed size, method and thread count.
For n=1500, sequential SIMD gain is 1.916x; parallel gain at 16 threads is
1.938x. Small cases may not benefit: n=100 at 16 threads has gain near one.
Five samples and uncontrolled background load limit fine-grained conclusions.

Reproduce the analysis using the exact run directory with analyze_simd.py.
AI assistance: Codex executed and checked real measurements and generated
analysis and figures. No benchmark values were invented or adjusted.
