# 动态角色生成协议 (Dynamic Role Generation Protocol)

> 这是诸葛亮框架的核心算法文档，定义了如何从任务描述动态生成专业角色。

## 1. 协议概述

### 1.1 目标

实现一个**零模板依赖**的角色生成系统，能够根据任意任务需求，实时创建合适的专业角色。

### 1.2 核心思想

```
传统方式：
  任务 → 匹配预设模板 → 返回角色
  问题：模板有限，无法覆盖长尾需求

诸葛亮方式：
  任务 → 分析需求 → 生成全新角色定义
  优势：无限扩展，精准匹配
```

---

## 2. 生成流程详解

### 2.1 完整流程

```
Step 1: 任务接收
    ↓
Step 2: 需求分析（领域、技能、复杂度）
    ↓
Step 3: 任务拆解（生成子任务树）
    ↓
Step 4: 角色映射（为子任务匹配合适角色）
    ↓
Step 5: 角色定义生成（LLM 生成 Prompt）
    ↓
Step 6: 角色优化（去重、合并、补充）
    ↓
Step 7: 输出角色列表
```

---

### 2.2 Step 2: 需求分析

**输入**：用户原始任务描述

**处理**：使用 LLM 分析以下维度：

| 维度 | 描述 | 示例值 |
|------|------|--------|
| `domain` | 涉及领域 | ["法律", "科技", "商业"] |
| `skill_required` | 所需技能 | ["数据分析", "文书写作", "逻辑推理"] |
| `work_type` | 工作类型 | "分析型" / "创造型" / "执行型" / "沟通型" |
| `complexity` | 复杂度 | "low" / "medium" / "high" |
| `interaction_level` | 交互需求 | "独立工作" / "需要协作" |

**输出示例**：
```json
{
  "domain": ["法律", "太空政策"],
  "skill_required": ["法律分析", "条约谈判", "案例研究"],
  "work_type": "分析型",
  "complexity": "high",
  "interaction_level": "需要协作"
}
```

---

### 2.3 Step 3: 任务拆解

**目标**：将大任务分解为可独立执行的子任务。

**Prompt 模板**：
```markdown
请将以下任务拆解为 N 个可独立执行的子任务：

任务：{task_description}

要求：
1. 每个子任务应有明确的目标和交付物
2. 子任务之间依赖关系清晰
3. 标注每个子任务的优先级（P0/P1/P2）
4. 估算每个子任务所需的专业技能

输出格式（JSON）：
{
  "subtasks": [
    {
      "id": "T1",
      "description": "...",
      "skills_required": ["技能 1", "技能 2"],
      "priority": "P0",
      "estimated_tokens": 5000
    }
  ]
}
```

**输出示例**：
```json
{
  "subtasks": [
    {
      "id": "T1",
      "description": "调研现有国际太空法律框架",
      "skills_required": ["法律研究", "信息搜集"],
      "priority": "P0",
      "estimated_tokens": 10000
    },
    {
      "id": "T2",
      "description": "设计火星殖民地基本法框架",
      "skills_required": ["法律起草", "逻辑推理"],
      "priority": "P0",
      "estimated_tokens": 15000
    },
    {
      "id": "T3",
      "description": "撰写殖民地居民权利宣言",
      "skills_required": ["法律写作", "伦理学"],
      "priority": "P1",
      "estimated_tokens": 8000
    }
  ]
}
```

---

### 2.4 Step 4: 角色映射

**目标**：为每个子任务匹配合适的角色类型。

**映射规则**：

| 子任务技能需求 | 推荐角色类型 |
|--------------|------------|
| 法律研究 + 信息搜集 | 法律研究员 |
| 法律起草 + 逻辑推理 | 资深法律顾问 |
| 法律写作 + 伦理学 | 法律伦理学家 |
| 数据分析 + 统计 | 数据分析师 |
| 代码实现 + 调试 | 软件工程师 |
| 创意写作 + 想象力 | 创意作家 |

**动态生成逻辑**：
```python
def generate_role_name(skills, work_type):
    """
    根据技能和工作类型生成角色名称
    """
    if "法律" in skills and "起草" in skills:
        return "法律起草专家"
    elif "数据分析" in skills and "统计" in skills:
        return "数据分析师"
    # ... 更多规则
    # 如果无匹配，使用通用命名：
    return f"{skills[0]}专家"
```

---

### 2.5 Step 5: 角色定义生成

**核心 Prompt 模板**：

```markdown
你是一位专业的角色设计师。请根据以下信息，生成一个完整的角色定义：

【任务背景】
{task_description}

【子任务描述】
{subtask_description}

【所需技能】
{skills_required}

【工作类型】
{work_type}

请生成以下内容（JSON 格式）：
{
  "role_name": "角色名称（简洁专业，如'资深数据分析师'）",
  "role_background": "角色背景描述（100 字内）",
  "core_skills": ["技能 1", "技能 2", "技能 3"],
  "personality": ["性格 1", "性格 2", "性格 3"],
  "system_prompt": "完整的 System Prompt（200 字内，包含行为准则、输出格式、禁忌事项）",
  "context_window": 128000,
  "persistence": "temporary"  // 或 "permanent"
}
```

**生成示例**：
```json
{
  "role_name": "星际法学家",
  "role_background": "拥有 20 年国际法经验，专攻外层空间法律框架，熟悉《外层空间条约》等国际公约。",
  "core_skills": ["法律分析", "条约谈判", "案例研究"],
  "personality": ["严谨", "逻辑性强", "注重细节"],
  "system_prompt": "你是一位星际法律专家，擅长为新兴太空活动设计法律框架。你的工作风格严谨，注重引用国际法先例。输出时使用正式的法律文书格式，条理清晰，引用准确。",
  "context_window": 128000,
  "persistence": "temporary"
}
```

---

### 2.6 Step 6: 角色优化

**目标**：对生成的角色列表进行去重、合并、补充。

**优化规则**：

1. **去重**：如果两个角色的技能重合度 > 80%，保留一个
2. **合并**：如果两个角色服务于同一子任务组，考虑合并
3. **补充**：检查是否有遗漏的关键角色（如缺少"文档整理"角色）

**伪代码**：
```python
def optimize_roles(roles):
    # 1. 计算相似度矩阵
    similarity_matrix = calculate_similarity(roles)
    
    # 2. 合并高相似度角色
    merged_roles = merge_similar_roles(roles, threshold=0.8)
    
    # 3. 检查覆盖度
    missing_skills = check_coverage(merged_roles, required_skills)
    if missing_skills:
        # 补充缺失角色
        merged_roles.append(generate_missing_role(missing_skills))
    
    return merged_roles
```

---

## 3. 角色实例化

### 3.1 临时角色（In-Memory）

适用于一次性任务：

```javascript
// 在 CoPaw 中创建临时会话
const tempAgent = await copaw.createAgent({
  name: roleDefinition.role_name,
  system_prompt: roleDefinition.system_prompt,
  context_window: roleDefinition.context_window,
  lifecycle: "session"  // 会话结束即销毁
});
```

### 3.2 持久角色（Persistent）

适用于通用型角色，可复用于未来任务：

```javascript
// 保存到 Agent 库
await copaw.saveAgent({
  path: "~/.copaw/workspaces/default/agents/experts/" + roleDefinition.role_name,
  config: roleDefinition,
  metadata: {
    created_from: "dynamic_generation",
    task_id: currentTaskId,
    usage_count: 0
  }
});
```

---

## 4. 质量评估

### 4.1 评估维度

| 维度 | 描述 | 评估方法 |
|------|------|---------|
| **相关性** | 角色是否匹配任务需求 | LLM 评分（1-5 分） |
| **专业性** | 角色定义是否专业、准确 | 人工审核 / 专家评分 |
| **可执行性** | System Prompt 是否清晰可执行 | 任务完成率 |
| **效率** | 角色创建耗时 | 计时统计 |

### 4.2 反馈循环

```
任务完成 → 用户评分 → 记录到记忆 → 优化生成 Prompt
```

---

## 5. 示例：完整生成流程

**用户任务**：
> "帮我研究火星殖民地的法律体系，需要涵盖现有国际法、新法设计、伦理问题。"

**Step 1-2: 需求分析**
```json
{
  "domain": ["法律", "太空政策", "伦理学"],
  "skill_required": ["法律研究", "法律起草", "伦理分析"],
  "work_type": "分析型",
  "complexity": "high"
}
```

**Step 3: 任务拆解**
- T1: 调研现有国际太空法律框架
- T2: 设计火星殖民地基本法
- T3: 分析伦理问题并撰写宣言

**Step 4-5: 角色生成**
- 角色 1: 星际法学家（负责 T1, T2）
- 角色 2: 太空伦理学家（负责 T3）
- 角色 3: 法律文档师（负责整理输出）

**Step 6: 优化**
- 检查覆盖度：✓ 法律 + 伦理 + 文档，覆盖完整
- 输出生成的角色列表

---

## 6. 附录：Prompt 模板库

### 6.1 角色生成 Prompt（完整版）

见 `prompts/role_generator.md`

### 6.2 任务拆解 Prompt

见 `prompts/task_decomposer.md`

### 6.3 角色优化 Prompt

见 `prompts/role_optimizer.md`

---

*协议版本：v0.1.0*
*最后更新：2026-04-04*
