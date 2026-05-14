---
status: Example
purpose: 對外展示 Prism 分析報告的標準結構
target_kind: 虛構 / fictional
last_updated: 2026-05-14
---

# Example Analysis — `acme-todo-api`

> 這份是 **公開範例**，目標 repo `acme-todo-api` 是**虛構**的小型 Node.js / Express Todo app，僅用於展示 Prism 一次 panel 分析會產出什麼樣的結構與內容深度。
>
> 真實跑 `/analyze panel=full path=<target>` 時，輸出會落在 `docs/analyses/<target-basename>-<YYYY-MM-DD>/` 下，並且**不會**被 commit 進 repo（見 [.gitignore](../../../.gitignore)）。

---

## 一份 Panel 分析包含的檔案

| 檔名 | 內容 | 對應維度 | 本 example 是否提供 |
|---|---|---|---|
| `00_panel_summary.md` | 鋒面問題 Q1~Q6 對照表 + 四維度健康度評分 + 跨維度觀察 + Open Questions 彙總 | （彙整） | ✅ |
| `01_system-analyst.md` | 技術現況清點：語言框架 / 相依 / 資料層 / 外部整合 / 啟動方式 | `fundamentals` | — |
| `02_business-analyst.md` | 業務流程：actor / 主要流程 / entry points / 痛點訊號 | `application` | — |
| `03_product-strategist.md` | 商業定位：目標客戶 / 解決問題 / 差異化 / 商業模式訊號 | `business` | — |
| `04_tech-lead.md` | 優化清單：程式碼熱點 / 架構問題 / 測試缺口 / P0~P2 優先序 | `optimization` | — |

> 本 example 只附上 `00_panel_summary.md`（最具代表性的「執行摘要」一張紙）以保持 repo 輕量。01~04 的個別維度詳細報告，請對你自己的 target repo 跑 `/analyze panel=full path=<your-repo>` 即可產生。

---

## 怎麼讀這份報告

1. **從 [`00_panel_summary.md`](00_panel_summary.md) 開始** — 看 Q1~Q6 對照表能立刻抓到四個維度的觀點落差
2. 對某個維度想深入再看對應的 `01~04` 詳細報告
3. 「Open Questions 彙總」是接手 / 補強的最高優先 todo list
4. 每個結論後面都有證據引用（`path:line` 或 `manifest:line`）— 可點進去驗證

---

## 約定俗成

- 每份報告開頭都是 YAML frontmatter（`status: Draft / Reviewed / Approved`、agent、skill、target、date）
- 推測必須標 `Status: Inferred` 或 `Status: Unknown`，不能假裝是事實（P-4）
- 報告不會修改 target repo 任何檔案（P-5）
- Q1~Q6 強制章節（P-6）

完整原則見 [`docs/meta/00_design_principles.md`](../../meta/00_design_principles.md)。

---

## 想看真實案例？

跑一次就有：

```bash
/analyze panel=full path=C:\path\to\your-target-repo
```

產出會落在 `docs/analyses/<target>-<date>/`，本機可讀，git 不會 commit。
