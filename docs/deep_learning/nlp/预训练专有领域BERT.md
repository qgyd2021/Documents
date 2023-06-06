## 预训练专有领域BERT


注意事项: 
```text
想在专有领域上训练自己的BERT, 需注意: 
1. MASK策略. 
2. 位置编码策略. 
3. 多任务. 
4. 引入额外的知识. 
5. 更精细的参数. 
6. 重训练词汇表. 


```

风险: 
```text
有可能吃力不讨好. 效果还没有通用BERT好. 

```

建议: 
```text
建议使用 transformers 库, 可在里面比较完善的代码的基础上做修改. 

```

### MASK策略

```text
MASK策略. 
1. 随机MASK
2. 按词MASK (WWM: whole word mask)
3. ngram MASK (参考ALBERT, 最大取 3-gram)
4. span MASK (参考 SpanBERT, 随机选取 MASK 位置, 随机选取 span 长度 0 到 10, 平均值 3.8)

建议: 
1. 中文应考虑按词MASK. 
2. 英文由于词表是 BPE 训练的, 也可考虑按单词 MASK.

WWM 按词 MASK 实现策略: 
1. 使用中文分词工具将文本进行分词. 
2. 制作 MLM 训练任务的训练数据时, 先采用 WordPiece 分词. 
3. 将 WordPiece 分词结果进行随机 MASK, 当碰到一个完整汉字词时, 把从属于该汉字词的所有字符都 MASK 掉. 

举例: 
原始文本: 
使用语言模型来预测下一个词的probability。

分词文本: 
使用 语言 模型 来 预测 下 一个 词 的 probability 。

原始Mask输入: 
使 用 语 言 [MASK] 型 来 [MASK] 测 下 一 个 词 的 pro [MASK] ##lity 。

全词Mask输入: 
使 用 语 言 [MASK] [MASK] 来 [MASK] [MASK] 下 一 个 词 的 [MASK] [MASK] [MASK] 。

WWM 细节: 
1. 首先需要在中文分词的时候, 将每个字符与其所属的词的对应的关系使用一个index列表或者字典来记录下来, 类似于得到[[c1,c2],[c3,c4,c5]]; 
2. 然后在做MASK替换的时候, 对前述的列表进行打乱, 然后对子列表中的字符进行MASK操作, 直到整个句子的MASK比例达到设定值. 


```


### 位置编码策略. 

```text
位置编码可考虑以下方案: 
1. 正余弦位置编码. 
2. 可训练位置编码. 
3. 可分解嵌入参数 (参考albert). 
4. 相对位置编码. 

建议: 
albert认为, 原bert模型的词嵌入维度与隐藏层大小相同, 但词嵌入学习的上下文无关的表示, 而隐藏层学习的是上下文相关词表示, 显然后者更加复杂.  因此, 词嵌入所需的参数量应该可以大幅减小. 
建议: 将词嵌入设置为 V×E 的矩阵, 再应用一个 E×H 的矩阵将其投影到高维的隐藏层维度 H. 来减少参数量. 

```


### 多任务

```text
MASK 和 NSP 是原 BERT 采用的两个自监督任务. 

在 BERT 中, NSP 任务的正例是文章中连续的两个句子, 而负例则是两篇文档中各选一个句子构造而成. 
先前的研究中, 已经证明 NSP 不是闰个合适的预训练任务. 
推测其原因是模型在判断两个句子的关系时, 不仅考虑了两个句子之间的连贯性, 还会考虑两个句子的主题. 
而两篇文档的主题通常不同, 模型会更多的通过主题去分析两个句子的关系, 而不是句子间的连贯性, 这使得 NSP变成了一个相对简单的任务. 

ALBERT 提出Sentence-order prediction (SOP) 来取代 NSP.  
具体来说, 其正例与 NSP 相同, 而负例是通过选择一篇文档中的两个连续的句子并将它们的顺序变换构造的. 
这样两个句子就具有相同的话题, 模型学习到的更多的是句子间的连贯性. 

```


### 引入额外的知识

```text
专有领域的数据量可能较少, 这可能导致模型坍塌, 即: 训练的BERT模型还不如通用模型. 

建议: 应尝试引入外部数据. 

```


### 更精细的参数

```text
参数设置: 
1. 参考ALBERT, 可考虑去除 dropout. 


```


### 重训练词汇表

```text
如果是从已有的预训练模型中训练, 可考虑在 [unused] token 设置专有名词 token. 
1. 应冻结其它 token, 只训练 [unused] 位置的专有 token. 
2. 取消冻结, 训练全部参数. 

如果是完全重新预训练, 则可训练自己的词汇表. 

pip3 install tokenizers
from tokenizers.bert_wordpiece import BertWordPieceTokenizer

参考链接: 
https://www.thepythoncode.com/article/pretraining-bert-huggingface-transformers-in-python

```


### 参考链接
```text
https://www.zhihu.com/question/434726886
https://blog.51cto.com/u_15060464/2675546
https://github.com/ymcui/Chinese-BERT-wwm

```
