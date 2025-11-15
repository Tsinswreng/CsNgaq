#!/usr/bin/env bash
# 用法: ./auto-tag.sh /path/to/repo v1.2.3
# TODO 改成只tag洏不push。 多寫一腳本作 批量push
set -euo pipefail

# 參數檢查
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <repo-path> <tag>"
  exit 1
fi

REPO="$1"
TAG="$2"

# 進入倉庫目錄
cd "$REPO"

# 檢查是否為 git 倉庫
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: '$REPO' is not a git repository."
  exit 1
fi

# 取得當前分支名稱
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)

# 檢查是否有未提交的變更（含已追蹤、未追蹤）
if ! git diff --quiet HEAD -- || ! git diff --cached --quiet || [[ -n $(git ls-files --others --exclude-standard) ]]; then
  echo "Detected uncommitted changes, auto-committing..."
  git add -A
  # 使用時間戳當 commit message，可視需求修改
  git commit -m "Auto-commit $(date +%F-%T)"
else
  echo "Working tree clean, skipping commit."
fi

# 打上 tag
git tag "$TAG"

# 推送當前分支與 tag
git push origin "$CURRENT_BRANCH"
git push origin "$TAG"

echo "Done. Tagged '$TAG' and pushed to origin/$CURRENT_BRANCH"
