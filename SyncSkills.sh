#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_REPO_DIR="$SCRIPT_DIR/.Tsinswreng/Skills"
AGENTS_SKILLS_DIR="$SCRIPT_DIR/.agents/skills"
GITHUB_BASE_URL="https://github.com/Tsinswreng"

# $1: skill short name (no prefix), e.g. "csharp-code-doc"
sync_one_skill() {
    local skill_name="$1"
    local repo_dir="$SKILLS_REPO_DIR/tsinswreng-$skill_name"
    local repo_url="$GITHUB_BASE_URL/skill-$skill_name.git"

    if [ -d "$repo_dir" ]; then
        echo "[pull] tsinswreng-$skill_name"
        git -C "$repo_dir" pull
    else
        echo "[clone] tsinswreng-$skill_name <- $repo_url"
        git clone "$repo_url" "$repo_dir"
    fi

    # Copy skill content to .agents/skills/
    local src="$repo_dir/tsinswreng-$skill_name"
    local dst="$AGENTS_SKILLS_DIR/tsinswreng-$skill_name"

    if [ -d "$src" ]; then
        mkdir -p "$AGENTS_SKILLS_DIR"
        echo "[sync] $src -> $dst"
        rm -rf "$dst"
        cp -r "$src" "$dst"
    else
        echo "[warn] skill inner directory not found: $src, skipping copy"
    fi
}

mkdir -p "$SKILLS_REPO_DIR"

if [ $# -ge 1 ]; then
    # Single skill mode
    sync_one_skill "$1"
else
    # All skills mode: pull and sync every repo under .Tsinswreng/Skills/
    echo "[sync-all] pulling and syncing all skills in $SKILLS_REPO_DIR"

    found_any=false
    for repo_dir in "$SKILLS_REPO_DIR"/*/; do
        [ -d "$repo_dir" ] || continue

        repo_name="$(basename "$repo_dir")"
        # Skip if not a tsinswreng- prefixed dir or no .git
        [ -d "$repo_dir/.git" ] || continue
        [[ "$repo_name" == tsinswreng-* ]] || continue

        echo "[pull] $repo_name"
        git -C "$repo_dir" pull || echo "[warn] pull failed for $repo_name, continuing..."

        src="$repo_dir/$repo_name"
        dst="$AGENTS_SKILLS_DIR/$repo_name"

        if [ -d "$src" ]; then
            mkdir -p "$AGENTS_SKILLS_DIR"
            echo "[sync] $src -> $dst"
            rm -rf "$dst"
            cp -r "$src" "$dst"
        else
            echo "[warn] skill inner directory not found: $src, skipping copy"
        fi

        found_any=true
    done

    if ! $found_any; then
        echo "[warn] no skill repos found in $SKILLS_REPO_DIR"
    fi
fi

echo "[done]"