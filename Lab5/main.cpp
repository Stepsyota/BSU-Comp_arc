#include <iostream>
#include <iomanip>
#include <math.h>

using namespace std;

extern "C" {
    double sse_cosh(double x, double eps = 1e-6);
    double avx_cosh(double x, double eps = 1e-6);
}

int main() {
    double x = 1.1;
    double eps = 1e-3;
    cout << fixed << setprecision(15);
    cout << "0. cosh(x) by math.h = \t" << cosh(x) << endl;
    cout << "1. cosh(x) by SSE    = \t" << sse_cosh(x, eps) << endl;
    cout << "2. cosh(x) by AVX    = \t" << avx_cosh(x, eps) << endl;

    return 0;
}