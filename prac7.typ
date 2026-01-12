== Практика №7. Программа для расчета. Вычисление интеграла методом Монте-Карло. Вычисление гипер-объема тела в $RR^4$. $Q = {(x, y, z, w) in RR^4 | x^2 + y^2 + z^2 + w^2 <= 1; x^2 + y^2 <= 0.5}$

#image("images/prac6_theory1.png", width: 100%)

```py
import numpy as np

def estimate_volume_MC(N=1_000_000):
    # Охватывающий 4D куб: [-1, 1]^4
    # Объём куба: (2)^4 = 16
    vol_cube = 16.0

    # Генерируем случайные точки в [-1, 1]^4
    points = np.random.uniform(-1, 1, size=(N, 4))  # (x, y, z, w)
    x, y, z, w = points[:, 0], points[:, 1], points[:, 2], points[:, 3]

    # Проверяем условия:
    cond1 = x**2 + y**2 + z**2 + w**2 <= 1  # внутри 4D-шара
    cond2 = x**2 + y**2 <= 0.5              # внутри цилиндра xy

    # Точки, удовлетворяющие обоим условиям
    inside_Q = cond1 & cond2
    fraction = np.sum(inside_Q) / N

    volume = vol_cube * fraction
    return volume

volume = estimate_volume_MC(N=1_000_000)
print(f"Оценка гипер-объёма тела Q: {volume:.6f}")


```

*ПРИМЕР ВЫВОДА:*
#image("images/prac6_theory2.png", width: 100%)
#image("images/prac6_theory3.png", width: 100%)
#image("images/prac6_theory4.png", width: 100%)