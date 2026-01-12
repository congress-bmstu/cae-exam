== Практика №6. Программа для расчета. Вычисление QR-разложения матрицы 6x6. Решение СЛАУ при помощи полученного разложения.

#image("images/prac6_theory1.png", width: 100%)

```py
import numpy as np

def solve_with_qr(A, b):
    """
    Решение СЛАУ Ax = b с использованием QR-разложения.

    :param A: Матрица коэффициентов (6x6).
    :param b: Вектор правой части.
    :return: Решение x.
    """
    # Вычисляем QR-разложение
    Q, R = np.linalg.qr(A)

    # Вычисляем вектор c = Q^T b
    c = np.dot(Q.T, b)

    # Решаем систему Rx = c
    x = np.linalg.solve(R, c)

    return x, Q, R

# Пример использования
A = np.array([
    [2, 1, 3, 4, 5, 6],
    [1, 3, 2, 1, 2, 3],
    [3, 2, 5, 3, 1, 2],
    [4, 1, 3, 6, 2, 1],
    [5, 2, 1, 2, 7, 3],
    [6, 3, 2, 1, 3, 8]
], dtype=float)

b = np.array([20, 15, 25, 30, 35, 40], dtype=float)

x, Q, R = solve_with_qr(A, b)

print("Матрица A:")
print(A)
print("\nВектор b:")
print(b)
print("\nМатрица Q:")
print(Q)
print("\nМатрица R:")
print(R)
print("\nРешение x:")
print(x)

```

*ПРИМЕР ВЫВОДА:*
#image("images/prac6_theory2.png", width: 100%)
#image("images/prac6_theory3.png", width: 100%)
#image("images/prac6_theory4.png", width: 100%)