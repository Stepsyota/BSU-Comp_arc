#include <iostream>
#include <cstdint>

using namespace std;

extern "C" {
    int8_t check_status(uint8_t k, uint8_t l, uint8_t m, uint8_t n);
}

int main() {
    int k_temp, l_temp, m_temp, n_temp;
    uint8_t k, l, m, n;
    cout << "Enter the x coordinate of the rook:\t";    cin >> k_temp;
    cout << "Enter the y coordinate of the rook:\t";    cin >> l_temp;
    cout << "Enter the x coordinate of the pawn:\t";    cin >> m_temp;
    cout << "Enter the y coordinate of the pawn:\t";    cin >> n_temp;
    k = static_cast<uint8_t>(k_temp);
    l = static_cast<uint8_t>(l_temp);
    m = static_cast<uint8_t>(m_temp);
    n = static_cast<uint8_t>(n_temp);
    switch (check_status(k, l, m, n)) {
    case -1:
        cout << "Error in the input data\n";
        break;
    case 0:
        cout << "The field is peaceful\n";
        break;
    case 1:
        cout << "Pawn beats rook\n";
        break;
    case 2:
        cout << "Rook beats pawn";
        break;
    default:
        cout << "An unidentified case\n";
        break;
    }
    return 0;
}