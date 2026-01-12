== Практика №15. Программа для расчета. Нахождение фронта Парето из множества точек (в пространстве критериев). Распределение точек на недоминирующие слои.

#image("images/prac15_theory1.png", width: 100%)
#image("images/prac15_theory2.png", width: 100%)


```py
import numpy as np

def dominates(a, b):
    """Проверка доминирования точки a над точкой b."""
    return all(a_i <= b_i for a_i, b_i in zip(a, b)) and any(a_i < b_i for a_i, b_i in zip(a, b))

def non_dominated_sort(points):
    """
    Распределение точек на недоминируемые слои.

    :param points: Список точек (каждая точка — список или массив критериев).
    :return: Список слоёв, где каждый слой — список индексов точек.
    """
    n = len(points)
    layers = []
    dominated_by = [[] for _ in range(n)]
    domination_count = [0] * n

    # Определение доминирования
    for i in range(n):
        for j in range(n):
            if i != j and dominates(points[i], points[j]):
                dominated_by[i].append(j)
            elif i != j and dominates(points[j], points[i]):
                domination_count[i] += 1

    # Поиск первого фронта Парето
    current_layer = [i for i in range(n) if domination_count[i] == 0]
    layers.append(current_layer)

    # Поиск последующих слоёв
    while current_layer:
        next_layer = []
        for i in current_layer:
            for j in dominated_by[i]:
                domination_count[j] -= 1
                if domination_count[j] == 0:
                    next_layer.append(j)
        if next_layer:
            layers.append(next_layer)
        current_layer = next_layer

    return layers

# Пример использования
points = [
    [1, 5],  # Точка 0
    [2, 3],  # Точка 1
    [3, 2],  # Точка 2
    [4, 1],  # Точка 3
    [1, 4],  # Точка 4
    [2, 2],  # Точка 5
]

layers = non_dominated_sort(points)

print("Недоминируемые слои:")
for i, layer in enumerate(layers, 1):
    print(f"Слой {i}: {layer} (точки: {[points[idx] for idx in layer]})")

```

*ПРИМЕР ВЫВОДА:*
#image("images/prac15_theory3.png", width: 100%)
#image("images/prac15_theory4.png", width: 100%)