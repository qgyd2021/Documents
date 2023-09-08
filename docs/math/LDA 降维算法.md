## LDA 降维算法

https://blog.csdn.net/xiaoweidz9/article/details/79895489

https://zhuanlan.zhihu.com/p/74590718



LDA 的全称是 Linear Discriminant Analysis (线性判别分析), 是一种 supervised learning. LDA 通常作为数据预处理阶段的降维技术, 经常经过特征提取以后, 我们需要进行降维. LDA 算法既可以用来降维, 又可以用来分类. 



### LDA目标

在对高维样本进行降维后, 我们希望样本在降维后, (1) 同类样本尽量靠近, (2)不同类样本尽量远离. 

采用的方法是, 使用矩阵 $W$ 对原样本进行映射, 之后需要各个类别的均值向量要相互远离 (方差大), 各类别自身的样本要相互靠近, 

![image.png](https://s2.loli.net/2022/01/06/pY8ZFSi956L4Uzy.png)



### 全局散度

全局散度 $S_{t}$, 全局样本数量 $m$ 类别数量 $k$. 样本 $X$, 每一行是一个样本 $x_{i}$. 

$$\begin{aligned} \mu = & \frac{1}{m} \sum_{i=1}^{m}{x_{i}} \end{aligned}$$ 



$$\begin{aligned} S_{t} = & \sum_{i=1}^{m} (x_{i} - \mu)(x_{i} - \mu)^{\mathsf{T}} \end{aligned}$$ 



### 类内散度

类内散度 $S_{w}$, 是各个类别各自, 各向量的方差的和: 

$$\begin{aligned} S_{wi} = \sum_{j=1}^{m_{i}}{(x_{j} - \mu_{i})(x_{j} - \mu_{i})^{\mathsf{T}}} \end{aligned}$$ 



$$\begin{aligned} S_{w} = & \sum_{i=1}^{k}{S_{wi}} \\ = & \sum_{i=1}^{k}{\sum_{j=1}^{m_{i}}{(x_{j} - \mu_{i})(x_{j} - \mu_{i})^{\mathsf{T}}}} \\ = & \sum_{i=1}^{k}{[(X_{i} - \mu_{i})^{T}(X_{i} - \mu_{i})]} \end{aligned}$$ 





### 类间散度

类间散度 $S_{b}$, 是各个类别中心到全局中心的方差和: 

$$\begin{aligned} S_{b} = & S_{t} - S_{w} \\ = & \sum_{i=1}^{m} (x_{j} - \mu)(x_{j} - \mu)^{\mathsf{T}} - \sum_{i=1}^{k}{\sum_{j=1}^{m_{i}}{(x_{j} - \mu_{i})(x_{j} - \mu_{i})^{\mathsf{T}}}} \\ = & \sum_{i=1}^{k}\sum_{j=1}^{m_{i}} (x_{j} - \mu)(x_{j} - \mu)^{\mathsf{T}} - \sum_{i=1}^{k}{\sum_{j=1}^{m_{i}}{(x_{j} - \mu_{i})(x_{j} - \mu_{i})^{\mathsf{T}}}} \\ = & \sum_{i=1}^{k}\sum_{j=1}^{m_{i}} \left[ (x_{j} - \mu)(x_{j} - \mu)^{\mathsf{T}} - (x_{j} - \mu_{i})(x_{j} - \mu_{i})^{\mathsf{T}} \right] \\ = & \sum_{i=1}^{k}\sum_{j=1}^{m_{i}} [(x_{j} x_{j}^{\mathsf{T}} - x_{j} \mu^{\mathsf{T}} - \mu x_{j}^{\mathsf{T}} + \mu \mu^{\mathsf{T}} ) - (x_{j} x_{j}^{\mathsf{T}} - x_{j} \mu_{i}^{\mathsf{T}} - \mu_{i} x_{j}^{\mathsf{T}} + \mu_{i} \mu_{i}^{\mathsf{T}} )] \\ = & \sum_{i=1}^{k}\sum_{j=1}^{m_{i}} (x_{j} x_{j}^{\mathsf{T}} - x_{j} \mu^{\mathsf{T}} - \mu x_{j}^{\mathsf{T}} + \mu \mu^{\mathsf{T}} - x_{j} x_{j}^{\mathsf{T}} + x_{j} \mu_{i}^{\mathsf{T}} + \mu_{i} x_{j}^{\mathsf{T}} - \mu_{i} \mu_{i}^{\mathsf{T}}) \\ = & \sum_{i=1}^{k}\sum_{j=1}^{m_{i}} ( - x_{j} \mu^{\mathsf{T}} - \mu x_{j}^{\mathsf{T}} + \mu \mu^{\mathsf{T}} + x_{j} \mu_{i}^{\mathsf{T}} + \mu_{i} x_{j}^{\mathsf{T}} - \mu_{i} \mu_{i}^{\mathsf{T}} ) \\ = & \sum_{i=1}^{k}\sum_{j=1}^{m_{i}} [ x_{j}( \mu_{i}^{\mathsf{T}} - \mu^{\mathsf{T}} )  + ( \mu_{i} - \mu ) x_{j}^{\mathsf{T}} + (\mu \mu^{\mathsf{T}} - \mu_{i} \mu_{i}^{\mathsf{T}})] \\ = & \sum_{i=1}^{k} [ (\sum_{j=1}^{m_{i}}x_{j} )( \mu_{i}^{\mathsf{T}} - \mu^{\mathsf{T}} )  + ( \mu_{i} - \mu ) (\sum_{j=1}^{m_{i}} x_{j}^{\mathsf{T}}) + \sum_{j=1}^{m_{i}}(\mu \mu^{\mathsf{T}} - \mu_{i} \mu_{i}^{\mathsf{T}})] \\ = & \sum_{i=1}^{k} [ m_{i}\mu_{i}( \mu_{i}^{\mathsf{T}} - \mu^{\mathsf{T}} )  + ( \mu_{i} - \mu ) m_{i}\mu_{i}^{\mathsf{T}} + m_{i}(\mu \mu^{\mathsf{T}} - \mu_{i} \mu_{i}^{\mathsf{T}})] \\ = & \sum_{i=1}^{k} m_{i} [ \mu_{i}( \mu_{i}^{\mathsf{T}} - \mu^{\mathsf{T}} )  + ( \mu_{i} - \mu ) \mu_{i}^{\mathsf{T}} + (\mu \mu^{\mathsf{T}} - \mu_{i} \mu_{i}^{\mathsf{T}})] \\ = & \sum_{i=1}^{k} m_{i} (\mu_{i}\mu_{i}^{\mathsf{T}} - \mu_{i}\mu^{\mathsf{T}} + \mu_{i}\mu_{i}^{\mathsf{T}} - \mu\mu_{i}^{\mathsf{T}} + \mu \mu^{\mathsf{T}} - \mu_{i} \mu_{i}^{\mathsf{T}}) \\ = & \sum_{i=1}^{k} m_{i} ( - \mu_{i}\mu^{\mathsf{T}} + \mu_{i}\mu_{i}^{\mathsf{T}} - \mu\mu_{i}^{\mathsf{T}} + \mu \mu^{\mathsf{T}}) \\ = & \sum_{i=1}^{k} m_{i} [(\mu_{i} - \mu)(\mu_{i}^{\mathsf{T}} - \mu^{\mathsf{T}})] \\ = & \sum_{i=1}^{k} m_{i} [(\mu_{i} - \mu)(\mu_{i} - \mu)^{\mathsf{T}}] \\ = & (\Mu - \mu)^{\mathsf{T}} \text{diag}(m) (\Mu - \mu) \end{aligned}$$ 





### LDA 的优化目标

LDA 的优化目标是, **最大化类间散度 $S_{b}$, 最小化类内散度 $S_{w}$**. 



#### 类内散度

现假设, 我们将 $n$ 维样本映射到一维的空间中. 即 $W$ 是 $n$ 行 $1$ 列的向量. 

$$\begin{aligned} \widetilde{S}_{w} = & \sum_{i=1}^{k}{\sum_{j=1}^{m_{i}}{(x_{j}W - \mu_{i}W)(x_{j}W - \mu_{i}W)^{\mathsf{T}}}} \end{aligned}$$ 



$$\begin{aligned}\widetilde{S}_{w}^{i} = & \sum_{j=1}^{m_{i}}{(x_{j}W - \mu_{i}W)(x_{j}W - \mu_{i}W)^{\mathsf{T}}} \\ = & \left[ \begin{matrix} w_{11} & w_{21} & \cdots & w_{n1} \end{matrix} \right] \left[ \begin{matrix} x_{11}^{i} - \mu_{1}^{i} & x_{21}^{i} - \mu_{1}^{i} & \cdots & x_{m_{i}1}^{i} - \mu_{1}^{i} \\ x_{12}^{i} - \mu_{2}^{i} & x_{22}^{i} - \mu_{2}^{i} & \cdots & x_{m_{i}2}^{i} - \mu_{2}^{i} \\ \cdots & \cdots & \cdots & \cdots \\ x_{1n}^{i} - \mu_{n}^{i} & x_{2n}^{i} - \mu_{n}^{i} & \cdots & x_{m_{i}n}^{i} - \mu_{n}^{i} \end{matrix} \right] \left[ \begin{matrix} x_{11}^{i} - \mu_{1}^{i} & x_{12}^{i} - \mu_{2}^{i} & \cdots & x_{1n}^{i} - \mu_{n}^{i} \\ x_{21}^{i} - \mu_{1}^{i} & x_{22}^{i} - \mu_{2}^{i} & \cdots & x_{2n}^{i} - \mu_{n}^{i} \\ \cdots & \cdots & \cdots & \cdots \\ x_{m_{i}1}^{i} - \mu_{1}^{i} & x_{m_{i}2}^{i} - \mu_{2}^{i} & \cdots & x_{m_{i}n}^{i} - \mu_{n}^{i} \end{matrix} \right] \left[ \begin{matrix} w_{11} \\ w_{21} \\ \cdots \\ w_{n1} \end{matrix} \right] \end{aligned}$$ 



#### 类间散度

现假设, 我们将 $n$ 维样本映射到一维的空间中. 即 $W$ 是 $n$ 行 $1$ 列的向量. 

$$\begin{aligned} \widetilde{S}_{b} = & \sum_{i=1}^{k} m_{i} [(\mu_{i} W - \mu W)(\mu_{i} W - \mu W)^{\mathsf{T}}] \\ = &  \left[ \begin{matrix} w_{11} & w_{21} & \cdots & w_{n1} \end{matrix} \right] \left[ \begin{matrix} \mu_{1}^{1} - \mu_{1} & \mu_{1}^{2} - \mu_{1} & \cdots & \mu_{1}^{k} - \mu_{1} \\ \mu_{2}^{1} - \mu_{2} & \mu_{2}^{2} - \mu_{2} & \cdots & \mu_{2}^{k} - \mu_{2} \\ \cdots & \cdots & \cdots & \cdots \\ \mu_{n}^{1} - \mu_{n} & \mu_{n}^{2} - \mu_{n} & \cdots & \mu_{n}^{k} - \mu_{n} \end{matrix} \right] \left[ \begin{matrix} m_{1} & 0 & \cdots & 0 \\ 0 & m_{2} & 0 & 0 \\ \cdots & \cdots & \cdots & \cdots \\ 0 & 0 & 0 & m_{k} \end{matrix} \right] \left[ \begin{matrix} \mu_{1}^{1} - \mu_{1} & \mu_{2}^{1} - \mu_{2} & \cdots & \mu_{n}^{1} - \mu_{n} \\ \mu_{1}^{2} - \mu_{1} & \mu_{2}^{2} - \mu_{2} & \cdots & \mu_{n}^{2} - \mu_{n} \\ \cdots & \cdots & \cdots & \cdots \\ \mu_{1}^{k} - \mu_{1} & \mu_{2}^{k} - \mu_{2} & \cdots & \mu_{n}^{k} - \mu_{n} \end{matrix} \right] \left[ \begin{matrix} w_{11} \\ w_{21} \\ \cdots \\ w_{n1} \end{matrix} \right] \end{aligned}$$ 



#### 优化目标

最大化: $$\begin{aligned} \frac{\widetilde{S}_{b}}{\widetilde{S}_{w}} \end{aligned}$$ . 令: $$\begin{aligned} \widetilde{S}_{w} = 1 \end{aligned}$$ . 

采用拉格朗日乘子法 ($\lambda$ 是常数, 加与减没有影响), 即最大化: 

$$\begin{aligned} L(W, \lambda) = & \widetilde{S}_{b} - \lambda (\widetilde{S}_{w} - 1) \\ = & \widetilde{S}_{b} - \lambda \widetilde{S}_{w} + \lambda \end{aligned}$$ 



$$\begin{aligned} \frac{\partial{\widetilde{S}_{b}}}{\partial{W}} = 2 \times \left[ \begin{matrix} \mu_{1}^{1} - \mu_{1} & \mu_{1}^{2} - \mu_{1} & \cdots & \mu_{1}^{k} - \mu_{1} \\ \mu_{2}^{1} - \mu_{2} & \mu_{2}^{2} - \mu_{2} & \cdots & \mu_{2}^{k} - \mu_{2} \\ \cdots & \cdots & \cdots & \cdots \\ \mu_{n}^{1} - \mu_{n} & \mu_{n}^{2} - \mu_{n} & \cdots & \mu_{n}^{k} - \mu_{n} \end{matrix} \right] \left[ \begin{matrix} m_{1} & 0 & \cdots & 0 \\ 0 & m_{2} & 0 & 0 \\ \cdots & \cdots & \cdots & \cdots \\ 0 & 0 & 0 & m_{k} \end{matrix} \right] \left[ \begin{matrix} \mu_{1}^{1} - \mu_{1} & \mu_{2}^{1} - \mu_{2} & \cdots & \mu_{n}^{1} - \mu_{n} \\ \mu_{1}^{2} - \mu_{1} & \mu_{2}^{2} - \mu_{2} & \cdots & \mu_{n}^{2} - \mu_{n} \\ \cdots & \cdots & \cdots & \cdots \\ \mu_{1}^{k} - \mu_{1} & \mu_{2}^{k} - \mu_{2} & \cdots & \mu_{n}^{k} - \mu_{n} \end{matrix} \right] \left[ \begin{matrix} w_{11} \\ w_{21} \\ \cdots \\ w_{n1} \end{matrix} \right] \end{aligned}$$ 



$$\begin{aligned} \frac{\partial{\widetilde{S}_{w}^{i}}}{\partial{W}} = 2 \times \left[ \begin{matrix} x_{11}^{i} - \mu_{1}^{i} & x_{21}^{i} - \mu_{1}^{i} & \cdots & x_{m_{i}1}^{i} - \mu_{1}^{i} \\ x_{12}^{i} - \mu_{2}^{i} & x_{22}^{i} - \mu_{2}^{i} & \cdots & x_{m_{i}2}^{i} - \mu_{2}^{i} \\ \cdots & \cdots & \cdots & \cdots \\ x_{1n}^{i} - \mu_{n}^{i} & x_{2n}^{i} - \mu_{n}^{i} & \cdots & x_{m_{i}n}^{i} - \mu_{n}^{i} \end{matrix} \right] \left[ \begin{matrix} x_{11}^{i} - \mu_{1}^{i} & x_{12}^{i} - \mu_{2}^{i} & \cdots & x_{1n}^{i} - \mu_{n}^{i} \\ x_{21}^{i} - \mu_{1}^{i} & x_{22}^{i} - \mu_{2}^{i} & \cdots & x_{2n}^{i} - \mu_{n}^{i} \\ \cdots & \cdots & \cdots & \cdots \\ x_{m_{i}1}^{i} - \mu_{1}^{i} & x_{m_{i}2}^{i} - \mu_{2}^{i} & \cdots & x_{m_{i}n}^{i} - \mu_{n}^{i} \end{matrix} \right] \left[ \begin{matrix} w_{11} \\ w_{21} \\ \cdots \\ w_{n1} \end{matrix} \right] \end{aligned}$$ 



$$\begin{aligned} \frac{\partial{L}}{\partial{W}} = & \frac{\partial{\widetilde{S}_{b}}}{\partial{W}} - \lambda \sum_{i=1}^{k} \frac{\partial{\widetilde{S}_{w}^{i}}}{\partial{W}} \\ = & 2 (\Mu - \mu)^{\mathsf{T}} \text{diag}(m) (\Mu - \mu) W - \lambda \sum_{i=1}^{k} 2 (X_{i} - \mu_{i})^{\mathsf{T}} (X_{i} - \mu_{i}) W \end{aligned}$$ 

令: 

$$\begin{aligned} \frac{\partial{L}}{\partial{W}} = 0 \end{aligned}$$ 

即: 

$$\begin{aligned} (\Mu - \mu)^{\mathsf{T}} \text{diag}(m) (\Mu - \mu) W = & \lambda \sum_{i=1}^{k} (X_{i} - \mu_{i})^{\mathsf{T}} (X_{i} - \mu_{i}) W \\ (\Mu - \mu)^{\mathsf{T}} \text{diag}(m) (\Mu - \mu) W = & \lambda \sum_{i=1}^{k} (X_{i} - \mu_{i})^{\mathsf{T}} (X_{i} - \mu_{i}) W \\ [\sum_{i=1}^{k} (X_{i} - \mu_{i})^{\mathsf{T}} (X_{i} - \mu_{i})]^{-1} \cdot [(\Mu - \mu)^{\mathsf{T}} \text{diag}(m) (\Mu - \mu)] W = & \lambda W \\ [S_{w}^{-1} \cdot S_{b}] W = \lambda W \end{aligned}$$ 



特征值分解 $Ax = \lambda x$. 

即求: $S_{w}^{-1} \cdot S_{b}$ 矩阵的特征值. 























































