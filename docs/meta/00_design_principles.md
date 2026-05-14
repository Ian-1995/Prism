---
status: Draft
version: 0.1
last_updated: 2026-05-14
---

# Prism 設計原則

本文件定義 prism 整套系統的設計原則。所有 Agent、Skill、Command 的撰寫都必須遵守這些原則。

---

## P-1 Agent 與 Skill 分離（職責邊界）

Agent 是「員工視角」，Skill 是「分析方法論」。兩者是 N:M 關係，職責互不重疊。

| 角色 | 提供 |
|---|---|
| Agent | persona、口氣、發問順序、預設關注點、證據引用習慣 |
| Skill | 分析框架、checklist、輸出 schema、評估標準、方法論的反模式 |

**禁令：**

- Agent 不重寫 Skill 的方法論
- Skill 不挑 Agent 的口氣
- Agent 不在自己定義裡硬編一套方法論（如果硬編了，就把它拆出來變 Skill）

---

## P-2 四維度分類

所有 Agent 和 Skill 都歸屬於下列四個維度之一作為主要歸屬：

| 維度 | 性質 | 核心提問 |
|---|---|---|
| `application` | 偏 IS | 系統如何被使用 |
| `business` | IS + SHOULD | 商業價值與定位 |
| `fundamentals` ⭐ | 純 IS | 技術現況（描述性） |
| `optimization` | 純 SHOULD | 優化方向（規範性） |

`fundamentals` 是優先維度，其他維度的分析品質都倚賴對現況的正確理解。

**跨維度宣告：** 一個 Agent 或 Skill 可以在 frontmatter 用 `also_applies_to` 宣告它能跨用到其他維度。例如 `tech-lead` 主要在 `optimization`，但也宣告 `also_applies_to: [fundamentals]`。

---

## P-3 Skill 可疊加，但同 category 互斥

呼叫時可疊加最多 3 個 Skill。**同一個 category 的 Skill 不能同時套用**，避免兩套相同性質的方法論互相打架。

- 合法：`joshua-bloch-api-design + clean-architecture-uncle-bob + 12-factor`（api-design + architecture + devops 三個不同 category）
- 非法：`clean-architecture-uncle-bob + ddd-evans`（兩個都是 architecture category）

category 由 Skill 自己在 frontmatter 宣告。Orchestrator 強制檢查。

---

## P-4 證據引用強制

所有分析結論必須附證據。證據格式：

- 程式碼：`path/to/file.py:42`
- 設定：`path/to/config.yml#section.key`
- Commit：`git@<hash>`
- Schema：`<table>.<column>`
- 外部資料：URL 或文件名

**沒有證據的推測必須明確標記：**

| 標記 | 意義 |
|---|---|
| `Status: Confirmed` | 從 code/docs/config 明確看到 |
| `Status: Inferred` | 從命名、結構、流程推測 |
| `Status: Unknown` | 找不到足夠證據 |
| `Status: Risk` | 有明確風險 |
| `Status: Blocker` | 會阻止啟動、接手或上線 |

---

## P-5 不修改被分析的標的

prism 是**只讀工具**。

- 不執行 DDL（建表、改表、刪表）
- 不執行被分析 repo 的 code（除非使用者明確授權，且 Orchestrator 統一管控）
- 不修改被分析 repo 的任何檔案
- 不寫入被分析系統的任何資料

所有產出都寫到 `docs/analyses/<analysis-slug>/`。

---

## P-6 報告骨架統一（鋒面問題）

不論 Agent × Skill 組合是什麼，最終報告都必須回答同一組「鋒面問題」，讓不同組合的報告可以做對照：

| 鋒面問題 |
|---|
| Q1. 這個標的的核心價值是什麼？ |
| Q2. 最大風險是什麼？ |
| Q3. 如果只能保留一部分，保留哪？ |
| Q4. 不能動的地方在哪？ |
| Q5. 第一週要做什麼？ |
| Q6. 商品化還是內部工具？（如不適用，標記 N/A 並說明原因） |

鋒面問題章節必須以 Q1~Q6 完整列出，每題附證據引用。除此之外的章節由 Skill 的 `output_schema` 定義。

---

## P-7 漸進交付（每個增量都可運作、可驗證）

不要試圖一次做完所有 Agent 和 Skill。每加入一個新的 Agent / Skill / Command 都應該：

- 能獨立跑起來（不依賴尚未完成的元件）
- 能對真實 repo 產出可被讀的報告
- 能通過契約檢查（frontmatter 完整、章節齊全、證據引用規格正確）

寧可只有 4 個高品質 baseline 比湊 20 個半成品好。新增的 Skill 與 Agent 一律從 `Status: Draft` 開始，經實際使用驗證後升 `Reviewed`，最後升 `Approved`。

---

## P-8 文件狀態流轉

所有 Prism 產出的分析報告走三階段流轉：

- **Draft** — Agent × Skill 直接產出
- **Reviewed** — 使用報告的人讀過、補充過
- **Approved** — 採納為正式評估依據（接手 / 重構 / 投資決策）

Agent / Skill 本身的定義檔（不是分析報告）也走同樣的流轉：剛寫出來是 Draft，經過幾次實際使用驗證後升 Reviewed，正式採納為內建 lens 後升 Approved。

---

## P-9 報告必須宣告 target_audience

每個 Agent 在 frontmatter 必須宣告 `target_audience: technical | business | mixed`，報告產出時遵守以下規則：

1. **一句話大綱**（≤30 字）：放在報告最前面，給所有 audience 都能 grok，不論維度。
2. **鋒面問題 Q1~Q6**：每題答案開頭強制加「**一句話**：」白話摘要，讓非該領域的 reader 也能快速掌握。
3. **維度間不混音**：技術維度（fundamentals / optimization）的方法論詳細章節保留工程深度；業務維度（business / application）的方法論詳細章節保留業務深度。不要為了「讓所有人看懂」而稀釋專業深度。
4. **多 audience 看完整 picture 時，由 panel summary 組合**，不由單一報告承擔跨領域翻譯的責任。

`mixed` 類型（如 business-analyst）允許在同一份報告裡同時帶技術細節與業務角度，因為該角色本身就是橋樑。
