== Практика №10. Программа для расчета. Нахождение аппроксимации функции $y=sin((x + x^2) dot pi) / (2 dot pi dot x)$ на промежутке $(0; 1)$ методом Галёркина. С использованием базисных функций $B_n(x) = x^n dot (1 - x); n=1,2,...,M; M = 4$

#image("images/prac10_theory1.png", width: 100%)
#image("images/prac10_theory2.png", width: 100%)
```py
import numpy as np
from scipy.integrate import quad

# Определение функции y(x)
def y(x):
    return np.sin((x + x**2) * np.pi) / (2 * np.pi * x)

# Базисные функции B_n(x)
def B_n(x, n):
    return x**n * (1 - x)

# Правая часть системы: b_k = ∫ y(x) B_k(x) dx
def compute_b_k(k):
    integrand = lambda x: y(x) * B_n(x, k)
    return quad(integrand, 0, 1)[0]

# Матрица системы: A_{k,n} = ∫ B_n(x) B_k(x) dx
def compute_A_kn(k, n):
    integrand = lambda x: B_n(x, n) * B_n(x, k)
    return quad(integrand, 0, 1)[0]

# Формирование системы линейных уравнений
M = 4
A = np.zeros((M, M))
b = np.zeros(M)

for k in range(M):
    b[k] = compute_b_k(k + 1)
    for n in range(M):
        A[k, n] = compute_A_kn(k + 1, n + 1)

# Решение системы линейных уравнений
c = np.linalg.solve(A, b)

# Аппроксимация функции
def y_M(x, c):
    return sum(c[n] * B_n(x, n + 1) for n in range(M))

# Пример: значение аппроксимации в точке x = 0.5
x_example = 0.5
print(f"Аппроксимация в точке x = {x_example}: {y_M(x_example, c):.6f}")
print(f"Точное значение в точке x = {x_example}: {y(x_example):.6f}")
print(f"Коэффициенты c: {c}")


```

*ПРИМЕР ВЫВОДА:*
#image("images/prac10_theory3.png", width: 100%)
#image("images/prac10_theory4.png", width: 100%)
