---
name: improvement-survey
category: improvement-baseline
dimension: optimization
also_applies_to: []
origin:
  author: Prism Project
  source: "Prism Baseline Lens — Optimization Improvement Survey (2026)"
  url: ""
compatible_agents:
  - tech-lead
default_for:
  - tech-lead
status: Draft
---

# Skill: Improvement Survey（改善機會清點）

## 核心概念

對被分析的 repo 做「改善機會結構化清點」。回答 **what should change** 和 **in what order**，建立在 fundamentals 維度的現況描述之上。產出的是一份有優先序的 improvement backlog，不是 code review comment。

此 skill 是 optimization 維度的 baseline，每個 tech-lead 工作起手都該跑一次；其他 optimization 的 specific schools（joshua-bloch-api-design / clean-architecture / OWASP 等）會疊加在這份清點之上。

關鍵主張：

- **問題必須排序**：不分優先序的問題清單沒有行動價值。用 P0 / P1 / P2 分級。
- **每個問題必須有證據和影響評估**：不是「感覺不好」，是「這裡會造成什麼具體風險」。
- **改善建議必須在現有架構上可執行**：「重寫」不是建議。

## 分析步驟

依下列順序執行；每一步都要附證據引用：

1. **掃描正確性風險** — 可能導致資料錯誤、邏輯錯誤、競爭條件的問題。這類問題自動列為 P0 候選。包含：時區不一致、型別轉換不安全、silent data loss、race condition。
2. **掃描重複與維護負擔** — copy-paste code、magic number、設定散落、缺乏 DRY。評估「改一個地方需要同時改幾個地方」的倍數。
3. **掃描防護缺口** — 缺 input validation、缺 error handling、缺 retry、缺 alert / notification、缺 circuit breaker。每個缺口評估「出事時的影響」。
4. **掃描可測試性** — 有無測試檔？測試覆蓋哪些路徑？能本地跑嗎？需要外部依賴嗎？CI 有在跑嗎？
5. **掃描可觀測性** — log 品質（structured? level 正確?）、有無 metrics、有無 dashboard、出問題能多快定位？
6. **掃描技術債歷史** — 從 git log、TODO / FIXME / HACK comment、commit message 找刻意的 trade-off 和趕工痕跡。
7. **排序並產出 Improvement Backlog** — 所有發現依 P0 / P1 / P2 排序，每項附：問題描述、證據、影響評估、建議修復方向。

## 評估維度與評分

評分用 A / B / C 等級（A=高、B=中、C=低）。目的是評「這個 repo 的技術健康度」— 具體地說，是「接手或持續維護的風險等級」。

| 維度 | A（健康） | B（可控） | C（需注意） |
|---|---|---|---|
| 正確性 | 無已知正確性風險，或已有防護機制 | 有潛在風險但影響範圍有限 | 有已知或高概率的正確性問題 |
| 可維護性 | DRY、設定集中、改一處即生效 | 有部分重複但數量可控 | 大量 copy-paste、改一處需同步多處 |
| 防護程度 | error handling + retry + alert 齊全 | 有部分防護但有缺口 | 缺乏基本 error handling |
| 可測試性 | 有測試 + 能本地跑 + CI 自動化 | 有部分測試但覆蓋不全 | 無測試或只能在生產環境驗證 |
| 可觀測性 | structured log + metrics + dashboard | 有 log 但缺 metrics / dashboard | log 不足，出問題難定位 |

## 輸出 Schema

報告除了強制的鋒面問題（Q1~Q6）章節之外，要包含以下章節：

```markdown
## 1. 正確性風險
- 每個風險：描述 / 證據 / 影響 / 建議優先序

## 2. 重複與維護負擔
- 重複項目清單
- 「改一處需同步 N 處」的估算
- 影響與優先序

## 3. 防護缺口
- 缺失項目（error handling / retry / alert / validation）
- 每項的「出事時影響」
- 優先序

## 4. 可測試性現況
- 現有測試盤點
- 測試覆蓋評估
- 本地可跑性
- CI 狀態

## 5. 可觀測性現況
- Log 品質
- Metrics / Dashboard
- 問題定位能力

## 6. 技術債紀錄
- TODO / FIXME / HACK 清單
- Git history 中的趕工痕跡
- 刻意 trade-off（如有）

## 7. Improvement Backlog（排序後）
- P0（必須修）：正確性風險、會 block 上線的問題
- P1（應該修）：維護負擔大、防護缺口
- P2（可以修）：code quality、可觀測性、可測試性
- 每項：問題 / 證據 / 影響 / 建議方向
```

## 反模式（這套方法論常見的誤用）

- **不排序的 laundry list** — 列 30 個問題但全部 P1 等於沒排序。強制自己分 P0/P1/P2，每級不超過 5 項。
- **把偏好當問題** — 「沒有用 type hint」不一定是問題；要評估它在這個 repo 的 context 下是否真的造成風險。
- **建議「重寫」** — 重寫不是改善，是新專案。改善建議必須在現有架構上可執行，而且有明確的 scope。
- **忽略歷史脈絡** — 看到 copy-paste 就說 bad code，但可能那是刻意的（如避免跨模組耦合）。看 git log 再判斷。
- **把 fundamentals 的描述混進來** — 「它用 MySQL」是事實描述（fundamentals）；「MySQL 的 UPSERT 語法容易出錯」是改善觀察（optimization）。兩者要分清。

## 何時不該用這個 Skill

- 對 repo 的現況還不清楚 — 先跑 fundamentals baseline（tech-inventory-survey），再跑 improvement survey。
- 標的是全新專案（green field）— 沒有「現有問題」可以改善，改用 architecture review lens。
- 只想看特定面向（如只看 security、只看 API design）— 那是 specific school 的事。
