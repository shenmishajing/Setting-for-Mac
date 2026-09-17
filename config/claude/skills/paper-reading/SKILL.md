---
name: paper-reading
description: Introduce, summarize, review, or digest research papers. Provides the fixed structure for a paper introduction, a concise OpenReview-style review, and a multi-paper category digest. Use when the user asks to explain, introduce, summarize, review, critique, or write up one or more papers.
---

# Paper reading and write-ups

Three modes. Pick the one that matches the request; if the user gives no more specific instruction, "introduce this paper" means mode 1.

Common rules for every mode:

- Write in the language the user is chatting in. Keep paper titles, method names, and dataset names in their original form.
- Ground every judgement in the paper's own text or in cited prior work. If the evidence is insufficient, say so explicitly instead of guessing.
- Never fabricate results, numbers, citations, or implementation details.
- When a claim about prior work matters, cite the prior paper with a link (arXiv or venue page).
- When the paper's description of its method is vague or insufficient for reproduction, state that as a finding.

## Mode 1: introduce a paper

Cover these points in this order. Use headings when the write-up is long; use a tight paragraph per point when it is short.

1. **Background**: the area and what was known before this paper.
2. **Core problem**: the precise problem or gap the paper attacks, stated as the authors would and as you would.
3. **Prior work**: the closest existing approaches and what they do.
4. **Method**: the concrete method, at the level a reader could re-implement it. Name the components, the inputs and outputs of each, the training or inference procedure, and the key design choices with the reasons the authors give.
5. **Differences from prior work**: what is new, and what is a recombination of known pieces.
6. **Experiment design**: datasets, metrics, baselines, ablations, and whether the comparison is fair.
7. **Result analysis**: the main numbers, what they do and do not support, and any notable failure cases or trends.
8. **Conclusions**: what the paper claims, limitations the authors admit, and limitations they do not.
9. **Judgement**: an explicit verdict on
   - clarity: is the method described unambiguously?
   - reproducibility: code, hyperparameters, compute, seeds?
   - suspiciousness: anything that looks too good, unfair, cherry-picked, or unexplained.

## Mode 2: review a paper (OpenReview style)

The user prefers concise drafts in simple, human-like wording, as a reviewer would actually write. Structure:

1. **Summary**: two to four sentences on what the paper does and claims. Neutral tone.
2. **Strengths**: bullet list. Each bullet is one concrete strength with a pointer to where it is shown (section, table, figure).
3. **Weaknesses**: bullet list, most important first. Each bullet states the problem, why it matters for the paper's claims, and what would fix it. Distinguish fixable-in-rebuttal from fundamental.
4. **Questions for the authors**: numbered, answerable, tied to specific weaknesses.
5. **Minor issues**: typos, notation, missing references. Keep short.
6. **Scores**: soundness, presentation, contribution, overall rating, confidence, each with one sentence of justification. Follow the venue's scale if the user names one.

Write it so the user can paste it with light editing. No preamble, no meta commentary about being an AI.

## Mode 3: digest several papers

Used for daily or weekly paper reports and for "summarize these N papers" requests.

1. **Count and statistics**: date window and how many papers were fetched, filtered, and kept, as concise bullets.
2. **Category overview**: group the papers into a small number of clear categories. For each category explain what it is about and how it differs from prior trends.
3. **Detailed analysis by category**: same categories as above. For every paper:
   - first line: the title as a Markdown link to the paper's URL;
   - a flexible analysis, not a rigid checklist;
   - the method part must be concrete enough that a reader understands what was actually done, not only high-level buzzwords;
   - if the paper's method description is too vague for concrete understanding or reproduction, say so.

## Related tooling

- Finding, filtering, and correcting paper metadata is handled by the `paper-skills` skill. Use it for collection; use this skill for reading and writing.
- When cleaning a bibliography, prefer upgrading arXiv preprints to their published venue citations whenever reliable published metadata is available.
