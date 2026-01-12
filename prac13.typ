== Практика №13. Программа для расчета. Нахождение корня уравнения $x^5 + x + a = 0$ методами: деления отрезка пополам, секущих, Ньютона. Характер сходимости методов. Сравнение количества итераций, необходимых для достижения точности $10^(-6), 10^(-9), 10^(-12)$.

#image("images/prac13_theory1.png", width: 100%)
#image("images/prac13_theory2.png", width: 100%)


```py
import numpy as np

def f(x, a):
    """Функция, корень которой ищем."""
    return x**5 + x + a

def df(x):
    """Производная функции."""
    return 5 * x**4 + 1

def bisection_method(a, tol=1e-6, max_iter=1000):
    """Метод деления отрезка пополам."""
    # Начальный отрезок
    left, right = -2, 2
    if f(left, a) * f(right, a) > 0:
        raise ValueError("Некорректный начальный отрезок.")

    iter_count = 0
    while (right - left) / 2 > tol and iter_count < max_iter:
        mid = (left + right) / 2
        if f(left, a) * f(mid, a) < 0:
            right = mid
        else:
            left = mid
        iter_count += 1

    return (left + right) / 2, iter_count

def secant_method(a, tol=1e-6, max_iter=1000):
    """Метод секущих."""
    # Начальные приближения
    x0, x1 = -1.5, 1.5
    iter_count = 0
    while abs(x1 - x0) > tol and iter_count < max_iter:
        x_next = x1 - f(x1, a) * (x1 - x0) / (f(x1, a) - f(x0, a))
        x0, x1 = x1, x_next
        iter_count += 1

    return x1, iter_count

def newton_method(a, tol=1e-6, max_iter=1000):
    """Метод Ньютона."""
    # Начальное приближение
    x0 = 1.0
    iter_count = 0
    while True:
        x_next = x0 - f(x0, a) / df(x0)
        if abs(x_next - x0) < tol or iter_count >= max_iter:
            break
        x0 = x_next
        iter_count += 1

    return x_next, iter_count

# Параметр a
a = 1.0

# Точности
tolerances = [1e-6, 1e-9, 1e-12]

# Сравнение методов
methods = {
    "Бисекция": bisection_method,
    "Секущие": secant_method,
    "Ньютон": newton_method,
}

results = {}
for method_name, method in methods.items():
    results[method_name] = {}
    for tol in tolerances:
        root, iterations = method(a, tol=tol)
        results[method_name][tol] = iterations

# Вывод результатов
print(f"Сравнение количества итераций для уравнения x^5 + x + {a} = 0:")
for tol in tolerances:
    print(f"\nТочность: {tol:.0e}")
    for method_name in methods:
        print(f"{method_name}: {results[method_name][tol]} итераций")


```

*ПРИМЕР ВЫВОДА:*
#image("images/prac13_theory3.png", width: 100%)
#image("images/prac13_theory4.png", width: 100%)
