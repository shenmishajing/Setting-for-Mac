---
name: paper-reading
description: Deep-read a research paper and write a structured nine-point reading note (背景, 核心问题, 之前工作怎么做, 核心 method, 与之前工作的区别, 实验设计, 实验分析, 结论, and a quality audit of clarity, reproducibility and suspicious signs). Use when the user asks to read, introduce, explain, summarize, or 精读 a paper.
---

# Paper reading note

When asked to read, introduce, or explain a paper, output one structured note with exactly the nine sections below, in this order, using these headings (in the conversation language; the Chinese names are the user's own). `${CLAUDE_SKILL_DIR}/references/example-reading-note.md` shows the expected depth.

## The nine points

1. **背景 / Background**
   What research context the paper sits in, and why the problem is worth studying.

2. **核心问题 / Core problem**
   The specific problem the paper tries to solve, and how the paper defines it.

3. **之前工作怎么做 / How prior work does it**
   How related work handled this problem before this paper, and the limitations of each line of work.

4. **核心 method / The method**
   What the method actually is. Cover, concretely:
   - the input and the output;
   - the key modules and what each computes;
   - the training procedure;
   - how it is used at inference or test time.

5. **与之前工作的区别 / Differences from prior work**
   Focus on **method-level novelty**: compared with existing methods that solve the same or a similar problem, what exactly is new in the method. Do not just repeat the authors' claims of being "stronger", "more general", or "better", and do not substitute your own framing for the paper's.

6. **实验设计 / Experiment design**
   Datasets, environments, or tasks; baselines; metrics; the experimental setup; and whether the setup is reasonable.

7. **实验分析 / Result analysis**
   Do not just restate table numbers. Explain which results matter most, what they show, and whether there are negative results, boundary conditions, or places that are not convincing.

8. **结论 / Conclusions**
   What the paper ultimately demonstrates, and how its contribution should be accurately summarized.

9. **method 描述是否清晰、是否足够复现、以及是否存在像 AI 生成/瞎编的可疑之处 / Quality audit**
   The user's added quality check. Evaluate:
   - whether the method is described clearly;
   - whether there is enough detail to reproduce it;
   - whether there are logical jumps, claims not supported by the experiments, exaggerated narrative, or signs that the text was AI-generated or fabricated and the authors never fully implemented the method.

## Fixed requirements

- For points 1 to 8, extract and summarize from the paper itself first. Do not fill gaps with imagination.
- If the paper does not clearly address a point, first say so explicitly ("the paper does not clearly state this"), then give your own cautious interpretation separately.
- Point 5 must answer the method-level novelty question, not a generic comparison.
- Avoid empty summaries. Be specific, evidence-based, and informative enough that the reader knows what the paper actually did.
- Where possible, support summaries with the paper's own key statements, equations, experimental observations, or section references.
- Never complete an unclear passage into a definite fact on the authors' behalf. Mark it as inference or as your interpretation.
- If the method closely resembles an existing line of work, say so directly. Do not accept novelty because the authors claim it.
- Read the full text when available. State explicitly when the note is based only on the abstract or partial text.

## Style

- Clear, specific, research-discussion tone. Not a promotional summary.
- Few generalities, many informative judgements.
- Within a section, distinguish "what the paper explicitly says" from "my understanding" when that helps.
- Use numbered sub-sections inside a point whenever there is more than one module, comparison, dataset, or experiment to cover.
