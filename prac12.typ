== Практика №12. Программа для расчета. Нахождение главных кривизн поверхности, заданной параметрически, в точке (использовать конечно-разностное приближение производных).
$
  cases(
    x(u, v) = cos(u)*sin(v),
    y(u, v) = sin(u)*sin(v),
    z(u, z) = cos(v),
    0 <= u < 2*pi,
    0 <= v < pi
  )
$

#image("images/prac12_theory1.png", width: 100%)
#image("images/prac12_theory2.png", width: 100%)
#image("images/prac12_theory3.png", width: 100%)


```py
import numpy as np

def r(u, v):
    """Параметризация поверхности."""
    x = np.cos(u) * np.sin(v)
    y = np.sin(u) * np.sin(v)
    z = np.cos(v)
    return np.array([x, y, z])

def principal_curvatures(u, v, h=1e-5):
    """Вычисление главных кривизн в точке (u, v)."""
    # Конечно-разностные производные
    r_u_plus = r(u + h, v)
    r_u_minus = r(u - h, v)
    r_v_plus = r(u, v + h)
    r_v_minus = r(u, v - h)

    r_u = (r_u_plus - r_u_minus) / (2 * h)
    r_v = (r_v_plus - r_v_minus) / (2 * h)

    # Вторая производная по u
    r_uu = (r_u_plus - 2 * r(u, v) + r_u_minus) / h**2

    # Вторая производная по v
    r_vv = (r_v_plus - 2 * r(u, v) + r_v_minus) / h**2

    # Смешанная производная
    r_u_plus_v_plus = r(u + h, v + h)
    r_u_plus_v_minus = r(u + h, v - h)
    r_u_minus_v_plus = r(u - h, v + h)
    r_u_minus_v_minus = r(u - h, v - h)
    r_uv = (r_u_plus_v_plus - r_u_plus_v_minus - r_u_minus_v_plus + r_u_minus_v_minus) / (4 * h**2)

    # Единичная нормаль
    n = np.cross(r_u, r_v) / np.linalg.norm(np.cross(r_u, r_v))

    # Коэффициенты первой квадратичной формы
    E = np.dot(r_u, r_u)
    F = np.dot(r_u, r_v)
    G = np.dot(r_v, r_v)

    # Коэффициенты второй квадратичной формы
    L = np.dot(n, r_uu)
    M = np.dot(n, r_uv)
    N = np.dot(n, r_vv)

    # Матрица формы
    shape_matrix = np.array([[L, M], [M, N]])
    metric_matrix = np.array([[E, F], [F, G]])

    # Нахождение главных кривизн
    inv_metric = np.linalg.inv(metric_matrix)
    curvature_matrix = np.dot(inv_metric, shape_matrix)
    k1, k2 = np.linalg.eigvalsh(curvature_matrix)

    return k1, k2

# Пример использования
u, v = np.pi/4, np.pi/4  # Точка, в которой вычисляем кривизны
k1, k2 = principal_curvatures(u, v)

print(f"Главные кривизны в точке (u, v) = ({u:.3f}, {v:.3f}):")
print(f"k1 = {k1:.6f}")
print(f"k2 = {k2:.6f}")

```

*ПРИМЕР ВЫВОДА:*
#image("images/prac12_theory4.png", width: 100%)
#image("images/prac12_theory5.png", width: 100%)
#image("images/prac12_theory6.png", width: 100%)