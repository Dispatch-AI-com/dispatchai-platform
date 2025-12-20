#!/bin/bash

# PR 创建脚本 - 为 onboarding 改动创建关联的 PR

set -e

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Onboarding Fixes PR Creator ===${NC}\n"

# 检查 gh CLI 是否安装
if ! command -v gh &> /dev/null; then
    echo -e "${YELLOW}GitHub CLI (gh) 未安装。${NC}"
    echo "请访问 https://cli.github.com 安装 GitHub CLI"
    echo "或手动访问以下链接创建 PR:"
    echo ""
    echo "后端:   https://github.com/Dispatch-AI-com/backend/pull/new/fix-onboarding"
    echo "前端:   https://github.com/Dispatch-AI-com/frontend/pull/new/fix-onboarding"
    echo "主仓库: https://github.com/Dispatch-AI-com/dispatchai-platform/pull/new/fix-onboarding"
    exit 1
fi

# 获取当前 commit hash
BACKEND_COMMIT=$(cd apps/backend && git rev-parse --short HEAD && cd ../..)
FRONTEND_COMMIT=$(cd apps/frontend && git rev-parse --short HEAD && cd ../..)

echo -e "${GREEN}✓ Backend commit: $BACKEND_COMMIT${NC}"
echo -e "${GREEN}✓ Frontend commit: $FRONTEND_COMMIT${NC}\n"

# 创建后端 PR
echo -e "${BLUE}创建后端 PR...${NC}"
cd apps/backend
gh pr create \
  --title "fix: improve onboarding address parsing and error handling" \
  --body "## Onboarding Module Fixes

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
- src/modules/onboarding/onboarding.service.ts
- src/modules/auth/strategies/google.strategy.ts
- src/modules/auth/auth.controller.ts
- src/lib/twilio/twilio.module.ts
- src/modules/stripe/stripe.service.ts

### 测试
- [ ] 地址解析功能
- [ ] 跳过按钮功能
- [ ] Google OAuth 流程
- [ ] 开发模式启动" \
  --head fix-onboarding \
  --base main || echo -e "${YELLOW}后端 PR 已存在或创建失败${NC}"
cd ../..

# 创建前端 PR
echo -e "${BLUE}创建前端 PR...${NC}"
cd apps/frontend
gh pr create \
  --title "fix: handle undefined values in onboarding components" \
  --body "## Onboarding UI Fixes

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
- src/components/ui/AddressAutocomplete.tsx
- src/app/onboarding/components/UserInputArea.tsx
- src/app/auth/callback/AuthCallbackContent.tsx
- src/lib/axiosBaseQuery.ts
- src/components/GoogleOAuthButton.tsx

### 关联 PR
- Backend: (完成后在此更新 PR 链接)
- Main: (完成后在此更新 PR 链接)" \
  --head fix-onboarding \
  --base main || echo -e "${YELLOW}前端 PR 已存在或创建失败${NC}"
cd ../..

# 创建主仓库 PR
echo -e "${BLUE}创建主仓库 PR...${NC}"
gh pr create \
  --title "chore: update submodule references for onboarding fixes" \
  --body "## Update Onboarding Module References

### 相关 PR
- Backend: (更新为实际 PR 链接)
- Frontend: (更新为实际 PR 链接)

### 改动
- 更新 Docker Compose 命令结构
- 移除环境变量占位符
- 更新子模块指针到 fix-onboarding 分支

### 子模块提交
- backend: $BACKEND_COMMIT (fix-onboarding)
- frontend: $FRONTEND_COMMIT (fix-onboarding)" \
  --head fix-onboarding \
  --base main || echo -e "${YELLOW}主仓库 PR 已存在或创建失败${NC}"

echo -e "\n${GREEN}✓ PR 创建完成！${NC}"
echo -e "${BLUE}请访问以下链接检查 PR 状态:${NC}"
echo "后端:   https://github.com/Dispatch-AI-com/backend/pulls"
echo "前端:   https://github.com/Dispatch-AI-com/frontend/pulls"
echo "主仓库: https://github.com/Dispatch-AI-com/dispatchai-platform/pulls"

