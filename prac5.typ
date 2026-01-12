== Практика №5. Программа для расчета. Вычисление LU-разложения матрицы 6x6. Решение СЛАУ при помощи полученного разложения.

#image("images/prac5_theory1.png", width: 100%)

```py
import numpy as np
from scipy.linalg import lu

# Пример матрицы 6x6
A = np.array([
    [4,  3,  2,  1,  0,  1],
    [5,  4,  3,  2,  1,  0],
    [6,  5,  4,  3,  2,  1],
    [7,  6,  5,  4,  3,  2],
    [8,  7,  6,  5,  4,  3],
    [9,  8,  7,  6,  5,  4]
], dtype=float)

b = np.array([1, 2, 3, 4, 5, 6], dtype=float)

# LU-разложение с перестановками (PLU)
P, L, U = lu(A)

print("Матрица P (перестановок):")
print(P)
print("\nМатрица L (нижняя треугольная):")
print(L)
print("\nМатрица U (верхняя треугольная):")
print(U)

# Решение СЛАУ: Ax = b
# Ly = Pb → Ux = y

y = np.linalg.solve(L, P @ b)
x = np.linalg.solve(U, y)
'''Символ @ в Python используется для декораторов (для функций и классов) и 
для матричных операций (в библиотеке NumPy). Декоратор @ "оборачивает" функцию или класс, 
добавляя им новую функциональность, а в NumPy используется для умножения матриц (аналог np.matmul())'''
print("\nРешение x:")
print(x)

# Проверка: Ax = b
print("\nПроверка: A @ x = b?")
print(A @ x)
print("b =", b)

```

*ПРИМЕР ВЫВОДА:*
#image("images/prac5_theory2.png", width: 100%)
#image("images/prac5_theory3.png", width: 100%)
#image("images/prac5_theory4.png", width: 100%)