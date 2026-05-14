---
name: impact-map-adzic
category: goal-mapping
dimension: business
also_applies_to: [optimization]
origin:
  author: Gojko Adzic
  source: "Impact Mapping: Making a big impact with software products and projects (2012)"
  url: https://www.impactmapping.org
compatible_agents:
  - product-strategist
  - tech-lead
default_for: []
status: Draft
---

# Skill: Impact Mapping — Adzic（影響力地圖）

## 核心概念

用 **Why → Who → How → What** 四層 mindmap，把產品決策連到具體可交付物。核心問題是：「我們為什麼做這件事（Goal），誰的行為需要改變（Actors），行為要怎麼變（Impacts），我們要交付什麼來促成這個變化（Deliverables）」。

Impact Map 的價值是**避免「因為技術上能做就做了」的陷阱** — 每個 deliverable 都必須能往上追溯到一個可衡量的 goal。

關鍵主張：

- **Goal 必須可衡量**：「提升使用者體驗」不是 goal；「checkout 完成率從 65% 提高到 80%」才是。
- **Impact 是行為變化，不是功能**：「加一個 dashboard」是 deliverable，不是 impact。「使用者每天主動查看訂單狀態」才是 impact。
- **Deliverable 是假設，不是承諾**：每個 deliverable 都是「我們假設做了這個，actor 的行為就會改變」。

## 分析步驟

依下列順序執行；每一步都要附證據引用：

1. **Goal (Why)** — 這個 repo 想達成什麼可衡量結果？從 README / commit history / 需求文件 / domain model 推斷。找不到就標 `Status: Inferred` 並從系統行為反推。
2. **Actors (Who)** — 誰會幫忙達成 goal？誰會阻礙？誰會受影響？包含人（營運人員 / 開發者 / 主管）和系統（排程器 / 監控系統 / 下游 dashboard）。
3. **Impacts (How)** — 每個 actor 的行為要怎麼變才能達成 goal？用「從 X 變成 Y」的格式描述。
4. **Deliverables (What)** — 要做什麼功能 / 改動才能促成行為變化？從 repo 現有功能和 backlog（如有）推斷。
5. **優先序與依賴** — 標 P0 / P1 / P2，標 deliverable 之間的依賴關係。

## 評估維度與評分

評分用 A / B / C 等級。目的是評「goal → deliverable 的連結是否清晰」。

| 維度 | A（高） | B（中） | C（低） |
|---|---|---|---|
| Goal 可衡量性 | 有明確的量化指標或 success criteria | 有定性描述但無量化 | 只有 vague vision |
| Actor 覆蓋廣度 | 涵蓋直接使用者 + 間接受影響者 + 阻礙者 | 只列了直接使用者 | 沒有識別 actor |
| Impact 行為導向 | 每個 impact 描述的是行為變化而非功能 | 混了部分功能描述 | 全部是功能描述 |
| Deliverable 可執行 | 每個 deliverable 有明確 scope 且可追溯到 impact | 有列出但 scope 模糊 | 只是 wish list |

## 輸出 Schema

報告除了強制的「一句話大綱」和鋒面問題（Q1~Q6）章節之外，要包含以下章節：

```markdown
### 1. Goal
（一句話可衡量的目標 + 證據）

### 2. Actors
| Actor | 類型（人/系統） | 角色（幫忙/阻礙/受影響） | 證據 |
|---|---|---|---|

### 3. Impacts（每個 actor 的行為變化）
| Actor | 現狀行為 | 目標行為 | 證據 |
|---|---|---|---|

### 4. Deliverables（每個 impact 對應的可交付物）
| Impact | Deliverable | 優先序 | 狀態（已做/待做） | 證據 |
|---|---|---|---|---|

### 5. Impact Map 主圖（Mermaid mindmap）

### 6. 優先序與依賴

### 7. 評分總結
| 維度 | 等級 | 說明 |
|---|---|---|
```

## 反模式（這套方法論常見的誤用）

- **Goal 寫成 vague vision** — 「成為最棒的監控平台」不是 goal。必須可衡量。找不到量化指標就老實標 `Status: Inferred` 並給出最佳推測。
- **跳過 impact 直接從 actor 到 deliverable** — 失去「為什麼做」的連結。「營運人員 → dashboard」缺了中間的「營運人員的行為要從 X 變成 Y」。
- **Deliverable 寫成 epic 而非 user story sized** — 「重寫整個 ETL」不是可執行的 deliverable；「把四個 DAG 合成 factory function」才是。
- **把 Impact Map 當 feature backlog** — Impact Map 的重點是策略連結，不是 task management。

## 何時不該用這個 Skill

- repo 已 deprecated 無後續開發計畫 — Impact Map 是前瞻性工具，對不再發展的系統沒用。
- 純技術重構 ticket 無 user-facing 變化 — 改用 improvement-survey。
- repo 的 goal 完全明確且已有 roadmap — 此時 Impact Map 只是重畫已知的東西。
