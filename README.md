# Big Data - Assignment 3

## Parallel matrix multiplication

Research question: How do matrix size and thread count affect runtime, memory,
speedup and efficiency for shared-memory dense matrix multiplication?

This project will compare a sequential C implementation with an equivalent
OpenMP implementation. Both will use the same i-k-j algorithm, contiguous
row-major integer matrices and identical inputs. Each worker will own distinct
output rows, avoiding concurrent updates to the same output element.

## Current status

Initial scaffold only. No Assignment 3 performance measurements have been made.
The copied sequential program still uses the Assignment 2 timing harness;
it must be adapted before collecting parallel comparison results.

## Reused materials

The following files are copied without changes from Assignment 2, commit
`1c42becb273ed649c89d91101fe40d9ec36ca059`:

- `c/matrix_loop_reordering.c` -> `c/matrix_sequential.c`
- `experiments/generate_matrix.py` -> `experiments/generate_matrix.py`

The sequential executable's old usage text and output filenames are retained
at this stage. The generator uses Python's `random.Random(42)`, integer values
from 0 to 10 inclusive and sizes 10, 50, 100, 250 and 500. For each size it
resets the generator, then generates A followed by B.

## Initial build and run (PowerShell, from the repository root)

Requirements: GCC and Python 3. OpenMP support will be required in the next step.

```powershell
python experiments/generate_matrix.py
New-Item -ItemType Directory -Force build, results | Out-Null
gcc -O2 -Wall -Wextra c/matrix_sequential.c -o build/matrix_sequential.exe
.\build\matrix_sequential.exe 100
```

These commands exercise the inherited program; its timings are not final
Assignment 3 results. Input loading and output writing are outside its timer,
while output zero-initialisation is inside the multiplication function.

## Experimental plan

1. Validate known-answer, identity and zero cases, then compare full sequential
   and parallel outputs on deterministic random inputs.
2. Use the same compiler optimisation, data layout, inputs and timing boundary
   in both versions. Use a monotonic elapsed-time timer rather than `clock()`.
3. Record CPU model, physical cores, logical processors, RAM, OS, compiler,
   OpenMP settings, affinity and actual thread counts before measurements.
4. Test the sequential baseline and the parallel implementation with one and
   several hardware-supported thread counts. Declare sizes and time/memory
   budgets before large runs. Avoid integer overflow when extending inputs.
5. Exclude documented warm-ups; collect at least five measured repetitions.
   Preserve raw samples and report median and interquartile range.
6. Report a named memory metric with its measurement limitations. Compute
   speedup as sequential median / parallel median, and efficiency as speedup
   / actual thread count. Include parallel one-thread overhead.
7. Generate figures and an English report from measured data. Report failures
   and budget limits without inventing timings.

SIMD vectorisation is optional and is outside the initial experiment scope.
Any compiler vectorisation settings will be documented and held consistent.

## Development and AI assistance

Changes are delivered in stages; the student reviews and makes each commit.
Codex (OpenAI) assisted with the initial scaffold and experimental planning.
Update this disclosure as further parts are developed. The student is
responsible for understanding the implementation and validating the evidence.
