## 拉普拉斯变换



```text
https://www.cnblogs.com/leocc325/p/12710090.html
https://www.zhihu.com/question/22085329
```





### 傅里叶变换的充分条件

傅里叶变换的充分条件: 函数分段光滑且绝对可积. 

#### 分段光滑函数

光滑曲线: 如果函数 $y = f(x)$ 的一阶导数连续, 则曲线 $y = f(x)$ 称为光滑曲线. 

分段光滑曲线: 如果函数 $y = f(x)$ 的一阶导数除有限多个点之外, 在其它的点处都连续, 这样的曲线 $y=f(x)$ 就称为分段光滑曲线. 

#### 绝对可积函数

绝对可积函数: 指绝对值可积的函数. 可积分函数必定绝对可积, 且函数的绝对值和积分不小于该函数的积分的绝对值. 



### 傅里叶变换的缺陷

离散傅里叶变换: 

$$\begin{aligned} C[n] = & \sum_{k=0}^{K-1} A[k] e^{-i \frac{2 n \pi k}{K}} \\ = & \sum_{k=0}^{K-1} A[k] \left[ \cos{\frac{2 n \pi k}{K}} - i \sin{\frac{2 n \pi k}{K}} \right] \\ = & \sum_{k=0}^{K-1} A[k] \cos{\frac{2 n \pi k}{K}} - i \sum_{k=0}^{K-1} A[k] \sin{\frac{2 n \pi k}{K}} \end{aligned}$$ 

从离散傅里叶变换来看, 当 $A[k]$ 是单调指数递增函数时, 则在正无穷处 $A[k]$ 取到无穷大. 则 $n=0$ 处 $C[0]$ 为无穷大. 因此, 对于单调指数递增函数, 是不能进行傅里叶变换的 (单调递增函数不是**绝对可积函数**). 

因此傅里叶变换存在其不能应用的场景. 



### 拉普拉斯变换

1. 一般信号的定义域只在 $[0, + \infty)$. 
2. 单调指数递增函数不能做傅里叶变换. 

为了解决傅里叶变换的这些缺点. 

1. 在对函数做傅里叶变换之前, 对函数乘以 $e^{- \beta t}$. 
2. 给函数乘以 $u(t)$, 其在 $t \le 0$ 时 $u(t) = 0$, $t > 0$ 时, $u(t) = 1$. 

则有: 

$$\begin{aligned} L[f(t)] = & \int_{- \infty}^{+ \infty}{f(t) u(t) e^{- \beta t} e^{-j \omega t} \text{d}t} \\ = & \int_{0}^{+ \infty}{f(t) e^{- (\beta + j \omega)t} \text{d}t} \end{aligned}$$ 

令: $s = - (\beta + j \omega)$, 可得 $f(t)$ 的拉普拉斯变换公式: 

$$\begin{aligned} F(s) = & \int_{0}^{+ \infty}{f(t) e^{-s t} \text{d}t} \\ = & \int_{0}^{+ \infty}{f(t) e^{- \beta t} e^{- j \omega t} \text{d}t} \\ = & \int_{0}^{+ \infty}f(t) e^{- \beta t} (\cos{\omega t} - j \sin{\omega t}) \text{d}t  \\ = & \int_{0}^{+ \infty}f(t) e^{- \beta t} (\cos{\frac{n \pi t}{l}} - j \sin{\frac{n \pi t}{l}}) \text{d}t \end{aligned}$$ 

其中: $\beta$ 为正数, 当 $\beta$ 大于一定值时, 单调指数递增函数就不会无限递增. 





### 离散拉普拉斯变换

对原函数乘以 $e^{- \beta t}$ 后, 再做离散傅里叶变换. 



离散傅里叶变换: 

$$\begin{aligned} C[n] = & \sum_{k=0}^{K-1} A[k] e^{-i \frac{2 n \pi k}{K}} \\ = & \sum_{k=0}^{K-1} A[k] \left[ \cos{\frac{2 n \pi k}{K}} - i \sin{\frac{2 n \pi k}{K}} \right] \\ = & \sum_{k=0}^{K-1} A[k] \cos{\frac{2 n \pi k}{K}} - i \sum_{k=0}^{K-1} A[k] \sin{\frac{2 n \pi k}{K}} \end{aligned}$$ 

其中: $n$ 的取值范围为 $0, \pm 1, \pm 2, \pm3, ... \pm \frac{K}{2}$, 



离散拉普拉斯变换: 

$$\begin{aligned} C[n] = & \sum_{k=0}^{K-1} A[k] e^{- (\beta + \frac{2 n \pi}{K}) k} \\ = & \sum_{k=0}^{K-1} A[k] e^{- \beta k} e^{-i \frac{2 n \pi k}{K}} \\ = & \sum_{k=0}^{K-1} A[k] e^{- \beta k} \left[ \cos{\frac{2 n \pi k}{K}} - i \sin{\frac{2 n \pi k}{K}} \right] \\ = & \sum_{k=0}^{K-1} A[k] e^{- \beta k} \cos{\frac{2 n \pi k}{K}} - i \sum_{k=0}^{K-1} A[k] e^{- \beta k} \sin{\frac{2 n \pi k}{K}} \end{aligned}$$ 



### Z 变换

对于拉普拉斯变换, 令 $z = e^{s} = e^{(\beta + j \omega)}$, 有: 

$$\begin{aligned} F(\omega) = & \int_{0}^{+ \infty}{f(t) e^{-(\beta + j \omega) t} \text{d}t} \\ F(s) = & \int_{0}^{+ \infty}{f(t) e^{-s t} \text{d}t} \\ H(z) = & \int_{0}^{+ \infty}{f(t) z^{- t} \text{d}t} \end{aligned}$$ 





对于拉普拉斯变换的离散形式. 令: $z = e^{(\beta + \frac{2 n \pi}{K})}$, 有: 

$$\begin{aligned} H(z) = & \sum_{k=0}^{K-1} A[k] z^{- k} \end{aligned}$$ 



注意: 

傅里叶变换中的 $n$ 值都是取整数, 而 Z 变换中 $z = e^{(\beta + \frac{2 n \pi}{K})}$ 包含了 $n$ 值, 因此, $z$ 的取值不是任意的. 

由于时域的卷积等于频域的乘积这一特性, 有些系统计算在频域下更加容易. 因此, 在解决了傅里叶变换的缺点后的 Z 变换更适用作对系统的表达. 而实际计算时仍然需要考虑到 $z$ 值与 $n$ 值之间的关系. 



