#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define REPETITIONS 5

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

// Optimised matrix multiplication: i-k-j
void matrix_multiplication(int *A, int *B, int *C, int n) {

    // Initialise result matrix
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            C[(size_t)i * n + j] = 0;
        }
    }

    // Loop reordering: i-k-j
    for (int i = 0; i < n; i++) {
        for (int k = 0; k < n; k++) {
            int a = A[(size_t)i * n + k];

            for (int j = 0; j < n; j++) {
                C[(size_t)i * n + j] +=
                    a * B[(size_t)k * n + j];
            }
        }
    }
}


int main(int argc, char *argv[]) {

    if (argc != 2) {
        printf("Usage: matrix_loop_reordering.exe <size>\n");
        return 1;
    }

    int n = atoi(argv[1]);

    if (n <= 0) {
        fprintf(stderr, "Invalid matrix size\n");
        return 1;
    }

    char filenameA[256];
    char filenameB[256];
    char resultFilename[256];

    snprintf(
        filenameA,
        sizeof(filenameA),
        "experiments/matrix/A_%d.csv",
        n
    );

    snprintf(
        filenameB,
        sizeof(filenameB),
        "experiments/matrix/B_%d.csv",
        n
    );

    snprintf(
        resultFilename,
        sizeof(resultFilename),
        "results/loop_reordering_%d.csv",
        n
    );

    int *A = create_matrix(n);
    int *B = create_matrix(n);
    int *C = create_matrix(n);

    load_matrix(filenameA, A, n);
    load_matrix(filenameB, B, n);

    // Benchmark
    for (int repetition = 1; repetition <= REPETITIONS; repetition++) {

        clock_t start_time = clock();

        matrix_multiplication(A, B, C, n);

        clock_t end_time = clock();

        double execution_time =
            (double)(end_time - start_time) / CLOCKS_PER_SEC;

        printf(
            "RESULT,%d,%d,%.9f\n",
            n,
            repetition,
            execution_time
        );

        // Save one result for validation
        if (repetition == 1) {
            save_matrix(resultFilename, C, n);
        }
    }

    printf("Result verification value: %d\n", C[0]);

    free_matrix(A);
    free_matrix(B);
    free_matrix(C);

    return 0;
}