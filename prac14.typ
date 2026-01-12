== Практика №14. Программа для расчета. Нахождение собственных значений и векторов симметричной положительно определенной матрицы 3x3 $A$ методом поворотов. Вычисление квадратного корня из этой матрицы при помощи полученных собственных значений и векторов.

#image("images/prac14_theory1.png", width: 100%)
#image("images/prac14_theory2.png", width: 100%)


```py
import numpy as np

def jacobi_eigenvalue(A, tol=1e-10, max_iter=1000):
    """
    Нахождение собственных значений и векторов методом Якоби.

    :param A: Симметричная матрица 3x3.
    :param tol: Точность.
    :param max_iter: Максимальное количество итераций.
    :return: Собственные значения и векторы.
    """
    n = A.shape[0]
    V = np.eye(n)  # Матрица собственных векторов
    for _ in range(max_iter):
        # Поиск максимального внедиагонального элемента
        max_val = 0
        max_i, max_j = 0, 1
        for i in range(n):
            for j in range(i + 1, n):
                if abs(A[i, j]) > max_val:
                    max_val = abs(A[i, j])
                    max_i, max_j = i, j

        # Если все внедиагональные элементы малы, завершаем
        if max_val < tol:
            break

        # Вычисление угла поворота
        if A[max_i, max_i] == A[max_j, max_j]:
            phi = np.pi / 4
        else:
            tau = (A[max_j, max_j] - A[max_i, max_i]) / (2 * A[max_i, max_j])
            phi = np.arctan(np.sign(tau) / (abs(tau) + np.sqrt(tau**2 + 1))) / 2

        # Построение матрицы вращения
        c = np.cos(phi)
        s = np.sin(phi)
        R = np.eye(n)
        R[max_i, max_i] = c
        R[max_i, max_j] = -s
        R[max_j, max_i] = s
        R[max_j, max_j] = c

        # Обновление матриц A и V
        A = R.T @ A @ R
        V = V @ R

    eigenvalues = np.diag(A)
    return eigenvalues, V

def matrix_sqrt(A, eigenvalues, V):
    """
    Вычисление квадратного корня из матрицы.

    :param A: Исходная матрица.
    :param eigenvalues: Собственные значения.
    :param V: Матрица собственных векторов.
    :return: Квадратный корень из матрицы.
    """
    sqrt_Lambda = np.diag(np.sqrt(eigenvalues))
    sqrt_A = V @ sqrt_Lambda @ V.T
    return sqrt_A

# Пример использования
A = np.array([
    [4, 2, 2],
    [2, 5, 3],
    [2, 3, 6]
], dtype=float)

eigenvalues, V = jacobi_eigenvalue(A)
sqrt_A = matrix_sqrt(A, eigenvalues, V)

print("Собственные значения:")
print(eigenvalues)
print("\nМатрица собственных векторов:")
print(V)
print("\nКвадратный корень из матрицы A:")
print(sqrt_A)


```

*ПРИМЕР ВЫВОДА:*
#image("images/prac14_theory3.png", width: 50%)
#image("images/prac14_theory4.png", width: 100%)