# Onboarding Fixes - PR Guide

本指南说明如何为 onboarding 改动提交 PR 到各个仓库。

## 子模块 PR 信息

### 1. Backend PR (apps/backend)
- **分支:** `fix-onboarding`
- **最新提交:** `6442ea6` - Fix onboarding: improve address parsing, skip button handling, and Google OAuth error handling
- **仓库:** https://github.com/Dispatch-AI-com/backend
- **PR 链接:** https://github.com/Dispatch-AI-com/backend/pull/new/fix-onboarding

**改动内容:**
- 改进地址解析和正则表达式支持
- 修复跳过按钮的字段验证
- 增强 Google OAuth 回调错误处理
- Twilio 和 Stripe 服务的开发模式支持

**文件:**
- `src/modules/onboarding/onboarding.service.ts` - 核心业务逻辑
- `src/modules/auth/strategies/google.strategy.ts` - Google OAuth 策略
- `src/modules/auth/auth.controller.ts` - 认证控制器
- `src/lib/twilio/twilio.module.ts` - Twilio 模块
- `src/modules/stripe/stripe.service.ts` - Stripe 服务

### 2. Frontend PR (apps/frontend)
- **分支:** `fix-onboarding`
- **最新提交:** `41e67a4` - Fix onboarding: handle undefined values in address autocomplete and user input
- **仓库:** https://github.com/Dispatch-AI-com/frontend
- **PR 链接:** https://github.com/Dispatch-AI-com/frontend/pull/new/fix-onboarding

**改动内容:**
- 处理地址自动完成中的 undefined 值
- 修复用户输入区域的错误处理
- 改进 OAuth 回调处理
- API base URL 配置改进

**文件:**
- `src/components/ui/AddressAutocomplete.tsx` - 地址自动完成组件
- `src/app/onboarding/components/UserInputArea.tsx` - 用户输入区域
- `src/app/auth/callback/AuthCallbackContent.tsx` - OAuth 回调处理
- `src/lib/axiosBaseQuery.ts` - Axios 配置
- `src/components/GoogleOAuthButton.tsx` - Google 登录按钮

### 3. Main Repo PR (dispatchai-platform)
- **分支:** `fix-onboarding`
- **仓库:** https://github.com/Dispatch-AI-com/dispatchai-platform
- **PR 链接:** https://github.com/Dispatch-AI-com/dispatchai-platform/pull/new/fix-onboarding

**改动内容:**
- 更新 Docker Compose 命令
- 移除环境变量占位符
- 更新子模块指针

**文件:**
- `package.json` - Docker Compose 脚本
- `.env.shared` - 环境配置

## PR 提交步骤

### 方式 1：使用 GitHub Web 界面（推荐）

1. **后端 PR:**
   - 访问: https://github.com/Dispatch-AI-com/backend/pull/new/fix-onboarding
   - 标题: `fix: improve onboarding address parsing and error handling`
   - 描述: 复制下方的 PR 描述

2. **前端 PR:**
   - 访问: https://github.com/Dispatch-AI-com/frontend/pull/new/fix-onboarding
   - 标题: `fix: handle undefined values in onboarding components`
   - 描述: 复制下方的 PR 描述

3. **主仓库 PR:**
   - 访问: https://github.com/Dispatch-AI-com/dispatchai-platform/pull/new/fix-onboarding
   - 标题: `chore: update submodule references for onboarding fixes`
   - 描述: 参考下方的关联 PR 描述

### PR 描述模板

#### 后端 PR 描述
```
## Onboarding Module Fixes

### 问题
- 地址解析对多种格式支持不足
- 跳过按钮处理时出现字段验证错误
- Google OAuth 错误处理不完整
- 缺少开发模式下的 Twilio/Stripe 支持

### 解决方案
- 扩展地址正则表达式支持多种 Australian 地址格式
- 允许空字段名用于演示/跳过步骤
- 改进 Google OAuth 数据验证
- 添加 Twilio 和 Stripe 的 mock 实现用于开发

### 改动文件
- `src/modules/onboarding/onboarding.service.ts`
- `src/modules/auth/strategies/google.strategy.ts`
- `src/modules/auth/auth.controller.ts`
- `src/lib/twilio/twilio.module.ts`
- `src/modules/stripe/stripe.service.ts`

### 测试
- [ ] 地址解析功能
- [ ] 跳过按钮功能
- [ ] Google OAuth 流程
- [ ] 开发模式启动
```

#### 前端 PR 描述
```
## Onboarding UI Fixes

### 问题
- 地址自动完成组件中的 undefined 值导致错误
- 用户输入区域未正确处理 undefined
- OAuth 回调处理缺少数据验证
- API base URL 配置不一致

### 解决方案
- 添加 undefined 值检查到 Autocomplete 组件
- 改进用户输入区域的错误处理
- 增强 OAuth 回调数据验证
- 统一 API base URL 配置

### 改动文件
- `src/components/ui/AddressAutocomplete.tsx`
- `src/app/onboarding/components/UserInputArea.tsx`
- `src/app/auth/callback/AuthCallbackContent.tsx`
- `src/lib/axiosBaseQuery.ts`
- `src/components/GoogleOAuthButton.tsx`

### 相关 PR
- Backend: Dispatch-AI-com/backend#(PR号)
- Main: Dispatch-AI-com/dispatchai-platform#(PR号)
```

#### 主仓库 PR 描述
```
## Update Onboarding Module References

### 相关 PR
- Backend: https://github.com/Dispatch-AI-com/backend/pull/XX
- Frontend: https://github.com/Dispatch-AI-com/frontend/pull/XX

### 改动
- 更新 Docker Compose 命令结构
- 移除环境变量占位符
- 更新子模块指针到 fix-onboarding 分支

### 子模块提交
- backend: `6442ea6` (fix-onboarding)
- frontend: `41e67a4` (fix-onboarding)
```

## 命令行方式提交 PR（可选）

如果你有 GitHub CLI (`gh`)，可以使用：

```bash
# 后端
cd apps/backend
gh pr create \
  --title "fix: improve onboarding address parsing and error handling" \
  --body "描述内容" \
  --head fix-onboarding \
  --base main

# 前端
cd ../frontend
gh pr create \
  --title "fix: handle undefined values in onboarding components" \
  --body "描述内容" \
  --head fix-onboarding \
  --base main

# 主仓库
cd ../..
gh pr create \
  --title "chore: update submodule references for onboarding fixes" \
  --body "描述内容" \
  --head fix-onboarding \
  --base main
```

## 合并顺序建议

1. 先合并**后端 PR**
2. 再合并**前端 PR**
3. 最后合并**主仓库 PR**（更新子模块指针）

这样确保依赖关系正确。

## PR 检查清单

- [ ] 代码通过 linter
- [ ] 单元测试通过
- [ ] 没有 console.error 或 TODO
- [ ] 代码注释清晰
- [ ] 环境变量已移除（仅占位符）
- [ ] 提交消息清晰明确
- [ ] PR 描述完整

## 问题排查

如果 PR 检查失败：

1. **类型检查失败:** `pnpm type-check` (frontend) / `npm run type-check` (backend)
2. **Linter 错误:** `pnpm lint --fix` (frontend) / `npm run lint -- --fix` (backend)
3. **构建失败:** `pnpm build` (frontend) / `npm run build` (backend)

