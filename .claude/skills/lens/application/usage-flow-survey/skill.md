---
name: usage-flow-survey
category: usage-baseline
dimension: application
also_applies_to: []
origin:
  author: Prism Project
  source: "Prism Baseline Lens — Application Usage Flow (2026)"
  url: ""
compatible_agents:
  - business-analyst
default_for:
  - business-analyst
status: Draft
---

# Skill: Usage Flow Survey（使用流程清點）

## 核心概念

對被分析的 repo 做「使用流程結構化清點」。只回答 **how it is used**，不回答 **how it should be used**。產出的是一份可被跨 repo 對照的 usage dossier，而不是 UX 評論。

此 skill 是 application 維度的 baseline，每個 business-analyst 工作起手都該跑一次；其他 application 的 specific schools（cockburn-use-case / event-storming）會疊加在這份清點之上。

關鍵主張：

- **使用者視角先於實作視角**：先搞清楚「誰在用、怎麼觸發、什麼結果」，再回頭看程式碼怎麼做。
- **flow 是第一等公民**：每條使用流程都要有完整的 trigger → steps → outcome 描述。
- **exception path 跟 happy path 同等重要**：找不到 exception 處理就標明，不假裝它不存在。

## 分析步驟

依下列順序執行；每一步都要附證據引用：

1. **辨識使用者 / 呼叫者** — 這個系統被誰使用？人（UI / CLI）、排程器（Airflow / cron）、其他系統（API consumer / message consumer）？從進入點、route 定義、DAG 宣告、README 判斷。
2. **列舉所有使用流程** — 每一條完整的 flow：trigger（什麼觸發）→ steps（經過哪些步驟）→ outcome（最終產出什麼）。一個 repo 可能有多條 flow（如 CRUD 各算一條、多個 DAG 各算一條）。
3. **描述資料流向** — 每條 flow 的 input（從哪來、什麼格式）→ processing → output（到哪去、什麼格式）。畫出資料的進出點。
4. **盤點 exception path** — 每條 flow 的失敗場景：retry 機制、error handling、alert / notification、dead letter、fallback。找不到就標 `Status: Unknown`。
5. **盤點排程與觸發機制** — 即時 / 定時 / 事件驅動？排程表達式？多久跑一次？有無 backfill / catchup？
6. **盤點使用者可見的回饋機制** — dashboard / log / alert / email / webhook callback / CLI output。使用者怎麼知道系統有在正常運作？
7. **產出 flow 完整度評分** — 依「評估維度與評分」表，給每條 flow 和整體打等級。

## 評估維度與評分

評分用 A / B / C 等級（A=高、B=中、C=低）。目的是評「我們對使用流程的理解程度」，而不是評「流程設計得好不好」（後者是 optimization 維度的事）。

| 維度 | A（高） | B（中） | C（低） |
|---|---|---|---|
| 使用者辨識度 | 使用者 / 呼叫者有明確證據（route / DAG / CLI 定義） | 能推測使用者類型，但無直接證據 | 完全不清楚誰在用 |
| Flow 完整度 | trigger + steps + outcome 全有證據 | 有部分步驟，但 trigger 或 outcome 不明 | 只知道「有東西在跑」，細節不明 |
| 資料流清晰度 | input / processing / output 全有證據 | 知道輸入輸出，但中間處理步驟不清楚 | 只能從程式碼結構猜測 |
| Exception 可見性 | retry / error handling / alert 都有定義 | 有部分 error handling，但 alert 缺失 | 找不到任何 exception 處理 |
| 排程明確度 | 排程表達式 + 頻率 + catchup 設定都有證據 | 知道是定時但頻率不確定 | 不知道怎麼觸發 |

## 輸出 Schema

報告除了強制的鋒面問題（Q1~Q6）章節之外，要包含以下章節：

```markdown
## 1. 使用者 / 呼叫者辨識
- 使用者類型（人 / 排程器 / 系統）
- 使用者身份
- 互動方式（UI / CLI / API / Schedule）

## 2. 使用流程清單
- 每條 flow：
  - Flow ID / 名稱
  - Trigger（觸發條件）
  - Steps（步驟摘要）
  - Outcome（最終產出）
  - 證據

## 3. 資料流向
- 每條 flow 的 Input → Processing → Output
- 資料進入點
- 資料產出點
- 中間暫存（如有）

## 4. Exception Path
- 每條 flow 的失敗場景
- Retry 機制
- Error handling
- Alert / Notification
- Fallback

## 5. 排程與觸發機制
- 觸發類型（即時 / 定時 / 事件）
- 排程表達式
- 頻率
- Catchup / Backfill 設定

## 6. 使用者回饋機制
- Dashboard / 監控
- Log
- Alert / Notification
- 報表 / 輸出檔

## 7. Flow 完整度評分
- 依「評估維度與評分」表打等級（A / B / C）
```

## 反模式（這套方法論常見的誤用）

- **用程式碼函數名當流程步驟** — `extract()` → `transform()` → `load()` 是實作結構，不是使用流程描述。要翻譯成「從上游服務取原始資料 → 做欄位轉換與清洗 → UPSERT 到目標資料庫」之類的業務語言描述。
- **只描述 happy path** — 看不到 error handling 不代表沒有 exception 場景；要標明 `Status: Unknown`。
- **把流程改善建議寫進清點** — 「應該加上 retry」「建議改成 event-driven」屬 optimization，不寫進此報告。
- **假設每條 flow 都是獨立的** — 多條 flow 可能共享資料、有先後依賴、會互相影響。要標出。
- **忽略排程的邊界條件** — catchup=False 和 catchup=True 在 Airflow 裡行為差很多，要記錄。

## 何時不該用這個 Skill

- 標的是 library / SDK（沒有「使用流程」的概念，只有 API surface）— 改用 application 的 API-focused lens。
- 標的純粹是設定檔或 infrastructure-as-code — 改用 fundamentals lens。
- 只想看單一面向（如只看 error handling）— 那是 specific school 的事。
