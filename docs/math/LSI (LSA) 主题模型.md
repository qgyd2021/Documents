## LSI (LSA) 主题模型

https://www.cnblogs.com/bentuwuying/p/6219970.html

https://wenku.baidu.com/view/ff09e133ab114431b90d6c85ec3a87c240288a7e.html



```
图床
https://sm.ms/
```





### 引述

早期, 为了比较文档的相似度, 通过统计文档中单词出现的次数, 作直方图向量. 则相似的文档具有相近的向量. 当文档有长短的差异时, 较长的文档, 单词数较多, 则向量值偏大, 因此可对向量做归一化, 以消除文档长度对向量的影响 (向量 L2 范数归一化). 

后来又提出了 TFIDF 算法, 它可以考虑到单词的逆文档频率 (inverse document frequency) 来加强单词代表文档的重要性. 

通过单词出现次数, 或者单词出现概率的方法可理解为 TF (term frequency) 算法. 但是, 不过是 TF 不是 TFIDF 算法, 它们都是基于单词数量的统计方法来生成文档向量. 这样的文档向量是不连续的. 因此它跟我们通常理解的相似度 (相似度应该是连续的而非跳越的) 不太符合. 

因此, 我们认为, 通过统计得到的文档向量表示, 与文档真实的含义之间存在差异. 



**LSA 主题模型**, 将文档看作由主题组成, 主题由单词组成. 

LSA 主题模型的缺点: 

1. SVD 奇异值分解的计算复杂度非常高, 特征空间维度较大, 计算效率十分低下. 
2. LSA 得到的分布信息是基于已有数据集的, 当一个新的文档进入已有的特征空间时, 需要对整个空间重新训练, 以得到加入新文档后对应的分布信息. 
2. 如果将文档看作由主题组成, 主题由单词组成. 那么, 直接能过 EM 最大似度估计, 对文档矩阵作分解即可, 并不一定要采用奇异值分解. 





### 异奇值分解

我们知道, 对矩阵作奇异值分解, 然后去除 $\lambda$ 较小值对应的部分, 可近似还原矩阵. 



$$\begin{aligned} A = & V \Sigma U^{\top} \\ \left[
\begin{matrix} a_{11} & a_{12} & \cdots & a_{1n} \\ a_{21} & a_{22} & \cdots & a_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ a_{m1} & a_{m2} & \cdots & a_{mn} \end{matrix}
\right] = & \left[
\begin{matrix} v_{11} & v_{21} & \cdots & v_{m1} \\ v_{12} & v_{22} & \cdots & v_{m2} \\ \cdots & \cdots & \cdots & \cdots \\ v_{1m} & v_{2m} & \cdots & v_{mm} \end{matrix}
\right] \cdot \left[
\begin{matrix} \lambda_{1} & 0 & \cdots & 0 & \cdots & 0 \\ 0 & \lambda_{2} & \cdots & 0 & \cdots & 0 \\ \cdots & \cdots & \cdots & \cdots & \cdots & \cdots \\ 0 & 0 & \cdots & \lambda_{m} & \cdots & 0 \end{matrix}
\right]_{m \times n} \cdot \left[
\begin{matrix} u_{11} & u_{12} & \cdots & u_{1n} \\ u_{21} & u_{22} & \cdots & u_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ u_{n1} & u_{n2} & \cdots & u_{nn} \end{matrix}
\right] \end{aligned}$$ 





###文档向量降维

假设有文档集合 $A_{m \times n}$, 又有文档 $d_{n \times 1}$, 它们都是通过单词统计数量作文档向量化, 然后归一化, 即矩阵中的数值, 表示对应文档中对应的单词出现的概率 (单词出现的次数除以单词的总数). 

那么, 计算文档 $d$ 与文档集合中各文档的相似度如下: 

$$\begin{aligned} A_{m \times n} \cdot d_{n \times 1} = & V \Sigma U^{\top} \cdot d_{n \times 1} \\ \left[
\begin{matrix} a_{11} & a_{12} & \cdots & a_{1n} \\ a_{21} & a_{22} & \cdots & a_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ a_{m1} & a_{m2} & \cdots & a_{mn} \end{matrix}
\right] \cdot \left[
\begin{matrix} d_{1} \\ d_{2} \\ \cdots \\ d_{n} \end{matrix}
\right] = & \left[
\begin{matrix} v_{11} & v_{21} & \cdots & v_{m1} \\ v_{12} & v_{22} & \cdots & v_{m2} \\ \cdots & \cdots & \cdots & \cdots \\ v_{1m} & v_{2m} & \cdots & v_{mm} \end{matrix}
\right] \cdot \left[
\begin{matrix} \lambda_{1} & 0 & \cdots & 0 & \cdots & 0 \\ 0 & \lambda_{2} & \cdots & 0 & \cdots & 0 \\ \cdots & \cdots & \cdots & \cdots & \cdots & \cdots \\ 0 & 0 & \cdots & \lambda_{m} & \cdots & 0 \end{matrix}
\right]_{m \times n} \cdot \left[
\begin{matrix} u_{11} & u_{12} & \cdots & u_{1n} \\ u_{21} & u_{22} & \cdots & u_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ u_{n1} & u_{n2} & \cdots & u_{nn} \end{matrix}
\right] \cdot \left[
\begin{matrix} d_{1} \\ d_{2} \\ \cdots \\ d_{n} \end{matrix}
\right] \\ A_{m \times n} \cdot d_{n \times 1} = & V \cdot [\Sigma U^{\top} d_{n \times 1}] \end{aligned}$$ 

从上式, 可以看出, 我们先用奇异值分解将 $A_{m \times n}$ 矩阵转换为 $V_{m \times m}$ 矩阵, 对新的文档做文档相似度时, 先采用 $\Sigma U^{\top} d_{n \times 1}$ 将文档做变换, 然后在 $V_{m \times m}$ 上做向量内积. 

奇异值分解, 我们知道 $\lambda$ 较小值对应项对矩阵 $A_{m \times n}$ 中的值的差值较小, 因此我们可以舍弃 $\lambda$ 较小值对应的项, 来减少 $V$ 矩阵的列, 实现对**文档向量的降维**. 

$$\begin{aligned} \Sigma \cdot U^{\top} \cdot d_{n \times 1} = & \left[
\begin{matrix} \lambda_{1} & 0 & \cdots & 0 & \cdots & 0 \\ 0 & \lambda_{2} & \cdots & 0 & \cdots & 0 \\ \cdots & \cdots & \cdots & \cdots & \cdots & \cdots \\ 0 & 0 & \cdots & \lambda_{m} & \cdots & 0 \end{matrix}
\right]_{m \times n} \cdot \left[
\begin{matrix} u_{11} & u_{12} & \cdots & u_{1n} \\ u_{21} & u_{22} & \cdots & u_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ u_{n1} & u_{n2} & \cdots & u_{nn} \end{matrix}
\right] \cdot \left[
\begin{matrix} d_{1} \\ d_{2} \\ \cdots \\ d_{n} \end{matrix}
\right] \\ = & \left[
\begin{matrix} \lambda_{1} & 0 & \cdots & 0 & \cdots & 0 \\ 0 & \lambda_{2} & \cdots & 0 & \cdots & 0 \\ \cdots & \cdots & \cdots & \cdots & \cdots & \cdots \\ 0 & 0 & \cdots & \lambda_{m} & \cdots & 0 \end{matrix}
\right]_{m \times n} \cdot \left[
\begin{matrix} \sum_{i=1}^{n}{u_{1i} d_{i}} \\ \sum_{i=1}^{n}{u_{2i} d_{i}} \\ \cdots \\ \sum_{i=1}^{n}{u_{ni} d_{i}} \end{matrix}
\right] \\ = & \left[
\begin{matrix} \lambda_{1} \sum_{i=1}^{n}{u_{1i} d_{i}} \\ \lambda_{2} \sum_{i=1}^{n}{u_{2i} d_{i}} \\ \cdots \\ \lambda_{m} \sum_{i=1}^{n}{u_{ni} d_{i}} \end{matrix}
\right] \end{aligned}$$ 





### 提取文档关键词

假设有一个文档 $d$, 只包含一个词 $w_{1}$, 对文档矩阵作内积, 如下: 

$$\begin{aligned}  A_{m \times n} \cdot d_{n \times 1} = & V \Sigma U^{\top} \cdot d_{n \times 1} \\ \left[
\begin{matrix} a_{11} & a_{12} & \cdots & a_{1n} \\ a_{21} & a_{22} & \cdots & a_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ a_{m1} & a_{m2} & \cdots & a_{mn} \end{matrix}
\right] \cdot \left[
\begin{matrix} 1 \\ 0 \\ \cdots \\ 0 \end{matrix}
\right] = & \left[
\begin{matrix} v_{11} & v_{21} & \cdots & v_{m1} \\ v_{12} & v_{22} & \cdots & v_{m2} \\ \cdots & \cdots & \cdots & \cdots \\ v_{1m} & v_{2m} & \cdots & v_{mm} \end{matrix}
\right] \cdot \left[
\begin{matrix} \lambda_{1} & 0 & \cdots & 0 & \cdots & 0 \\ 0 & \lambda_{2} & \cdots & 0 & \cdots & 0 \\ \cdots & \cdots & \cdots & \cdots & \cdots & \cdots \\ 0 & 0 & \cdots & \lambda_{m} & \cdots & 0 \end{matrix}
\right]_{m \times n} \cdot \left[
\begin{matrix} u_{11} & u_{12} & \cdots & u_{1n} \\ u_{21} & u_{22} & \cdots & u_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ u_{n1} & u_{n2} & \cdots & u_{nn} \end{matrix}
\right] \cdot \left[
\begin{matrix} 1 \\ 0 \\ \cdots \\ 0 \end{matrix}
\right] \\ \approx & \left[
\begin{matrix} v_{11} & v_{21} & \cdots & v_{k1} \\ v_{12} & v_{22} & \cdots & v_{k2} \\ \cdots & \cdots & \cdots & \cdots \\ v_{1m} & v_{2m} & \cdots & v_{km} \end{matrix}
\right]_{m \times k} \cdot \left[
\begin{matrix} \lambda_{1} & 0 & \cdots & 0 & \cdots & 0 \\ 0 & \lambda_{2} & \cdots & 0 & \cdots & 0 \\ \cdots & \cdots & \cdots & \cdots & \cdots & \cdots \\ 0 & 0 & \cdots & \lambda_{k} & \cdots & 0 \end{matrix}
\right]_{k \times n} \cdot \left[
\begin{matrix} u_{11} & u_{12} & \cdots & u_{1n} \\ u_{21} & u_{22} & \cdots & u_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ u_{n1} & u_{n2} & \cdots & u_{nn} \end{matrix}
\right] \cdot \left[
\begin{matrix} 1 \\ 0 \\ \cdots \\ 0 \end{matrix}
\right] \\ \approx & \left[
\begin{matrix} v_{11} & v_{21} & \cdots & v_{k1} \\ v_{12} & v_{22} & \cdots & v_{k2} \\ \cdots & \cdots & \cdots & \cdots \\ v_{1m} & v_{2m} & \cdots & v_{km} \end{matrix}
\right]_{m \times k} \cdot \left[
\begin{matrix} \lambda_{1} & 0 & \cdots & 0 \\ 0 & \lambda_{2} & \cdots & 0 \\ \cdots & \cdots & \cdots & \cdots \\ 0 & 0 & \cdots & \lambda_{k} \end{matrix}
\right]_{k \times k} \cdot \left[
\begin{matrix} u_{11} & u_{12} & \cdots & u_{1n} \\ u_{21} & u_{22} & \cdots & u_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ u_{k1} & u_{k2} & \cdots & u_{kn} \end{matrix}
\right]_{k \times n} \cdot \left[
\begin{matrix} 1 \\ 0 \\ \cdots \\ 0 \end{matrix}
\right] \\ \approx & \left[
\begin{matrix} v_{11} & v_{21} & \cdots & v_{k1} \\ v_{12} & v_{22} & \cdots & v_{k2} \\ \cdots & \cdots & \cdots & \cdots \\ v_{1m} & v_{2m} & \cdots & v_{km} \end{matrix}
\right]_{m \times k} \cdot \left[
\begin{matrix} \lambda_{1} & 0 & \cdots & 0 \\ 0 & \lambda_{2} & \cdots & 0 \\ \cdots & \cdots & \cdots & \cdots \\ 0 & 0 & \cdots & \lambda_{k} \end{matrix}
\right]_{k \times k} \cdot \left[
\begin{matrix} u_{11} \\ u_{21} \\ \cdots \\ u_{k1} \end{matrix}
\right]_{k \times 1} \\ \approx & \left[
\begin{matrix} v_{11} & v_{21} & \cdots & v_{k1} \\ v_{12} & v_{22} & \cdots & v_{k2} \\ \cdots & \cdots & \cdots & \cdots \\ v_{1m} & v_{2m} & \cdots & v_{km} \end{matrix}
\right]_{m \times k} \cdot \left[
\begin{matrix} \lambda_{1} u_{11} \\ \lambda_{2} u_{21} \\ \cdots \\ \lambda_{k} u_{k1} \end{matrix}
\right]_{k \times 1} \\ \approx & \left[
\begin{matrix} \sum_{i=1}^{k}{\lambda_{i} v_{i1} u_{i1}} \\ \sum_{i=1}^{k}{\lambda_{i} v_{i2} u_{i1}} \\ \cdots \\ \sum_{i=1}^{k}{\lambda_{i} v_{im} u_{i1}} \end{matrix}
\right]_{m \times 1} \end{aligned}$$ 



通过上式计算, 得出, 词 $w_{1}$ 与每个文档的相似度. 通过上述方法, 我们可以计算每个词与各文档的相似度, 如下: 

$$\begin{aligned} \left[
\begin{matrix} a_{11} & a_{12} & \cdots & a_{1n} \\ a_{21} & a_{22} & \cdots & a_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ a_{m1} & a_{m2} & \cdots & a_{mn} \end{matrix}
\right] \cdot \left[
\begin{matrix} 1 & 0 & \cdots & 0 \\ 0 & 1 & \cdots & 0 \\ \cdots & \cdots & \cdots & \cdots \\ 0 & 0 & \cdots & 1 \end{matrix}
\right] \approx & \left[
\begin{matrix} \sum_{i=1}^{k}{\lambda_{i} v_{i1} u_{i1}} & \sum_{i=1}^{k}{\lambda_{i} v_{i1} u_{i2}} & \cdots & \sum_{i=1}^{k}{\lambda_{i} v_{i1} u_{in}} \\ \sum_{i=1}^{k}{\lambda_{i} v_{i2} u_{i1}} & \sum_{i=1}^{k}{\lambda_{i} v_{i2} u_{i2}} & \cdots & \sum_{i=1}^{k}{\lambda_{i} v_{i2} u_{in}} \\ \cdots & \cdots & \cdots & \cdots \\ \sum_{i=1}^{k}{\lambda_{i} v_{im} u_{i1}} & \sum_{i=1}^{k}{\lambda_{i} v_{im} u_{i2}} & \cdots & \sum_{i=1}^{k}{\lambda_{i} v_{im} u_{in}} \end{matrix}
\right]_{m \times n} \end{aligned}$$ 



每个文档, 分别对各单词的相似度从大到小排序, 即可得到 $\text{top\_n}$ 个最相似单词. 这些词即是**文档的关键词**. 





### 同义词挖掘

任意单词 $w_{i}$ 与文档的相似度, 如下: 

$$\begin{aligned}  A_{m \times n} \cdot d_{n \times 1} = & V \Sigma U^{\top} \cdot d_{n \times 1} \\ \left[
\begin{matrix} a_{11} & a_{12} & \cdots & a_{1n} \\ a_{21} & a_{22} & \cdots & a_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ a_{m1} & a_{m2} & \cdots & a_{mn} \end{matrix}
\right] \cdot \left[
\begin{matrix} 0 \\ \cdots \\ 1 \\ \cdots \\ 0 \end{matrix}
\right] = & \left[
\begin{matrix} v_{11} & v_{21} & \cdots & v_{m1} \\ v_{12} & v_{22} & \cdots & v_{m2} \\ \cdots & \cdots & \cdots & \cdots \\ v_{1m} & v_{2m} & \cdots & v_{mm} \end{matrix}
\right] \cdot \left[
\begin{matrix} \lambda_{1} & 0 & \cdots & 0 & \cdots & 0 \\ 0 & \lambda_{2} & \cdots & 0 & \cdots & 0 \\ \cdots & \cdots & \cdots & \cdots & \cdots & \cdots \\ 0 & 0 & \cdots & \lambda_{m} & \cdots & 0 \end{matrix}
\right]_{m \times n} \cdot \left[
\begin{matrix} u_{11} & u_{12} & \cdots & u_{1n} \\ u_{21} & u_{22} & \cdots & u_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ u_{n1} & u_{n2} & \cdots & u_{nn} \end{matrix}
\right] \cdot \left[
\begin{matrix} 0 \\ \cdots \\ 1 \\ \cdots \\ 0 \end{matrix}
\right] \\ \approx & \left[
\begin{matrix} v_{11} & v_{21} & \cdots & v_{k1} \\ v_{12} & v_{22} & \cdots & v_{k2} \\ \cdots & \cdots & \cdots & \cdots \\ v_{1m} & v_{2m} & \cdots & v_{km} \end{matrix}
\right]_{m \times k} \cdot \left[
\begin{matrix} \lambda_{1} & 0 & \cdots & 0 & \cdots & 0 \\ 0 & \lambda_{2} & \cdots & 0 & \cdots & 0 \\ \cdots & \cdots & \cdots & \cdots & \cdots & \cdots \\ 0 & 0 & \cdots & \lambda_{k} & \cdots & 0 \end{matrix}
\right]_{k \times n} \cdot \left[
\begin{matrix} u_{11} & u_{12} & \cdots & u_{1n} \\ u_{21} & u_{22} & \cdots & u_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ u_{n1} & u_{n2} & \cdots & u_{nn} \end{matrix}
\right] \cdot \left[
\begin{matrix} 0 \\ \cdots \\ 1 \\ \cdots \\ 0 \end{matrix}
\right] \\ \approx & \left[
\begin{matrix} v_{11} & v_{21} & \cdots & v_{k1} \\ v_{12} & v_{22} & \cdots & v_{k2} \\ \cdots & \cdots & \cdots & \cdots \\ v_{1m} & v_{2m} & \cdots & v_{km} \end{matrix}
\right]_{m \times k} \cdot \left[
\begin{matrix} \lambda_{1} & 0 & \cdots & 0 \\ 0 & \lambda_{2} & \cdots & 0 \\ \cdots & \cdots & \cdots & \cdots \\ 0 & 0 & \cdots & \lambda_{k} \end{matrix}
\right]_{k \times k} \cdot \left[
\begin{matrix} u_{11} & u_{12} & \cdots & u_{1n} \\ u_{21} & u_{22} & \cdots & u_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ u_{k1} & u_{k2} & \cdots & u_{kn} \end{matrix}
\right]_{k \times n} \cdot \left[
\begin{matrix} 0 \\ \cdots \\ 1 \\ \cdots \\ 0 \end{matrix}
\right] \\ \approx & \left[
\begin{matrix} v_{11} & v_{21} & \cdots & v_{k1} \\ v_{12} & v_{22} & \cdots & v_{k2} \\ \cdots & \cdots & \cdots & \cdots \\ v_{1m} & v_{2m} & \cdots & v_{km} \end{matrix}
\right]_{m \times k} \cdot \left[
\begin{matrix} \lambda_{1} & 0 & \cdots & 0 \\ 0 & \lambda_{2} & \cdots & 0 \\ \cdots & \cdots & \cdots & \cdots \\ 0 & 0 & \cdots & \lambda_{k} \end{matrix}
\right]_{k \times k} \cdot \left[
\begin{matrix} u_{1i} \\ u_{2i} \\ \cdots \\ u_{ki} \end{matrix}
\right]_{k \times 1} \\ \approx & \left[
\begin{matrix} v_{11} & v_{21} & \cdots & v_{k1} \\ v_{12} & v_{22} & \cdots & v_{k2} \\ \cdots & \cdots & \cdots & \cdots \\ v_{1m} & v_{2m} & \cdots & v_{km} \end{matrix}
\right]_{m \times k} \cdot \left[
\begin{matrix} \lambda_{1} u_{1i} \\ \lambda_{2} u_{2i} \\ \cdots \\ \lambda_{k} u_{ki} \end{matrix}
\right]_{k \times 1}  \end{aligned}$$ 



如果存在两个单词 $w_{1}$, $w_{2}$ 它们与任意文档的相似度分数的 **平方误差 (空间距离)** 越小, 则说明这两个单词越相似, 为 **同义词**. 

$$\begin{aligned} \text{square\_error} = & \sum \left( \begin{matrix}  \left[
\begin{matrix} v_{11} & v_{21} & \cdots & v_{k1} \\ v_{12} & v_{22} & \cdots & v_{k2} \\ \cdots & \cdots & \cdots & \cdots \\ v_{1m} & v_{2m} & \cdots & v_{km} \end{matrix}
\right]_{m \times k} \cdot \left( \begin{matrix} \left[
\begin{matrix} \lambda_{1} u_{1i} \\ \lambda_{2} u_{2i} \\ \cdots \\ \lambda_{k} u_{ki} \end{matrix}
\right]_{k \times 1} - \left[
\begin{matrix} \lambda_{1} u_{1j} \\ \lambda_{2} u_{2j} \\ \cdots \\ \lambda_{k} u_{kj} \end{matrix}
\right]_{k \times 1} \end{matrix} \right) \end{matrix} \right)^{2} \\ = & \left[
\begin{matrix} \hat{u}_{1} & \hat{u}_{2} & \cdots & \hat{u}_{k} \end{matrix}
\right]_{k \times 1} \cdot \left[
\begin{matrix} v_{11} & v_{12} & \cdots & v_{1m} \\ v_{21} & v_{22} & \cdots & v_{2m} \\ \cdots & \cdots & \cdots & \cdots \\ v_{k1} & v_{k2} & \cdots & v_{km} \end{matrix}
\right]_{m \times k} \cdot \left[
\begin{matrix} v_{11} & v_{21} & \cdots & v_{k1} \\ v_{12} & v_{22} & \cdots & v_{k2} \\ \cdots & \cdots & \cdots & \cdots \\ v_{1m} & v_{2m} & \cdots & v_{km} \end{matrix}
\right]_{m \times k} \cdot \left[
\begin{matrix} \hat{u}_{1} \\ \hat{u}_{2} \\ \cdots \\ \hat{u}_{k} \end{matrix}
\right]_{k \times 1} \\ = & \left[
\begin{matrix} \hat{u}_{1} & \hat{u}_{2} & \cdots & \hat{u}_{k} \end{matrix}
\right]_{k \times 1} \cdot \left[
\begin{matrix} 1 & 0 & \cdots & 0 \\ 0 & 1 & \cdots & 0 \\ \cdots & \cdots & \cdots & \cdots \\ 0 & 0 & \cdots & 1 \end{matrix}
\right]_{k \times k} \cdot \left[
\begin{matrix} \hat{u}_{1} \\ \hat{u}_{2} \\ \cdots \\ \hat{u}_{k} \end{matrix}
\right]_{k \times 1} \\ = & \left[
\begin{matrix} \hat{u}_{1} & \hat{u}_{2} & \cdots & \hat{u}_{k} \end{matrix}
\right]_{k \times 1} \cdot \left[
\begin{matrix} \hat{u}_{1} \\ \hat{u}_{2} \\ \cdots \\ \hat{u}_{k} \end{matrix}
\right]_{k \times 1} \end{aligned}$$ 



上式可见, 当 $\Sigma U^{\top}$ 矩阵中任意两列的 **平方误差 (空间距离)** 可表达对应两个单词的相似性. 

$$\begin{aligned} \Sigma U^{\top} = & \left[
\begin{matrix} \lambda_{1} & 0 & \cdots & 0 & \cdots & 0 \\ 0 & \lambda_{2} & \cdots & 0 & \cdots & 0 \\ \cdots & \cdots & \cdots & \cdots & \cdots & \cdots \\ 0 & 0 & \cdots & \lambda_{m} & \cdots & 0 \end{matrix}
\right]_{m \times n} \cdot \left[
\begin{matrix} u_{11} & u_{12} & \cdots & u_{1n} \\ u_{21} & u_{22} & \cdots & u_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ u_{n1} & u_{n2} & \cdots & u_{nn} \end{matrix}
\right] \\ = & \left[
\begin{matrix} \lambda_{1} & 0 & \cdots & 0 \\ 0 & \lambda_{2} & \cdots & 0 \\ \cdots & \cdots & \cdots & \cdots \\ 0 & 0 & \cdots & \lambda_{k} \end{matrix}
\right]_{k \times k} \cdot \left[
\begin{matrix} u_{11} & u_{12} & \cdots & u_{1n} \\ u_{21} & u_{22} & \cdots & u_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ u_{k1} & u_{k2} & \cdots & u_{kn} \end{matrix}
\right]_{k \times n} \\ = & \left[
\begin{matrix} \lambda_{1} u_{11} & \lambda_{1} u_{12} & \cdots & \lambda_{1} u_{1m} & \cdots & \lambda_{1} u_{1n} \\ \lambda_{2} u_{21} & \lambda_{2} u_{22} & \cdots & \lambda_{2} u_{2m} & \cdots & \lambda_{2} u_{2n} \\ \cdots & \cdots & \cdots & \cdots & \cdots & \cdots \\ \lambda_{k} u_{k1} & \lambda_{k} u_{k2} & \cdots & \lambda_{k} u_{km} & \cdots & \lambda_{m} u_{mn} \end{matrix}
\right]_{k \times n} \end{aligned}$$ 







### 提取主题关键词

从 **同义词挖掘** 中可以看出, $\Sigma U^{\top}$ 可以看作是将单词映射为主题的矩阵. $V$ 矩阵表示文档由主题组成. 



$$\begin{aligned} A = & V \Sigma U^{\top} \\ \left[
\begin{matrix} a_{11} & a_{12} & \cdots & a_{1n} \\ a_{21} & a_{22} & \cdots & a_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ a_{m1} & a_{m2} & \cdots & a_{mn} \end{matrix}
\right] = & \left[
\begin{matrix} v_{11} & v_{21} & \cdots & v_{m1} \\ v_{12} & v_{22} & \cdots & v_{m2} \\ \cdots & \cdots & \cdots & \cdots \\ v_{1m} & v_{2m} & \cdots & v_{mm} \end{matrix}
\right] \cdot \left[
\begin{matrix} \lambda_{1} & 0 & \cdots & 0 & \cdots & 0 \\ 0 & \lambda_{2} & \cdots & 0 & \cdots & 0 \\ \cdots & \cdots & \cdots & \cdots & \cdots & \cdots \\ 0 & 0 & \cdots & \lambda_{m} & \cdots & 0 \end{matrix}
\right]_{m \times n} \cdot \left[
\begin{matrix} u_{11} & u_{12} & \cdots & u_{1n} \\ u_{21} & u_{22} & \cdots & u_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ u_{n1} & u_{n2} & \cdots & u_{nn} \end{matrix}
\right] \\ = & \left[
\begin{matrix} v_{11} & v_{21} & \cdots & v_{m1} \\ v_{12} & v_{22} & \cdots & v_{m2} \\ \cdots & \cdots & \cdots & \cdots \\ v_{1m} & v_{2m} & \cdots & v_{mm} \end{matrix}
\right] \cdot \left[
\begin{matrix} \lambda_{1} u_{11} & \lambda_{1} u_{12} & \cdots & \lambda_{1} u_{1m} & \cdots & \lambda_{1} u_{1n} \\ \lambda_{2} u_{21} & \lambda_{2} u_{22} & \cdots & \lambda_{2} u_{2m} & \cdots & \lambda_{2} u_{2n} \\ \cdots & \cdots & \cdots & \cdots & \cdots & \cdots \\ \lambda_{m} u_{m1} & \lambda_{m} u_{m2} & \cdots & \lambda_{m} u_{mm} & \cdots & \lambda_{m} u_{mn} \end{matrix}
\right]_{m \times n} \\ = & \left[
\begin{matrix} \sum_{i=1}^{m}{\lambda_{i}v_{i1}u_{i1}} & \sum_{i=1}^{m}{\lambda_{i}v_{i1}u_{i2}} & \cdots & \sum_{i=1}^{m}{\lambda_{i}v_{i1}u_{im}} & \cdots & \sum_{i=1}^{m}{\lambda_{i}v_{i1}u_{in}} \\ \sum_{i=1}^{m}{\lambda_{i}v_{i2}u_{i1}} & \sum_{i=1}^{m}{\lambda_{i}v_{i2}u_{i2}} & \cdots & \sum_{i=1}^{m}{\lambda_{i}v_{i2}u_{im}} & \cdots & \sum_{i=1}^{m}{\lambda_{i}v_{i2}u_{in}} \\ \cdots & \cdots & \cdots & \cdots & \cdots & \cdots \\ \sum_{i=1}^{m}{\lambda_{i}v_{im}u_{i1}} & \sum_{i=1}^{m}{\lambda_{i}v_{im}u_{i2}} & \cdots & \sum_{i=1}^{m}{\lambda_{i}v_{im}u_{im}} & \cdots & \sum_{i=1}^{m}{\lambda_{i}v_{im}u_{in}} \end{matrix}
\right] \end{aligned}$$ 



从上式异奇值分解可以看出, 文档可以分解为: 

$$\begin{aligned} A = & V \Sigma U^{\top} \\ \left[
\begin{matrix} a_{11} & a_{12} & \cdots & a_{1n} \\ a_{21} & a_{22} & \cdots & a_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ a_{m1} & a_{m2} & \cdots & a_{mn} \end{matrix}
\right] = & \left[
\begin{matrix} v_{11} & v_{21} & \cdots & v_{m1} \\ v_{12} & v_{22} & \cdots & v_{m2} \\ \cdots & \cdots & \cdots & \cdots \\ v_{1m} & v_{2m} & \cdots & v_{mm} \end{matrix}
\right] \cdot \left[
\begin{matrix} \lambda_{1} & 0 & \cdots & 0 & \cdots & 0 \\ 0 & \lambda_{2} & \cdots & 0 & \cdots & 0 \\ \cdots & \cdots & \cdots & \cdots & \cdots & \cdots \\ 0 & 0 & \cdots & \lambda_{m} & \cdots & 0 \end{matrix}
\right]_{m \times n} \cdot \left[
\begin{matrix} u_{11} & u_{12} & \cdots & u_{1n} \\ u_{21} & u_{22} & \cdots & u_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ u_{n1} & u_{n2} & \cdots & u_{nn} \end{matrix}
\right] \\ = & \left[
\begin{matrix} v_{11} & v_{21} & \cdots & v_{m1} \\ v_{12} & v_{22} & \cdots & v_{m2} \\ \cdots & \cdots & \cdots & \cdots \\ v_{1m} & v_{2m} & \cdots & v_{mm} \end{matrix}
\right] \cdot \left[
\begin{matrix} \lambda_{1} u_{11} & \lambda_{1} u_{12} & \cdots & \lambda_{1} u_{1m} & \cdots & \lambda_{1} u_{1n} \\ \lambda_{2} u_{21} & \lambda_{2} u_{22} & \cdots & \lambda_{2} u_{2m} & \cdots & \lambda_{2} u_{2n} \\ \cdots & \cdots & \cdots & \cdots & \cdots & \cdots \\ \lambda_{m} u_{m1} & \lambda_{m} u_{m2} & \cdots & \lambda_{m} u_{mm} & \cdots & \lambda_{m} u_{mn} \end{matrix}
\right]_{m \times n} \\ = & \left[
\begin{matrix} \sum_{i=1}^{m}{\lambda_{i}v_{i1}u_{i1}} & \sum_{i=1}^{m}{\lambda_{i}v_{i1}u_{i2}} & \cdots & \sum_{i=1}^{m}{\lambda_{i}v_{i1}u_{im}} & \cdots & \sum_{i=1}^{m}{\lambda_{i}v_{i1}u_{in}} \end{matrix}
\right] \end{aligned}$$ 



从奇异值分解中, 我们知道, 去除较小 $\lambda$ 对应的项, 再还原矩阵, 所得到的矩阵与原矩阵相比, 平方误差更少. 

如下: 

$$\begin{aligned} \left[
\begin{matrix} a_{11} & a_{12} & \cdots & a_{1n} \\ a_{21} & a_{22} & \cdots & a_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ a_{m1} & a_{m2} & \cdots & a_{mn} \end{matrix}
\right] \approx & \left[
\begin{matrix} v_{11} & v_{21} & \cdots & v_{k1} \\ v_{12} & v_{22} & \cdots & v_{k2} \\ \cdots & \cdots & \cdots & \cdots \\ v_{1m} & v_{2m} & \cdots & v_{km} \end{matrix}
\right]_{m \times k} \cdot \left[
\begin{matrix} \lambda_{1} & 0 & \cdots & 0 \\ 0 & \lambda_{2} & \cdots & 0 \\ \cdots & \cdots & \cdots & \cdots \\ 0 & 0 & \cdots & \lambda_{k} \end{matrix}
\right]_{k \times k} \cdot \left[
\begin{matrix} u_{11} & u_{12} & \cdots & u_{1n} \\ u_{21} & u_{22} & \cdots & u_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ u_{k1} & u_{k2} & \cdots & u_{kn} \end{matrix}
\right]_{k \times n}  \\ \approx & \left[
\begin{matrix} v_{11} & v_{21} & \cdots & v_{k1} \\ v_{12} & v_{22} & \cdots & v_{k2} \\ \cdots & \cdots & \cdots & \cdots \\ v_{1m} & v_{2m} & \cdots & v_{km} \end{matrix}
\right]_{m \times k} \cdot \left[
\begin{matrix} \lambda_{1} u_{11} & \lambda_{1} u_{12} & \cdots & \lambda_{1} u_{1n} \\ \lambda_{2} u_{21} & \lambda_{2} u_{22} & \cdots & \lambda_{2} u_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ \lambda_{k} u_{k1} & \lambda_{k} u_{k2} & \cdots & \lambda_{k} u_{kn} \end{matrix}
\right]_{k \times n} \end{aligned}$$ 



矩阵 $V$ 矩阵表示文档由主题组成. 

$$\begin{aligned} V = & \left[
\begin{matrix} v_{11} & v_{21} & \cdots & v_{k1} \\ v_{12} & v_{22} & \cdots & v_{k2} \\ \cdots & \cdots & \cdots & \cdots \\ v_{1m} & v_{2m} & \cdots & v_{km} \end{matrix}
\right]_{m \times k} \end{aligned}$$ 



矩阵 $\Sigma U^{\top}$ 可以看作是将单词映射为主题的矩阵. 

$$\begin{aligned} \Sigma U^{\top} = & \left[
\begin{matrix} \lambda_{1} u_{11} & \lambda_{1} u_{12} & \cdots & \lambda_{1} u_{1n} \\ \lambda_{2} u_{21} & \lambda_{2} u_{22} & \cdots & \lambda_{2} u_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ \lambda_{k} u_{k1} & \lambda_{k} u_{k2} & \cdots & \lambda_{k} u_{kn} \end{matrix}
\right]_{k \times n} \end{aligned}$$ 

对上面的 $\Sigma U^{\top}$ 矩阵的每一行, 分别从大到小排序, 即可得到每个**主题的 $\text{top\_n}$ 个关键词**. 

由于上面的矩阵在排序时, $\lambda$ 的值并不影响排序结果, 因此, 直接对 $U^{\top}$ 矩阵排序, 即可得到主题关键词. 

$$\begin{aligned} U^{\top} = & \left[
\begin{matrix} u_{11} & u_{12} & \cdots & u_{1n} \\ u_{21} & u_{22} & \cdots & u_{2n} \\ \cdots & \cdots & \cdots & \cdots \\ u_{k1} & u_{k2} & \cdots & u_{kn} \end{matrix}
\right]_{k \times n} \end{aligned}$$ 















