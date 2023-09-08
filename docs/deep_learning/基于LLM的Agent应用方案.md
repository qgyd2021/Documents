## 基于LLM的Agent应用方案

针对电商场景. 

```text
参考数据集: 
https://huggingface.co/datasets/NebulaByte/E-Commerce_FAQs
https://huggingface.co/datasets/NebulaByte/E-Commerce_Customer_Support_Conversations
https://huggingface.co/datasets/TrainingDataPro/asos-e-commerce-dataset
https://huggingface.co/datasets/bitext/customer-support-intent-dataset

```

### 场景

电商场景涉及的场景包括: 
```text
Shopping 商品推荐
FAQ 基于商品信息的问答
Order 订单
Refund & Return 退换货
Payment 付款
Shipping 物流
Review 商品评价
Account 帐号
Privacy & Security 隐私与安全
Warranty 售后服务
Gift Cards 折扣

```

其中: 

(1) `Shopping 商品推荐` 需要借助商品推荐API来完成. 

(2) `FAQ 基于商品信息的问答`, `Refund & Return 退换货`, `Payment 付款`, `Account 帐号`, `Privacy & Security 隐私与安全`, `Warranty 售后服务`, `Gift Cards 折扣` 通过 Document QA 完成. 

(3) `Order 订单`, `Shipping 物流`, `Review 商品评价` 需要调用API. 


### 设计思路

```text
(1) 每个场景做为一种意图. 
(2) 每个场景通过一个 Tool 实现. 
(3) Tool 可能是由另一个 Agent 实现. 
(4) 整个过程基于 mrkl 系统 (Observation, Thought, Action, Answer) 来实现. 

```

处理流程: 

(1)接收到用户 Query 后, 先识别场景(意图). 

此过程可以通过专门的意图识别模块, 然后提示 Agent, 也可以完全由 Agent 自己判断, 

(2)Agent 决定调用哪个 Tool. 

调用 Tool 时传入的参数为包含一些信息的 Json 格式. 

(3)Tool被调用之后. 
如果缺少执行操作的信息, 则会返回提示信息, 要求 Agent 补充信息. 
如果完成操作, 但还有后续操作, 同样会提示 Agent 与用户互动. 

(4)Agent 根据 Tool 的响应与用户互动, 实现多轮对话. 


