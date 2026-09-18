# Example: depth and granularity of a paper introduction

This is a real write-up produced earlier for an arXiv paper (Vector Policy Optimization). Use it as the yardstick for **how deep each section goes**: the method is split into numbered modules, every related-work comparison is a separate item, and every dataset, metric, and baseline comes with the reason it was chosen.

Two caveats. It follows the older ten-section layout rather than the nine points in SKILL.md, and it was written with only partial access to the full text, so its experiment sections partly describe what the experiments *should* contain. A real introduction reports what the paper actually did and marks anything not found in the paper as missing.

---

## 背景与问题定义
这篇工作讨论的是**面向测试时搜索（test-time search）的语言模型后训练目标**，核心问题非常贴近当前 agent/推理系统的发展方向：当大模型不再只输出单个答案，而是被放进 rejection sampling、best-of-N、evolutionary search、AlphaEvolve 一类搜索框架中时，训练阶段到底应该优化什么。

作者指出，主流 RL 后训练范式通常把奖励压成一个**预先指定的标量目标**，例如 GRPO 一类方法会持续把策略推向当前标量奖励最高的模式。这样做在单次输出场景下是合理的，但在需要多样候选供搜索器筛选的场景里，会带来一个直接问题：**策略分布熵下降、样本高度重复、额外采样收益迅速衰减**。对于 agent inference 而言，这意味着模型虽然单样本可能更强，但在 pass@k、best@k、evolutionary search 这类依赖候选池质量的设置下，未必能给搜索器提供足够“有用的差异性”。

因此，论文重新定义了问题：
- 不是让训练同时承担“探索 + 利用”；
- 而是把**利用交给测试时搜索**，把**训练目标转为生成一组高质量且覆盖不同 reward trade-off 的候选解**。

作者把这种目标称为 **reward diversity**：候选集合中的不同解，不只是表面措辞不同，而是分别在不同奖励维度权衡下接近最优，从而更接近 Pareto frontier 的覆盖问题。这一点与 agent 研究中的“多路径推理”“多工具调用策略”“多 persona 对齐”“多测试样例代码生成”都高度相关。

---

## 研究动机
这篇文章的动机很明确，而且与 LLM agent 的训练/推理闭环关系很强。

第一，现实中的很多 agent 或复杂推理任务，奖励天然不是单一标量，而是**向量值奖励**：
- 代码生成里可以是 per-test-case correctness；
- RLHF / 多偏好对齐里可以是多个评价维度或多个 reward model；
- 多跳推理里可以是 per-hop 成功；
- 工具使用任务里可以是结构正确性、调用有效性、最终答案质量等多个子目标。

第二，测试时搜索越来越成为标准配置。无论是简单的 best-of-k，还是更复杂的 evolutionary search，系统最终依赖的是：**模型能否提供一批互补而非重复的候选**。如果训练阶段已经把策略压缩到单峰分布，那么搜索预算再大，也只是重复采样近似相同的解。

第三，作者强调一种很重要的视角转变：即使部署时最终目标权重是已知的，训练时保留多种 reward trade-off 仍然有价值。原因在于，某些在当前标量目标下看似次优的策略，可能包含更好的中间结构、分解方式或局部 reasoning pattern，经过搜索后反而更容易产生最终高分解。这一点对 agent inference 很关键，因为很多复杂任务的成功并不来自单次最优 rollout，而来自候选池中的“可被后续筛选/重组/进化”的多样轨迹。

---

## 方法概览（模块级）
论文提出的方法叫 **Vector Policy Optimization (VPO)**。从摘要和引言可见，它本质上是对现有 GRPO 风格 RL 后训练的一个较低侵入式替换，重点不在重写整个训练框架，而在于**改变 advantage / 优化目标的构造方式**，使模型学会输出一组在不同奖励权衡下各自擅长的候选。

可以把方法拆成几个模块理解：

### 1. 向量奖励建模
作者假设奖励可以写成：
\[
r(x,y) = [r_1(x,y), ..., r_d(x,y)]
\]
其中每个分量对应一个独立质量维度。与传统做法先固定一个权重向量 \(w^*\) 再优化 \(w^{*\top}r\) 不同，VPO把“奖励的多维结构”直接作为训练信号来源。

### 2. 随机标量化（stochastic reward scalarization）
训练时不只针对单一固定权重，而是对奖励向量采用**随机权重标量化**。直观上，相当于让模型在训练过程中不断面对不同的偏好组合，从而避免所有样本都朝同一个局部最优模式塌缩。

### 3. 多答案联合生成
论文提到 VPO 结合了 **multi-answer generation**。也就是说，模型不是只为一个 prompt 生成单个响应，而是生成一个候选集合；训练目标鼓励这个集合内部的不同答案分别覆盖不同 reward 权衡区域，而不是彼此复制。

### 4. 面向 Pareto frontier 的集合优化
VPO 的关键不是“让每个答案都平均地兼顾所有目标”，而是让**集合中的不同答案专门化（specialize）到不同 trade-off**。这使得候选集更像 Pareto frontier 的近似覆盖，而不是单点收缩。

### 5. 作为 GRPO advantage estimator 的替换件
作者明确说 VPO 基本可以看作是 **GRPO advantage estimator 的 drop-in replacement**。这点很重要，因为它意味着：
- 方法与现有 RLHF / RLVR / post-training pipeline 兼容性较强；
- 研究贡献更偏“训练目标与 credit assignment 的创新”，而不是大规模系统工程；
- 对近期开源训练框架复现和迁移到 agent 任务具有现实可操作性。

从 agent 视角看，VPO 的核心价值在于：它不是直接优化单条轨迹最优，而是优化“**供搜索器消费的候选分布**”。这与很多 agent 系统中 planner / executor / verifier 的协同关系非常一致。

---

## 相关工作对比与差异
这篇工作与几条相关研究线都有明显联系，但切入点有自己的独特性。

### 1. 与标准标量 RL 后训练（如 GRPO）相比
传统 GRPO/策略梯度方法优化的是固定标量奖励，因此天然倾向于模式收缩。VPO 的差异不在于更强 exploitation，而在于**显式保留 reward-diverse solutions**。换言之，它优化的是“搜索友好型分布”，而不是“单样本最优分布”。

### 2. 与提升采样多样性的工作相比
很多工作会通过温度采样、解码扰动、语义去重等方式增加输出差异，但作者强调这些往往只是表层 diversity。VPO 追求的是**沿奖励维度的功能性多样性**，即不同候选在不同目标权衡下各自占优。这比单纯 lexical / semantic diversity 更贴近 agent search 的真实需求。

### 3. 与多目标强化学习（multi-objective RL）相比
论文借鉴了多目标 RL 的思想，尤其是 Pareto frontier 覆盖，但目标并不完全相同。经典多目标 RL 常关注：给定用户偏好，学习可条件化的策略或完整 Pareto 集。而本文并不是要做 preference-conditioned policy，也不是假设部署目标未知；它关注的是：**即便最终只关心一个固定目标，训练时保留多目标覆盖也可能更利于测试时搜索下的最终性能**。

### 4. 与 evolutionary computation / lexicase selection 相比
作者也把方法与 lexicase selection 等“保留在不同子目标上占优个体”的思想联系起来。差异在于，这里对象是语言模型策略后训练，且目标是让 LLM 在单次 rollout 中生成可供后续搜索利用的候选集合。

### 5. 与 agent benchmark / inference 研究的关系
虽然论文本身更偏训练算法，但它的评估方式明显面向 agent inference：best@k、pass@k、evolutionary search 内表现。这使它不只是“训练更稳”或“单样本更强”的 RL 论文，而是直接讨论**训练目标如何影响测试时搜索收益曲线**，这一点对 agent 系统设计很有启发。

---

## 实验设计草案
从摘要与引言可恢复出论文的实验逻辑，整体上是围绕“训练出的策略是否更适合测试时搜索”展开，而不是只看单次响应质量。

一个合理的实验设计框架包括：

### 1. 多任务验证
作者在四类任务上评估，覆盖：
- multi-hop question answering
- logic reasoning
- navigation
- tool use
- coding

虽然摘要说“四个任务”，引言列举了更广的能力维度，说明实验应当是跨任务类型的，重点验证方法不是只对代码或单一 reward decomposition 生效。

### 2. 训练阶段对比
核心比较对象应是：
- VPO
- 强标量 RL baseline（尤其是 matched-compute 的 GRPO）

重点控制训练预算、模型底座、采样数、更新步数等，使差异主要来自目标函数而非算力堆叠。

### 3. 测试时搜索评估
论文最关键的实验不是单样本 accuracy，而是：
- 随着候选预算 \(k\) 增大，best@k / pass@k 如何变化；
- 在更复杂的 evolutionary search 环境中，模型是否能提供更可进化的候选。

这类设计非常适合验证“训练多样性是否真的转化为搜索收益”，也比只看平均 reward 更贴近 agent inference 实际使用方式。

### 4. 搜索预算扩展曲线
摘要明确提到“gap widens as the search budget grows”，因此实验应包含不同 \(k\) 下的性能曲线，而不是只报一个固定 k。因为如果方法真在优化候选分布，那么其优势应在更大采样预算下更明显。

---

## 数据集（及原因）
从已给信息看，论文至少包含以下代表性评测环境：

### 1. LiveCodeBench
这是摘要和图示中明确出现的数据集，用于代码生成场景。它非常适合 VPO，因为代码任务天然具有**按测试用例分解的向量奖励**：每个 test case 都可以看作一个 reward component。对于研究“多样候选是否提升 pass@k / best@k”，这是非常自然且主流的选择。

### 2. OpenEvolve hard subset
论文还把模型放进 OpenEvolve 搜索循环中，尤其关注 hard subset。这个设置的价值在于，它不是简单地看静态采样，而是看模型生成的候选是否能支持更复杂的 evolutionary improvement。对 agent inference / search-augmented generation 来说，这比普通 benchmark 更接近真实系统使用场景。

### 3. 多跳问答 / 逻辑推理 / 导航 / 工具使用任务
引言说明实验覆盖这些能力维度。虽然 excerpt 未给出具体 benchmark 名称，但选择这些任务是合理的，因为它们都能构造多维奖励：
- 多跳问答：每一跳或子问题可分解；
- 逻辑推理：不同中间约束或子目标可分解；
- 导航：路径效率、成功率、约束满足等可分解；
- 工具使用：调用格式、调用正确性、最终答案质量等可分解。

从研究设计角度，这些数据集的共同原因是：**既需要搜索，又存在天然 reward decomposition**，正好支撑 VPO 的方法假设。

---

## 指标（及原因，是否主流）
这篇工作的指标选择非常关键，因为它决定了论文是否真正回答“训练是否改善搜索”。

### 1. pass@k
这是代码生成和多候选评估中的主流指标，衡量前 k 个样本中是否至少有一个正确答案。对于 VPO 来说，pass@k 能直接反映候选池中是否存在互补解，而不是所有样本都重复失败。

### 2. best@k
best@k 衡量在 k 个候选中选到最优解后的性能上界，适合评估“如果有 verifier / reranker / reward model 进行选择，模型候选池能提供多大潜力”。这对 agent inference 非常主流，也比单样本分数更贴近 search-augmented deployment。

### 3. solved problems / # problems solved
图中出现了 “# problems solved”，尤其在 OpenEvolve hard subset 上，这类指标适合衡量 evolutionary search 最终是否真正解锁原本无法解决的问题，而不仅是平均分小幅提升。

### 4. Pareto frontier coverage / diversity-related analysis
虽然摘要未明确列出具体 diversity 指标，但从方法目标看，论文很可能需要分析候选集合对 reward space 的覆盖程度，例如不同 reward weighting 下的最优候选分布、Pareto front 近似程度等。这类指标在主流 benchmark 中不一定标准化，但对验证方法机理非常必要。

总体上，这篇论文的指标体系是主流且合理的，尤其因为它把重点放在 **search-aware metrics** 上，而不是只看单样本 reward。

---

## 基线（公平性说明）
论文摘要明确提到与“the strongest scalar RL baselines”比较，并特别提到 **matched-compute GRPO checkpoint**。这说明作者意识到公平性问题主要在以下几个方面：

### 1. 训练算力匹配
如果 VPO 生成多答案或处理向量奖励，容易被质疑只是用了更多采样/更多计算。因此 matched-compute 对比很关键，意味着需要控制：
- 总 rollout 数；
- 总 token 预算；
- 更新步数；
- 模型参数规模。

### 2. 相同底座模型
摘要中提到 Qwen2.5-Coder-7B-Instruct，说明至少代码实验是在相同 backbone 上比较 VPO 与 GRPO，而不是换更强底模。

### 3. 相同测试时预算
既然论文强调随着 search budget 增大优势扩大，那么 baseline 与 VPO 必须在相同 k、相同 verifier / search loop 下比较，否则无法说明是训练目标带来的收益。

### 4. 强标量 RL 基线而非弱监督基线
这点很重要。若只和 SFT 或 naive sampling 比较，结论说服力有限；而与 GRPO 这类当前主流 RL 后训练方法比较，更能体现方法创新点在于“标量目标 vs 向量目标”的差异。

如果正文完整展开，理想情况下还应包含：
- scalarized reward 的不同聚合方式基线；
- diversity-promoting decoding 基线；
- 多样性正则但非向量奖励建模的基线。

这样才能更清楚地区分：VPO 的收益究竟来自 reward decomposition，还是仅仅来自更高熵采样。

---

## 消融实验（组件级验证）
这篇方法很适合做组件级消融，而且这些消融对判断机理非常关键。

### 1. 去掉随机标量化
验证如果固定单一权重，只保留多答案生成，是否仍能获得主要收益。这样可以区分“多答案”与“多目标训练”各自的贡献。

### 2. 去掉多答案联合生成
只做向量奖励标量化但不显式训练候选集合，可检验集合级训练是否是性能提升的必要条件。

### 3. 不同 reward decomposition 粒度
例如代码任务中按 test case 分解、按 test group 分解、或直接聚合成标量，比较不同粒度对 diversity 与最终 search performance 的影响。这能验证方法是否依赖“有意义的奖励分解”。

### 4. 不同搜索预算 k
虽然这也属于主实验，但从方法验证角度可视为关键消融：如果 VPO 真在优化搜索友好分布，那么优势应随 k 增大而增强；若优势只在小 k 存在，则说明可能只是单样本质量提升。

### 5. 不同 reward weighting 分布
随机标量化时，权重采样策略可能影响 Pareto 覆盖。可以比较均匀采样、偏向某些维度采样、固定少量权重模板等。

### 6. 与简单 entropy bonus 的比较
这是非常重要的消融。因为作者主张的是“reward diversity”而非泛化的高熵输出，因此需要证明 VPO 优于简单增加熵或提高采样温度。

---

## 深度分析可行性（机理分析 / 案例研究）
这篇论文很适合做深入机理分析，而且这些分析对 agent 研究尤其有价值。

### 1. 候选集合的 reward-space 覆盖分析
可以可视化不同方法生成的候选在二维/多维 reward 空间中的分布，观察：
- GRPO 是否集中到单一区域；
- VPO 是否更接近 Pareto frontier；
- 随训练推进，分布是否发生模式塌缩。

这类分析能直接支撑论文的核心论点，而不仅是结果层面的 pass@k 提升。

### 2. 候选间去重后的有效多样性
不仅统计表面不同答案数量，还应分析功能性差异，例如：
- 不同代码解法是否覆盖不同测试样例；
- 不同工具调用轨迹是否对应不同策略；
- 不同 reasoning path 是否在不同子问题上成功。

这能验证 VPO 学到的是“有用差异”，而不是语言表述噪声。

### 3. 搜索过程中的利用方式分析
在 evolutionary search 或 best-of-k 中，可以进一步分析搜索器最终选中的候选来自哪些 reward trade-off 区域，是否真的利用了 VPO 提供的多样候选，而不是仍然只依赖某一类样本。

### 4. 失败案例研究
很值得看 VPO 在哪些任务上收益有限：
- 奖励分解不自然时是否失效；
- reward components 高度相关时是否难以形成有效专门化；
- 搜索器本身较弱时，多样性是否无法转化为最终收益。

这些分析会帮助判断方法适用边界。

### 5. 与 agent setting 的迁移分析
如果扩展到工具使用或多步 agent 任务，可以研究：
- VPO 是否增加策略层面的分叉，而非仅增加最终答案差异；
- 多样性主要出现在 planning、tool selection 还是 execution 细节；
- verifier / reranker 的质量如何影响 VPO 收益释放。

---

## 总结性介绍
整体来看，这篇论文提出了一个非常清晰的命题：**当语言模型被部署在测试时搜索框架中时，后训练目标不应只优化单一标量奖励，而应显式优化可供搜索利用的 reward-diverse 候选集合。**

其方法 VPO 的技术核心是把现实任务中常见的**向量值奖励结构**利用起来，通过**随机标量化 + 多答案联合生成 + 集合级专门化**，让模型学习覆盖不同 reward trade-off，而不是塌缩到单一模式。实验上，它围绕 pass@k、best@k、evolutionary search 等 search-aware 指标展开，强调优势会随着搜索预算增加而扩大，这一点与 agent inference 和 search-augmented LLM 的研究趋势高度一致。

如果从研究启发角度看，这篇工作最值得关注的不是“又一个 RL 变体”，而是它提出了一个更基础的问题重构：**在有测试时搜索的时代，训练目标是否应该从单答案最优，转向候选分布最优。**