== Практика №9. Программа для расчета. Дискретное преобразование Фурье (одномерное).

#image("images/prac9_theory1.png", width: 100%)
#image("images/prac9_theory2.png", width: 100%)
```py
import numpy as np
import matplotlib.pyplot as plt

def dft(x):
    """
    Вычисляет одномерное ДПФ для вектора x
    """
    N = len(x)
    X = np.zeros(N, dtype=complex)
    for k in range(N):
        for n in range(N):
            X[k] += x[n] * np.exp(-2j * np.pi * k * n / N)
    return X

# Пример: синусоидальный сигнал + шум
N = 64
t = np.linspace(0, 1, N)
freq = 5  # частота синусоиды
signal = np.sin(2 * np.pi * freq * t) + 0.5 * np.random.randn(N)

X = dft(signal)

# Построим амплитудный спектр
plt.figure(figsize=(12, 6))
plt.subplot(1, 2, 1)
plt.plot(t, signal)
plt.title("Входной сигнал")
plt.xlabel("Время")
plt.ylabel("Амплитуда")

plt.subplot(1, 2, 2)
frequencies = np.arange(N)
plt.plot(frequencies[:N//2], np.abs(X[:N//2]))
plt.title("Амплитудный спектр (DFT)")
plt.xlabel("Частота (k)")
plt.ylabel("|X[k]|")
plt.tight_layout()
plt.show()

```

*ПРИМЕР ВЫВОДА:*
#image("images/prac9_theory3.png", width: 100%)
#image("images/prac9_theory4.png", width: 100%)
#image("images/prac9_theory5.png", width: 100%)