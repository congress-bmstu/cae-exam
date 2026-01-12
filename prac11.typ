== Практика №11. Программа для расчета. Нахождение аппроксимации функции $y=sin((x + x^2) dot pi) / (2 dot pi dot x)$ на промежутке $(0; 1)$ методом коллокации по областям. С использованием базисных функций $B_n(x) = x^n dot (1 - x); n=1,2,...,M; M = 4$

#image("images/prac11_theory1.png", width: 100%)
#image("images/prac11_theory2.png", width: 100%)
```py
import numpy as np

# Определение функции y(x)
def y(x):
    return np.sin((x + x**2) * np.pi) / (2 * np.pi * x)

# Базисные функции B_n(x)
def B_n(x, n):
    return x**n * (1 - x)

# Метод коллокации по областям
def collocation_method(M):
    # Коллокационные точки
    x_k = np.linspace(1/(M+1), M/(M+1), M)

    # Формирование матрицы системы
    A = np.zeros((M, M))
    b = np.zeros(M)

    for k in range(M):
        b[k] = y(x_k[k])
        for n in range(M):
            A[k, n] = B_n(x_k[k], n + 1)

    # Решение системы линейных уравнений
    c = np.linalg.solve(A, b)

    return c

# Аппроксимация функции
def y_M(x, c):
    M = len(c)
    return sum(c[n] * B_n(x, n + 1) for n in range(M))

# Основной код
M = 4
c = collocation_method(M)

# Пример: значение аппроксимации в точке x = 0.5
x_example = 0.5
print(f"Аппроксимация в точке x = {x_example}: {y_M(x_example, c):.6f}")
print(f"Точное значение в точке x = {x_example}: {y(x_example):.6f}")
print(f"Коэффициенты c: {c}")

```

*ПРИМЕР ВЫВОДА:*
#image("images/prac11_theory3.png", width: 100%)
#image("images/prac11_theory4.png", width: 100%)
#image("images/prac11_theory5.png", width: 100%)