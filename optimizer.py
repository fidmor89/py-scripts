import numpy as np


# Functions f(x)
def f(x):
    # f(x) = (x mod 6)^2 mod 7 - sin(x)
    return ((x % 6) ** 2 % 7) - np.sin(x)


def f2(x):
    # f(x) = -x^4 + 1000x^3 - 20x^2 +4x - 6
    return -x**4 + 1000*x**3 - 20*x**2 + 4*x - 6


def find_optimal(X, f=None):
    if f is None:
        return 0

    optimal_x = None
    max_f_x = float('-inf')
    for x in X:
        current_f_x = f(x)
        if current_f_x > max_f_x:
            optimal_x = x
            max_f_x = current_f_x

    print(f"Optimal x*: {optimal_x} with value: {max_f_x}")


X = range(1, 101)  # X= {1, ..., 100}
find_optimal(X, f)

# X=ℝ (set of real numbers)
X2 = range(1, 2000)  # Restricting from 0 to 1,000
find_optimal(X2, f2)
