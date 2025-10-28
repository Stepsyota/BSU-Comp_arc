/*
7.1 ¬ыполнить индивидуальный вариант задани€ использу€ векторные операции AVX.
ƒл€ заданных массивов A, B и C дл€ каждого i, если A[i] четное, C[i] := A[i] + B[i],
иначе C[i] := A[i] Ц B[i].


7.2 ¬ыполнить задани€ использу€ операции AVX дл€ упакованных чисел с плавающей точкой.
Ќормировать заданный вектор x, т. е. разделить каждый его элемент на длину вектора
|x| = sqrt(sigma from k = 1 to n of pow(x_k, 2)


7.3 ¬ычислить значение многочлена заданного пор€дка n по схеме √орнера во всех точках
вектора x, использу€ операции AVX/FMA дл€ упакованных чисел с плавающей точкой.
y = 10 + sigma from k = 1 to n of (pow(-1, k + 1) * (2k - 1) * pow(x, 2k - 1))
*/

#include <iostream>
#include <iomanip>
#include <math.h>
#include <chrono>

using namespace std;

extern "C" {
    int* task7_1();
    float* task7_2();
    float* task7_3(int n = 1);
}
void test7_1();
void test7_2();
void norm_vector(float[]);
void test7_3(int = 1);
void poly(float[], float[], int);

void measure_all_tasks(int iterations = 10000) {
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    auto start_cpp_1 = std::chrono::high_resolution_clock::now();
    for (int j = 0; j < iterations; ++j) {
        volatile int A[] = { 2, 2, 5, -1, 13, 8, -5, 2 };
        volatile int B[] = { -4, 1, 2, 8, -3, -2, 1 ,6 };
        volatile int C[8];
        for (int i = 0; i < 8; ++i) {
            if (A[i] % 2 == 0) {
                C[i] = A[i] + B[i];
            }
            else C[i] = A[i] - B[i];
        }
        if (time(nullptr) == 0) std::cout << C[0];
    }
    auto end_cpp_1 = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::nano> elapsed_time_cpp_1 = end_cpp_1 - start_cpp_1;
    cout << "CPP. " << iterations << " iterations. Time for Task 7.1 = " << elapsed_time_cpp_1.count() / iterations << " nanoseconds" << endl;
    //
    auto start_asm_1 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < iterations; ++i) {
        int* C_6_1 = task7_1();
        if (time(nullptr) == 0) std::cout << C_6_1;
    }
    auto end_asm_1 = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::nano> elapsed_time_asm_1 = end_asm_1 - start_asm_1;
    cout << "AVX. " << iterations << " iterations. Time for Task 7.1 = " << elapsed_time_asm_1.count() / iterations << " nanoseconds" << endl;
    cout << "The difference is " << elapsed_time_cpp_1 / elapsed_time_asm_1 << " times\n";
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    auto start_cpp_2 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < iterations; ++i) {
        float X_math[] = { 2.0, -3.2, 4.2, 10.2, 12.3, 14.2, 3.01, 3.25 };
        norm_vector(X_math);
        if (time(nullptr) == 0) std::cout << X_math;
    }
    auto end_cpp_2 = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::nano> elapsed_time_cpp_2 = end_cpp_2 - start_cpp_2;
    cout << "CPP. " << iterations << " iterations. Time for Task 7.2 = " << elapsed_time_cpp_2.count() << " nanoseconds" << endl;
    //
    auto start_asm_2 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < iterations; ++i) {
        float* X = task7_2();
        if (time(nullptr) == 0) std::cout << X;
    }
    auto end_asm_2 = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::nano> elapsed_time_asm_2 = end_asm_2 - start_asm_2;
    cout << "AVX. " << iterations << " iterations. Time for Task 7.2 = " << elapsed_time_asm_2.count() << " nanoseconds" << endl;
    cout << "The difference is " << elapsed_time_cpp_2 / elapsed_time_asm_2 << " times\n";
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    int n = 10;
    auto start_cpp_3 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < iterations; ++i) {
        float x[] = { 1.3, 2.4, 6.8, 7.2, 4.3, 4.2, 1.1, 0.6 };
        float res[8];
        poly(x, res, n);
        if (time(nullptr) == 0) std::cout << res;
    }
    auto end_cpp_3 = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::nano> elapsed_time_cpp_3 = end_cpp_3 - start_cpp_3;
    cout << "CPP. " << iterations << " iterations. Time for Task 7.3 = " << elapsed_time_cpp_3.count() << " nanoseconds" << endl;
    //
    auto start_asm_3 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < iterations; ++i) {
        float* x_res = task7_3(n);
        if (time(nullptr) == 0) std::cout << x_res;
    }
    auto end_asm_3 = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::nano> elapsed_time_asm_3 = end_asm_3 - start_asm_3;
    cout << "AVX. " << iterations << " iterations. Time for Task 7.3 = " << elapsed_time_asm_3.count() << " nanoseconds" << endl;
    cout << "The difference is " << elapsed_time_cpp_3 / elapsed_time_asm_3 << " times\n";
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s
}
int main() {
    int iter = int(10e6);
    measure_all_tasks(iter);
    //test7_1();
    //test7_2();
    //test7_3(5);
    system("pause");
    return 0;
}
void test7_1() {
    auto start_cpp = std::chrono::high_resolution_clock::now();
    int A[] = { 2, 2, 5, -1, 13, 8, -5, 2 };
    int B[] = { -4, 1, 2, 8, -3, -2, 1 ,6 };
    int C[8];

    for (int i = 0; i < 8; ++i) {
        if (A[i] % 2 == 0) {
            C[i] = A[i] + B[i];
        }
        else C[i] = A[i] - B[i];
    }

    auto end_cpp = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::nano> elapsed_time_cpp = end_cpp - start_cpp;

    cout << "CPP. Time for Task 7.1 = " << elapsed_time_cpp.count() << " nanoseconds" << endl;
    //
    auto start_asm = std::chrono::high_resolution_clock::now();

    int* C_6_1 = task7_1();

    auto end_asm = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::nano> elapsed_time_asm = end_asm - start_asm;
    cout << "AVX. Time for Task 7.1 = " << elapsed_time_asm.count() << " nanoseconds" << endl;
    //

    for (int i = 0; i < 8; ++i) {
        cout << "A[" << i << "] = " << A[i] << ",\tB[" << i << "] = " << B[i] << ",\tC[" << i << "] ASM/Theor = " << C_6_1[i] << "/" << C[i];
        if (C_6_1[i] - C[i] == 0) {
            cout << "\tEQUAL!\n";
        }
        else cout << "\tNOT EQUAL!\n";
    }
    cout << endl;
}
void test7_2() {
    //
    auto start_cpp = std::chrono::high_resolution_clock::now();

    float X_math[] = { 2.0, -3.2, 4.2, 10.2, 12.3, 14.2, 3.01, 3.25 };
    norm_vector(X_math);

    auto end_cpp = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::nano> elapsed_time_cpp = end_cpp - start_cpp;
    cout << "CPP. Time for Task 7.2 = " << elapsed_time_cpp.count() << " nanoseconds" << endl;
    //
    auto start_asm = std::chrono::high_resolution_clock::now();

    float* X = task7_2();

    auto end_asm = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::nano> elapsed_time_asm = end_asm - start_asm;
    cout << "AVX. Time for Task 7.2 = " << elapsed_time_asm.count() << " nanoseconds" << endl;
    //

    float sum_X = 0;
    float sum_X_math = 0;
    for (int i = 0; i < 8; ++i) {
        cout << fixed << setprecision(10) << "X[" << i << "] ASM/MATH.H = " << X[i] << "/" << X_math[i];
        if (round((X[i] - X_math[i]) * 10000) == 0) {
            cout << "\tEQUAL!\n";
        }
        else cout << "\tNOT EQUAL!\n";
        sum_X += pow(X[i], 2);
        sum_X_math += pow(X_math[i], 2);
    }
    cout << "Length of vector ASM/MATH.H = " << sqrt(sum_X) << "/" << sqrt(sum_X_math) << endl << endl;
}
void norm_vector(float X[]) {
    float summ = 0;
    for (int i = 0; i < 8; ++i) {
        summ += pow(X[i], 2);
    }
    float sqrt_summ = sqrt(summ);
    for (int i = 0; i < 8; ++i) {
        X[i] /= sqrt_summ;
    }
}
void test7_3(int n) {
    //
    auto start_cpp = std::chrono::high_resolution_clock::now();

    float x[] = { 1.3, 2.4, 6.8, 7.2, 4.3, 4.2, 1.1, 0.6 };
    float res[8];
    poly(x, res, n);

    auto end_cpp = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::nano> elapsed_time_cpp = end_cpp - start_cpp;

    cout << "CPP. Time for Task 7.2 = " << elapsed_time_cpp.count() << " nanoseconds" << endl;
    //
    auto start_asm = std::chrono::high_resolution_clock::now();

    float* x_res = task7_3(n);

    auto end_asm = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::nano> elapsed_time_asm = end_asm - start_asm;
    cout << "AVX. Time for Task 7.3 = " << elapsed_time_asm.count() << " nanoseconds" << endl;
    //
    for (int i = 0; i < 8; ++i) {
        cout << fixed << setprecision(10) << "X" << i << " by ASM/FUNC = " << x_res[i] << "/" << res[i];
        if (round((x_res[i] - res[i]) * 10e5) == 0) {
            cout << " EQUAL!\n";
        }
        else cout << " NOT EQUAL!\n";
    }
    cout << endl;
}
void poly(float x[], float res[], int n = 1) {
    for (int i = 0; i < 8; ++i) {
        float result = 10;
        for (int k = 1; k <= n; ++k) {
            float sigma = pow(-1, k + 1) * (2 * k - 1) * pow(x[i], 2 * k - 1);
            result += sigma;
        }
        res[i] = result;
    }
}