---
name: paper-reading
description: Introduce, summarize, review, or digest research papers. Provides the fixed nine-point structure for a deep paper introduction, a concise OpenReview-style review, and a multi-paper category digest. Use when the user asks to explain, introduce, summarize, read, review, critique, or write up one or more papers.
---

# Paper reading and write-ups

Three modes. Pick the one that matches the request. If the user asks to introduce, explain, or read a paper without more specific instructions, use mode 1.

Rules for every mode:

- Write in the language the user is chatting in. Keep paper titles, method names, and dataset names in their original form.
- Read the full paper when it is available. Say explicitly when a write-up is based only on the abstract or a partial text.
- Ground every judgement in the paper's own text or in cited prior work. If the evidence is insufficient, say so instead of guessing.
- Never fabricate results, numbers, citations, or implementation details.
- When a claim about prior work matters, cite the prior paper with a link (arXiv or venue page).
- Depth matters more than brevity. `${CLAUDE_SKILL_DIR}/references/example-introduction.md` shows the expected granularity.

## Mode 1: introduce a paper (nine points, in this order)

Use a heading per point. Within a point, use numbered sub-items whenever there is more than one component, comparison, dataset, or experiment to cover.

1. **Background**
   The area, what was already known or already worked, and the setting the paper assumes. Enough for a reader outside the subfield to follow the rest.

2. **Core problem**
   The precise problem or gap the paper attacks, stated both as the authors frame it and as you would. Why existing solutions fail on it, concretely.

3. **How prior work does it**
   The closest existing approaches, each as a separate item: what it does, what assumption or mechanism it relies on, and where it breaks.

4. **The method, concretely**
   At the level a reader could re-implement it. Split into numbered modules. For each module: its input and output, what it computes, and the key design choices with the reasons the authors give. Cover the training or inference procedure end to end, including loss or objective, data flow, and any approximations. Name what is new versus borrowed. If the paper leaves a step unspecified, say which.

5. **Differences from prior work**
   One item per compared line of work, mirroring point 3: what changes, and whether the change is a new mechanism or a recombination of known pieces.

6. **Experiment design**
   Report what the paper actually does, item by item:
   - datasets or benchmarks: which ones and why they fit the claim;
   - metrics: which ones, why, and whether they are the mainstream choice for this task;
   - baselines: which ones, what they represent, and whether the comparison is fair (same backbone, same compute, same test-time budget, strong rather than weak baselines);
   - ablations: which components are removed or swapped, and which claim each ablation is meant to support;
   - any analysis experiments (mechanism analysis, case studies, scaling curves).
   Note designs you would have expected but that are missing.

7. **Result analysis**
   The main numbers with the comparison they come from. What the results do and do not support. Trends across settings, failure cases, variance or seeds if reported, and anything where the gain is smaller or less consistent than the text implies.

8. **Conclusions**
   What the paper claims to have shown, the limitations the authors admit, and the limitations they do not.

9. **Judgement: clarity, reproducibility, and suspicious signs**
   - Clarity: is the method described unambiguously, or do key steps rely on the reader guessing?
   - Reproducibility: code, hyperparameters, compute, seeds, data splits. Could the results be rerun?
   - Suspicious signs, each with the evidence: text that reads as AI-assembled or generic; a method described but not visibly used in the experiments; claimed modules absent from ablations or from the released code; results inconsistent with the described mechanism; numbers for baselines that disagree with their original papers. If nothing looks wrong, say so.

## Mode 2: review a paper (OpenReview style)

The user prefers concise drafts in simple, human-like wording, as a reviewer would actually write. Structure:

1. **Summary**: two to four sentences on what the paper does and claims. Neutral tone.
2. **Strengths**: bullet list. Each bullet is one concrete strength with a pointer to where it is shown (section, table, figure).
3. **Weaknesses**: bullet list, most important first. Each bullet states the problem, why it matters for the paper's claims, and what would fix it. Distinguish fixable-in-rebuttal from fundamental.
4. **Questions for the authors**: numbered, answerable, tied to specific weaknesses.
5. **Minor issues**: typos, notation, missing references. Keep short.
6. **Scores**: soundness, presentation, contribution, overall rating, confidence, each with one sentence of justification. Follow the venue's scale if the user names one.

Write it so the user can paste it with light editing. No preamble, no meta commentary.

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
