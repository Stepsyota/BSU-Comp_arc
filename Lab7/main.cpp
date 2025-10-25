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
float poly(float, int);

int main() {
    test7_1();
    test7_2();
    test7_3();
    return 0;
}
void test7_1() {
    int A[] = { 2, 2, 5, -1 };
    int B[] = { -4, 1, 2, 8 };
    int C[4];
    int* C_6_1 = task7_1();

    for (int i = 0; i < 4; ++i) {
        if (A[i] % 2 == 0) {
            C[i] = A[i] + B[i];
        }
        else C[i] = A[i] - B[i];
        cout << "A[" << i << "] = " << A[i] << ",\tB[" << i << "] = " << B[i] << ",\tC[" << i << "] ASM/Theor = " << C_6_1[i] << "/" << C[i];
        if (C_6_1[i] - C[i] == 0) {
            cout << "\tEQUAL!\n";
        }
        else cout << "\tNOT EQUAL!\n";
    }
    cout << endl;
}
void test7_2() {
    float* X = task7_2();
    float X_math[] = { 2.0, -3.2, 4.2, 10.2 };
    norm_vector(X_math);
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
void test7_3(int n) {
    float x[] = { 1.3, 2.4, 6.8, 7.2 };
    float* x_res = task7_3(n);

    for (int i = 0; i < 4; ++i) {
        float x_poly = poly(x[i], n);
        cout << fixed << setprecision(10) << "X" << i << " by ASM/FUNC = " << x_res[i] << "/" << x_poly;
        if (round((x_res[i] - x_poly) * 10000) == 0) {
            cout << " EQUAL!\n";
        }
        else cout << " NOT EQUAL!\n";
    }
    cout << endl;
}
float poly(float x, int n = 1) {
    float res = 0;
    res += 10;
    for (int k = 1; k <= n; ++k) {
        float sigma = pow(-1, k + 1) * (2 * k - 1) * pow(x, 2 * k - 1);
        res += sigma;
    }
    return res;
}