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
    //void task6_1(double* A, double *B, double *C, int size);
    //void task6_2(double* x, int n);
    int* task6_1();
    float* task6_3(int n = 1);
}
void test6_1();
void test6_3(int = 1);
float poly(float, int);

int main() {
    test6_1();
    //test6_3();
    return 0;
}
void test6_1() {
    int A[] = { 2, 2, 5, -1 };
    int B[] = { -4, 1, 2, 8 };
    int C[4];
    int* C_6_1 = task6_1();

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
}
void test6_3(int n) {
    float x[] = { 1.3, 2.4, 6.8, 7.2 };
    float* x_res = task6_3(n);

    for (int i = 0; i < 4; ++i) {
        float x_poly = poly(x[i], n);
        cout << fixed << setprecision(10) << "X" << i << " by ASM/FUNC = " << x_res[i] << "/" << x_poly;
        if (round((x_res[i] - x_poly) * 10000) == 0) {
            cout << " EQUAL!\n";
        }
        else cout << " NOT EQUAL!\n";
    }
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