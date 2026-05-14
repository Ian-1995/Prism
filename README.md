# Prism

**🌐 Language**: **中文** · [English](README.en.md)

> 一束光進來，分解成多種顏色 — 把陌生 / 舊 / 做到一半的 repo，分解成多視角的分析報告。

**Prism** 是一套以 Claude 為核心的多視角程式碼分析框架。
當你面對的是 **vibe-coding 留下的半成品**，或是**難以維護的舊系統**（接手沒人寫過 doc 的祖傳代碼、被技術債卡住的舊專案、收購標的的盡職調查），Prism 用 **Agent（專業員工角色）× Skill（專業觀點方法論）** 的可組合機制，從多個視角同時健檢，產出可彼此對照的結構化報告。

> **長期願景**：成為一套能幫團隊系統化健檢程式碼、產出可行動優化方案的服務。本 repo 是這個服務的開源框架核心 — 提供多種專業員工（Agent）× 專業觀點（Skill），對 codebase 做結構化分析輸出。

---

## 為什麼需要它

接手一份 repo 時，工程師通常會踩到這幾個坑：

- 只看技術現況，沒看流程，導致改了 code 卻打斷使用流程
- 只看商業文件，沒看實作，導致對接手成本嚴重低估
- 只用單一視角分析，導致風險評估有盲區
- 多人分頭分析時，報告骨架不同，無法 side-by-side 比較

Prism 把這個過程結構化：**固定四個維度、固定鋒面問題（每份報告都要回答 Q1~Q6）、固定證據引用規格**，讓不同視角的分析結果可以被擺在同一張對照表上。

---

## 核心抽象

### Agent × Skill = N:M 組合

| 抽象 | 比喻 | 提供什麼 |
|---|---|---|
| **Agent** | 員工 / 廚師 | persona、口氣、優先發問順序、證據引用習慣 |
| **Skill** | 方法論 / 食譜 | 分析框架、checklist、輸出 schema、評估標準、反模式 |

同一個 Agent 可以套不同 Skill 產出不同風格的報告；同一個 Skill 也可以給不同 Agent 使用。

### 四個分析維度

每個 Agent 與 Skill 都歸屬於下列其中一個維度：

| 維度 | 性質 | 回答的問題 |
|---|---|---|
| `application` | 偏 IS | 這個系統怎麼被用？使用流程是什麼？ |
| `business` | IS + SHOULD | 它創造什麼價值？誰是顧客？ |
| `fundamentals` ⭐ | 純 IS | 目前的技術、相依、結構長什麼樣？ |
| `optimization` | 純 SHOULD | 現在有什麼問題？怎麼改善？ |

`fundamentals` 是優先維度 — 不知道現況，無法評應用、無法評商業、更無法談優化。

### Skill 疊加規則

呼叫時可疊加最多 3 個 Skill，但**同 category 互斥**（避免兩套同性質方法論互相打架）：

- 合法：`tech-inventory-survey + c4-model + 12-factor`（三個不同 category）
- 非法：`clean-architecture + ddd-evans`（同為 architecture 類）

### 鋒面問題（強制章節）

不論用哪個 Agent × Skill 組合，產出的報告都必須回答這 6 個問題：

| # | 問題 |
|---|---|
| Q1 | 這個標的的核心價值是什麼？ |
| Q2 | 最大風險是什麼？ |
| Q3 | 如果只能保留一部分，保留哪？ |
| Q4 | 不能動的地方在哪？ |
| Q5 | 第一週要做什麼？ |
| Q6 | 商品化還是內部工具？ |

---

## 如何使用

Prism 設計為**只讀工作台（read-only workbench）**：開啟 prism 這個 repo 當工作目錄，用 `/analyze` 指向要分析的 target repo，所有報告產出在 prism 自己的 `docs/analyses/` 下，**完全不動 target repo**。

### 前置需求

- [Claude Code CLI](https://docs.claude.com/en/docs/claude-code/overview) 或 VSCode Claude 擴充
- Git clone 這個 repo 到本機

### 單一 Agent 分析

```bash
# 用 agent 的 default skill
/analyze agent=system-analyst path=C:\path\to\target-repo

# 指定 skill
/analyze agent=system-analyst skill=tech-inventory-survey path=C:\path\to\target-repo

# Agent 直覺模式（不套方法論）
/analyze agent=system-analyst skill=none path=C:\path\to\target-repo
```

### Full Panel 分析（四維度同時跑）

```bash
/analyze panel=full path=C:\path\to\target-repo
```

並行跑四組 agent × default-skill，輸出到 `docs/analyses/<target-basename>-<YYYY-MM-DD>/`：

- `00_panel_summary.md` — 鋒面問題 Q1~Q6 對照表 + 四維度健康度評分
- `01_system-analyst.md`（fundamentals）
- `02_business-analyst.md`（application）
- `03_product-strategist.md`（business）
- `04_tech-lead.md`（optimization）

---

## 內建 Agent 與 Skill

### Agents（4 個專業員工角色）

| Agent | 維度 | Default Skill | 角色 |
|---|---|---|---|
| `system-analyst` | fundamentals | tech-inventory-survey | 系統分析師，看技術棧 / 結構 / 相依 |
| `business-analyst` | application | usage-flow-survey | 業務分析師，看 actor / 流程 / use case |
| `product-strategist` | business | value-positioning-survey | 產品策略，看市場 / 價值 / 定位 |
| `tech-lead` | optimization | improvement-survey | 技術主管，看問題 / 風險 / 優先序 |

### Skills（9 套專業觀點方法論）

通用 baseline（每個維度一套，agent 預設使用）：

| Skill | Category | 必出章節 |
|---|---|---|
| `tech-inventory-survey` | inventory-baseline | 語言框架 / 主要相依 Top 10 / 資料層 / 外部整合 / 啟動方式 |
| `usage-flow-survey` | usage-baseline | Actor map / 主要流程 / Entry points / 痛點訊號 |
| `value-positioning-survey` | value-baseline | 目標客戶 / 解決的問題 / 差異化 / 商業模式訊號 |
| `improvement-survey` | improvement-baseline | 程式碼熱點 / 架構問題 / 測試缺口 / 效能風險 / P0~P2 優先序 |

具體學派視角（疊加在 baseline 上，提供視覺化與深度分析）：

| Skill | Category | Origin |
|---|---|---|
| `c4-model-brown` | architecture-doc | Simon Brown — C4 Model |
| `ddd-context-map-evans` | context-map | Eric Evans — Domain-Driven Design |
| `wardley-maps-wardley` | strategy-map | Simon Wardley — Wardley Mapping |
| `impact-map-adzic` | goal-mapping | Gojko Adzic — Impact Mapping |
| `user-story-mapping-patton` | user-journey | Jeff Patton — User Story Mapping |

---

## 設計原則（節錄）

- **P-1 Agent 與 Skill 分離** — Agent 不重寫方法論，Skill 不挑口氣
- **P-3 Skill 可疊加，同 category 互斥** — 最多 3 個 Skill
- **P-4 證據強制** — 所有結論附證據；無證據要標 `Status: Inferred / Unknown`
- **P-5 只讀** — Prism 不修改被分析的 target repo
- **P-6 鋒面問題統一** — Q1~Q6 強制章節，讓報告可跨組合對照

完整原則見 [`docs/meta/00_design_principles.md`](docs/meta/00_design_principles.md)。

---

## 專案結構

```
prism/
├── .claude/
│   ├── agents/{4 dimensions}/        員工定義
│   ├── skills/lens/{4 dimensions}/   分析透鏡（方法論）
│   ├── commands/analyze.md           Orchestrator 指令
│   ├── coordination/                 Agent ↔ Skill 撰寫契約
│   └── context/lens-catalog.md       Skill 註冊表
├── docs/
│   ├── meta/                         系統設計文件
│   └── analyses/                     每次分析的輸出
├── templates/                        Agent / Skill / Report 範本
└── tools/                            輔助腳本
```

---

## 致謝

Prism 內建的具體學派 Skill 吸收了多位前輩的方法論：Simon Brown（C4 Model）、Eric Evans（DDD）、Simon Wardley（Wardley Mapping）、Gojko Adzic（Impact Mapping）、Jeff Patton（User Story Mapping）。Prism 本身只提供組合機制，方法論的智慧屬於原作者。

---

## License

本專案採用 **Prism Non-Commercial License (Prism-NC 1.0)** — 允許個人學習、研究、教學、評估與非營利使用；**未經作者書面同意，禁止任何形式的商業使用**（包含付費服務、SaaS、嵌入販售產品等）。完整條款見 [LICENSE](LICENSE)。

如需商業授權，請聯絡作者 Ian Xu。

Copyright © 2026 Ian Xu. All rights reserved.
