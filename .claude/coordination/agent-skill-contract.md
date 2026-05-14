---
status: Draft
purpose: 撰寫新 Agent 或 Skill 時的 runtime checklist
canonical_source: docs/meta/01_agent_skill_contract.md
---

# Agent / Skill 撰寫快查表

> 完整契約見 `docs/meta/01_agent_skill_contract.md`。本檔是濃縮版，給撰寫時快速對照。

## 寫新 Agent 前

讀完：

1. `docs/meta/00_design_principles.md` — 特別是 P-1（職責邊界）、P-6（鋒面問題）
2. `docs/meta/01_agent_skill_contract.md` 第一節（Agent 必須提供）

複製：`templates/agent-template.md` → `.claude/agents/<dimension>/<agent-name>.md`

填完後自查：

- [ ] frontmatter 五個必填：name, dimension, voice_summary, default_skill, compatible_skills
- [ ] 內容五個必備章節齊全
- [ ] 沒有在 agent 裡硬編方法論（如果有，拆出來變 Skill）
- [ ] default_skill 真的存在於 `.claude/skills/lens/` 下
- [ ] compatible_skills 列出的 Skill 都實際存在

## 寫新 Skill 前

讀完：

1. `docs/meta/00_design_principles.md` — 特別是 P-3（同 category 互斥）
2. `docs/meta/01_agent_skill_contract.md` 第二節（Skill 必須提供）
3. `.claude/context/lens-catalog.md` — 確認新 Skill 的 category 不會跟既有的撞名（除非刻意要做替代）

複製：`templates/skill-template.md` → `.claude/skills/lens/<dimension>/<skill-name>/skill.md`

填完後自查：

- [ ] frontmatter 八個必填：name, category, dimension, origin, compatible_agents, default_for（其餘為可選）
- [ ] 內容五個必備章節齊全（核心概念、分析步驟、評估維度、輸出 schema、反模式）
- [ ] origin 有明確出處（作者 + 書/論文/年份）
- [ ] category 不跟既有 Skill 衝突（除非刻意做替代）
- [ ] 更新 `.claude/context/lens-catalog.md` 註冊新 Skill

## 寫新 Command（Orchestrator）前

讀完：

1. `docs/meta/00_design_principles.md` — 特別是 P-5（只讀邊界）
2. `docs/meta/01_agent_skill_contract.md` 第四節 — Compatibility Matrix 檢查邏輯

放到：`.claude/commands/<command-name>.md`

Command 必須：

- [ ] 跑 Compatibility Matrix 檢查（見 01_agent_skill_contract 第四節）
- [ ] 拒絕非法組合並提示原因
- [ ] 寫入 `docs/analyses/<analysis-slug>/` 而非任意位置
- [ ] 不修改被分析的 repo

## 衝突仲裁速查

| 衝突 | 誰贏 |
|---|---|
| Skill 章節 vs Agent priority_questions | Skill |
| Agent 不在 Skill.compatible_agents | Orchestrator 拒絕 |
| Skill 不在 Agent.compatible_skills | Orchestrator 拒絕 |
| 疊加 Skill 同 category | Orchestrator 拒絕 |
| 證據引用格式 | Agent |
| 評估標準 | Skill |
