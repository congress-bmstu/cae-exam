== Практика №17. Программа для расчета. Решение ОДУ 2-го порядка вида  $y'' = f(x, y, y')$ методами Рунге-Кутты и Эйлера.
$
  cases(f(x, y, y') = -4 - 0.1*y' + 0.01 dot (y')^2, y(0) = 200, y'(0) = 0, 0<=x<=x_T, y(x_T)=0.)
$
Сравнить полученные $x_T$.

#image("images/prac17_theory1.png", width: 100%)
#image("images/prac17_theory2.png", width: 100%)


```py
import numpy as np

def f(x, y, v):
    """Правая часть уравнения для v'."""
    return -4 - 0.1 * v + 0.01 * v**2

def euler_method(x0, y0, v0, dx, target_y):
    """Метод Эйлера для решения ОДУ."""
    x, y, v = x0, y0, v0
    while y > target_y:
        y += dx * v
        v += dx * f(x, y, v)
        x += dx
    return x

def runge_kutta_4(x0, y0, v0, dx, target_y):
    """Метод Рунге-Кутты 4-го порядка для решения ОДУ."""
    x, y, v = x0, y0, v0
    while y > target_y:
        k1_y = dx * v
        k1_v = dx * f(x, y, v)

        k2_y = dx * (v + k1_v / 2)
        k2_v = dx * f(x + dx / 2, y + k1_y / 2, v + k1_v / 2)

        k3_y = dx * (v + k2_v / 2)
        k3_v = dx * f(x + dx / 2, y + k2_y / 2, v + k2_v / 2)

        k4_y = dx * (v + k3_v)
        k4_v = dx * f(x + dx, y + k3_y, v + k3_v)

        y += (k1_y + 2 * k2_y + 2 * k3_y + k4_y) / 6
        v += (k1_v + 2 * k2_v + 2 * k3_v + k4_v) / 6
        x += dx
    return x

# Параметры
x0, y0, v0 = 0, 200, 0
dx = 0.01
target_y = 0

# Решение методом Эйлера
xT_euler = euler_method(x0, y0, v0, dx, target_y)

# Решение методом Рунге-Кутты 4-го порядка
xT_rk4 = runge_kutta_4(x0, y0, v0, dx, target_y)

print(f"Метод Эйлера: xT = {xT_euler:.6f}")
print(f"Метод Рунге-Кутты 4-го порядка: xT = {xT_rk4:.6f}")


```

*ПРИМЕР ВЫВОДА:*
#image("images/prac17_theory3.png", width: 100%)
#image("images/prac17_theory4.png", width: 100%)