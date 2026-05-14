# Example: Claude Code 工作規則範本

> 這份是 Prism 給 contributors / fork 者參考的 `CLAUDE.md` 範本。
>
> 真實使用時，把這份檔案複製成專案根目錄的 `CLAUDE.md`，依需求調整內容。
> `CLAUDE.md` 預設被 `.gitignore` 排除，因為它通常含本機路徑、進度狀態、session 接手筆記等不適合公開的資訊。

---

# Prism — Claude Code 工作規則

## 專案簡介

Prism 是一套多視角程式碼分析框架，透過 Agent（員工）× Skill（方法論）組合，對 target repo 產出多維度 panel 報告。

## 必讀文件

1. `docs/meta/00_design_principles.md` — 設計原則
2. `docs/meta/01_agent_skill_contract.md` — Agent ↔ Skill 契約
3. `.claude/context/lens-catalog.md` — Skill 註冊表

## 工作規則

### R-1：不修改被分析的 target repo

Prism 是只讀工具（P-5）。分析時只讀取 target repo，所有產出寫到 `prism/docs/analyses/<slug>/`。

### R-2：.claude/ 子目錄直接寫入

在 Claude Code CLI 或 VSCode 擴充中，`.claude/agents`、`.claude/skills`、`.claude/commands` 等子目錄是 whitelist 可寫，直接用 Write tool。

### R-3：Skill 檔名是小寫 skill.md

路徑格式：`.claude/skills/lens/<dimension>/<skill-name>/skill.md`

### R-4：寫新 Agent / Skill 前先讀契約

- Agent：對照 `docs/meta/01_agent_skill_contract.md` §一 + `templates/agent-template.md`
- Skill：對照 `docs/meta/01_agent_skill_contract.md` §二 + `templates/skill-template.md`
- 寫完後更新 `.claude/context/lens-catalog.md`

### R-5：報告必須遵守鋒面問題 + 證據規則

- Q1~Q6 強制回答（P-6）
- 所有結論附證據（P-4）
- 推測標 `Status: Inferred` 或 `Status: Unknown`

### R-6：避免在 voice samples / examples 寫進客戶資料

寫 agent / skill 的 voice sample、anti-pattern 範例、audience 對話樣本時，**使用通用的虛構領域**（e-commerce / Todo API / SaaS / blog 等），不要使用真實客戶名稱、內部專案 codename、specific column / file 命名。

如果你要在本機留客戶分析報告，記得：

- `docs/analyses/<slug>/` 預設被 `.gitignore` 排除（除了 `example/`）
- 不要把客戶 domain term 寫進 `.claude/` 下的任何檔
- `CLAUDE.md` 也被 gitignore；如果你要在那寫私密 todo / 認證資訊，請確認 gitignore 已生效

---

## 補充：如何客製這份檔案

複製到專案根作 `CLAUDE.md` 後可調整：

- **加入內部進度追蹤** — 如果你維護 PROGRESS.md / Linear / Notion 等內部 tracker，可在這加上「每次工作後回填」的規則
- **R-2 的工具差異** — 如果你用 cowork desktop 或其他 Claude 工具，工具限制不同
- **R-6 的領域舉例** — 改成你常用的測試領域（例：金融、教育、IoT）

如果你 fork 了 Prism 並要做 commercial fork，請另外閱讀 [LICENSE](LICENSE) — 商業使用須事前取得作者書面同意。
