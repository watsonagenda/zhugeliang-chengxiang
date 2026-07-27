# 快速开始指南 (Quick Start)

> 5 分钟内部署你的诸葛亮动态 Agent 框架

---

## 前置要求

- ✅ CoPaw 1.0+ 已安装并配置
- ✅ Node.js v20+
- ✅ 一个可用的 LLM 后端（NVIDIA NIM / OpenRouter / SiliconFlow 等）

---

## 安装步骤

### 1. 克隆项目

```bash
git clone https://github.com/watsonagenda/zhugeliang-chengxiang.git
cd zhugeliang-chengxiang
```

### 2. 复制配置到 CoPaw

```bash
# 创建 Agent 目录
mkdir -p ~/.copaw/workspaces/default/agents/zhugeliang

# 复制配置文件
cp config/zhugeliang.agent.json ~/.copaw/workspaces/default/agents/zhugeliang/

# 复制 System Prompt
cp prompts/system.md ~/.copaw/workspaces/default/agents/zhugeliang/

# 复制角色生成 Prompt（可选）
cp prompts/role_generator.md ~/.copaw/workspaces/default/agents/zhugeliang/
```

### 3. 重启 CoPaw 服务

```bash
copaw restart
```

### 4. 验证安装

在 CoPaw 中创建新会话，选择 `zhugeliang` Agent，发送测试消息：

```
你好，诸葛亮。请介绍一下你能做什么。
```

如果收到类似以下回复，说明安装成功：

```
我是诸葛亮，你的团队架构师与任务编排总指挥。

我可以根据你的任务需求，动态创建专业角色并组建团队。例如：
- 复杂研究任务 → 创建领域专家团队
- 项目开发 → 创建产品、开发、测试团队
- 创意写作 → 创建创意策划和内容创作团队

请告诉我你想完成什么任务，我来帮你组建合适的团队！
```

---

## 基础使用

### 场景 1: 复杂研究

```
用户：我想研究火星殖民地的法律体系，需要涵盖现有国际法、新法设计、伦理问题。

诸葛亮：收到！这个任务涉及跨学科知识，我将创建以下专家团队：
        1. 星际法学家 - 负责法律框架调研
        2. 制度设计专家 - 负责新法设计
        3. 太空伦理学家 - 负责伦理分析
        
        正在创建角色并分配任务...
```

### 场景 2: 项目开发

```
用户：我想开发一个智能提醒系统，支持持续提醒和周期性打卡

诸葛亮：理解！这是一个中等复杂度的开发任务，我将创建：
        1. 产品经理 - 需求分析与文档化
        2. 架构师 - 技术方案设计
        3. 开发者 - 核心功能实现
        4. 测试员 - 功能验证
        
        是否开始执行？
```

### 场景 3: 创意写作

```
用户：我想写一部关于 AI 觉醒的科幻小说

诸葛亮：很有趣的创意！我将组建：
        1. 科幻世界观架构师 - 设定背景
        2. 角色设计师 - 创建人物
        3. 情节编排师 - 设计剧情线
        4. 文笔润色师 - 优化表达
        
        开始创作之前，请告诉我：
        1. 小说篇幅？（短篇/中篇/长篇）
        2. 目标读者群体？
        3. 偏好风格？（硬科幻/软科幻/赛博朋克）
```

---

## 高级用法

### 指定角色要求

```
用户：帮我做个市场调研，需要一个懂 AI 行业、有投资背景的人

诸葛亮：好的，我将创建：
        角色名称：AI 行业分析师
        背景：10 年科技行业投资经验，专注 AI 赛道
        技能：行业分析、市场调研、投资评估
        
        是否满足要求？
```

### 指定团队规模

```
用户：组建一个小团队，3-4 个人就够了

诸葛亮：明白，我会控制团队规模在 3-4 个角色内，优先保证核心能力覆盖。
```

### 指定输出格式

```
用户：最后给我一个结构化的报告，要有目录和摘要

诸葛亮：已记录，最终输出会包含：
        - 执行摘要
        - 目录结构
        - 分章节正文
        - 结论与建议
```

---

## 常见问题

### Q: 角色是真实的 Agent 吗？

A: 是的。诸葛亮会为每个角色生成独立的 System Prompt，并在 CoPaw 中实例化为临时或持久的 Agent。每个角色有自己的"人格"和专业能力。

### Q: 如何保存优秀的角色？

A: 诸葛亮会自动将通用型强、质量高的角色标记为 `permanent`，保存到 `~/.copaw/workspaces/default/agents/experts/` 目录。你也可以手动指定。

### Q: 可以自定义角色生成逻辑吗？

A: 可以！编辑 `prompts/role_generator.md`，调整角色生成的维度、格式和质量标准。

### Q: 支持哪些 LLM 后端？

A: 理论上支持所有 CoPaw 支持的模型。推荐使用：
- NVIDIA NIM（qwen/qwen3.5-397b-a17b）
- OpenRouter（支持免费模型）
- SiliconFlow

### Q: 如何查看历史创建的角色？

A: 查看 `~/.copaw/workspaces/default/agents/experts/` 目录，所有持久化角色都在那里。

---

## 下一步

- [ ] 阅读 `docs/01-architecture.md` 了解架构设计
- [ ] 阅读 `docs/02-dynamic-role-protocol.md` 了解角色生成算法
- [ ] 尝试一个复杂任务，体验动态组队
- [ ] 贡献你的角色模板和优化建议

---

**祝你使用愉快！有任何问题欢迎提 Issue。** 🚀
