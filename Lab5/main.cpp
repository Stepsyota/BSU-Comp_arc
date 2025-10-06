#include <iostream>
#include <math.h>

using namespace std;

extern "C" {
    double first_cosh(double x, double eps = 1e-6);
}

int main() {
    double x = 1.0345;
    double eps = 1e-6;
    cout << "cosh(x) by math.h = " << cosh(x) << endl;
    cout << "cosh(x) by masm = " << first_cosh(x) << endl;

    return 0;
}