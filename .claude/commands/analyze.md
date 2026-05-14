# /analyze — Prism 多視角分析指令

> Orchestrator command。負責組合 Agent × Skill、驗證相容性、驅動分析、產出報告。

---

## 使用方式

```
/analyze agent=<agent-name> [skill=<skill-name>] path=<absolute_target_path>
/analyze panel=full path=<absolute_target_path>
```


### 單一分析模式

```
/analyze agent=system-analyst path=C:\Users\IanXu\claudeCode\some-repo
/analyze agent=system-analyst skill=tech-inventory-survey path=C:\Users\IanXu\claudeCode\some-repo
```

- 不指定 skill 時，使用 agent 的 `default_skill`
- 指定 `skill=none` 時，跑無 Skill 模式（只走鋒面問題 + agent 的優先發問順序）

### Full Panel 模式

```
/analyze panel=full path=C:\Users\IanXu\claudeCode\some-repo
```

依序跑四組 agent × default_skill：

| 順序 | Agent | Skill | 維度 |
|---|---|---|---|
| 01 | system-analyst | tech-inventory-survey | fundamentals |
| 02 | business-analyst | usage-flow-survey | application |
| 03 | product-strategist | value-positioning-survey | business |
| 04 | tech-lead | improvement-survey | optimization |

---

## 執行流程

### Step 0：參數解析

1. 解析 `agent`、`skill`、`path`、`panel` 參數
2. `path` 必須是絕對路徑且目錄存在
3. `panel=full` 時忽略 `agent` 和 `skill` 參數

### Step 1：Compatibility Matrix 檢查

對每組 agent × skill 組合，依序檢查（任一失敗即拒絕並說明原因）：

```
✓ agent 定義檔存在？（.claude/agents/<dimension>/<agent-name>.md）
✓ skill 定義檔存在？（.claude/skills/lens/<dimension>/<skill-name>/skill.md）
✓ agent.dimension 或 agent.also_applies_to 包含 skill.dimension？
✓ skill ∈ agent.compatible_skills？
✓ agent ∈ skill.compatible_agents？
✓ 疊加的多個 skill 之間，category 全部不同？
✓ 疊加的 skill 總數 ≤ 3？
```

### Step 2：建立輸出目錄

```
docs/analyses/<slug>/
```

slug 規則：`<target-basename>-<YYYY-MM-DD>`

例：`acme-todo-api-2026-05-14`

如果目錄已存在，在 slug 後加 `-N`（`-2`、`-3`...）。

### Step 3：讀取定義檔

1. 讀取 agent 定義檔 → 取得 persona、voice、優先發問順序、證據引用偏好
2. 讀取 skill 定義檔 → 取得分析步驟、評估維度、輸出 schema、反模式
3. 讀取 `templates/report-template.md` → 取得報告骨架

### Step 4：分析 Target Repo

以 agent 的 persona 和 voice，按 skill 的分析步驟，對 target repo 執行分析：

1. **掃描 target repo 結構** — 讀目錄樹、manifest、config、README
2. **依 skill 的分析步驟逐步執行** — 每一步都記錄證據
3. **回答鋒面問題 Q1~Q6** — 從 agent 的視角回答
4. **依 skill 的 output_schema 組織方法論分析章節**
5. **依 skill 的評估維度打分**
6. **收集 Open Questions / Unknowns**

**重要約束：**
- **只讀 target repo，不修改任何檔案**（P-5）
- **所有結論必須附證據**（P-4）
- **找不到證據標 `Status: Inferred` 或 `Status: Unknown`**
- **文字風格走 Agent，結構骨架走 Skill**

### Step 5：產出報告

依 `templates/report-template.md` 的骨架，組裝報告：

```
1. Header（frontmatter：slug、target、agent、skill、date、status=Draft）
2. 鋒面問題章節 Q1~Q6（強制，依 P-6）
3. 方法論分析章節（依 Skill.output_schema）
4. 證據附錄（依 Agent.evidence_rules 格式）
5. Open Questions / Unknowns
6. Status 流轉紀錄
```

報告檔名規則：
- 單一模式：`<NN>_<agent-name>.md`（NN 依維度順序：01=fundamentals, 02=application, 03=business, 04=optimization）
- Panel 模式：`01_system-analyst.md` ~ `04_tech-lead.md`

### Step 6：產出 Panel Summary（僅 panel=full）

建立 `00_panel_summary.md`，內容：

```markdown
---
analysis_slug: <slug>
target: <path>
date: <YYYY-MM-DD>
status: Draft
---

# Panel Summary: <target-basename>

> 四維度分析總覽。各維度詳見 01~04 報告。

## 鋒面問題對照表

| 問題 | fundamentals | application | business | optimization |
|---|---|---|---|---|
| Q1. 核心價值 | (摘要) | (摘要) | (摘要) | (摘要) |
| Q2. 最大風險 | (摘要) | (摘要) | (摘要) | (摘要) |
| Q3. 保留哪部分 | (摘要) | (摘要) | (摘要) | (摘要) |
| Q4. 不能動的 | (摘要) | (摘要) | (摘要) | (摘要) |
| Q5. 第一週 | (摘要) | (摘要) | (摘要) | (摘要) |
| Q6. 商品化/內部 | (摘要) | (摘要) | (摘要) | (摘要) |

## 各維度健康度評分

| 維度 | Agent | Skill | 整體評分 | 最弱項 |
|---|---|---|---|---|
| fundamentals | system-analyst | tech-inventory-survey | (等級) | (維度) |
| application | business-analyst | usage-flow-survey | (等級) | (維度) |
| business | product-strategist | value-positioning-survey | (等級) | (維度) |
| optimization | tech-lead | improvement-survey | (等級) | (維度) |

## 跨維度觀察

- (人工填寫或由 reviewer 補上：跨維度衝突點、互補觀察、共同發現)

## Open Questions 彙總

- (彙集四份報告的 Open Questions，去重後列出)
```

### Step 7：回報完成

輸出：
```
✓ 分析完成
  Target: <path>
  Output: docs/analyses/<slug>/
  報告：
    - 00_panel_summary.md (僅 panel 模式)
    - 01_system-analyst.md
    - 02_business-analyst.md
    - 03_product-strategist.md
    - 04_tech-lead.md
```

---

## 錯誤處理

| 情境 | 行為 |
|---|---|
| path 不存在或不是目錄 | 拒絕，提示正確格式 |
| agent 定義檔不存在 | 拒絕，列出可用 agents |
| skill 定義檔不存在 | 拒絕，列出可用 skills |
| agent × skill 不相容 | 拒絕，說明哪條檢查失敗 |
| 疊加 skill 同 category | 拒絕，列出衝突的 skill pair |
| 疊加 skill > 3 | 拒絕，提示上限 |
| target repo 為空目錄 | 產出報告但所有項目標 `Status: Unknown` |

---

## 可用的 Agents

| Agent | 維度 | Default Skill |
|---|---|---|
| system-analyst | fundamentals | tech-inventory-survey |
| business-analyst | application | usage-flow-survey |
| product-strategist | business | value-positioning-survey |
| tech-lead | optimization | improvement-survey |

## 可用的 Skills

| Skill | Category | 維度 | Compatible Agents |
|---|---|---|---|
| tech-inventory-survey | inventory-baseline | fundamentals | system-analyst |
| usage-flow-survey | usage-baseline | application | business-analyst |
| value-positioning-survey | value-baseline | business | product-strategist |
| improvement-survey | improvement-baseline | optimization | tech-lead |

---

## 約束與原則

- **P-5 只讀**：不修改 target repo 的任何檔案
- **P-4 證據強制**：所有結論附證據，推測標 Inferred / Unknown
- **P-6 鋒面問題**：Q1~Q6 強制回答
- **P-1 職責分離**：文字風格走 Agent，結構骨架走 Skill
- **Workbench 模式**：prism repo 是工作台，target repo 是被分析對象，輸出寫到 prism 的 docs/analyses/
