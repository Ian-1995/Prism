---
name: tech-inventory-survey
category: inventory-baseline
dimension: fundamentals
also_applies_to: []
origin:
  author: Prism Project
  source: "Prism Baseline Lens — Fundamentals Inventory (2026)"
  url: ""
compatible_agents:
  - system-analyst
default_for:
  - system-analyst
status: Draft
---

# Skill: Tech Inventory Survey（技術現況清點）

## 核心概念

對被分析的 repo 做「結構化現況清點」。只回答 **what is**，不回答 **what should be**。產出的是一份可被跨 repo 對照的 inventory dossier，而不是評論文。

此 skill 是 fundamentals 維度的 baseline，每個 system-analyst 工作起手都該跑一次；其他 fundamentals 的 specific schools（c4-model-brown / arc42 / 12-factor-audit / dependency-mapping）會疊加在這份清點之上。

關鍵主張：

- **IS 先於 SHOULD**：清點報告裡不出現「應該」「建議」「最好」這類字眼；那些是 optimization 維度的事。
- **每項結論需要證據**：找不到證據時，明確標 `Status: Inferred` 或 `Status: Unknown`，並寫明推測依據或為何找不到。
- **結構化勝過 narrative**：清點要能讓不同 repo 之間做 side-by-side 對照，因此用固定章節與表格欄位。

## 分析步驟

依下列順序執行；每一步都要附證據引用：

1. **偵測主語言與框架** — 掃描專案根目錄找 manifest 檔（`package.json` / `pyproject.toml` / `requirements.txt` / `go.mod` / `Cargo.toml` / `pom.xml` / `build.gradle` / `composer.json` 等）。記錄語言、主框架、版本、Runtime version 要求。Monorepo 時要遞迴掃所有子模組。
2. **列出 Top 10 直接相依** — 從 manifest 或 lockfile 取直接相依（不含 transitive）。每項記錄：套件名、版本、是否 pinned、用途推測（依命名 / 官方 short description）、證據行號。
3. **盤點資料層** — 找 DB 連線設定、ORM model 目錄、migration 目錄、`schema.sql`、cache 設定（Redis / Memcached）、queue 設定（RabbitMQ / Kafka / SQS）、object store 設定。每項標明證據位置。
4. **盤點外部整合** — 掃描 HTTP client 用法、SDK import（aws-sdk / google-cloud / stripe / twilio 等）、env vars 需求、webhook 接收端 endpoint。整理成「整合來源 → 用途 → 證據」表。
5. **偵測執行環境** — 開發環境（venv / conda / Docker / DevContainer）、執行環境（本機 / Docker / K8s / Airflow managed / Cloud Run / Lambda / Serverless）、部署形態（on-premise / cloud-managed / hybrid）。從 `Dockerfile`、`docker-compose.yml`、`devcontainer.json`、`.github/workflows/`、`Procfile`、Airflow DAG 定義、serverless.yml、IaC 檔（Terraform / Pulumi）推斷。找不到任何線索時標 `Status: Unknown`，並在 Open Questions 建議向 author / ops / 部署負責人確認。
6. **盤點啟動方式** — 找進入點檔、`Dockerfile`、`docker-compose.yml`、`Procfile`、`Makefile`、`README` 的啟動指令。記錄：build 指令、run 指令、必要 env vars、預設 port。
7. **產出明確度評分** — 依「評估維度與評分」表，給每個章節打等級（A / B / C），列出有多少結論是 `Confirmed`、多少是 `Inferred`、多少是 `Unknown`。
8. **匯出 Open Questions 清單** — 把所有 `Status: Unknown` 條目**強制**列入 Open Questions，並標明建議確認對象（author / ops / 部署負責人）。`Status: Inferred` 條目也集中列出，供 reviewer 補強。

## 評估維度與評分

評分用 A / B / C 等級（A=高、B=中、C=低）。目的是評「我們對這份 repo 了解多少」，而不是評「這份 repo 寫得好不好」（後者是 optimization 維度的事）。

| 維度 | A（高） | B（中） | C（低） |
|---|---|---|---|
| 語言/框架明確度 | 主語言 + 主框架 + 版本都有 manifest 證據 | 語言 + 框架有證據，版本不確定或散落 | 只能從檔案副檔名推測語言 |
| 相依清晰度 | Top 10 全部版本 pinned 且有 lockfile | 有 manifest 但 lockfile 缺漏 | 只有 `requirements.txt` 無版本約束、或無 manifest |
| 資料層完整度 | DB type + host 來源 + schema 位置都有證據 | 知道有 DB，但 schema / migration 找不到 | 無資料層線索（可能未使用 DB 但也未確認） |
| 外部整合可見性 | env vars + SDK import + endpoint 都列出 | 有部分線索（例：只有 env 沒看到 import） | 完全靠套件名稱推測，無實際呼叫證據 |
| 啟動方式可重現 | 有 Dockerfile / Compose 或 Makefile 一鍵啟動 | 散落在 README，需手動拼步驟 | 找不到啟動指令 |
| 執行環境可重現性 | 有 Dockerfile / IaC / DevContainer 一鍵起全套環境 | 散落在 README 或口頭知識，需手動拼環境 | 完全靠口耳相傳，repo 內無任何環境線索 |

## 輸出 Schema

報告除了強制的「一句話大綱」和鋒面問題（Q1~Q6）章節之外，要包含以下章節（使用 H3 層級；表格欄位細節由 agent 自行決定，但建議包含證據欄）：

```markdown
### 1. 語言與框架
- 主語言、版本、Runtime 版本要求
- 主框架、版本

### 2. 主要直接相依（最多 10 項）
- 套件 / 版本 / Pinned? / 用途推測 / 證據

### 3. 資料層
- DB / 儲存
- Cache
- Queue / 訊息匯流排
- 檔案 / 物件儲存

### 4. 外部整合
- 對外 API client
- Webhook / Callback
- 環境變數清單

### 5. 執行環境
- 開發環境（本機 / venv / conda / Docker / DevContainer）
- 執行環境（本機 / Docker / K8s / Airflow managed / Airflow on-premise
            / Cloud Run / Lambda / Serverless / Unknown）
- 部署形態（on-premise / cloud-managed / hybrid / unknown）
- 必要前置基礎設施（從 §3 資料層交叉引用）
- 資源需求（CPU / RAM / Storage，能抓到才填）

### 6. 啟動方式
- 進入點
- Build 指令
- Run 指令
- 必要環境變數
- 預設 port / 監聽位址

### 7. 清點明確度評分
- 依「評估維度與評分」表給每個維度打等級（A / B / C）

### 8. Inferred / Unknown 清單
- 所有 Status: Unknown 條目強制列出，標明建議確認對象（author / ops / 部署負責人）
- 所有 Status: Inferred 條目集中列出，供 reviewer 補強

### 9. 視覺化附錄（建議，可選）

> 用 Mermaid 補一張簡化 C4 Context 圖或 flowchart，標出本系統 + 外部系統 + 資料流方向。
> 目的：讓非技術 reader 三秒看出「這個系統跟誰互動、資料怎麼流」。
> 如果 repo 結構太簡單（如 single-file script 無外部互動），寫 N/A 並說明。

建議圖型：Mermaid `flowchart LR` 或 `C4Context`。
```

## 反模式（這套方法論常見的誤用）

- **把推測寫成 Confirmed** — 看到 `redis` 在 requirements 不代表 Redis 真的被使用；要找實際呼叫點再升級為 Confirmed。
- **把版本標成「最新版」** — 找不到版本就標 `Unknown`，不要寫「latest」這種無證據的描述。
- **把清點寫成評論** — 「相依太多了」「版本太舊了」屬 optimization 視角，不該出現在 inventory 報告。
- **跳過冷門檔案類型** — 不要因為「沒看過 `Cargo.toml`」就跳過 Rust 子模組；遇到不熟的 manifest 也要清。
- **只看 top-level，不看子目錄** — monorepo 可能每個 service 有自己的 manifest；要全部掃過。

## 何時不該用這個 Skill

- 標的不是 software repo（純文件庫、純設定庫、靜態網站內容庫）— 改用其他 fundamentals lens 或 application lens。
- 已經有最新且可信的 architecture 文件 — 此時 `c4-model-brown` 或 `arc42` 可能更合適，inventory survey 只當基礎墊檔。
- 只想看單一面向（例：只看 security、只看 API design）— 那是 specific school 的事，不需要先跑完整 baseline。
