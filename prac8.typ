== Практика №8. Программа для расчета. Вычисление кривизны и кручения кривой, заданной параметрически, в точке (с использованием конечно-разностных производных).
$
  cases(
    x(p) = sin(p) / p,
    y(p) = cos(p) / p,
    z(p) = p^2
  )
$

#image("images/prac8_theory1.png", width: 100%)

```py
import numpy as np

def r(p):
    x = np.sin(p) / p if p != 0 else 1  # предел при p -> 0
    y = np.cos(p) / p if p != 0 else float('inf')
    z = p**2
    return np.array([x, y, z])

def finite_diff_derivatives(p, h=1e-6):
    # Вычисляем производные методом конечных разностей
    r_p = r(p)
    r_p_plus_h = r(p + h)
    r_p_minus_h = r(p - h)
    r_p_plus_2h = r(p + 2*h)
    r_p_minus_2h = r(p - 2*h)

    # Первая производная
    dr_dp = (r_p_plus_h - r_p_minus_h) / (2 * h)

    # Вторая производная
    d2r_dp2 = (r_p_plus_h - 2 * r_p + r_p_minus_h) / (h**2)

    # Третья производная
    d3r_dp3 = (r_p_plus_2h - 2 * r_p_plus_h + 2 * r_p_minus_h - r_p_minus_2h) / (2 * h**3)

    return dr_dp, d2r_dp2, d3r_dp3

def curvature_and_torsion(p):
    dr, d2r, d3r = finite_diff_derivatives(p)

    # Векторное произведение
    cross_product = np.cross(dr, d2r)
    norm_cross = np.linalg.norm(cross_product)
    norm_dr = np.linalg.norm(dr)

    # Кривизна
    kappa = norm_cross / (norm_dr ** 3)

    # Кручение
    tau = np.dot(cross_product, d3r) / (norm_cross ** 2)

    return kappa, tau

# Пример: вычислить кривизну и кручение в точке p = 1
p = 1.0
kappa, tau = curvature_and_torsion(p)

print(f"В точке p = {p}:")
print(f"Кривизна κ = {kappa:.6f}")
print(f"Кручение τ = {tau:.6f}")


```

*ПРИМЕР ВЫВОДА:*
#image("images/prac8_theory2.png", width: 50%)
#image("images/prac8_theory3.png", width: 100%)
