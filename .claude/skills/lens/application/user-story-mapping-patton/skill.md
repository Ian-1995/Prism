---
name: user-story-mapping-patton
category: user-journey
dimension: application
also_applies_to: []
origin:
  author: Jeff Patton
  source: "User Story Mapping: Discover the Whole Story, Build the Right Product (2014)"
  url: https://www.jpattonassociates.com/the-new-backlog
compatible_agents:
  - business-analyst
default_for: []
status: Draft
---

# Skill: User Story Mapping — Patton（使用者故事地圖）

## 核心概念

以「使用者活動（橫軸）× tasks/stories（縱軸）」拆解產品功能。橫軸是使用者的旅程 backbone（大塊活動），縱軸是每個活動下面的具體步驟和實作條目，由上到下代表優先序。

User Story Map 的核心價值是**看到完整的使用者旅程**，而不是一堆零散的 user story。它幫助團隊找出「走完最小旅程需要的最小功能集」（walking skeleton）。

關鍵主張：

- **Backbone 先於 Stories**：先畫出使用者做事的大流程（activities），再往下拆步驟和 story。
- **橫向是旅程，縱向是優先序**：左到右是使用者走過的步驟，上到下是「先做什麼、後做什麼」。
- **切 Release 是核心動作**：用水平線把 story map 切成 releases — 最上面那條線就是 walking skeleton / MVP。

## 分析步驟

依下列順序執行；每一步都要附證據引用：

1. **識別 User Activities（Backbone）** — 使用者跟這個系統互動時，有哪些大塊的活動？從 route 定義、DAG 結構、UI screen、CLI command 推斷。對 ETL / 後端 service，activities 是系統自動做的大步驟。
2. **列出 Tasks per Activity（Spine）** — 每個 activity 下面有哪些具體步驟？使用者（或系統）要做什麼、看到什麼、得到什麼？
3. **列出 Stories per Task** — 每個 task 有哪些具體的實作條目？已做的和待做的都列。
4. **切 Walking Skeleton / Release** — 找出「走完最小旅程需要的最小功能集」。已實作的 story 標「已做」，缺的標「待做」。
5. **產出主圖** — 用 Mermaid journey 或 flowchart 呈現。

**非互動式系統的處理**：對 batch ETL / 排程 service 等沒有人類直接互動的系統，把「系統自動執行的步驟」當 activities，把「排程器」當 user。如果完全沒有使用者旅程的概念，寫 N/A 並建議改用 usage-flow-survey。

## 評估維度與評分

評分用 A / B / C 等級。目的是評「使用者旅程的理解完整度」。

| 維度 | A（高） | B（中） | C（低） |
|---|---|---|---|
| Backbone 完整度 | 所有主要 user activities 都有列出 | 大部分有但缺少 edge case 流程 | 只有 happy path |
| Task 切分顆粒度 | 每個 activity 有 2-5 個具體步驟 | 有些 activity 只列了一個粗步驟 | 全部混在一起沒拆 |
| Story 可實作度 | 每個 story 有明確 scope 且 user-facing | 有些 story 是 implementation detail | 全部是技術任務 |
| Walking skeleton 可辨識 | 能明確畫出最小可用旅程的切割線 | 有初步分辨但界線模糊 | 無法區分 MVP 和 nice-to-have |

## 輸出 Schema

報告除了強制的「一句話大綱」和鋒面問題（Q1~Q6）章節之外，要包含以下章節：

```markdown
### 1. User Activities Backbone
（橫向排列的大塊活動）

### 2. Tasks per Activity
| Activity | Task | 說明 | 證據 |
|---|---|---|---|

### 3. Stories per Task
| Task | Story | 狀態（已做/待做） | 證據 |
|---|---|---|---|

### 4. Walking Skeleton / Release Cuts
（最小可用旅程需要哪些 story）

### 5. 主圖（Mermaid journey + flowchart 補強）

### 6. 評分總結
| 維度 | 等級 | 說明 |
|---|---|---|
```

## 反模式（這套方法論常見的誤用）

- **寫成單條 timeline 沒有橫向 activity 區分** — User Story Map 的核心是二維的（橫向旅程 × 縱向優先序）。一維列表不是 story map。
- **Story 寫成 implementation detail** — 「加 retry 機制」是技術任務；「使用者提交表單失敗時看到清楚的錯誤訊息」才是 user story。
- **沒切 release** — User Story Map 的核心動作就是 release 切割。沒切 = 沒用到方法論的主要價值。
- **對非互動系統強行畫 journey** — 如果系統完全沒有人類互動（如純 cron job），journey 會很彆扭。改用 usage-flow-survey 或 service blueprint。

## 何時不該用這個 Skill

- repo 是 batch ETL / 後端 service 無互動 user — 改用 usage-flow-survey（把排程器當 user）。
- repo 是 library / SDK — 沒有使用者旅程的概念，只有 API surface。
- repo 已有完整的 Figma / 設計稿定義了使用者旅程 — 直接引用即可。
