---
analysis_slug: <slug>               # kebab-case，例：acme-backend-2026-05
target: <被分析的標的>               # 例：github.com/acme/backend@main
agent: <agent-name>
skill: <skill-name | none>          # 沒套 SKILL 時填 none
date: 2026-MM-DD
status: Draft                       # Draft | Reviewed | Approved
---

# <Agent Display Name> × <Skill Display Name>: <Target>

> 由 prism 產出。Agent + Skill 組合 → 視角分析。
> 證據規則：所有結論附 `file:line` 或同等證據；推測標記 `Status: Inferred`。

---

## 一句話大綱

> （≤30 字，給所有人。寫到讓非該領域 reader 也能 grok。
> 例：「一個給個人記待辦事項的 REST API，支援多裝置同步與分享。」）

---

## 鋒面問題（強制章節）

每題必答。如果不適用，回答 `N/A` 並說明為什麼。
每題答案開頭強制加「**一句話**：」白話摘要。

### Q1. 這個標的的核心價值是什麼？

**一句話**：<白話摘要，給所有人>

<詳細回答 + 證據>

### Q2. 最大風險是什麼？

**一句話**：<白話摘要，給所有人>

<詳細回答 + 證據>

### Q3. 如果只能保留一部分，保留哪？

**一句話**：<白話摘要，給所有人>

<詳細回答 + 證據>

### Q4. 不能動的地方在哪？

**一句話**：<白話摘要，給所有人>

<詳細回答 + 證據>

### Q5. 第一週要做什麼？

**一句話**：<白話摘要，給所有人>

<詳細回答 + 證據>

### Q6. 商品化還是內部工具？

**一句話**：<白話摘要，給所有人>

<詳細回答 + 證據。如不適用，標記 N/A 並說明>

---

## 方法論分析（依 Skill.output_schema）

> 沒套 Skill 時，本章節由 agent 的「優先發問順序」展開，每個問題一個小節。

<由 Skill 的 output_schema 定義的章節>

---

## 證據附錄

依 Agent.evidence_rules 格式列出。建議用表格：

| 結論編號 | 證據類型 | 路徑 / 鍵 | 備註 |
|---|---|---|---|
| C-1 | code | `src/api/auth.py:42` | 缺 refresh token |
| C-2 | config | `app.yaml#redis.host` | hardcoded `127.0.0.1` |
| C-3 | commit | `git@a1b2c3d` | 最後一次有意義 commit |

---

## Open Questions / Unknowns

無法從現有證據判斷的事項，明列出來。這些是 Reviewer 要回答或進一步調查的：

- [ ] <未解問題 1>
- [ ] <未解問題 2>

---

## Status 流轉紀錄

| Status | 變更日期 | 變更者 | 備註 |
|---|---|---|---|
| Draft | 2026-MM-DD | prism (auto) | 由 `/analyze` 產出 |
| Reviewed | | | |
| Approved | | | |
