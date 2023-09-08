## pLSI (pLSA) 主题模型

https://zhuanlan.zhihu.com/p/453189362



图床

```text
https://sm.ms/
```





概率潜在语义分析 (probabilistic latent semantic analysis, PLSA), 也称概率潜在语义索引 (pLSI), 是一种利用概率生成模型对文本集合进行话题分析的无监督学习的方法. 

pLSA 是基于 LSA 的模型, 两者最大的区别是 pLSA 是概率模型, 而 LSA 是非概率模型. 

更进一步的, LSA 模型对文本间空分解成若干个矩阵, 而 pLSA 用概率分布理论对各矩阵进行了装饰. 在后面提到的共现模型中, 可以更加直接的体现了这种矩阵与概率分布的对应关系. 



### pLSA 生成模型

假定, **文档由主题组成**, 主题的数量为 $k$, 那么文档可表示为主题的向量如下: 

$$\begin{aligned} d = \left[ z_{1}, z_{2}, \cdots , z_{k} \right] \end{aligned}$$ 

并规定: 

$$\begin{aligned} \sum_{i=1}^{k}{z_{i}} = 1 \end{aligned}$$ 

即: $z_{i}$ 表示该文档中, 各主题的出现的概率. 可进一步表示为: $$\begin{aligned} P(z | d) \end{aligned}$$. 



**主题由单词组成**, 不同单词的总数量为 $m$, 那么主题可表示为单词的向量如下: 

$$\begin{aligned} z = \left[ w_{1}, w_{2}, \cdots , w_{m} \right] \end{aligned}$$ 

并规定: 

$$\begin{aligned} \sum_{i=1}^{m}{w_{i}} = 1 \end{aligned}$$ 

即: $w_{i}$ 表示该主题中, 各单词出现的概率. 可进一步表示为: $$\begin{aligned} P(w | z) \end{aligned}$$. 



通过对文档的统计, 可以得到各文档出现的概率 $P(d)$, 各文档中各单词出现的概率 $P(w | d)$. 那么我们需要根据 $P(d), P(w | d)$, 求 $P(z | d), P(w | z)$. 

各文档中单词 $w_{i}$ 出现的概率等于该文档中主题出现的概率 $P(z_{j} | d)$ 与该主题中单词 $w_{i}$ 出现的概率 $P(w_{i} | z_{j})$ 的和: 

$$\begin{aligned} P(w_{i} | d) = \sum_{j=1}^{k}{P(w_{i} | z_{j}) P(z_{j} | d)} \end{aligned}$$ 



用矩阵表示如下: 

$$\begin{aligned} D = & \left[ \begin{matrix} a(w_{1}, d_{1}) & a(w_{2}, d_{1}) & \cdots & a(w_{m}, d_{1}) \\ a(w_{2}, d_{2}) & a(w_{2}, d_{2}) & \cdots & a(w_{m}, d_{2}) \\ \cdots & \cdots & \cdots & \cdots \\ a(w_{1}, d_{m}) & a(w_{2}, d_{m}) & \cdots & a(w_{m}, d_{n}) \end{matrix} \right] \\ = & \left[ \begin{matrix} A \cdot P(w_{1}, d_{1}) & A \cdot P(w_{2}, d_{1}) & \cdots & A \cdot P(w_{m}, d_{1}) \\ A \cdot P(w_{1}, d_{2}) & A \cdot P(w_{2}, d_{2}) & \cdots & A \cdot P(w_{m}, d_{2}) \\ \cdots & \cdots & \cdots & \cdots \\ A \cdot P(w_{1}, d_{n}) & A \cdot P(w_{2}, d_{n}) & \cdots & A \cdot P(w_{m}, d_{n}) \end{matrix} \right] \\ = & \left[ \begin{matrix} A \cdot P(d_{1}) P(w_{1}| d_{1}) & A \cdot P(d_{1}) P(w_{2}| d_{1}) & \cdots & A \cdot P(d_{1}) P(w_{m}| d_{1}) \\ A \cdot P(d_{2}) P(w_{1}| d_{2}) & A \cdot P(d_{2}) P(w_{2}| d_{2}) & \cdots & A \cdot P(d_{2}) P(w_{m}| d_{2}) \\ \cdots & \cdots & \cdots & \cdots \\ A \cdot P(d_{n}) P(w_{1}| d_{n}) & A \cdot P(d_{n}) P(w_{2}| d_{n}) & \cdots & A \cdot P(d_{n}) P(w_{m}| d_{n}) \end{matrix} \right] \\ = & \left[ \begin{matrix} a(d_{1}) P(w_{1}| d_{1}) & a(d_{1}) P(w_{2}| d_{1}) & \cdots & a(d_{1}) P(w_{m}| d_{1}) \\ a(d_{2}) P(w_{1}| d_{2}) & a(d_{2}) P(w_{2}| d_{2}) & \cdots & a(d_{2}) P(w_{m}| d_{2}) \\ \cdots & \cdots & \cdots & \cdots \\ a(d_{n}) P(w_{1}| d_{n}) & a(d_{n}) P(w_{2}| d_{n}) & \cdots & a(d_{n}) P(w_{m}| d_{n}) \end{matrix} \right] \\ = & \left[ \begin{matrix} a(d_{1}) \\ a(d_{2}) \\ \cdots \\ a(d_{n}) \end{matrix} \right] \times \left[ \begin{matrix} P(w_{1}| d_{1}) & P(w_{2}| d_{1}) & \cdots & P(w_{m}| d_{1}) \\ P(w_{1}| d_{2}) & P(w_{2}| d_{2}) & \cdots & P(w_{m}| d_{2}) \\ \cdots & \cdots & \cdots & \cdots \\ P(w_{1}| d_{m}) & P(w_{2}| d_{n}) & \cdots & P(w_{m}| d_{n}) \end{matrix} \right] \end{aligned}$$ 



其中: 

$$\begin{aligned} \left[ \begin{matrix} P(w_{1} | d_{1}) & P(w_{2} | d_{1}) & \cdots & P(w_{m} | d_{1}) \\ P(w_{1} | d_{2}) & P(w_{2} | d_{2}) & \cdots & P(w_{m} | d_{2}) \\ \cdots & \cdots & \cdots & \cdots \\ P(w_{1} | d_{n}) & P(w_{2} | d_{n}) & \cdots & P(w_{m} | d_{n}) \end{matrix} \right]_{n \times m} = & \left[ \begin{matrix} P(z_{1} | d_{1}) & P(z_{2} | d_{1}) & \cdots & P(z_{k} | d_{1}) \\ P(z_{1} | d_{2}) & P(z_{2} | d_{2}) & \cdots & P(z_{k} | d_{2}) \\ \cdots & \cdots & \cdots & \cdots \\ P(z_{1} | d_{n}) & P(z_{2} | d_{n}) & \cdots & P(z_{k} | d_{n}) \end{matrix} \right]_{n \times k} \cdot \left[ \begin{matrix} P(w_{1} | z_{1}) & P(w_{2} | z_{1}) & \cdots & P(w_{m} | z_{1}) \\ P(w_{1} | z_{2}) & P(w_{2} | z_{2}) & \cdots & P(w_{m} | z_{2}) \\ \cdots & \cdots & \cdots & \cdots \\ P(w_{1} | z_{k}) & P(w_{2} | z_{k}) & \cdots & P(w_{m} | z_{k}) \end{matrix} \right]_{k \times m} \end{aligned}$$ 





### pLSA 生成模型求解



#### Jensen不等式

https://blog.csdn.net/xiaomeng29/article/details/89380205

https://web.stanford.edu/~boyd/cvxbook/bv_cvxbook.pdf

假设函数 $f(x)$ 为凸函数. 则有: 

$$\begin{aligned} f(\theta x_{1} + (1-\theta) x_{2}) \le \theta f(x_{1}) + (1 - \theta) f(x_{2}) \end{aligned}$$ 

此处, $0 \le \theta \le 1$. 

![image.png](https://s2.loli.net/2022/07/10/xPWTb3sqOmYtal7.png)



利用归纳法, 我们很容易将其扩展到多维情况下: 

$$\begin{aligned} f(\theta_{1} x_{1} + \cdots + \theta_{k} x_{k}) \le \theta_{1} f(x_{1}) + \cdots + \theta_{k} f(x_{k}) \end{aligned}$$ 

其中: $\theta_{1}, \theta_{2}, \cdots , \theta_{k} \ge 0$ 且 $\theta_{1} + \theta_{2} + \cdots + \theta_{k} = 1$. 

如果 $k$ 的取值无限大, 则可以将上式转换为积分的形式, 我们设函数 $p(x) \ge 0$, 且 $$\begin{aligned} \int p(x) \text{d} x = 1 \end{aligned}$$, 用 $p(x)$ 代表 $\theta$, 我们有: 

$$\begin{aligned} f \left( \int_{S}{p(x)x \text{d}x} \right) \le \int_{S} {f(x) p(x) \text{d} x} \end{aligned}$$ 

那么如果 $x$ 是随机变量, $p(x)$ 是概率密度函数, 则止式就变成了: 

$$\begin{aligned} f(\mathbf{E}(x)) \le \mathbf{E}(f(x)) \end{aligned}$$ 





#### 极大似然估计

最大化各文档中, 各单词出现的概率. 

$$\begin{aligned} L = & \sum_{i=1}^{M} \sum_{j=1}^{N} {a(w_{i}, d_{j}) \log{P(w_{i}, d_{j})}} \\ = &  \sum_{i=1}^{M} \sum_{j=1}^{N} { a(w_{i}, d_{j}) \log{ \left[ P(d_{j}) \sum_{k=1}^{K}{P(w_{i} | z_{k}) P(z_{k} | d_{j})} \right]}} \\ = & \sum_{i=1}^{M} \sum_{j=1}^{N}{ a(w_{i}, d_{j}) \left \{ \log{P(d_{j})} + \log{\left[ \sum_{k=1}^{K}{ P(w_{i} | z_{k}) P(z_{k} | d_{j}) } \right]} \right \} } \\ = & \sum_{i=1}^{M} \sum_{j=1}^{N}{ \left \{ a(w_{i}, d_{j}) \log{P(d_{j})} + a(w_{i}, d_{j}) \log{\left[ \sum_{k=1}^{K}{ P(w_{i} | z_{k}) P(z_{k} | d_{j}) } \right]} \right \} } \\ = & \sum_{j=1}^{N} a(d_{j}) \log{P(d_{j})} + \sum_{i=1}^{M} \sum_{j=1}^{N} a(w_{i}, d_{j}) \log{\left[ \sum_{k=1}^{K}{ P(w_{i} | z_{k}) P(z_{k} | d_{j}) } \right]} \\ = & \sum_{j=1}^{N} a(d_{j}) \left( \log{P(d_{j})} + \sum_{i=1}^{M}{ \frac{ a(w_{i}, d_{j})}{ a(d_{j}) } \log{\sum_{k=1}^{K}{ P(w_{i} | z_{k}) P(z_{k} | d_{j})}} } \right) \end{aligned}$$ 



其中: 

* $$\begin{aligned} a(d_{j}) = \sum_{i=1}^{M}{a(w_{i}, d_{j})} \end{aligned}$$ , 表示文档 $d_{j}$ 中的单词个数. 
* $N$ 是文档数. 
* $M$ 是总词数. 



条件: 

$$\begin{aligned} \sum_{i=1}^{M}{P(w_{i} | z_{k}) = 1} \quad k = 1,2,\cdots , K \\ \sum_{k=1}^{K}{P(z_{k} | d_{j}) = 1} \quad j = 1,2, \cdots , N \end{aligned}$$ 



极大化 $L$, 相当于极大化: 

$$\begin{aligned} L^{'} = & \sum_{i=1}^{M} \sum_{j=1}^{N} a(w_{i}, d_{j}) \log{\left[ \sum_{k=1}^{K}{ P(w_{i} | z_{k}) P(z_{k} | d_{j}) } \right]} \\ = & \text{sum} \left \{ \left[ \begin{matrix} a(w_{1}, d_{1}) & a(w_{2}, d_{1}) & \cdots & a(w_{m}, d_{1}) \\ a(w_{1}, d_{2}) & a(w_{2}, d_{2}) & \cdots & a(w_{m}, d_{2}) \\ \cdots & \cdots & \cdots & \cdots \\ a(w_{1}, d_{n}) & a(w_{2}, d_{n}) & \cdots & a(w_{m}, d_{n}) \end{matrix} \right] \times \log \left( \left[ \begin{matrix} P(z_{1} | d_{1}) & P(z_{2} | d_{1}) & \cdots & P(z_{k} | d_{1}) \\ P(z_{1} | d_{2}) & P(z_{2} | d_{2}) & \cdots & P(z_{k} | d_{2}) \\ \cdots & \cdots & \cdots & \cdots \\ P(z_{1} | d_{n}) & P(z_{2} | d_{n}) & \cdots & P(z_{k} | d_{n}) \end{matrix} \right]_{n \times k} \cdot \left[ \begin{matrix} P(w_{1} | z_{1}) & P(w_{2} | z_{1}) & \cdots & P(w_{m} | z_{1}) \\ P(w_{1} | z_{2}) & P(w_{2} | z_{2}) & \cdots & P(w_{m} | z_{2}) \\ \cdots & \cdots & \cdots & \cdots \\ P(w_{1} | z_{k}) & P(w_{2} | z_{k}) & \cdots & P(w_{m} | z_{k}) \end{matrix} \right]_{k \times m} \right) \right \} \end{aligned}$$ 





拉格朗日乘子法: 

$$\begin{aligned} f = & \sum_{i=1}^{M} \sum_{j=1}^{N} a(w_{i}, d_{j}) \log{\left[ \sum_{k=1}^{K}{ P(w_{i} | z_{k}) P(z_{k} | d_{j}) } \right]} \\ g = & \sum_{k=1}^{K} { \rho_{k} \left( 1 - \sum_{i=1}^{M} {P(w_{i} | z_{k})} \right) } + \sum_{j=1}^{N} \tau_{j} \left( 1 - \sum_{k=1}^{K} { P(z_{k} | d_{j}) } \right) \\ F = & \sum_{i=1}^{M} \sum_{j=1}^{N} a(w_{i}, d_{j}) \log{\left[ \sum_{k=1}^{K}{ P(w_{i} | z_{k}) P(z_{k} | d_{j}) } \right]} + \sum_{k=1}^{K} { \rho_{k} \left( 1 - \sum_{i=1}^{M} {P(w_{i} | z_{k})} \right) } + \sum_{j=1}^{N} \tau_{j} \left( 1 - \sum_{k=1}^{K} { P(z_{k} | d_{j}) } \right) \end{aligned}$$ 

分别对 $P(z_{k} | d_{j})$ 和 $P(w_{i} | z_{k})$ 求偏导 (把 $\log$ 当作 $\ln$), 并令其为 $0$, 从而得到: 



$$\begin{aligned} \frac{\partial{F}}{\partial{P(z_{k} | d_{j})}} = & \sum_{i=1}^{M} \frac{ a(w_{i}, d_{j}) P(w_{i}|z_{k})}{ \sum_{k=1}^{K}{ P(w_{i} | z_{k}) P(z_{k} | d_{j}) }} - \tau_{j} \\ = & \sum_{i=1}^{M} \frac{ a(w_{i}, d_{j}) P(w_{i}|z_{k})}{ P(w_{i} | d_{j}) } - \tau_{j} \\ = & \sum_{i=1}^{M} \frac{ a(w_{i}, d_{j}) P(w_{i}|z_{k})}{ \frac{a(w_{i}, d_{j})}{a(d_{j})} } - \tau_{j} \\ = & \sum_{i=1}^{M} a(d_{j}) P(w_{i}|z_{k}) - \tau_{j} \end{aligned}$$ 



$$\begin{aligned} \frac{\partial{F}}{\partial{P(w_{i} | z_{k})}} = & \sum_{j=1}^{N} \frac{ a(w_{i}, d_{j}) P(z_{k} | d_{j})}{ \sum_{k=1}^{K}{ P(w_{i} | z_{k}) P(z_{k} | d_{j}) }} - \rho_{i} \\ = & \sum_{j=1}^{N} \frac{ a(w_{i}, d_{j}) P(z_{k} | d_{j})}{ P(w_{i} | d_{j}) } - \rho_{i} \\ = & \sum_{j=1}^{N} \frac{ a(w_{i}, d_{j}) P(z_{k} | d_{j})}{ \frac{a(w_{i}, d_{j})}{a(d_{j})} } - \rho_{i} \\ = & \sum_{j=1}^{N} a(d_{j}) P(z_{k} | d_{j}) - \rho_{i} \end{aligned}$$ 



$$\begin{aligned} \frac{\partial{F}}{\partial{P(z_{k} | d_{j})}}  \end{aligned}$$ , $$\begin{aligned} \frac{\partial{F}}{\partial{P(w_{i} | z_{k})}} \end{aligned}$$ 中都包含未知数. 且 $\lambda$ 无法消除, 因此**无法求解**. 





根据 **jensen 不等式**: 

$$\begin{aligned} f(\theta_{1} x_{1} + \cdots + \theta_{k} x_{k}) \le \theta_{1} f(x_{1}) + \cdots + \theta_{k} f(x_{k}) \end{aligned}$$ 

函数 $\log$ 是凹函数, 有: 

$$\begin{aligned} \log{\left[ \sum_{k=1}^{K}{ P(w_{i} | z_{k}) P(z_{k} | d_{j}) } \right]} = & \log{\left[ \sum_{k=1}^{K}{ P(z_{k} | w_{i}, d_{j}) \frac{P(w_{i} | z_{k}) P(z_{k} | d_{j})}{P(z_{k} | w_{i}, d_{j})} } \right]} \\ \ge & \sum_{k=1}^{K}{ P(z_{k} | w_{i}, d_{j}) \log{ \left[ \frac{P(w_{i} | z_{k}) P(z_{k} | d_{j})}{P(z_{k} | w_{i}, d_{j})} \right] } }  \\ \ge & \sum_{k=1}^{K}{ P(z_{k} | w_{i}, d_{j}) \log{ \left[ P(w_{i} | z_{k}) P(z_{k} | d_{j}) \right] } - P(z_{k} | w_{i}, d_{j}) \log{ P(z_{k} | w_{i}, d_{j}) } } \end{aligned}$$ 



其中: $$\begin{aligned} P(z_{k} | w_{i}, d_{j}) \log{ P(z_{k} | w_{i}, d_{j}) } \end{aligned}$$ 为常数. 

因此, 最大似然优化的代价函数 $L^{'}$ : 

$$\begin{aligned} L^{'} = \sum_{i=1}^{M} \sum_{j=1}^{N} a(w_{i}, d_{j}) \log{\left[ \sum_{k=1}^{K}{ P(w_{i} | z_{k}) P(z_{k} | d_{j}) } \right]} \end{aligned}$$ 

求 $L^{'}$ 极大, 即求 $L^{'}$ 的下界极大, 即: 

$$\begin{aligned}Q = \sum_{i=1}^{M} \sum_{j=1}^{N} a(w_{i}, d_{j}) \sum_{k=1}^{K}{ P(z_{k} | w_{i}, d_{j}) \log{ \left[ P(w_{i} | z_{k}) P(z_{k} | d_{j}) \right] } } \end{aligned}$$ 



$$\begin{aligned} P(z_{k} | w_{i}, d_{j}) = & \frac{P(w_{i}, d_{j}, z_{k})}{\sum_{k=1}^{K}{P(w_{i}, d_{j}, z_{k})} } \\ = & \frac{ P(w_{i} | d_{j}, z_{k}) P(z_{k} | d_{j}) P(d_{j}) }{\sum_{k=1}^{K}{ P(w_{i} | d_{j}, z_{k}) P(z_{k} | d_{j}) P(d_{j}) } } \\ = & \frac{ P(w_{i} | z_{k}) P(z_{k} | d_{j}) }{\sum_{k=1}^{K}{ P(w_{i} | z_{k}) P(z_{k} | d_{j}) } } \end{aligned}$$ 



$$\begin{aligned} P(w_{i} | z_{k}) P(z_{k} | d_{j}) = & \left[ \begin{matrix} P(w_{1}|z_{1}) & P(w_{2}|z_{1}) & \cdots & P(w_{m}|z_{1}) \\ P(w_{1}|z_{2}) & P(w_{2}|z_{2}) & \cdots & P(w_{m}|z_{2}) \\ \cdots & \cdots & \cdots & \cdots \\ P(w_{1}|z_{k}) & P(w_{2}|z_{k}) & \cdots & P(w_{m}|z_{k}) \end{matrix} \right]_{k \times 1 \times m} \times \left[ \begin{matrix} P(z_{1}|d_{1}) & P(z_{1}|d_{2}) & \cdots & P(z_{1}|d_{n}) \\ P(z_{2}|d_{1}) & P(z_{2}|d_{2}) & \cdots & P(z_{2}|d_{n}) \\ \cdots & \cdots & \cdots & \cdots \\ P(z_{k}|d_{1}) & P(z_{2}|d_{2}) & \cdots & P(z_{k}|d_{n}) \end{matrix} \right]_{k \times n \times 1} \end{aligned}$$ 





拉格朗日乘子法: 

$$\begin{aligned} f = &  \sum_{i=1}^{M} \sum_{j=1}^{N} a(w_{i}, d_{j}) \sum_{k=1}^{K}{ P(z_{k} | w_{i}, d_{j}) \log{ \left[ P(w_{i} | z_{k}) P(z_{k} | d_{j}) \right] } } \\ g = & \sum_{k=1}^{K} { \rho_{k} \left( 1 - \sum_{i=1}^{M} {P(w_{i} | z_{k})} \right) } + \sum_{j=1}^{N} \tau_{j} \left( 1 - \sum_{k=1}^{K} { P(z_{k} | d_{j}) } \right) \\ F = &  \sum_{i=1}^{M} \sum_{j=1}^{N} a(w_{i}, d_{j}) \sum_{k=1}^{K}{ P(z_{k} | w_{i}, d_{j}) \log{ \left[ P(w_{i} | z_{k}) P(z_{k} | d_{j}) \right] } } + \sum_{k=1}^{K} { \rho_{k} \left( 1 - \sum_{i=1}^{M} {P(w_{i} | z_{k})} \right) } + \sum_{j=1}^{N} \tau_{j} \left( 1 - \sum_{k=1}^{K} { P(z_{k} | d_{j}) } \right) \end{aligned}$$ 



分别对 $P(z_{k} | d_{j})$ 和 $P(w_{i} | z_{k})$ 求偏导 (把 $\log$ 当作 $\ln$), 并令其为 $0$, 从而得到: 

$$\begin{aligned} \frac{\partial{F}}{\partial{P(z_{k} | d_{j})}} = & \sum_{i=1}^{M}  a(w_{i}, d_{j}) P(z_{k} | w_{i}, d_{j}) \frac{P(w_{i} | z_{k})}{P(w_{i} | z_{k}) P(z_{k} | d_{j})} - \tau_{j} \\ = & \sum_{i=1}^{M} { \frac{ a(w_{i}, d_{j}) P(z_{k} | w_{i}, d_{j}) }{ P(z_{k} | d_{j}) } } - \tau_{j} \\ = & \frac{ \sum_{i=1}^{M}{ a(w_{i}, d_{j}) P(z_{k} | w_{i}, d_{j}) } }{ P(z_{k} | d_{j}) } - \tau_{j} \end{aligned}$$ 



$$\begin{aligned} \sum_{i=1}^{M}{ a(w_{i}, d_{j}) P(z_{k} | w_{i}, d_{j}) } = & \tau_{j} P(z_{k} | d_{j}) \\ \sum_{k=1}^{K}{ \sum_{i=1}^{M}{ a(w_{i}, d_{j}) P(z_{k} | w_{i}, d_{j}) } } = & \tau_{j} \sum_{k=1}^{K}{ P(z_{k} | d_{j}) } \\ \sum_{k=1}^{K}{ \sum_{i=1}^{M}{ a(w_{i}, d_{j}) P(z_{k} | w_{i}, d_{j}) } }= & \tau_{j} \\ \sum_{i=1}^{M}{ a(w_{i}, d_{j}) }= & \tau_{j} \\ a(d_{j}) = & \tau_{j} \end{aligned}$$ 



得到: 

$$\begin{aligned} P(z_{k} | d_{j}) =  \frac{ \sum_{i=1}^{M}{ a(w_{i}, d_{j}) P(z_{k} | w_{i}, d_{j}) } }{ a(d_{j}) } \end{aligned}$$ 



$$\begin{aligned} A_{1 \times n \times m} \times P_{k \times n \times m} \end{aligned}$$ 



$$\begin{aligned} \frac{\partial{F}}{\partial{P(w_{i} | z_{k})}} = & \sum_{j=1}^{N}  a(w_{i}, d_{j}) P(z_{k} | w_{i}, d_{j}) \frac{P(z_{k} | d_{j})}{P(w_{i} | z_{k}) P(z_{k} | d_{j})} - \rho_{k} \\ = & \sum_{j=1}^{N} { \frac{ a(w_{i}, d_{j}) P(z_{k} | w_{i}, d_{j}) }{ P(w_{i} | z_{k}) } } - \rho_{k} \\ = & \frac{ \sum_{j=1}^{N}{ a(w_{i}, d_{j}) P(z_{k} | w_{i}, d_{j}) } }{ P(w_{i} | z_{k}) } - \rho_{k} \end{aligned}$$ 



$$\begin{aligned} \sum_{j=1}^{N}{ a(w_{i}, d_{j}) P(z_{k} | w_{i}, d_{j}) } = & \rho_{k} P(w_{i} | z_{k}) \\ \sum_{i=1}^{M}{ \sum_{j=1}^{N}{ a(w_{i}, d_{j}) P(z_{k} | w_{i}, d_{j}) } } = & \rho_{k} \sum_{i=1}^{M}{P(w_{i} | z_{k})} \\ \sum_{i=1}^{M}{ \sum_{j=1}^{N}{ a(w_{i}, d_{j}) P(z_{k} | w_{i}, d_{j}) } } = & \rho_{k} \end{aligned}$$ 



得到: 

$$\begin{aligned} P(w_{i} | z_{k}) = \frac{ \sum_{j=1}^{N}{ a(w_{i}, d_{j}) P(z_{k} | w_{i}, d_{j}) } }{ \sum_{i=1}^{M}{ \sum_{j=1}^{N}{ a(w_{i}, d_{j}) P(z_{k} | w_{i}, d_{j}) } } } \end{aligned}$$ 



$$\begin{aligned} A_{1 \times n \times m} \times P_{k \times n \times m} \end{aligned}$$ 

































### pLSA 共现模型

从文档集中我们可以得到的是 $w$ 和 $d$ 档同时出现的概率. 将其分解为 $P(z)$ 主题出现的概率和 $P(w, d | z)$ 主题中 $w$ 和 $d$ 同时出现的概率. 

$$\begin{aligned} P(w, d) = & \sum_{z \in Z}{P(z) P(w, d | z)} \\ = & \sum_{z \in Z}{P(z) P(w | z) P(d | z)} \end{aligned}$$ 



其中, 上述推导中假设在话题 $z$ 给定条件下, 单词 $w$ 与文本 $d$ 是条件独立的, 即: 

$$\begin{aligned} P(w, z | d) = P(w | z) P(d | z) \end{aligned}$$ 



### pLSA 共现模型求解

















