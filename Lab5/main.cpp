#include <iostream>
#include <iomanip>
#include <math.h>

using namespace std;

extern "C" {
    double first_cosh(double x, double eps = 1e-6);
}

int main() {
    double x = 1.1;
    double eps = 1e-10;
    cout << fixed << setprecision(15);
    cout << "cosh(x) by math.h = \t" << cosh(x) << endl;
    cout << "cosh(x) by masm = \t" << first_cosh(x, eps) << endl;

    return 0;
}