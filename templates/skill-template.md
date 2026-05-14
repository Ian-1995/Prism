---
name: <skill-name>                  # kebab-case，唯一，例：joshua-bloch-api-design
category: <category-key>            # 同 category 不可疊加。例：api-design
dimension: <dim>                    # application | business | fundamentals | optimization
also_applies_to: []                 # 可選
origin:
  author: <作者姓名>
  source: <書名 / 論文 / 演講 + 年份>
  url: <可選，網路來源>
compatible_agents:                  # 哪些 Agent 可以套這個 SKILL
  - <agent-name-1>
  - <agent-name-2>
default_for:                        # 我是哪些 Agent 的預設 SKILL
  - <agent-name>
status: Draft                       # Draft | Reviewed | Approved
---

# Skill: <Display Name>

## 核心概念

3-5 句話講清楚這套方法論在主張什麼。避免照抄原作者用詞，用自己的話濃縮，但保留術語。

關鍵主張：

- <主張 1>
- <主張 2>
- <主張 3>

## 分析步驟

套用這套方法論時，要照下列順序執行：

1. **<步驟名稱>** — <做什麼、看哪些檔案、產出什麼>
2. **<步驟名稱>** — ...
3. **<步驟名稱>** — ...

## 評估維度與評分

| 維度 | 高分標準 | 低分標準 |
|---|---|---|
| <維度 1> | <什麼樣算好> | <什麼樣算壞> |
| <維度 2> | ... | ... |
| <維度 3> | ... | ... |

評分尺度建議：1-5 分，或 A/B/C/D。

## 輸出 Schema

報告除了強制的「一句話大綱」和鋒面問題（Q1~Q6）章節之外，要包含以下章節：

```markdown
### <章節 1：方法論專屬>
- <子章節 / 表格欄位>

### <章節 2>
- ...

### 執行環境（fundamentals / inventory 類 skill 建議包含）
- 開發環境（本機 / venv / conda / Docker / DevContainer）
- 執行環境（本機 / Docker / K8s / Airflow managed / Cloud Run / Lambda / Unknown）
- 部署形態（on-premise / cloud-managed / hybrid / unknown）
- 必要前置基礎設施
- 資源需求（CPU / RAM / Storage，能抓到才填）

### 評分總結
| 維度 | 分數 | 證據 |
|---|---|---|

### 視覺化附錄（建議，可選）

> 用 Mermaid 補一張對應本 skill 內容的視覺化圖。
> 目的：讓非技術 reader 三秒抓到要點，不取代主章節文字。
> 如果 repo 結構不適合畫圖（如 single-file、vibe-coded），寫 N/A 並說明。

各 baseline 對應建議圖型：
- inventory / architecture 類 → 簡化 C4 Context 圖 或 Mermaid flowchart
- usage-flow 類              → Mermaid `journey` 1-2 條主流程
- value / strategy 類        → Mermaid `mindmap` 利害關係人 + 價值
- improvement / priority 類  → Mermaid `quadrantChart` 顯示優先序
```

注意：方法論分析章節在報告中使用 H3（`###`），不使用 H2。H2 留給報告骨架的大區塊（一句話大綱、鋒面問題、方法論分析、證據附錄、Open Questions）。

## 反模式（這套方法論常見的誤用）

- <誤用 1，例：把 Bloch 原則套到內部工具 API，導致過度設計>
- <誤用 2>
- <誤用 3>

## 何時不該用這個 Skill

- <情境 1>
- <情境 2>
