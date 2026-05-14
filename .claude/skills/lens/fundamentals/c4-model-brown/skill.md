---
name: c4-model-brown
category: architecture-doc
dimension: fundamentals
also_applies_to: []
origin:
  author: Simon Brown
  source: "The C4 Model for Visualising Software Architecture (2018-ongoing)"
  url: https://c4model.com
compatible_agents:
  - system-analyst
default_for: []
status: Draft
---

# Skill: C4 Model — Brown（C4 架構視覺化）

## 核心概念

用 4 個遞增的抽象層級把軟體架構畫出來：Context → Container → Component → Code。從最高層（系統跟外部世界的關係）逐層放大到內部結構。

C4 的核心主張是「不同的 audience 需要不同的 zoom level」— 老闆看 Level 1（Context），架構師看 Level 2（Container），開發者看 Level 3（Component）。

關鍵主張：

- **由外而內**：先畫系統跟外部的邊界（Context），再拆內部。不要從 code 往外推。
- **每張圖有明確 audience**：Level 1 給所有人看，Level 2 給技術決策者，Level 3 給開發者。
- **標籤比形狀重要**：每個框至少標名稱、技術棧、職責描述。空殼框圖沒有價值。

## 分析步驟

依下列順序執行；每一步都要附證據引用：

1. **繪 Level 1 — System Context** — 識別本系統、使用者（人或排程器）、外部系統（DB / API / message queue 等）。標出互動方向與互動內容（讀 / 寫 / 呼叫 / 推送）。用 Mermaid C4Context 語法。
2. **繪 Level 2 — Container** — 把本系統拆成主要 runtime 單元（web app / API server / worker / DB / queue / scheduler）。標各自的技術棧與資料流方向。用 Mermaid C4Container 或 flowchart。
3. **評估是否繪 Level 3 — Component** — 只在單一 container 內部結構複雜時才畫。對 vibe-coded single-file repo 或小型 ETL，Level 3 通常省略。
4. **標注圖未涵蓋的事實** — 把無法從 repo 確認的互動、系統、或技術選型列出，標 `Status: Unknown` 或 `Status: Inferred`。

**vibe-coded repo 特殊處理**：Level 1 Context 是必出（即使只有一個人 + 一個系統 + 一個 DB）。Level 2 視情況（如果系統就是一個 Python script，寫 N/A 並說明）。Level 3 省略。

## 評估維度與評分

評分用 A / B / C 等級。目的是評「圖的資訊密度和完整度」，不是評「架構好不好」。

| 維度 | A（高） | B（中） | C（低） |
|---|---|---|---|
| Context 完整度 | 所有外部系統和使用者都有標出，互動方向和內容完整 | 主要外部系統有標，但互動內容不完整 | 只畫了本系統，外部關係缺失 |
| Container 拆分清晰度 | 每個 runtime 單元有獨立框，標技術棧和資料流 | 有拆分但標籤不完整 | 整個系統只有一個框，沒有拆分 |
| 標籤資訊密度 | 每個框有名稱 + 技術棧 + 職責 | 有名稱和技術棧，缺職責描述 | 只有名稱 |
| 圖與證據對應度 | 圖中每個元素都能對應到 repo 內的證據 | 大部分有對應，少數推測 | 多數元素靠推測 |

## 輸出 Schema

報告除了強制的「一句話大綱」和鋒面問題（Q1~Q6）章節之外，要包含以下章節：

```markdown
### 1. C4 Level 1 — System Context
（Mermaid C4Context 或 flowchart + 5-10 行解釋）

### 2. C4 Level 2 — Container（如適用）
（Mermaid C4Container 或 flowchart + 解釋；如 single-container 寫 N/A 並說明）

### 3. C4 Level 3 — Component（可選）
（大多數情況省略；如繪製則標明只針對哪個 container）

### 4. 圖未涵蓋的事實
（Status: Unknown / Inferred 條目，標建議確認對象）

### 5. 評分總結
| 維度 | 等級 | 說明 |
|---|---|---|
```

## 反模式（這套方法論常見的誤用）

- **把 Code Level（class 圖）當主要 output** — C4 的設計就是高層為主。class 圖留給 IDE，不是 C4 的工作。
- **Container 標籤只寫框架名沒寫資料流方向** — 「FastAPI」不是有用的標籤；「API Server (FastAPI) — 接收 HTTP 請求，查詢 DB 回傳 JSON」才是。
- **對 single-file repo 強行畫 Component Level** — 如果整個系統就是一個 Python script，Level 3 畫不出有意義的東西。寫 N/A。
- **把圖畫得很漂亮但沒有證據** — 每個框和箭頭都要能對應到 repo 裡的 code / config / doc。

## 何時不該用這個 Skill

- repo 是純前端 single-file HTML 無外部互動 — Context 圖會空殼，沒有分析價值。
- repo 已有最新且可信的 C4 文件 — 直接引用即可，不需要重畫。
- 只想看 code-level 結構（class / function 關係）— C4 不做這個，改用 IDE 或 dependency graph 工具。
