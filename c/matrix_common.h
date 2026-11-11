/* Shared input/output and benchmark harness; adapted from Assignment 2. */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <limits.h>
#include <errno.h>
#include <omp.h>
#ifdef _WIN32
#include <windows.h>
/* Query frequency once, outside all timed regions. */
static LARGE_INTEGER timer_frequency;
static void initialise_timer(void) {
    if (!QueryPerformanceFrequency(&timer_frequency)) {
        fprintf(stderr, "High-resolution timer unavailable\n");
        exit(EXIT_FAILURE);
    }
}
static double elapsed_seconds(void) {
    LARGE_INTEGER counter;
    if (!QueryPerformanceCounter(&counter)) exit(EXIT_FAILURE);
    return (double)counter.QuadPart / (double)timer_frequency.QuadPart;
}
#else
static void initialise_timer(void) { }
static double elapsed_seconds(void) { return omp_get_wtime(); }
#endif
#define REPETITIONS 5
#define WARMUPS 2

// Allocate a matrix using contiguous memory
int *create_matrix(int n) {
    int *matrix = malloc((size_t)n * n * sizeof(int));

    if (matrix == NULL) {
        perror("Memory allocation failed");
        exit(EXIT_FAILURE);
    }

    return matrix;
}


// Free matrix memory
void free_matrix(int *matrix) {
    free(matrix);
}


// Load matrix from CSV
void load_matrix(const char *filename, int *matrix, int n) {
    FILE *file = fopen(filename, "r");

    if (file == NULL) {
        perror("Error opening matrix file");
        exit(EXIT_FAILURE);
    }

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {

            if (fscanf(file, "%d", &matrix[(size_t)i * n + j]) != 1) {
                fprintf(stderr, "Error reading matrix values\n");
                fclose(file);
                exit(EXIT_FAILURE);
            }

            if (j < n - 1) {
                if (fgetc(file) != ',') {
                    fprintf(stderr, "Invalid CSV format\n");
                    fclose(file);
                    exit(EXIT_FAILURE);
                }
            }
        }
    }

    fclose(file);
}


// Save result matrix to CSV
void save_matrix(const char *filename, int *matrix, int n) {
    FILE *file = fopen(filename, "w");

    if (file == NULL) {
        perror("Error creating result file");
        exit(EXIT_FAILURE);
    }

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {

            fprintf(file, "%d", matrix[(size_t)i * n + j]);

            if (j < n - 1) {
                fprintf(file, ",");
            }
        }

        fprintf(file, "\n");
    }

    fclose(file);
}


static int positive_int(const char *text) {
    char *end;
    errno = 0;
    long value = strtol(text, &end, 10);
    if (errno || *text == '\0' || *end || value < 1 || value > INT_MAX) {
        fprintf(stderr, "Expected a positive integer: %s\n", text);
        exit(EXIT_FAILURE);
    }
    return (int)value;
}

static int benchmark(int argc, char **argv, int parallel) {
    if (argc != (parallel ? 3 : 2)) {
        fprintf(stderr, "Usage: %s <size>%s\n", argv[0], parallel ? " <threads>" : "");
        return EXIT_FAILURE;
    }
    int n = positive_int(argv[1]);
    int requested = parallel ? positive_int(argv[2]) : 1;
    /* Inputs are restricted to [0,10]: each output is at most 100*n. */
    if (n > INT_MAX / 100 || (size_t)n > SIZE_MAX / sizeof(int) / (size_t)n) {
        fprintf(stderr, "Size exceeds safe integer or allocation limits\n");
        return EXIT_FAILURE;
    }
    omp_set_dynamic(0);
    omp_set_num_threads(requested);
    char filename[256];
    int *A = create_matrix(n), *B = create_matrix(n), *C = create_matrix(n);
    snprintf(filename, sizeof(filename), "experiments/matrix/A_%d.csv", n);
    load_matrix(filename, A, n);
    snprintf(filename, sizeof(filename), "experiments/matrix/B_%d.csv", n);
    load_matrix(filename, B, n);
    for (size_t i = 0; i < (size_t)n*n; ++i) {
        if (A[i] < 0 || A[i] > 10 || B[i] < 0 || B[i] > 10) {
            fprintf(stderr, "Input values must be in [0,10]\n");
            free_matrix(A); free_matrix(B); free_matrix(C);
            return EXIT_FAILURE;
        }
    }
    initialise_timer();
    int actual = 1;
    for (int run = -WARMUPS; run < REPETITIONS; ++run) {
        double start = elapsed_seconds();
        actual = matrix_multiplication(A, B, C, n);
        double elapsed = elapsed_seconds() - start;
        /* Consume every result outside the timer. */
        uint64_t checksum = 0;
        for (size_t i = 0; i < (size_t)n*n; ++i) checksum += (uint64_t)C[i];
        if (run >= 0) {
            printf("RESULT,%s,%d,%d,%d,%d,%.9f,%llu\n",
                   parallel ? "parallel" : "sequential", n, requested, actual,
                   run + 1, elapsed, (unsigned long long)checksum);
        }
    }
    if (parallel)
        snprintf(filename, sizeof(filename), "results/parallel_%d_t%d.csv", n, requested);
    else
        snprintf(filename, sizeof(filename), "results/sequential_%d.csv", n);
    save_matrix(filename, C, n);
    free_matrix(A); free_matrix(B); free_matrix(C);
    return EXIT_SUCCESS;
}
