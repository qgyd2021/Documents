## Gamma 函数

https://blog.csdn.net/pilotmickey/article/details/105345457

https://www.jianshu.com/p/387ab7b9998b



图床

```text
http://sm.ms/
```





### 阶乘

阶乘数列 $1!, 2!, \cdots ,n!$ 中每一个值都只能取整数, 其在数域上不连续, 那么有没有一个连续函数可以将其连接起来呢. 



练习实例: 

```python
import math

import matplotlib.pyplot as plt


def demo1():
    x = list()
    y = list()
    for a in range(5):
        b = math.factorial(a)
        x.append(a)
        y.append(b)

    plt.plot(x, y)
    plt.show()
    return


if __name__ == '__main__':
    demo1()

```

 图片输出结果为: 

![image.png](https://s2.loli.net/2022/07/03/km5F8tlIJOKvhgL.png)



### 阶乘连续函数推导



设阶乘函数: $f \rightarrow (0, \infty)$ 应满足: 

1. $f(0) = 1$. 
2. $f(x+1) = x f(x)$. 
3. $\log{f}$ 为凸函数. 



令: $\phi = \log{f}$ , 有: 

$$\begin{aligned} \phi (1) = & 0 \\ \phi (x+1) = & \log{x f(x)} = \log{f(x)} + \log{x} = \phi (x) + \log{x} \end{aligned}$$ 

其中函数 $\phi$ 的增量为 $\log{x}$ , 逐渐递增, 因此 $\phi$ 为凸函数. 



令 $0 \le x \le 1$, 有: 

$$\begin{aligned} \frac{\phi (n+1) - \phi (n)}{1} \le \frac{\phi (n+1+x) - \phi (n+1)}{x} \end{aligned}$$ 



$$\begin{aligned} \phi (n+1) - \phi (n) = & \log{n} \\ \phi (n+2) - \phi (n+1) = & \log{(n+1)} \end{aligned}$$ 



有: 

$$\begin{aligned} \log{n} \le \frac{\phi (n+1+x) - \phi (n+1)}{x} \le \log{(n+1)} \end{aligned}$$ 



由: 

$$\begin{aligned} \phi (x+1) = \phi (x) + \log(x) \end{aligned}$$ 

有: 

$$\begin{aligned} \phi (x+n+1) = & \phi (x+n) + \log(x+n) \\ = & \phi (x+n-1) + \log{(x+n-1)} + \log(x+n) \\ = & \phi (x+n-1) + \log{[(x+n)(x+n-1)]} \\ = & \phi (x+n-2) + \log{[(x+n)(x+n-1)(x+n-2)]} \\ & \cdots \\ = & \phi (x) + \log{[(x+n)(x+n-1)(x+n-2) \cdots (x+1)x]} \end{aligned}$$ 



由: 

$$\begin{aligned} \phi(x+1) = & \phi(x) + \log{x} \end{aligned}$$ 

有: 

$$\begin{aligned} \phi(x+1) = & \phi(x) + \log{x} \\ \phi(n+1) = & \phi(n) + \log{n} \\ = & \phi(n-1) + \log{(n-1)} + \log{n} \\ = & \phi(1) + \log{(n!)} \\ = & \log{(n!)} \end{aligned}$$ 



所以: 

$$\begin{aligned} \frac{\phi(n+1+x) - \phi(n+1)}{x} = & \frac{1}{x} [ \phi(x) + \log{[(x+n) \cdots (x+1)x]} - \log{(n!)} ] \end{aligned}$$ 



有: 

$$\begin{aligned} \log{n} \le & \frac{1}{x} [ \phi(x) + \log{[(x+n) \cdots (x+1)x]} - \log{(n!)} ] \le \log{(n+1)} \\ \log{n^{x}} \le & \frac{1}{x} [ \phi(x) + \log{[(x+n) \cdots (x+1)x]} - \log{(n!)} ] \le \log{(n+1)^{x}} \\ 0 \le & \phi(x) + \log{[(x+n) \cdots (x+1)x]} - \log{(n!)} -\log{n^{x}} \le \log{(n+1)^{x}} - \log{n^{x}} \\ 0 \le & \phi(x) - \log{\frac{n! x^{x}}{(x+n) \cdots (x+1)x}} \le x \log{(1 + \frac{1}{n})} \end{aligned}$$ 

令 $n \rightarrow \infty$, 则有 $\log{(1 + \frac{1}{n})} \rightarrow 0$. 推出: 

$$\begin{aligned} \phi(x) = & \lim_{n \rightarrow \infty} {\log{[ \frac{n! n^{x}}{(x+n) \cdots (x+1)x} ]}} \quad (0 \lt x \lt 1) \\ f(x) = & \lim_{n \rightarrow \infty} {[ \frac{n! n^{x}}{(x+n) \cdots (x+1)x} ]} \quad (0 \lt x \lt 1) \end{aligned}$$ 

当 $x = 1$ 时: 

$$\begin{aligned} f(x) = & \lim_{n \rightarrow \infty} {[ \frac{n! n^{x}}{(x+n) \cdots (x+1)x} ]} \\ = & \lim_{n \rightarrow \infty} {[ \frac{n! n^{1}}{(1+n) \cdots (1+1)1} ]} \\ = & \lim_{n \rightarrow \infty} {[ \frac{n! \times n}{ 1 \times 2 \times \cdots \times (n+1) } ]} \\ = & \lim_{n \rightarrow \infty} {[ \frac{n! \times n}{ n! \times (n+1) } ]} \\ = & \lim_{n \rightarrow \infty} {( 1 - \frac{1}{n+1})} \\ = & 1 \end{aligned}$$ 

说明 $f(x)$ 在 $(0, 1]$ 上有定义. 



$$\begin{aligned} f(x+1) = & \lim_{n \rightarrow \infty} {[ \frac{n! n^{(x+1)}}{(x+1) \cdots (x+n)(x+n+1)} ]} \\ = &  \lim_{n \rightarrow \infty}{[ 1 + \frac{1+x}{n} ]} \lim_{n \rightarrow \infty} {[ \frac{n! n^{(x+1)}}{(x+1) \cdots (x+n)(x+n+1)} ]} \\ = & \lim_{n \rightarrow \infty}{\frac{x+n+1}{n}[ \frac{n! n^{(x+1)}}{(x+1) \cdots (x+n)(x+n+1)} ]} \\ = & \lim_{n \rightarrow \infty}{[ \frac{n! n^{x}}{(x+1) \cdots (x+n)} ]} \\ = & x \lim_{n \rightarrow \infty}{[ \frac{n! n^{x}}{x(x+1) \cdots (x+n)} ]} \\ = & x f(x) \end{aligned}$$ 

因此, $f(x)$ 在 $(1, 2]$ 上有定义. 通过递归上述过程, 可知 $f(x)$ 在 $x > 0$ 上都有定义. 



























