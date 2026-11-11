
import random
import csv
from pathlib import Path

# Experiment configuration
SIZES = [10, 50, 100, 250, 500]
SEED = 42
MIN_VALUE = 0
MAX_VALUE = 10

# Output directory
OUTPUT_DIR = Path(__file__).resolve().parent / "matrix"
OUTPUT_DIR.mkdir(exist_ok=True)


def generate_matrix(n, rng):
    return [
        [rng.randint(MIN_VALUE, MAX_VALUE) for _ in range(n)]
        for _ in range(n)
    ]


def save_matrix(matrix, filename):
    with open(filename, "w", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        writer.writerows(matrix)


def main():
    for n in SIZES:
        rng = random.Random(SEED)

        A = generate_matrix(n, rng)
        B = generate_matrix(n, rng)

        save_matrix(A, OUTPUT_DIR / f"A_{n}.csv")
        save_matrix(B, OUTPUT_DIR / f"B_{n}.csv")

        print(f"Generated matrices of size {n}x{n}")


if __name__ == "__main__":
    main()
