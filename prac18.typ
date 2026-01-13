== Практика №18. Программа для расчета. Решение ОДУ 2-го порядка вида  $y'' = f(x, y, y')$ методами Рунге-Кутты и Эйлера.
$ cases(
  f(x, y, y') = -4/(y/400+1/2)^2-0.2 dot y' dot exp(-y/200+1), y(0) = 200, y'(0) = 0, 0<=x<=x_T, y(x_T)=0.
) $ Сравнить полученные $x_T$.

```py
import numpy as np
import matplotlib.pyplot as plt

class ODESolver2ndOrder:
    
    def __init__(self, y0=200, y_prime0=0, x_start=0, x_end=10, h=0.01):
        """
        Инициализация решателя
        
        Parameters:
        -----------
        y0 : float
            Начальное условие y(0)
        y_prime0 : float
            Начальное условие y'(0)
        x_start : float
            Начало интервала
        x_end : float
            Конец интервала
        h : float
            Шаг интегрирования
        """
        self.y0 = y0
        self.y_prime0 = y_prime0
        self.x_start = x_start
        self.x_end = x_end
        self.h = h
        self.x_T_rk = None
        self.x_T_euler = None
        
    def f_equation(self, x, y, y_prime):
        """Уравнение y'' = -4/(y/400+1/2)^2 - 0.2*y'*exp(-y/200+1)"""
        return -4/((y/400 + 0.5)**2) - 0.2 * y_prime * np.exp(-y/200 + 1)
    
    def euler_method(self):
        """
        Метод Эйлера для решения ОДУ 2-го порядка
        Возвращает массивы x, y, y'
        """
        # Преобразуем ОДУ 2-го порядка в систему 1-го порядка
        # u = y, v = y'
        # u' = v
        # v' = f(x, u, v)
        
        n = int((self.x_end - self.x_start) / self.h) + 1
        x = np.linspace(self.x_start, self.x_end, n)
        u = np.zeros(n)  # y
        v = np.zeros(n)  # y'
        
        # Начальные условия
        u[0] = self.y0
        v[0] = self.y_prime0
        
        for i in range(n-1):
            # Метод Эйлера
            u[i+1] = u[i] + self.h * v[i]
            v[i+1] = v[i] + self.h * self.f_equation(x[i], u[i], v[i])
        
        return x, u, v
    
    def runge_kutta_4th(self):
        """
        Метод Рунге-Кутты 4-го порядка для ОДУ 2-го порядка
        Возвращает массивы x, y, y'
        """
        n = int((self.x_end - self.x_start) / self.h) + 1
        x = np.linspace(self.x_start, self.x_end, n)
        u = np.zeros(n)  # y
        v = np.zeros(n)  # y'
        
        # Начальные условия
        u[0] = self.y0
        v[0] = self.y_prime0
        
        for i in range(n-1):
            # Коэффициенты для u = y
            k1_u = self.h * v[i]
            
            # Коэффициенты для v = y'
            k1_v = self.h * self.f_equation(x[i], u[i], v[i])
            
            k2_u = self.h * (v[i] + 0.5 * k1_v)
            k2_v = self.h * self.f_equation(x[i] + 0.5*self.h, 
                                          u[i] + 0.5*k1_u, 
                                          v[i] + 0.5*k1_v)
            
            k3_u = self.h * (v[i] + 0.5 * k2_v)
            k3_v = self.h * self.f_equation(x[i] + 0.5*self.h, 
                                          u[i] + 0.5*k2_u, 
                                          v[i] + 0.5*k2_v)
            
            k4_u = self.h * (v[i] + k3_v)
            k4_v = self.h * self.f_equation(x[i] + self.h, 
                                          u[i] + k3_u, 
                                          v[i] + k3_v)
            
            # Обновление значений
            u[i+1] = u[i] + (k1_u + 2*k2_u + 2*k3_u + k4_u) / 6
            v[i+1] = v[i] + (k1_v + 2*k2_v + 2*k3_v + k4_v) / 6
        
        return x, u, v
    
    def find_root_euler(self, tolerance=1e-6):
        """
        Найти x_T такое, что y(x_T) = 0, используя метод Эйлера
        """
        def y_at_x(x_target):
            """Вычислить y(x_target) методом Эйлера"""
            # Интегрируем до x_target
            n = int((x_target - self.x_start) / self.h) + 1
            if n <= 1:
                return self.y0
            
            x_local = np.linspace(self.x_start, x_target, n)
            u = np.zeros(n)
            v = np.zeros(n)
            
            u[0] = self.y0
            v[0] = self.y_prime0
            
            for i in range(n-1):
                h_local = x_local[i+1] - x_local[i]
                u[i+1] = u[i] + h_local * v[i]
                v[i+1] = v[i] + h_local * self.f_equation(x_local[i], u[i], v[i])
            
            return u[-1]
        
        # Используем метод бисекции для нахождения корня
        a, b = self.x_start, self.x_end
        fa, fb = y_at_x(a), y_at_x(b)
        
        # Если на концах интервала нет смены знака, расширяем интервал
        while fa * fb > 0 and b < 100:  # Ограничим максимальный поиск
            b += 5
            fb = y_at_x(b)
        
        # Проверяем, есть ли решение
        if fa * fb > 0:
            print(f"   Предупреждение: не удалось найти корень на интервале [{a}, {b}]")
            print(f"   Значения на концах: y({a}) = {fa:.6e}, y({b}) = {fb:.6e}")
            self.x_T_euler = None
            return None
        
        # Поиск корня методом бисекции
        for _ in range(100):
            c = (a + b) / 2
            fc = y_at_x(c)
            
            if abs(fc) < tolerance:
                self.x_T_euler = c
                return c
            
            if fa * fc < 0:
                b, fb = c, fc
            else:
                a, fa = c, fc
        
        self.x_T_euler = (a + b) / 2
        return self.x_T_euler
    
    def find_root_rk(self, tolerance=1e-6):
        """
        Найти x_T такое, что y(x_T) = 0, используя метод Рунге-Кутты
        """
        def y_at_x_rk(x_target):
            """Вычислить y(x_target) методом Рунге-Кутты"""
            # Интегрируем до x_target
            n = int((x_target - self.x_start) / self.h) + 1
            if n <= 1:
                return self.y0
            
            x_local = np.linspace(self.x_start, x_target, n)
            u = np.zeros(n)
            v = np.zeros(n)
            
            u[0] = self.y0
            v[0] = self.y_prime0
            
            for i in range(n-1):
                h_local = x_local[i+1] - x_local[i]
                
                # Коэффициенты РК4
                k1_u = h_local * v[i]
                k1_v = h_local * self.f_equation(x_local[i], u[i], v[i])
                
                k2_u = h_local * (v[i] + 0.5 * k1_v)
                k2_v = h_local * self.f_equation(x_local[i] + 0.5*h_local, 
                                               u[i] + 0.5*k1_u, 
                                               v[i] + 0.5*k1_v)
                
                k3_u = h_local * (v[i] + 0.5 * k2_v)
                k3_v = h_local * self.f_equation(x_local[i] + 0.5*h_local, 
                                               u[i] + 0.5*k2_u, 
                                               v[i] + 0.5*k2_v)
                
                k4_u = h_local * (v[i] + k3_v)
                k4_v = h_local * self.f_equation(x_local[i] + h_local, 
                                               u[i] + k3_u, 
                                               v[i] + k3_v)
                
                u[i+1] = u[i] + (k1_u + 2*k2_u + 2*k3_u + k4_u) / 6
                v[i+1] = v[i] + (k1_v + 2*k2_v + 2*k3_v + k4_v) / 6
            
            return u[-1]
        
        # Используем метод бисекции для нахождения корня
        a, b = self.x_start, self.x_end
        fa, fb = y_at_x_rk(a), y_at_x_rk(b)
        
        # Если на концах интервала нет смены знака, расширяем интервал
        while fa * fb > 0 and b < 100:  # Ограничим максимальный поиск
            b += 5
            fb = y_at_x_rk(b)
        
        # Проверяем, есть ли решение
        if fa * fb > 0:
            print(f"   Предупреждение: не удалось найти корень на интервале [{a}, {b}]")
            print(f"   Значения на концах: y({a}) = {fa:.6e}, y({b}) = {fb:.6e}")
            self.x_T_rk = None
            return None
        
        # Поиск корня методом бисекции
        for _ in range(100):
            c = (a + b) / 2
            fc = y_at_x_rk(c)
            
            if abs(fc) < tolerance:
                self.x_T_rk = c
                return c
            
            if fa * fc < 0:
                b, fb = c, fc
            else:
                a, fa = c, fc
        
        self.x_T_rk = (a + b) / 2
        return self.x_T_rk
    
    def solve_and_compare(self):
        """
        Решить задачу обоими методами и сравнить результаты
        """
        print("=" * 60)
        print("РЕШЕНИЕ ОДУ 2-ГО ПОРЯДКА")
        print("=" * 60)
        print(f"Уравнение: y'' = -4/(y/400 + 0.5)² - 0.2*y'*exp(-y/200 + 1)")
        print(f"Начальные условия: y(0) = {self.y0}, y'(0) = {self.y_prime0}")
        print(f"Интервал: [{self.x_start}, {self.x_end}]")
        print(f"Шаг интегрирования: h = {self.h}")
        print("-" * 60)
        
        # Решение методом Эйлера
        print("\n1. МЕТОД ЭЙЛЕРА:")
        x_euler, y_euler, y_prime_euler = self.euler_method()
        x_T_euler = self.find_root_euler()
        
        if x_T_euler is not None:
            print(f"   Найденное x_T (y(x_T) = 0): {x_T_euler:.6f}")
            print(f"   Значение y(x_T): {y_euler[-1]:.6e}")
        else:
            print(f"   Не удалось найти x_T на заданном интервале")
        
        # Решение методом Рунге-Кутты
        print("\n2. МЕТОД РУНГЕ-КУТТЫ 4-ГО ПОРЯДКА:")
        x_rk, y_rk, y_prime_rk = self.runge_kutta_4th()
        x_T_rk = self.find_root_rk()
        
        if x_T_rk is not None:
            print(f"   Найденное x_T (y(x_T) = 0): {x_T_rk:.6f}")
            print(f"   Значение y(x_T): {y_rk[-1]:.6e}")
        else:
            print(f"   Не удалось найти x_T на заданном интервале")
        
        # Сравнение результатов (если оба метода нашли решение)
        if x_T_euler is not None and x_T_rk is not None:
            print("\n" + "=" * 60)
            print("СРАВНЕНИЕ РЕЗУЛЬТАТОВ:")
            print("-" * 60)
            print(f"x_T (Эйлер): {x_T_euler:.8f}")
            print(f"x_T (Рунге-Кутта): {x_T_rk:.8f}")
            print(f"Разница: {abs(x_T_euler - x_T_rk):.8f}")
            print(f"Относительная погрешность: {abs(x_T_euler - x_T_rk)/x_T_rk*100:.4f}%")
        
        # Формируем словарь результатов
        results = {
            'euler': {
                'x': x_euler, 
                'y': y_euler, 
                'y_prime': y_prime_euler, 
                'x_T': x_T_euler
            },
            'runge_kutta': {
                'x': x_rk, 
                'y': y_rk, 
                'y_prime': y_prime_rk, 
                'x_T': x_T_rk
            }
        }
        
        return results
    
    def plot_solutions(self, results):
        """
        Построить графики решений
        """
        fig, axes = plt.subplots(1, 2, figsize=(12, 5))
        
        # График y(x)
        ax1 = axes[0]
        ax1.plot(results['euler']['x'], results['euler']['y'], 
                'b-', linewidth=2, alpha=0.7, label='Эйлер')
        ax1.plot(results['runge_kutta']['x'], results['runge_kutta']['y'], 
                'r--', linewidth=2, alpha=0.7, label='Рунге-Кутта')
        ax1.axhline(y=0, color='k', linestyle=':', alpha=0.5)
        
        # Добавляем вертикальные линии, если найдены корни
        if results['euler']['x_T'] is not None:
            ax1.axvline(x=results['euler']['x_T'], color='b', linestyle='--', alpha=0.5, 
                       label=f'x_T (Эйлер) = {results["euler"]["x_T"]:.3f}')
        
        if results['runge_kutta']['x_T'] is not None:
            ax1.axvline(x=results['runge_kutta']['x_T'], color='r', linestyle='--', alpha=0.5,
                       label=f'x_T (РК) = {results["runge_kutta"]["x_T"]:.3f}')
        
        ax1.set_xlabel('x')
        ax1.set_ylabel('y(x)')
        ax1.set_title('Решение: y(x)')
        ax1.legend()
        ax1.grid(True, alpha=0.3)
        
        # График y'(x)
        ax2 = axes[1]
        ax2.plot(results['euler']['x'], results['euler']['y_prime'], 
                'b-', linewidth=2, alpha=0.7, label="Эйлер")
        ax2.plot(results['runge_kutta']['x'], results['runge_kutta']['y_prime'], 
                'r--', linewidth=2, alpha=0.7, label="Рунге-Кутта")
        ax2.set_xlabel('x')
        ax2.set_ylabel("y'(x)")
        ax2.set_title("Производная: y'(x)")
        ax2.legend()
        ax2.grid(True, alpha=0.3)
        
        plt.suptitle('Сравнение методов Эйлера и Рунге-Кутты 4-го порядка', fontsize=14)
        plt.tight_layout()
        plt.show()

def main():
    """
    Основная функция программы
    """
    # Параметры задачи
    y0 = 200.0          # y(0) = 200
    y_prime0 = 0.0      # y'(0) = 0
    x_start = 0.0       # начало интервала
    x_end = 5.0         # предполагаемый конец интервала
    h = 0.01            # шаг интегрирования
    
    # Создаем решатель
    solver = ODESolver2ndOrder(
        y0=y0,
        y_prime0=y_prime0,
        x_start=x_start,
        x_end=x_end,
        h=h
    )
    
    # Решаем и сравниваем (получаем результаты)
    results = solver.solve_and_compare()
    
    # Строим графики
    solver.plot_solutions(results)
    
    
if __name__ == "__main__":
    main()
```

