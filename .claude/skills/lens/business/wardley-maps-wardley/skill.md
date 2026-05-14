---
name: wardley-maps-wardley
category: strategy-map
dimension: business
also_applies_to: []
origin:
  author: Simon Wardley
  source: "Wardley Maps (CC-BY-SA, 2005-ongoing)"
  url: https://learnwardleymapping.com
compatible_agents:
  - product-strategist
default_for: []
status: Draft
---

# Skill: Wardley Maps — Wardley（價值鏈演化地圖）

## 核心概念

把系統的元件畫在「價值鏈（user need → 基礎設施）× 演化階段（Genesis → Custom Built → Product/Rental → Commodity/Utility）」的二維圖上。目的是看清楚哪些元件是 differentiator（該自建投資），哪些是 commodity（該外包或用現成服務）。

Wardley Map 的核心洞見是：**所有元件都會隨時間從左（Genesis）往右（Commodity）演化**。如果你把 commodity 當 differentiator 在自建，就是浪費資源。

關鍵主張：

- **從 user need 起點**：地圖的頂端一定是使用者的需求，不是技術元件。所有元件都要能往上追溯到 user need。
- **位置有意義**：橫軸（演化階段）不是隨便放的，要根據市場成熟度判斷。
- **movement 比 position 重要**：現在在哪不是重點，往哪移動才是策略洞見。

## 分析步驟

依下列順序執行；每一步都要附證據引用：

1. **識別 User Need** — 這個系統最終滿足什麼使用者需求？從 README / 需求文件 / domain model 推斷。
2. **列出 Value Chain** — 從 user need 往下，列出所有支撐的元件（服務 / 模組 / 資料來源 / 基礎設施）。每個元件標一句話職責。
3. **標記演化階段** — 每個元件在 Genesis / Custom Built / Product / Commodity 四階段中的位置。依據：市場上有多少替代方案、標準化程度、是否有 SaaS 可用。
4. **識別 Differentiator vs Commodity** — 高 visibility + 低成熟度 = differentiator（值得投資）；低 visibility + 高成熟度 = commodity（不值得自建）。
5. **觀察 Climatic Patterns（如可辨識）** — 有沒有元件正在快速 commoditize？有沒有被鎖定在 custom built 的元件？
6. **評估 Doctrine Maturity** — 團隊在 Wardley 原則的實踐程度（如：focus on user needs、use appropriate methods、think small）。

## 評估維度與評分

評分用 A / B / C 等級。目的是評「我們對這個系統的策略定位理解程度」。

| 維度 | A（高） | B（中） | C（低） |
|---|---|---|---|
| Value chain 完整度 | 從 user need 到基礎設施全部列出，無斷鏈 | 主要元件有列，但底層基礎設施缺漏 | 只列了技術元件，user need 不明 |
| 演化階段標記 | 每個元件有合理的演化判斷 + 依據 | 大部分有標，少數靠猜 | 多數元件位置靠猜或全標同一階段 |
| Differentiator 識別 | 明確標出哪些值得投資、哪些該 commoditize | 有初步分類但依據不足 | 無法分辨 |
| Climatic 觀察 | 觀察到 1-2 個演化趨勢並有證據 | 有觀察但偏模糊 | 無法觀察到任何趨勢 |

## 輸出 Schema

報告除了強制的「一句話大綱」和鋒面問題（Q1~Q6）章節之外，要包含以下章節：

```markdown
### 1. User Need
（一句話 + 證據）

### 2. Value Chain
（文字列表，從 user need 往下，每條一句話註解）

### 3. Wardley Map（主圖）
（Mermaid graph LR 搭配 subgraph 模擬四個演化階段欄位；
 Mermaid 原生不支援 Wardley，用 subgraph Genesis / Custom / Product / Commodity 分區）

### 4. Differentiator vs Commodity 分類
| 元件 | 演化階段 | 分類 | 理由 |
|---|---|---|---|

### 5. Climatic Patterns 觀察（如有）

### 6. Doctrine Maturity（self-assessment）

### 7. 評分總結
| 維度 | 等級 | 說明 |
|---|---|---|
```

## 反模式（這套方法論常見的誤用）

- **把所有元件標 Genesis** — 不可能全部都是新發明。如果用了 MySQL / React / Airflow，它們是 Product 或 Commodity。
- **沒有 user need 起點** — Wardley Map 強調 user-centric。地圖頂端不是「我們的系統」，是「使用者要什麼」。
- **用座標亂標** — 位置應反映演化階段而非版面美感。Custom Built 的元件不該畫在 Commodity 區。
- **只畫圖不做分析** — Wardley Map 的價值不在圖本身，在於「從圖看出該投資什麼、該放棄什麼」。

## 何時不該用這個 Skill

- 純基礎設施 repo（無 user-facing element）— value chain 起點失焦，畫不出有意義的地圖。
- 還在 prototype 極早期（演化階段全在 Genesis）— 沒有辨識度，地圖會是一團點。
- 只想看技術架構 — 那是 C4 的事，不是 Wardley Map 的事。
