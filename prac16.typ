== Практика №16. Программа для расчета. Решение систему ОДУ 1-го порядка вида
$
  cases(
    d/(d t) x = 10 dot (y - x),
    d/(d t) y = x dot (28 - z) - y,
    d/(d t) z = x dot y - (8/3) dot z,
    x bar_(t=0) = 0,
    y bar_(t=0) = 1,
    z bar_(t=0) = 1.05
  )
$
методом Эйлера с пересчётом (предиктор-корректор) и с двойным пересчетом.

#image("images/prac16_theory1.png", width: 100%)
#image("images/prac16_theory2.png", width: 100%)


```py
import numpy as np

def lorenz_system(x, y, z):
    """Правая часть системы Лоренца."""
    dx_dt = 10 * (y - x)
    dy_dt = x * (28 - z) - y
    dz_dt = x * y - (8/3) * z
    return dx_dt, dy_dt, dz_dt

def euler_predictor_corrector(t0, tf, dt, x0, y0, z0, double_correction=False):
    """Метод Эйлера с пересчётом (предиктор-корректор)."""
    num_steps = int((tf - t0) / dt)
    t = np.linspace(t0, tf, num_steps + 1)

    x = np.zeros(num_steps + 1)
    y = np.zeros(num_steps + 1)
    z = np.zeros(num_steps + 1)

    x[0], y[0], z[0] = x0, y0, z0

    for n in range(num_steps):
        # Предиктор
        dx_dt, dy_dt, dz_dt = lorenz_system(x[n], y[n], z[n])
        x_pred = x[n] + dt * dx_dt
        y_pred = y[n] + dt * dy_dt
        z_pred = z[n] + dt * dz_dt

        # Корректор
        dx_dt_pred, dy_dt_pred, dz_dt_pred = lorenz_system(x_pred, y_pred, z_pred)
        x[n+1] = x[n] + (dt / 2) * (dx_dt + dx_dt_pred)
        y[n+1] = y[n] + (dt / 2) * (dy_dt + dy_dt_pred)
        z[n+1] = z[n] + (dt / 2) * (dz_dt + dz_dt_pred)

        if double_correction:
            # Второй корректор
            dx_dt_corr, dy_dt_corr, dz_dt_corr = lorenz_system(x[n+1], y[n+1], z[n+1])
            x[n+1] = x[n] + (dt / 2) * (dx_dt + dx_dt_corr)
            y[n+1] = y[n] + (dt / 2) * (dy_dt + dy_dt_corr)
            z[n+1] = z[n] + (dt / 2) * (dz_dt + dz_dt_corr)

    return t, x, y, z

# Параметры
t0, tf = 0, 30
dt = 0.01
x0, y0, z0 = 0, 1, 1.05

# Решение методом Эйлера с пересчётом
t, x, y, z = euler_predictor_corrector(t0, tf, dt, x0, y0, z0, double_correction=False)

# Решение методом Эйлера с двойным пересчётом
t_double, x_double, y_double, z_double = euler_predictor_corrector(t0, tf, dt, x0, y0, z0, double_correction=True)

# Вывод результатов
print("Метод Эйлера с пересчётом:")
print(f"Последнее значение: x = {x[-1]:.6f}, y = {y[-1]:.6f}, z = {z[-1]:.6f}")

print("\nМетод Эйлера с двойным пересчётом:")
print(f"Последнее значение: x = {x_double[-1]:.6f}, y = {y_double[-1]:.6f}, z = {z_double[-1]:.6f}")

```

*ПРИМЕР ВЫВОДА:*
#image("images/prac16_theory3.png", width: 100%)
#image("images/prac16_theory4.png", width: 100%)