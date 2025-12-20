# 🎯 Onboarding PR 关联指南

## 当前状态

✅ **代码已完成并推送到各分支**

```
dispatchai-platform (fix-onboarding)
    ├─ apps/backend (fix-onboarding) ✓
    ├─ apps/frontend (fix-onboarding) ✓
    ├─ apps/ai (fix-onboarding) ✓
    └─ deployment (fix-onboarding) ✓
```

## 👉 接下来要做什么？

需要创建 **3 个关联的 PR**，分别针对不同的仓库：

### 1️⃣ 后端 PR - Backend Repository

**仓库:** https://github.com/Dispatch-AI-com/backend

**创建 PR 链接:**
```
https://github.com/Dispatch-AI-com/backend/compare/main...fix-onboarding?expand=1
```

**最简单的方式 (推荐):**
1. 访问 https://github.com/Dispatch-AI-com/backend
2. 点击 "Contribute" → "Open pull request"
3. 选择 `fix-onboarding` 分支
4. 填写标题和描述

**标题:** 
```
fix: improve onboarding address parsing and error handling
```

**描述:**
```markdown
## 改进内容

- ✅ 扩展地址正则表达式，支持多种 Australian 地址格式
- ✅ 添加手动地址解析回退机制
- ✅ 修复跳过按钮的字段验证问题
- ✅ 增强 Google OAuth 错误处理
- ✅ 添加开发模式支持 (Twilio/Stripe Mock)

## 改动文件

- src/modules/onboarding/onboarding.service.ts (110+ 行)
- src/modules/auth/strategies/google.strategy.ts (30+ 行)
- src/modules/auth/auth.controller.ts (50+ 行)
- src/lib/twilio/twilio.module.ts (新文件)
- src/modules/stripe/stripe.service.ts (20+ 行)

## 测试

- [ ] 本地 npm run type-check
- [ ] 本地 npm run lint
- [ ] 本地 npm run build
- [ ] 测试地址解析功能
- [ ] 测试 Google OAuth 流程
- [ ] 测试跳过按钮功能
```

**预期结果:**
- 后端 PR URL: `https://github.com/Dispatch-AI-com/backend/pull/XXX`

---

### 2️⃣ 前端 PR - Frontend Repository

**仓库:** https://github.com/Dispatch-AI-com/frontend

**创建 PR 链接:**
```
https://github.com/Dispatch-AI-com/frontend/compare/main...fix-onboarding?expand=1
```

**标题:**
```
fix: handle undefined values in onboarding components
```

**描述:**
```markdown
## 改进内容

- ✅ 处理地址自动完成中的 undefined 值
- ✅ 修复用户输入区域的错误处理
- ✅ 增强 OAuth 回调数据验证
- ✅ 统一 API base URL 配置

## 改动文件

- src/components/ui/AddressAutocomplete.tsx (60+ 行)
- src/app/onboarding/components/UserInputArea.tsx (30+ 行)
- src/app/auth/callback/AuthCallbackContent.tsx (40+ 行)
- src/lib/axiosBaseQuery.ts (20+ 行)
- src/components/GoogleOAuthButton.tsx (10+ 行)
- src/features/public/publicApiSlice.ts (5+ 行)
- src/services/places.ts (5+ 行)
- package.json (5+ 行)

## 测试

- [ ] 本地 pnpm type-check
- [ ] 本地 pnpm lint --fix
- [ ] 本地 pnpm build
- [ ] 测试地址输入 (各种格式)
- [ ] 测试 Google 登录
- [ ] 测试完整 onboarding 流程
- [ ] 浏览器控制台无错误

## 关联 PR

- Backend: (将在下方更新为实际链接)
```

**预期结果:**
- 前端 PR URL: `https://github.com/Dispatch-AI-com/frontend/pull/XXX`

---

### 3️⃣ 主仓库 PR - Main Repository

**仓库:** https://github.com/Dispatch-AI-com/dispatchai-platform

**创建 PR 链接:**
```
https://github.com/Dispatch-AI-com/dispatchai-platform/compare/main...fix-onboarding?expand=1
```

**标题:**
```
chore: update submodule references for onboarding fixes
```

**描述:**
```markdown
## 改进内容

- ✅ 更新 Docker Compose 命令结构
- ✅ 移除环境变量占位符
- ✅ 更新子模块指针到修复分支

## 相关 PR

**必须在此处链接前两个 PR (在创建后获得实际链接):**
- Backend: https://github.com/Dispatch-AI-com/backend/pull/XXX
- Frontend: https://github.com/Dispatch-AI-com/frontend/pull/XXX

## 改动文件

- package.json (Docker Compose 脚本更新)
- .env.shared (移除占位符)
- PR_GUIDE.md (新文件 - PR 指南)
- ONBOARDING_CHANGES_SUMMARY.md (新文件 - 改动总结)
- create-prs.sh (新文件 - 自动化脚本)

## 子模块更新

```
apps/backend: 6442ea6 (fix-onboarding)
apps/frontend: 41e67a4 (fix-onboarding)
apps/ai: dcbea4b (fix-onboarding)
deployment: fe8873f (fix-onboarding)
```

## 说明

此 PR 汇总了前后端和基础设施的所有 onboarding 相关改动。
```

**预期结果:**
- 主仓库 PR URL: `https://github.com/Dispatch-AI-com/dispatchai-platform/pull/XXX`

---

## 📋 创建 PR 的完整流程

### 步骤 1: 创建后端 PR

```
1. 打开: https://github.com/Dispatch-AI-com/backend
2. 点击: Code 按钮旁的绿色 "New pull request"
3. 或直接访问: https://github.com/Dispatch-AI-com/backend/compare/main...fix-onboarding
4. 填写标题和描述
5. 点击 "Create pull request"
6. ✅ 复制 PR 链接 (例如: https://github.com/Dispatch-AI-com/backend/pull/99)
```

### 步骤 2: 创建前端 PR

```
1. 打开: https://github.com/Dispatch-AI-com/frontend
2. 点击: Code 按钮旁的绿色 "New pull request"
3. 或直接访问: https://github.com/Dispatch-AI-com/frontend/compare/main...fix-onboarding
4. 填写标题和描述
5. 在描述中添加后端 PR 的链接
6. 点击 "Create pull request"
7. ✅ 复制 PR 链接 (例如: https://github.com/Dispatch-AI-com/frontend/pull/88)
```

### 步骤 3: 创建主仓库 PR

```
1. 打开: https://github.com/Dispatch-AI-com/dispatchai-platform
2. 点击: Code 按钮旁的绿色 "New pull request"
3. 或直接访问: https://github.com/Dispatch-AI-com/dispatchai-platform/compare/main...fix-onboarding
4. 填写标题和描述
5. 在描述中添加后端和前端 PR 的链接
6. 点击 "Create pull request"
7. ✅ 复制 PR 链接 (例如: https://github.com/Dispatch-AI-com/dispatchai-platform/pull/77)
```

### 步骤 4: 在各 PR 中相互引用 (可选但推荐)

```
在后端 PR 的描述中添加:
关联 PR: 
- Frontend: <前端 PR 链接>
- Main: <主仓库 PR 链接>

在前端 PR 的描述中添加:
关联 PR:
- Backend: <后端 PR 链接>
- Main: <主仓库 PR 链接>
```

---

## 🔍 PR 创建后的检查清单

### 后端 PR
- [ ] 标题正确: "fix: improve onboarding address parsing..."
- [ ] 基础分支: `main` (而不是 `develop` 或其他)
- [ ] 头部分支: `fix-onboarding`
- [ ] 改动 5 个文件
- [ ] CI/CD 检查通过 (绿色 ✅)
- [ ] 无代码冲突

### 前端 PR
- [ ] 标题正确: "fix: handle undefined values..."
- [ ] 基础分支: `main`
- [ ] 头部分支: `fix-onboarding`
- [ ] 改动 8 个文件
- [ ] CI/CD 检查通过 (绿色 ✅)
- [ ] 无代码冲突
- [ ] 已链接后端 PR

### 主仓库 PR
- [ ] 标题正确: "chore: update submodule references..."
- [ ] 基础分支: `main`
- [ ] 头部分支: `fix-onboarding`
- [ ] 改动 5 个文件
- [ ] 子模块指针已更新
- [ ] 已链接后端和前端 PR

---

## 🚀 快速链接

直接点击即可开始创建 PR:

| PR | 创建链接 |
|-----|---------|
| Backend | https://github.com/Dispatch-AI-com/backend/compare/main...fix-onboarding |
| Frontend | https://github.com/Dispatch-AI-com/frontend/compare/main...fix-onboarding |
| Main | https://github.com/Dispatch-AI-com/dispatchai-platform/compare/main...fix-onboarding |

---

## ❓ FAQ

**Q: 可以只创建一个 PR 吗?**
A: 不可以。每个仓库都有独立的 GitHub 工作流，必须为每个仓库创建单独的 PR。

**Q: PR 的顺序重要吗?**
A: 可以同时创建，但建议顺序: Backend → Frontend → Main。

**Q: 如何知道 PR 已创建成功?**
A: 创建后会自动重定向到 PR 详情页，链接中会有 PR 号 (例如: `/pull/99`)。

**Q: 为什么主仓库 PR 要等其他 PR 创建后?**
A: 因为主仓库 PR 的描述中需要包含其他两个 PR 的链接。

**Q: 所有改动都在分支中了吗?**
A: 是的，所有改动已提交并推送到各子模块和主仓库的 `fix-onboarding` 分支。

---

## 📞 需要帮助?

1. 查看 `PR_GUIDE.md` - 详细的 PR 指南
2. 查看 `ONBOARDING_CHANGES_SUMMARY.md` - 完整的改动说明
3. 查看 `create-prs.sh` - 自动化脚本 (需要 GitHub CLI)

---

**✅ 准备就绪！现在就开始创建您的 PR 吧！**

