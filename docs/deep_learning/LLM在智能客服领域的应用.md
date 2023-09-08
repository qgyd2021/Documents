## LLM在智能客服领域的应用



### 应用案例



#### (1)TaskBot中的意图识别

在智能客服机器人需要处理一个新的场景时, 问题有: 

1. 新的场景中我们没有足够的相关的训练数据, 
2. 无法预先知道应该将用户意图区分为哪些标签. 
3. 通用的 `句型分类` 和 `关键词` 组合识别意图的方式仍然具有相当的人工配置的工作量. 

因此, 我们建议了以下的方案, 即通过让 LLM 做选择题的方式进行智能的意图识别, 此过程中只需要准备 `当前机器人的话术`, `用户的回答`, 以及`候选的机器人话术`. 

此方法最大的优点就是 `快`, `灵活`, 在面对中小客户或者是随时变化的灵活场景中, 我们需要这种立即可以生效的方案. 



定制 prompt 模板如下, 其中 `{query}` 是需要填充用户回答的部分: 

```text
You are an e-commerce customer service robot.

Below is the history conversation Context: 
---------
AI: Hi dear
lt's my great honor to be your Whatsapp friend.
lf you need any help, you can click the button below to get the solution!

User: {query}.
---------


Which option should AI replying to the user ? 
---------
Option ID: A
AI Answer: Click the link: https://bppoo.com/MNryim to get help!
Description: This option is about how to get the track id or track info. 

Option ID: B
AI Answer: GET 2.99E WITH EXCELLENT REVIEWS
Description: This option is about the reward when the customers leave a excellent review. 

Option ID: C
AI Answer: Please go to the "Me" page of Voghion APP and click "Support" or "24/7 VIP" to get help!
Description: This option is about how to switch to manual customer service. 
---------

Tips:
1. Only reply the Option ID. 
2. Reply X when no Option available.

Option ID: 
```



调用 `OpenAI` 的 `text-davinci-003` 模型得到的输出结果分别如下: 

```text
query: where is my parcel arrived.
option: A

query: how to get the reward. 
option: B

query: I don't want to talk with robot.
option: C
```





#### (2)会话摘要

在智能外呼系统中, 由于受到对话响应时间的限制, 我们无法在线上使用较复杂的算法模型, 因此对话中的错误常常会发生. 

有些客户会对AI外呼筛选出的标签进行人工的二次确认, 然后再转交下一个业务环节. 



我们建议通过 LLM 对会话进行最终的打标签并提取关键的摘要信息. 

定制 prompt 模板如下, 其中 `{conversation}` 是需要填充的部分: 

```
我们向你提供关于电商物流派送中AI机器人向客户确认其是否仍然需要他购买的商品的对话. 
你需要判断这个对话属于以下标签中的哪一个: 
Label: 同意
Description: 客户表示需要该商品, 希望我们为其派送商品. 
Label: 拒收
Description: 客户表示不再需要该商品, 我们不要为其派送. 
Label: 未知
Description: 通过对话无法判断用户是否还需要商品. 

另外你还需要提供客户表示其意图的关键句子 Key Sentence. 

Example: 

Conversation: 
-------------
AI: 您好
User: 
AI: 您好，请问您是莊芳菁吗？
User:
AI:您在我们这里购买过的內增高小白鞋，价格是1299，因为没有送达成功，我们将再次为您派送，请问您还需要吗？
User:
AI:您之前在网上购买了內增高小白鞋，您方便收货吗？
User:要買
AI:好的，我们会尽快为您安排订单并进行派送，祝您生活愉快，再见！
-------------
Label: 同意  
Key Sentence: 要買

Conversation: 
-------------
{conversation}
-------------
Label: 
```



测试示例如下: 

**示例1**: 

```text
我们向你提供关于电商物流派送中AI机器人向客户确认其是否仍然需要他购买的商品的对话. 
你需要判断这个对话属于以下标签中的哪一个: 
Label: 同意
Description: 客户表示需要该商品, 希望我们为其派送商品. 
Label: 拒收
Description: 客户表示不再需要该商品, 我们不要为其派送. 
Label: 未知
Description: 通过对话无法判断用户是否还需要商品. 

另外你还需要提供客户表示其意图的关键句子 Key Sentence. 

Example: 

Conversation: 
-------------
AI: 您好
User: 
AI: 您好，请问您是莊芳菁吗？
User:
AI:您在我们这里购买过的內增高小白鞋，价格是1299，因为没有送达成功，我们将再次为您派送，请问您还需要吗？
User:
AI:您之前在网上购买了內增高小白鞋，您方便收货吗？
User:要買
AI:好的，我们会尽快为您安排订单并进行派送，祝您生活愉快，再见！
-------------
Label: 同意  
Key Sentence: 要買

Conversation: 
-------------
AI:您好
User:
AI:您好，请问您是<say-as interpret-as=""name"">謝清生</say-as>吗？
User:什麼事啊？,哎。
AI:您在我们这里购买过的切割機套裝，价格是990，因为没有送达成功，我们将再次为您派送，请问您还需要吗？
User:
AI:您之前在网上购买了切割機套裝，您方便收货吗？
User:與三五
AI:
User:一三不要送就可以
AI:好的，那不好意思，打扰您，再见
-------------
Label: 
```

调用 `OpenAI` 的 `text-davinci-003` 模型得到的输出结果如下: 

```text
拒收
Key Sentence: 一三不要送就可以
```



**示例2**: 

```text
我们向你提供关于电商物流派送中AI机器人向客户确认其是否仍然需要他购买的商品的对话. 
你需要判断这个对话属于以下标签中的哪一个: 
Label: 同意
Description: 客户表示需要该商品, 希望我们为其派送商品. 
Label: 拒收
Description: 客户表示不再需要该商品, 我们不要为其派送. 
Label: 未知
Description: 通过对话无法判断用户是否还需要商品. 

另外你还需要提供客户表示其意图的关键句子 Key Sentence. 

Example: 

Conversation: 
-------------
AI: 您好
User: 
AI: 您好，请问您是莊芳菁吗？
User:
AI:您在我们这里购买过的內增高小白鞋，价格是1299，因为没有送达成功，我们将再次为您派送，请问您还需要吗？
User:
AI:您之前在网上购买了內增高小白鞋，您方便收货吗？
User:要買
AI:好的，我们会尽快为您安排订单并进行派送，祝您生活愉快，再见！
-------------
Label: 同意  
Key Sentence: 要買

Conversation: 
-------------
AI:您好
User:
AI:您好，请问您是<say-as interpret-as=""name"">賴玉秀</say-as>吗？
User:
AI:您在我们这里购买过的超聲波驅蟲器，价格是799，因为没有送达成功，我们将再次为您派送，请问您还需要吗？
User:
AI:您之前在网上购买了超聲波驅蟲器，您方便收货吗？
User:什麼東西
AI:您购买的是超聲波驅蟲器，请问您还需要吗？
User:
AI:您在我们这里购买过的超聲波驅蟲器，价格是799，因为没有送达成功，我们将再次为您派送，请问您还需要吗？
User:不是我先問一下裡面有什麼
AI:好的，那不好意思，打扰您，再见
-------------
Label: 
```

调用 `OpenAI` 的 `text-davinci-003` 模型得到的输出结果如下: 

```
未知
Key Sentence: 不是我先問一下裡面有什麼
```



**示例3**: 

```text
我们向你提供关于电商物流派送中AI机器人向客户确认其是否仍然需要他购买的商品的对话. 
你需要判断这个对话属于以下标签中的哪一个: 
Label: 同意
Description: 客户表示需要该商品, 希望我们为其派送商品. 
Label: 拒收
Description: 客户表示不再需要该商品, 我们不要为其派送. 
Label: 未知
Description: 通过对话无法判断用户是否还需要商品. 

另外你还需要提供客户表示其意图的关键句子 Key Sentence. 

Example: 

Conversation: 
-------------
AI: 您好
User: 
AI: 您好，请问您是莊芳菁吗？
User:
AI:您在我们这里购买过的內增高小白鞋，价格是1299，因为没有送达成功，我们将再次为您派送，请问您还需要吗？
User:
AI:您之前在网上购买了內增高小白鞋，您方便收货吗？
User:要買
AI:好的，我们会尽快为您安排订单并进行派送，祝您生活愉快，再见！
-------------
Label: 同意  
Key Sentence: 要買

Conversation: 
-------------
AI:您好
User:
AI:您好，请问您是李健元吗？
User:講話。
AI:您在我们这里购买过的淡斑美肌霜，价格是1080，因为没有送达成功，我们将再次为您派送，请问您还需要吗？
User:我沒有買呀
AI:好的，那不好意思，打扰您，再见
-------------
Label: 
```

调用 `OpenAI` 的 `text-davinci-003` 模型得到的输出结果如下: 

```
拒绝 
Key Sentence: 我沒有買呀
```





#### (3)分类数据自动标注

无论是针对`特定领域`还是`通用领域`的意图识别标签体系, 其构建过程中都会涉及到如何更加高效的标注数据. 

数据标注的过程一般如下: 

1. **确定标签体系** 此过程由算法工程师和业务人员一起标注. 此阶段完成后, 表现为标注样本量有限, 标签数量相对较大, 各类别的标注样本少. 制作的分类模型准确率不高. 
2. **大规模标注** 在确定标签体系后, 转移给标注员进行大规模标注, 此过程一般借助标注平台完成, 其中包含 `主动学习` 的相关效率提升方法. 



我们的方法就是在早期数据不充足, 模型不准, 难以开展主动学习时应用 LLM, 智能的做数据标注. 



定制 prompt 模板如下, 其中 `{examples}`, `{sentence}` 是需要填充的部分: 

```
我们在做电话营销场景的意图识别任务, 并给定了一些示例如下: 

Examples: 
---------
{examples}
---------

你需要从 Examples 示例中的 Intent 意图标签中选择一个给以下句子

Tips: 
1. 如果句子不属于这些意图中的任何一个, 你可以回答: 无关领域. 
2. 意图标签和信心分数用换行符隔开, 即各占一行. 
3. 不要编造 Intent 意图. 信心分数也不应该为 0.

Sentence: {sentence}
Intent:
```

备注: 

* 前期我们已有模型但准确率很差, 因此我们考虑 top k 准确率, 即正确标签在前 k 个预测标签中的概率, 当其达到可接受的阈值后, 即可只将 top k 的候选标签填充到 prompt 中做 LLM 意图识别. 
* 有时候 LLM 会生成不存在于 `Examples` 中的意图, 或者生成 `信心分数` 太小或为零, 的则可以重试几次. 



测试示例如下: 

**示例1**: 

```text
我们在做电话营销场景的意图识别任务, 并给定了一些示例如下: 

Examples: 
---------
Sentence: 没什么是什么
Intent: 无关领域

Sentence: 费用怎么样
Intent: 查收费方式

Sentence: 不是很够
Intent: 否定答复

Sentence: 我听到啊。
Intent: 肯定答复

Sentence: 我现在钱多啊怎么办啊
Intent: 资金充足

Sentence: 哎，我没有做玩股票啊，谢谢喔欸。
Intent: 否定(没有)

Sentence: 不用不用谢谢哈
Intent: 否定(不用了)

Sentence: 噢不需要不需要。
Intent: 否定(不需要)

Sentence: 有没有2,000万？
Intent: 疑问(数值)

Sentence: 还钱操作方不方便
Intent: 查操作流程
---------

你需要从 Examples 示例中的 Intent 意图标签中选择一个给以下句子, 并给出0到1之间的信心分数. 

Tips: 
1. 如果句子不属于这些意图中的任何一个, 你可以回答: 无关领域. 
2. 意图标签和信心分数用换行符隔开, 即各占一行. 
3. 不要编造 Intent 意图. 信心分数也不应该为 0.

Sentence: 免费给我用的话，我就要不用签字了，打到卡上来
Intent:
```

调用 `OpenAI` 的 `text-davinci-003` 模型得到的输出结果如下: 

```text
查收费方式
0.7
```



**示例2**: 

```text
我们在做电话营销场景的意图识别任务, 并给定了一些示例如下: 

Examples: 
---------
Sentence: 不方便，不好意思，谢谢。
Intent: 否定(不方便)

Sentence: 没办法用
Intent: 否定答复

Sentence: 嗯没有需要耶
Intent: 否定(不需要)

Sentence: 靠!我也不想啊
Intent: 否定(不想要)

Sentence: 我需要啊谢谢你
Intent: 肯定(需要)

Sentence: 我的电脑什么时候能到吖
Intent: 疑问(时间)

Sentence: 谀奉承
Intent: 无关领域

Sentence: 不是怎么靠谱
Intent: 否定(不是)

Sentence: 扣扣号码吗
Intent: 查操作流程

Sentence: 在忙吧10
Intent: 用户正忙
---------

你需要从 Examples 示例中的 Intent 意图标签中选择一个给以下句子, 并给出0到1之间的信心分数. 

Tips: 
1. 如果句子不属于这些意图中的任何一个, 你可以回答: 无关领域. 
2. 意图标签和信心分数用换行符隔开, 即各占一行. 
3. 不要编造 Intent 意图. 信心分数也不应该为 0.

Sentence: 不需要开会啊
Intent:
```

调用 `OpenAI` 的 `text-davinci-003` 模型得到的输出结果如下: 

```text
否定(不需要)
0.7
```



**示例3**: 

```text
我们在做电话营销场景的意图识别任务, 并给定了一些示例如下: 

Examples: 
---------
Sentence: 会的会的
Intent: 会按时处理

Sentence: 下等下等
Intent: 无关领域

Sentence: 有钱的
Intent: 资金充足

Sentence: 已经。
Intent: 已完成

Sentence: 我只有少量的闲钱
Intent: 资金困难

Sentence: 我要告诉你们天天骚扰我
Intent: 骚扰电话

Sentence: 我不愿意
Intent: 否定(不可以)

Sentence: 小姐，我这样好都开始不上班，所以没时间看股票。
Intent: 否定(没时间)

Sentence: 啊没钱
Intent: 否定(没有)

Sentence: 没去啊
Intent: 否定答复
---------

你需要从 Examples 示例中的 Intent 意图标签中选择一个给以下句子, 并给出0到1之间的信心分数. 

Tips: 
1. 如果句子不属于这些意图中的任何一个, 你可以回答: 无关领域. 
2. 意图标签和信心分数用换行符隔开, 即各占一行. 
3. 不要编造 Intent 意图. 信心分数也不应该为 0.

Sentence: 欠了许多债
Intent:
```

调用 `OpenAI` 的 `text-davinci-003` 模型得到的输出结果如下: 

```text
资金困难
0.8
```



















