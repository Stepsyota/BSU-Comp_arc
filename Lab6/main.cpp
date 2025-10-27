/*
6.1 ¬ыполнить индивидуальный вариант задани€ использу€ векторные операции SSE.
ƒл€ заданных массивов A, B и C дл€ каждого i, если A[i] четное, C[i] := A[i] + B[i],
иначе C[i] := A[i] Ц B[i].


6.2 ¬ыполнить задани€ использу€ операции SSE дл€ упакованных чисел с плавающей точкой.
Ќормировать заданный вектор x, т. е. разделить каждый его элемент на длину вектора
|x| = sqrt(sigma from k = 1 to n of pow(x_k, 2)


6.3 ¬ычислить значение многочлена заданного пор€дка n по схеме √орнера во всех точках
вектора x, использу€ операции SSE дл€ упакованных чисел с плавающей точкой.
y = 10 + sigma from k = 1 to n of (pow(-1, k + 1) * (2k - 1) * pow(x, 2k - 1))
*/

#include <iostream>
#include <iomanip>
#include <math.h>
#include <chrono>

using namespace std;

extern "C" {
    int* task6_1();
    float* task6_2();
    float* task6_3(int n = 1);
}
void test6_1();
void test6_2();
void norm_vector(float[]);
void test6_3(int = 1);
void poly(float [], float [], int);

int main() {
    test6_1();
    test6_2();
    test6_3();
    return 0;
}
void test6_1() {
    //
    auto start_cpp = std::chrono::high_resolution_clock::now();

    int A[] = { 2, 2, 5, -1 };
    int B[] = { -4, 1, 2, 8 };
    int C[4];
    for (int i = 0; i < 4; ++i) {
        if (A[i] % 2 == 0) {
            C[i] = A[i] + B[i];
        }
        else C[i] = A[i] - B[i];
    }

    auto end_cpp = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::nano> elapsed_time_cpp = end_cpp - start_cpp;
    cout << "CPP. Time for Task 6.1 = " << elapsed_time_cpp.count() << " nanoseconds" << endl;
    //
    auto start_asm = std::chrono::high_resolution_clock::now();

    int* C_6_1 = task6_1();

    auto end_asm = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::nano> elapsed_time_asm = end_asm - start_asm;
    cout << "SSE. Time for Task 6.1 = " << elapsed_time_asm.count() << " nanoseconds" << endl;
    //

    for (int i = 0; i < 4; ++i) {
        cout << "A[" << i << "] = " << A[i] << ",\tB[" << i << "] = " << B[i] << ",\tC[" << i << "] ASM/Theor = " << C_6_1[i] << "/" << C[i];
        if (C_6_1[i] - C[i] == 0) {
            cout << "\tEQUAL!\n";
        }
        else cout << "\tNOT EQUAL!\n";
    }
    cout << endl;
}
void test6_2() {
    //
    //
    auto start_cpp = std::chrono::high_resolution_clock::now();

    float X_math[] = { 2.0, -3.2, 4.2, 10.2 };
    norm_vector(X_math);

    auto end_cpp = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::nano> elapsed_time_cpp = end_cpp - start_cpp;
    cout << "CPP. Time for Task 6.2 = " << elapsed_time_cpp.count() << " nanoseconds" << endl;
    //
    //
    auto start_asm = std::chrono::high_resolution_clock::now();

    float* X = task6_2();

    auto end_asm = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::nano> elapsed_time_asm = end_asm - start_asm;
    cout << "SSE. Time for Task 6.2 = " << elapsed_time_asm.count() << " nanoseconds" << endl;
    //
    
    float sum_X = 0;
    float sum_X_math = 0;
    for (int i = 0; i < 4; ++i) {
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
    for (int i = 0; i < 4; ++i) {
        summ += pow(X[i], 2);
    }
    float sqrt_summ = sqrt(summ);
    float X_norm[4];
    for (int i = 0; i < 4; ++i) {
        X[i] /= sqrt_summ;
    }
}
void test6_3(int n) {
    //
    auto start_cpp = std::chrono::high_resolution_clock::now();

    float x[] = { 1.3, 2.4, 6.8, 7.2 };
    float res[4];
    poly(x, res, n);

    auto end_cpp = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::nano> elapsed_time_cpp = end_cpp - start_cpp;

    cout << "CPP. Time for Task 6.3 = " << elapsed_time_cpp.count() << " nanoseconds" << endl;
    //
    //
    auto start_asm = std::chrono::high_resolution_clock::now();

    float* x_res = task6_3(n);

    auto end_asm = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::nano> elapsed_time_asm = end_asm - start_asm;
    cout << "SSE. Time for Task 6.3 = " << elapsed_time_asm.count() << " nanoseconds" << endl;
    //

    for (int i = 0; i < 4; ++i) {
        cout << fixed << setprecision(10) << "X" << i << " by ASM/FUNC = " << x_res[i] << "/" << res[i];
        if (round((x_res[i] - res[i]) * 10000) == 0) {
            cout << " EQUAL!\n";
        }
        else cout << " NOT EQUAL!\n";
    }
    cout << endl;
}
void poly(float x[], float res[], int n = 1) {
    for (int i = 0; i < 4; ++i) {
        float result = 10;
        for (int k = 1; k <= n; ++k) {
            float sigma = pow(-1, k + 1) * (2 * k - 1) * pow(x[i], 2 * k - 1);
            result += sigma;
        }
        res[i] = result;
    }
}