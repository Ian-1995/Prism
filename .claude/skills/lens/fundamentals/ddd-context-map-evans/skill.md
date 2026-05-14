---
name: ddd-context-map-evans
category: context-map
dimension: fundamentals
also_applies_to: []
origin:
  author: Eric Evans
  source: "Domain-Driven Design: Tackling Complexity in the Heart of Software (2003), Context Maps chapter"
  url: ""
compatible_agents:
  - system-analyst
default_for: []
status: Draft
---

# Skill: DDD Context Map — Evans（領域邊界地圖）

## 核心概念

把 codebase 切成 **bounded contexts**（各自有一致語言和邊界的模組），標出 context 之間的 **integration patterns**（誰上游誰下游、怎麼整合）。

DDD Context Map 的核心洞見是：**大系統裡不同區塊用的「語言」不一樣**。同一個「order」在計費模組和物流模組意思不同。找到這些語言邊界，就找到了模組邊界。

關鍵主張：

- **語言邊界 = 模組邊界**：不是按檔案結構切，是按「哪些 code 用同一套術語」切。
- **Integration pattern 比箭頭重要**：Context Map 的價值不在「A 呼叫 B」，在於「A 跟 B 的關係是 Customer/Supplier、Conformist、還是 Anticorruption Layer」。
- **核心 domain 要保護**：識別哪個 context 是核心競爭力（core domain），哪個是支援性質（supporting），哪個是通用的（generic）。

## 分析步驟

依下列順序執行；每一步都要附證據引用：

1. **識別 Bounded Contexts** — 從模組邊界 / 命名空間 / 子目錄 / 微服務邊界切。看哪些 code 共享相同的 domain terms，哪些 code 用不同的詞彙描述類似概念。
2. **標記 Ubiquitous Language** — 每個 context 內的核心領域詞彙。同一個詞在不同 context 裡意思不同要特別標出。
3. **標記 Integration Patterns** — 每對有互動的 context 之間，標出整合模式：
   - **Upstream / Downstream**：誰依賴誰
   - **Open Host Service (OHS)**：提供標準 API
   - **Anticorruption Layer (ACL)**：下游自建轉譯層
   - **Customer / Supplier**：下游需求驅動上游
   - **Conformist**：下游完全配合上游
   - **Partnership**：兩邊協調同步
   - **Shared Kernel**：共享部分 model
   - **Separate Ways**：不整合
4. **識別 Domain 重要性** — 核心 domain（competitive advantage）、支援 domain（必要但非差異化）、通用 domain（可外包）。
5. **產出主圖** — 用 Mermaid flowchart 模擬 context map，標 context 名稱 + integration pattern。

**vibe-coded / single-file repo 特殊處理**：如果 repo 結構鬆散、沒有明確的模組邊界，context 切分會很困難。此時誠實標 N/A 或 `Status: Inferred`，說明「無法識別明確的 bounded context」，不要強行切割。

## 評估維度與評分

評分用 A / B / C 等級。目的是評「我們對 domain 邊界的理解程度」。

| 維度 | A（高） | B（中） | C（低） |
|---|---|---|---|
| Context 識別清晰度 | 每個 context 有明確邊界、名稱、職責 | 能識別主要 context，但邊界模糊 | 無法識別任何 context 邊界 |
| Integration 標記正確度 | 每對互動都標了具體的 DDD pattern | 有標 upstream/downstream 但沒細分 pattern | 只畫箭頭沒標 pattern |
| Ubiquitous language 真實度 | 術語直接來自 code 中的命名 | 部分來自 code，部分推測 | 全靠推測 |
| Domain 分類合理度 | core / supporting / generic 分類有依據 | 有分類但 core 的判斷不確定 | 無法分辨重要性 |

## 輸出 Schema

報告除了強制的「一句話大綱」和鋒面問題（Q1~Q6）章節之外，要包含以下章節：

```markdown
### 1. Bounded Contexts 清單
| Context | 邊界（模組/目錄/服務） | 職責 | 證據 |
|---|---|---|---|

### 2. Ubiquitous Language per Context
| Context | 核心術語 | 同詞異義（如有） |
|---|---|---|

### 3. Integration Patterns
| Context A | Context B | Pattern | 方向 | 證據 |
|---|---|---|---|---|

### 4. Domain 重要性分類
| Context | 分類（核心/支援/通用） | 理由 |
|---|---|---|

### 5. Context Map 主圖（Mermaid flowchart）

### 6. 評分總結
| 維度 | 等級 | 說明 |
|---|---|---|
```

## 反模式（這套方法論常見的誤用）

- **把每個檔案當一個 context** — context 應該是「語言邊界」不是「檔案邊界」。`orders.js` 和 `inventory.js` 如果用同一套 domain terms（如都用 `Product` 和 `SKU`），它們屬於同一個 context。
- **沒標 integration pattern 只畫箭頭** — 失去 DDD Context Map 的主要價值。「A → B」不如「A (Upstream) → B (Conformist)」有用。
- **把 generic domain 當核心 domain** — logging / auth / monitoring 是 generic，不是核心競爭力。核心 domain 是「只有這個系統才做的獨特業務邏輯」。
- **對 single-file repo 強行切 context** — 如果整個系統就是一個 Python script，硬切只會誤導。寫 N/A。

## 何時不該用這個 Skill

- single-file repo 或 vibe-coded repo 結構鬆散 — 沒有 context 可分。標 N/A 並說明。
- repo 是 pure library（單一 context）— 內部可能有 module 但不是 DDD 意義上的 bounded context。
- 團隊不打算用 DDD 做後續開發 — Context Map 的價值在於指導未來的重構方向，如果沒有後續計畫就不值得畫。
