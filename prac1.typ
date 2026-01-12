== Практика №1. Программа для расчета. Аппроксимация результатов $n$ измерений $(x_i, y_i)$ квадратичным трехчленом $y(x) = a x^2 + b x + c$ методом минимизации критерия $R(a, b, c) = sum_(i=1)^n (y(x_i) / y_i - 1)^2$ (Сумма квадратов относительных погрешностей). Вычислить максимальное и среднеквадратичное отклонение.

#image("images/prac1_theory1.png", width: 100%)

```py
import numpy as np
from scipy.optimize import minimize

def approximate_quadratic(x, y):
    """
    Аппроксимация данных (x, y) квадратичным трёхчленом y(x) = ax^2 + bx + c
    методом минимизации суммы квадратов относительных погрешностей.
    :param x: Список значений x.
    :param y: Список значений y.
    :return: Коэффициенты (a, b, c), максимальное и среднеквадратичное отклонение.
    """
    def objective_function(coeffs):
        a, b, c = coeffs
        y_pred = a * x**2 + b * x + c
        relative_errors = (y_pred / y - 1)**2
        return np.sum(relative_errors)

    # Начальное приближение для коэффициентов
    initial_guess = [0.0, 0.0, np.mean(y)]

    # Минимизация критерия
    result = minimize(
        objective_function,
        initial_guess,
        method='L-BFGS-B'
    )

    a, b, c = result.x

    # Вычисление отклонений
    y_pred = a * x**2 + b * x + c
    relative_errors = np.abs(y_pred / y - 1)
    max_deviation = np.max(relative_errors)
    rms_deviation = np.sqrt(np.mean(relative_errors**2))

    return (a, b, c), max_deviation, rms_deviation

# Пример использования
x = np.array([1, 2, 3, 4, 5])
y = np.array([2, 3, 5, 10, 18])

(a, b, c), max_dev, rms_dev = approximate_quadratic(x, y)

print(f"Коэффициенты: a = {a:.4f}, b = {b:.4f}, c = {c:.4f}")
print(f"Максимальное отклонение: {max_dev:.4f}")
print(f"Среднеквадратичное отклонение: {rms_dev:.4f}")

```

*ПРИМЕР ВЫВОДА:*

#image("images/prac1_theory2.png", width: 100%)