#include <iostream>
#include <iomanip>
#include <math.h>

using namespace std;

extern "C" {
    double sse_cosh(double x, double eps = 1e-6);
    double avx_cosh(double x, double eps = 1e-6);
    double fma_poly(double x, int n = 1);
}

double poly(double x, int n = 1) {
    double res = 0;
    res += 10;
    for (int k = 1; k <= n; ++k) {
        double sigma = pow(-1, k + 1) * (2 * k - 1) * pow(x, 2 * k - 1);
        res += sigma;
    }
    return res;
}
int main() {
    double x = 1.1;
    double eps = 1e-6;
    cout << fixed << setprecision(15);
    //cout << "0. cosh(x) by math.h = \t" << cosh(x) << endl;
    //cout << "1. cosh(x) by SSE    = \t" << sse_cosh(x, eps) << endl;
    //cout << "2. cosh(x) by AVX    = \t" << avx_cosh(x, eps) << endl;
    cout << "3. polynomial by math.h    = \t" << poly(1) << endl;
    cout << "4. polynomial by FMA       = \t" << fma_poly(1) << endl;

    return 0;
}