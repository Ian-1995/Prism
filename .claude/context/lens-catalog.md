---
status: Living Document
purpose: Prism 所有 Skill（透鏡）的註冊表
---

# Lens Catalog — Skill 註冊表

每新增一個 Skill，必須在這份目錄登記。撰寫新 Skill 前先看這份，確認 category 不衝突。

---

## 設計區隔：Baseline vs Specific School

Skill 分兩大類：

| 類型 | 性質 | Category 後綴 | 用途 |
|---|---|---|---|
| **Baseline** | 通用 survey，不綁學派 | `*-baseline` | 每個 Agent 的 default_skill，提供標準資訊蒐集 |
| **Specific School** | 特定方法論 | `architecture-doc`、`api-design` 等 | 套上特定學派視角，可疊加在 Baseline 上 |

疊加規則：同 category 互斥；不同 category 可疊（最多 3 個）。
Baseline 跟 Specific School 屬不同 category，永遠可以共存。

---

## 已內建 Skill

### Baseline Skills（4 套，每維度一套）

| Skill Name | Category | Dimension | Origin | 狀態 |
|---|---|---|---|---|
| usage-flow-survey | usage-baseline | application | （自製）| Draft |
| value-positioning-survey | value-baseline | business | （自製）| Draft |
| tech-inventory-survey | inventory-baseline | fundamentals | （自製）| Draft |
| improvement-survey | improvement-baseline | optimization | （自製）| Draft |

### Specific-School Skills（5 套，視覺化與深度分析）

| Skill Name | Category | Dimension | Origin | 狀態 |
|---|---|---|---|---|
| c4-model-brown | architecture-doc | fundamentals | Simon Brown | Draft |
| ddd-context-map-evans | context-map | fundamentals | Eric Evans | Draft |
| user-story-mapping-patton | user-journey | application | Jeff Patton | Draft |
| wardley-maps-wardley | strategy-map | business | Simon Wardley | Draft |
| impact-map-adzic | goal-mapping | business | Gojko Adzic | Draft |

---

## Category 列表（用於疊加互斥檢查）

每個 Skill 必須宣告 category。同 category 的 Skill 不可疊加。

```
Baseline categories:
  usage-baseline           (application)
  value-baseline           (business)
  inventory-baseline       (fundamentals)
  improvement-baseline     (optimization)

Specific-school categories:
  architecture-doc         (fundamentals)
  context-map              (fundamentals)
  user-journey             (application)
  strategy-map             (business)
  goal-mapping             (business)
```

合法疊加範例：
- `tech-inventory-survey + c4-model-brown + ddd-context-map-evans`（inventory-baseline + architecture-doc + context-map，三不同 category）
- `value-positioning-survey + wardley-maps-wardley + impact-map-adzic`（value-baseline + strategy-map + goal-mapping，三不同 category）

非法疊加範例：
- 同 category 的兩個 specific-school skill（例：兩個 architecture-doc）不能同時套
- baseline 之間不互相疊加（每個維度只有一個 baseline）

---

## 維護規則

1. 新增 Skill 時，先檢查這份目錄
2. 確認 category 不會與既有 Skill 衝突
3. 確認 Skill name 唯一
4. 完成 Skill 撰寫後，把狀態從「未寫」改為「Draft」
5. 經第一次實際使用後，升為「Reviewed」
6. 經正式採納後，升為「Approved」
