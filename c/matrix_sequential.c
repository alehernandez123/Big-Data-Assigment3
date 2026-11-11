/* i-k-j kernel adapted from Assignment 2; each row is initialised here. */
static int matrix_multiplication(const int *, const int *, int *, int);
#include "matrix_common.h"

static int matrix_multiplication(const int *A, const int *B, int *C, int n) {
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) C[(size_t)i*n+j] = 0;
        for (int k = 0; k < n; ++k) {
            int a = A[(size_t)i*n+k];
            for (int j = 0; j < n; ++j)
                C[(size_t)i*n+j] += a * B[(size_t)k*n+j];
        }
    }
    return 1;
}

int main(int argc, char **argv) { return benchmark(argc, argv, 0); }
