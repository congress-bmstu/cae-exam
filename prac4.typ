== Практика №4. Программа для расчета. Аппроксимация результатов $n$ измерений $(x_i, y_i)$ рациональной функцией $y(x) = (a + b x) / (1 + c x)$ методом наименьших квадратов. Вычислить максимальное и среднеквадратичное отклонение.

#image("images/prac4_theory1.png", width: 100%)
#image("images/prac4_theory2.png", width: 100%)

```py
import numpy as np
from scipy.optimize import least_squares
import matplotlib.pyplot as plt

# Пример данных
x_data = np.array([0.1, 0.2, 0.4, 0.6, 0.8, 1.0])
y_data = np.array([0.9, 1.7, 3.1, 4.2, 5.1, 6.0])

def residuals(params, x, y):
    a, b, c = params
    y_pred = (a + b * x) / (1 + c * x)
    return y_pred - y

initial_guess = [1.0, 1.0, 0.01]  # начальные приближения
result = least_squares(residuals, initial_guess, args=(x_data, y_data))

a, b, c = result.x
print(f"Коэффициенты: a = {a:.4f}, b = {b:.4f}, c = {c:.4f}")

y_pred = (a + b * x_data) / (1 + c * x_data)

max_deviation = np.max(np.abs(y_pred - y_data))
rmse = np.sqrt(np.mean((y_pred - y_data)**2))

print(f"Максимальное отклонение: {max_deviation:.4f}")
print(f"Среднеквадратичное отклонение (RMSE): {rmse:.4f}")

plt.scatter(x_data, y_data, label="Экспериментальные точки", color="red")
x_smooth = np.linspace(min(x_data), max(x_data), 200)
y_smooth = (a + b * x_smooth) / (1 + c * x_smooth)
plt.plot(x_smooth, y_smooth, label=f"Рациональная аппроксимация", color="blue")
plt.legend()
plt.title("Аппроксимация рациональной функцией y = (a+bx)/(1+cx)")
plt.grid(True)
plt.show()

```

*ПРИМЕР ВЫВОДА:*

#image("images/prac4_theory3.png", width: 100%)
#image("images/prac4_theory4.png", width: 100%)