"""Full-output checks against an independent Python i-j-k reference."""
import csv
import random
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def write_matrix(path, rows):
    with path.open("w", newline="") as f:
        csv.writer(f).writerows(rows)

def main():
    rng = random.Random(2026)
    cases = [
        ([[1, 2], [3, 4]], [[5, 6], [7, 8]]),
        ([[0]*3 for _ in range(3)], [[2]*3 for _ in range(3)]),
        ([[int(i == j) for j in range(3)] for i in range(3)],
         [[rng.randint(0, 10) for _ in range(3)] for _ in range(3)]),
    ]
    for n in (1, 7, 32, 33):
        cases.append(tuple([[rng.randint(0, 10) for _ in range(n)]
                            for _ in range(n)] for _ in range(2)))
    checks = 0
    with tempfile.TemporaryDirectory() as folder:
        work = Path(folder)
        (work / "experiments/matrix").mkdir(parents=True)
        (work / "results").mkdir()
        for a, b in cases:
            n = len(a)
            expected = [[sum(a[i][k]*b[k][j] for k in range(n))
                         for j in range(n)] for i in range(n)]
            write_matrix(work / f"experiments/matrix/A_{n}.csv", a)
            write_matrix(work / f"experiments/matrix/B_{n}.csv", b)
            for threads in (None, 1, 2, 4):
                name = "sequential" if threads is None else "parallel"
                args = [str(ROOT / f"build/matrix_{name}.exe"), str(n)]
                if threads is not None:
                    args.append(str(threads))
                run = subprocess.run(args, cwd=work, check=True,
                                     capture_output=True, text=True, timeout=30)
                samples = [line.split(",") for line in run.stdout.splitlines()
                           if line.startswith("RESULT,")]
                assert len(samples) == 5, run.stdout
                assert all(int(row[4]) == (threads or 1) for row in samples), run.stdout
                assert all(int(row[7]) == sum(map(sum, expected)) for row in samples)
                suffix = "" if threads is None else f"_t{threads}"
                with (work / f"results/{name}_{n}{suffix}.csv").open() as f:
                    actual = [list(map(int, row)) for row in csv.reader(f)]
                assert actual == expected, (name, threads, n)
                checks += 1
    print(f"PASS: {checks} full-output checks, including known, zero, identity and random cases")

if __name__ == "__main__":
    main()
