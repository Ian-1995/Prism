---
status: Draft
version: 0.1
last_updated: 2026-05-14
---

# Agent ↔ Skill 契約

本文件規定 Agent 和 Skill 在合成分析時的職責分工與合作規則。任何新 Agent / Skill 撰寫時，必須能通過本契約檢查。

---

## 一、Agent 必須提供

### Frontmatter 必填欄位

```yaml
---
name: backend-engineer
dimension: fundamentals            # application | business | fundamentals | optimization
also_applies_to: [optimization]    # 可選，宣告跨維度
voice_summary: 一句話自我介紹
target_audience: technical         # technical | business | mixed（必填，影響報告語氣）
default_skill: tech-stack-inventory
compatible_skills:
  - tech-stack-inventory
  - joshua-bloch-api-design
  - clean-architecture-uncle-bob
  - 12-factor-audit
---
```

### 內容必備章節

1. **我是誰** — Persona 自述
2. **優先發問順序** — 看到標的時先看什麼、後看什麼
3. **口氣樣本** — 兩三句範例，給 LLM 對口氣的錨點
4. **證據引用偏好** — 我習慣怎麼附證據
5. **我絕對不會做的事** — anti-patterns
6. **audience 對話樣本**（可選但建議）— 給 LLM 對齊「對這個 audience 我會怎麼說」的範例

---

## 二、Skill 必須提供

### Frontmatter 必填欄位

```yaml
---
name: joshua-bloch-api-design
category: api-design               # 用於疊加互斥檢查
dimension: optimization
also_applies_to: []
origin:
  author: Joshua Bloch
  source: "How to Design a Good API and Why It Matters (2006)"
compatible_agents:
  - backend-engineer
  - tech-lead
default_for:
  - backend-engineer
---
```

### 內容必備章節

1. **核心概念** — 3-5 句話講清楚這套方法論在主張什麼
2. **分析步驟** — 套用此方法論時的執行步驟（checklist）
3. **評估維度與評分** — 表格列出維度、高分標準、低分標準
4. **輸出 Schema** — 報告章節骨架（除了鋒面問題之外的部分）
5. **反模式** — 此方法論常見的誤用

---

## 三、合成規則

### 1. 職責優先順序

| 衝突情境 | 誰贏 |
|---|---|
| Skill 要求的章節與 Agent 的 priority_questions 衝突 | **Skill 贏**（方法論優先） |
| Agent 不在 Skill.compatible_agents | **Skill 贏**（Orchestrator 拒絕組合） |
| Skill 不在 Agent.compatible_skills | **Agent 贏**（Orchestrator 拒絕組合） |
| 疊加的 Skill 同 category | **Orchestrator 贏**（強制二選一） |
| 證據引用格式衝突 | **Agent 贏**（口氣層級） |
| 評估標準衝突 | **Skill 贏**（方法論層級） |

### 2. 報告組裝順序

```
1. Header（target、agent、skill、date、status）
2. 鋒面問題章節 Q1~Q6（強制，依 P-6）
3. 方法論分析章節（依 Skill.output_schema）
4. 證據附錄（依 Agent.evidence_rules 格式）
5. Open Questions / Unknowns
```

### 3. Voice ↔ Schema 分工

- **Agent 的 voice** 影響：自述章節、發問順序、語氣、舉例風格
- **Skill 的 schema** 影響：方法論分析章節的標題、表格欄位、評分模型

兩者疊加時，文字風格走 Agent，結構骨架走 Skill。

---

## 四、Compatibility Matrix 檢查

Orchestrator 在組合時跑以下檢查，任何一條失敗就拒絕並提示原因：

```
✓ agent.dimension 或 agent.also_applies_to 包含 skill.dimension？
✓ skill ∈ agent.compatible_skills？
✓ agent ∈ skill.compatible_agents？
✓ 疊加的多個 skill 之間，category 全部不同？
✓ 疊加的 skill 總數 ≤ 3？
```

---

## 五、無 Skill 模式

Agent 可以不配 Skill 執行。沒配 Skill 時，agent 用「自己的直覺判斷」分析，產出只走鋒面問題 + agent 的優先發問順序，不套任何方法論章節。

呼叫：

```
/analyze agent=backend-engineer path=<repo>              # 直覺模式
/analyze agent=backend-engineer skill=bloch path=<repo>  # 套 SKILL 模式
```

---

## 六、契約檢查清單

撰寫新 Agent 時自查：

- [ ] frontmatter 六個必填欄位齊全（含 target_audience）
- [ ] 五至六個必備章節齊全（audience 對話樣本為建議）
- [ ] dimension 是四選一
- [ ] compatible_skills 至少列一個（即 default_skill）
- [ ] 沒有在內容裡硬編方法論

撰寫新 Skill 時自查：

- [ ] frontmatter 八個必填欄位齊全
- [ ] 五個必備章節齊全
- [ ] category 跟其他 Skill 不衝突（除非刻意要做替代方案）
- [ ] compatible_agents 至少列一個
- [ ] origin 有明確出處（書、論文、作者）
