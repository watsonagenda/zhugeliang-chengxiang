#!/bin/bash
# 诸葛亮框架 - GitHub 推送脚本
# 使用方法：bash push-to-github.sh

REPO_PATH="$(cd "$(dirname "$0")" && pwd)"
REMOTE_URL="https://github.com/watsonagenda/zhugeliang-chengxiang.git"

cd "$REPO_PATH" || exit 1

echo "📦 准备推送到 GitHub..."
echo "仓库：$REMOTE_URL"
echo ""

# 获取当前分支
BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "当前分支：$BRANCH"

# 显示提交记录
echo ""
echo "最近提交："
git log --oneline -3

echo ""
echo "🚀 开始推送..."
echo ""

# 尝试推送
if git push origin "$BRANCH" --force; then
    echo ""
    echo "✅ 推送成功！"
    echo "🌐 查看仓库：https://github.com/watsonagenda/zhugeliang-chengxiang"
else
    echo ""
    echo "❌ 推送失败，请手动执行以下命令："
    echo ""
    echo "  cd $REPO_PATH"
    echo "  git push origin $BRANCH"
    echo ""
    echo "或者使用 GitHub Desktop 推送"
    exit 1
fi
