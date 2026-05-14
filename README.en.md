# Prism

**🌐 Language**: [中文](README.md) · **English**

> A beam of light enters and splits into many colors — decompose an unfamiliar / legacy / half-finished repo into multi-perspective analysis reports.

**Prism** is a multi-perspective code analysis framework built on top of Claude.
When you're facing a **vibe-coded prototype left half-finished** or a **hard-to-maintain legacy system** (inherited code with no documentation, projects stalled by tech debt, due-diligence on an acquisition target), Prism uses composable **Agent (professional role) × Skill (methodology lens)** pairs to run multiple perspectives in parallel and produce structured, side-by-side comparable reports.

> **Long-term vision**: To become a service that systematically health-checks codebases and delivers actionable optimization plans. This repo is the open-source framework core of that service — a library of professional roles (Agents) × methodology lenses (Skills) that produce structured analytical output.

---

## Why it matters

When engineers inherit a repo, they typically fall into these traps:

- Look only at technical state, miss the usage flow — change code in ways that break user journeys
- Look only at business docs, miss the implementation — severely underestimate handoff cost
- Use a single perspective — risk assessment has blind spots
- Different people analyzing separately produce reports with different skeletons — can't be compared side-by-side

Prism structures this process: **four fixed dimensions, six fixed front-line questions (Q1~Q6) every report must answer, fixed evidence-citation rules** — so that analyses from different perspectives can be placed in the same comparison table.

---

## Core abstractions

### Agent × Skill = N:M composition

| Abstraction | Analogy | Provides |
|---|---|---|
| **Agent** | An employee / a chef | Persona, voice, priority questions, evidence-citation habits |
| **Skill** | A methodology / a recipe | Analysis framework, checklist, output schema, scoring rubric, anti-patterns |

The same Agent can wear different Skills to produce different reports; the same Skill can be used by different Agents.

### Four dimensions

Every Agent and Skill belongs to one of these dimensions:

| Dimension | Nature | Core question |
|---|---|---|
| `application` | IS-leaning | How is the system used? What are the flows? |
| `business` | IS + SHOULD | What value does it create? Who is the customer? |
| `fundamentals` ⭐ | Pure IS | What is the current tech, dependencies, structure? |
| `optimization` | Pure SHOULD | What's wrong and how do we improve it? |

`fundamentals` is the priority dimension — without knowing what IS, you can't evaluate application, business, or optimization.

### Skill stacking rules

Up to 3 Skills can be stacked per analysis call, but **same-category Skills are mutually exclusive** (to avoid two competing methodologies clashing):

- Legal: `tech-inventory-survey + c4-model + 12-factor` (three different categories)
- Illegal: `clean-architecture + ddd-evans` (both are `architecture` category)

### Front-line questions (mandatory section)

No matter which Agent × Skill combination you use, every report must answer these 6 questions:

| # | Question |
|---|---|
| Q1 | What is the core value of this target? |
| Q2 | What is the biggest risk? |
| Q3 | If only one part can be kept, which? |
| Q4 | What can't be touched? |
| Q5 | What should the first week look like? |
| Q6 | Commercial product or internal tool? |

---

## How to use

Prism is a **read-only workbench**: open this repo as your working directory, point `/analyze` at the target repo, and all reports are written into Prism's own `docs/analyses/`. **The target repo is never modified.**

### Prerequisites

- [Claude Code CLI](https://docs.claude.com/en/docs/claude-code/overview) or VSCode Claude extension
- Clone this repo locally

### Single-agent analysis

```bash
# Use the agent's default skill
/analyze agent=system-analyst path=C:\path\to\target-repo

# Specify a skill
/analyze agent=system-analyst skill=tech-inventory-survey path=C:\path\to\target-repo

# Agent intuition mode (no methodology applied)
/analyze agent=system-analyst skill=none path=C:\path\to\target-repo
```

### Full panel analysis (four dimensions at once)

```bash
/analyze panel=full path=C:\path\to\target-repo
```

Runs four `agent × default-skill` combinations in parallel; output goes to `docs/analyses/<target-basename>-<YYYY-MM-DD>/`:

- `00_panel_summary.md` — Q1~Q6 comparison table + per-dimension health scores
- `01_system-analyst.md` (fundamentals)
- `02_business-analyst.md` (application)
- `03_product-strategist.md` (business)
- `04_tech-lead.md` (optimization)

---

## Built-in Agents & Skills

### Agents (4 professional roles)

| Agent | Dimension | Default Skill | Role |
|---|---|---|---|
| `system-analyst` | fundamentals | tech-inventory-survey | Systems analyst — tech stack / structure / dependencies |
| `business-analyst` | application | usage-flow-survey | Business analyst — actors / flows / use cases |
| `product-strategist` | business | value-positioning-survey | Product strategist — market / value / positioning |
| `tech-lead` | optimization | improvement-survey | Tech lead — problems / risks / priorities |

### Skills (9 methodology lenses)

Baseline (one per dimension, used by agents as default):

| Skill | Category | Required sections |
|---|---|---|
| `tech-inventory-survey` | inventory-baseline | Language & framework / Top 10 deps / data layer / external integrations / startup |
| `usage-flow-survey` | usage-baseline | Actor map / main flows / entry points / pain-point signals |
| `value-positioning-survey` | value-baseline | Target customer / problem solved / differentiation / business-model signals |
| `improvement-survey` | improvement-baseline | Code hotspots / architecture issues / test gaps / perf risk / P0~P2 priorities |

Specific schools (stack on top of baseline for visualization and depth):

| Skill | Category | Origin |
|---|---|---|
| `c4-model-brown` | architecture-doc | Simon Brown — C4 Model |
| `ddd-context-map-evans` | context-map | Eric Evans — Domain-Driven Design |
| `wardley-maps-wardley` | strategy-map | Simon Wardley — Wardley Mapping |
| `impact-map-adzic` | goal-mapping | Gojko Adzic — Impact Mapping |
| `user-story-mapping-patton` | user-journey | Jeff Patton — User Story Mapping |

---

## Design principles (excerpt)

- **P-1 Separation of Agent and Skill** — Agent doesn't override methodology; Skill doesn't dictate voice
- **P-3 Skills stack, same category is mutually exclusive** — Max 3 Skills per call
- **P-4 Evidence required** — Every conclusion must cite evidence; uncertain claims must be marked `Status: Inferred / Unknown`
- **P-5 Read-only** — Prism never modifies the target repo
- **P-6 Unified front-line questions** — Q1~Q6 are mandatory; makes reports comparable across combinations

Full principles: [`docs/meta/00_design_principles.md`](docs/meta/00_design_principles.md).

---

## Project structure

```
prism/
├── .claude/
│   ├── agents/{4 dimensions}/        Agent definitions
│   ├── skills/lens/{4 dimensions}/   Analysis lenses (methodologies)
│   ├── commands/analyze.md           Orchestrator command
│   ├── coordination/                 Agent ↔ Skill contract
│   └── context/lens-catalog.md       Skill registry
├── docs/
│   ├── meta/                         System design docs
│   └── analyses/                     Output of each analysis
├── templates/                        Agent / Skill / Report templates
└── tools/                            Helper scripts
```

---

## Acknowledgements

Prism's specific-school Skills draw on the methodologies of Simon Brown (C4 Model), Eric Evans (DDD), Simon Wardley (Wardley Mapping), Gojko Adzic (Impact Mapping), and Jeff Patton (User Story Mapping). Prism only provides the composition mechanism; the wisdom belongs to the original authors.

---

## License

This project is licensed under the **Prism Non-Commercial License (Prism-NC 1.0)** — free for personal study, research, teaching, evaluation, and non-profit use. **Commercial use of any kind (paid services, SaaS, embedding into commercial products, etc.) requires the author's prior written consent.** See [LICENSE](LICENSE) for full terms.

For commercial licensing, please contact the author, Ian Xu.

Copyright © 2026 Ian Xu. All rights reserved.
