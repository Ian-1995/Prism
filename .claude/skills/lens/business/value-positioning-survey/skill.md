---
name: value-positioning-survey
category: value-baseline
dimension: business
also_applies_to: []
origin:
  author: Prism Project
  source: "Prism Baseline Lens — Business Value Positioning (2026)"
  url: ""
compatible_agents:
  - product-strategist
default_for:
  - product-strategist
status: Draft
---

# Skill: Value Positioning Survey（價值定位清點）

## 核心概念

對被分析的 repo 做「商業價值結構化清點」。回答 **why it exists** 和 **who benefits**，而不是回答 **how it works**。產出的是一份可被跨 repo 對照的 value dossier。

此 skill 是 business 維度的 baseline，每個 product-strategist 工作起手都該跑一次；其他 business 的 specific schools（jobs-to-be-done / porter-value-chain）會疊加在這份清點之上。

關鍵主張：

- **價值先於功能**：先搞清楚「為誰解決什麼問題」，再看功能清單。功能是手段，不是目的。
- **證據可以來自 code**：即使沒有商業文件，table name、field name、domain model、README 都能透露商業意圖。
- **找不到商業理由就如實說**：「Status: Unknown — repo 內無商業文件」比編故事有價值。

## 分析步驟

依下列順序執行；每一步都要附證據引用：

1. **辨識 Stakeholder** — 誰是 sponsor（出錢的人）？誰是 end user（用結果的人）？誰是 operator（操作系統的人）？從 README、需求文件、commit author、DAG owner、domain model 推斷。
2. **萃取核心問題陳述** — 這個系統解決什麼問題？從需求文件、README 的第一段、domain model 的命名、table / API 的語意推斷。寫成一句 problem statement。
3. **評估價值類型** — 它創造的價值是：降低成本？提高效率？避免風險？創造營收？合規需求？分類並附證據。
4. **辨識輸出消費者** — 系統產出被誰 / 什麼系統消費？產出的形式是什麼（報表 / API / DB table / 檔案）？消費者用產出做什麼決策？
5. **評估替代方案** — 市面上有沒有現成工具可以達成同樣效果？自建 vs 買的 trade-off 推測。找不到就標 `Status: Inferred`。
6. **評估影響範圍** — 覆蓋多少使用者 / 交易量 / 資料量？如果系統停擺，影響的半徑多大？
7. **產出價值定位評分** — 依「評估維度與評分」表打等級。

## 評估維度與評分

評分用 A / B / C 等級（A=高、B=中、C=低）。目的是評「我們對這個系統的商業價值理解程度」，而不是評「這個系統的商業策略好不好」（後者是 specific school 的事）。

| 維度 | A（高） | B（中） | C（低） |
|---|---|---|---|
| Stakeholder 明確度 | sponsor / end user / operator 都有明確證據 | 能推測出使用者，但 sponsor 不明 | 完全不知道為誰做的 |
| 問題陳述清晰度 | README 或需求文件有明確 problem statement | 能從 domain model / table name 推測 | 只知道「做了什麼」不知道「為什麼」 |
| 價值類型辨識度 | 有文件說明價值類型，或從使用場景能明確判斷 | 能推測價值類型但無直接證據 | 無法判斷這個系統為什麼存在 |
| 輸出消費鏈 | 知道輸出被誰消費、做什麼決策 | 知道輸出形式，但不知被誰消費 | 只知道寫到 DB，不知後續 |
| 影響範圍可估性 | 有量化指標（使用者數 / 交易量 / 資料量） | 有定性描述但無量化 | 完全不知道規模 |

## 輸出 Schema

報告除了強制的鋒面問題（Q1~Q6）章節之外，要包含以下章節：

```markdown
## 1. Stakeholder 地圖
- Sponsor（出錢 / 決策者）
- End User（使用結果的人）
- Operator（操作系統的人）
- 證據來源

## 2. 核心問題陳述
- Problem Statement（一句話）
- 不解決會怎樣
- 證據

## 3. 價值類型
- 分類（降低成本 / 提高效率 / 避免風險 / 創造營收 / 合規）
- 每個類型的證據

## 4. 輸出消費鏈
- 系統產出形式
- 消費者（人 / 系統）
- 消費後做什麼決策
- 資料新鮮度要求

## 5. 替代方案評估
- 市場現成方案
- 自建理由推測
- Build vs Buy 考量

## 6. 影響範圍
- 覆蓋範圍（使用者 / 交易量 / 資料量）
- 停擺影響半徑
- 關鍵性等級

## 7. 價值定位評分
- 依「評估維度與評分」表打等級（A / B / C）
```

## 反模式（這套方法論常見的誤用）

- **把技術能力當商業價值** — 「支援多家金流」是技術能力描述；「讓商家不需綁定單一支付，能依手續費自由切換」才是價值描述。
- **編造商業場景** — repo 裡沒有的東西不要腦補。找不到 stakeholder 就標 `Status: Unknown`。
- **忽略負面價值** — 維護成本高、使用率低、有更好的替代方案 — 這些都是有用的發現，不要只報正面。
- **把策略建議寫進清點** — 「應該拓展到其他市場」「建議加 SLA」屬 optimization 視角，不寫進 value survey。
- **只看 code 不看文件** — 需求文件、README、commit message 常常有更直接的商業意圖線索。

## 何時不該用這個 Skill

- 標的是純技術 infra（如 logging library / CI pipeline）— 商業價值太間接，改用 fundamentals 或 optimization lens。
- 已有明確的 PRD / BRD 文件 — 此時 jobs-to-be-done 或 porter-value-chain 可能更有洞見。
- 只想評估 ROI — 那是 specific school 的事，baseline survey 不做量化財務分析。
