#include <iostream>

long long unsigned int calculate(long long unsigned int x) {
    std::cout << x << "\n";

    if (x <= 4) {
        std::cerr << "3x+1 problem reached." << "\n";
        return 0;
    }

    long long unsigned int num;

    if (x % 2 == 0) {
        num = x / 2;
    } else {
        num = x * 3 + 1;
    }

    return calculate(num);
}

int main() {
    calculate(18446744073709551615);
    return 0;
}
