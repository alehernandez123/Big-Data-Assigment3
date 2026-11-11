# Assignment 3 experimental protocol

This protocol is declared before the performance campaign. Run commands from
the repository root, using GCC with OpenMP and Python 3 (standard library only).

```powershell
python experiments/run_experiments.py --dry-run
python experiments/run_experiments.py
```

The second command builds both executables, runs full-output correctness checks,
records hardware and tool versions, generates shared inputs and measures the
configurations in config.json. Each invocation creates a new results/runs folder;
it does not overwrite an earlier campaign. No performance campaign has been
executed as part of preparing this protocol.

## Design

- Sequential i-k-j baseline and the equivalent OpenMP row-parallel kernel.
- Sizes: 100, 250, 500, 1000, 1500; parallel threads: 1, 2, 4, 8, 16.
- Hardware identified during preparation: Ryzen 7 6800HS, 8 physical cores,
  16 logical processors, 16387997696 bytes RAM, Windows 11 Home 10.0.22631.
  Each actual campaign queries the current hardware again.
- Same GCC flags, 32-bit integer type, contiguous row-major arrays and logical
  inputs. Values 0..10, Python random.Random(42), reset per size, A then B.
  Inputs match Assignment 2 generation for common sizes. SHA-256 hashes saved.
- Two excluded warmups and five measured multiplications per configuration.
  Configuration order is shuffled with seed 2026 to reduce fixed-order effects.
- The main thread uses QueryPerformanceCounter on Windows (omp_get_wtime on
  other platforms) and measures output initialisation and multiplication,
  including OpenMP region overhead. Allocation, validation, CSV I/O and checksum
  are outside the timer. Each result is consumed; actual threads are recorded.
- Dynamic teams disabled, static row schedule, no explicit affinity pinning,
  passive waiting and a 16-thread limit. Inherited OpenMP affinity controls are
  removed. No internally threaded matrix library is used. No oversubscription
  is planned. Sixteen threads explore logical processors beyond eight cores.
- Optional SIMD extension is excluded; compiler flags remain identical.

## Budgets and memory

Maximum process wall time is 60 seconds, including loading, warmups and output;
maximum campaign execution phase is 600 seconds. Setup, generation and checking
are outside that campaign phase. A timed-out configuration gets no invented
runtime. Later configurations are marked unattempted if the campaign limit is
reached. A process failure retains its return code and stderr for diagnosis;
allocation failures are not inferred unless the message provides evidence.

Array-storage budget: 256 MiB. Metric: 3*n*n*sizeof(int) = 12*n*n bytes for A, B,
C on this platform. This is an estimate of matrix storage, not peak resident
memory. It excludes runtime, allocator overhead and thread stacks, and cannot
establish whether process memory increases with thread count. Python input
creation uses one row at a time, outside the benchmarked executable. Largest
planned size needs 27000000 bytes for matrix elements. The largest feasible
completed size will be identified from actual statuses, separately from largest
attempted size; it is not a claim of the machine's absolute capacity.

## Evidence and analysis to follow

raw.csv keeps every reported sample with method, size, requested/actual threads,
repetition, seconds, checksum, numeric type and array-storage estimate.
status.csv records completion, failure, timeout and unattempted configurations.
Original stdout/stderr and environment.json retain configuration, source/input
hashes, hardware, compiler, Python version and correctness-check outcome.

The analysis step will report median, IQR, runtime, memory metric, speedup
Tseq_median/Tparallel_median and efficiency speedup/actual_threads. It must include
parallel-one-thread overhead, uncertainty, failed configurations and observed
bottlenecks, and must not draw conclusions before examining measured data.
Very short timings will be assessed for reliability; batch measurement may be
needed if timer resolution or variability makes individual runs uninformative.

AI assistance: Codex helped author this protocol and the experiment runner.
The student must review the code and interpret and validate collected evidence.

## Timer correction before the completed campaign

The first campaign stopped after detecting a zero-duration sample for size 100
with two threads using this Windows OpenMP timer. That incomplete campaign and
its original outputs are retained as diagnostic evidence, not pooled with the
completed campaign. Both implementations now use QueryPerformanceCounter on
Windows, with frequency initialised outside the timer. The complete campaign
is rerun with unchanged inputs, compiler flags, thread counts and boundaries.
