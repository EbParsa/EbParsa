#!/usr/bin/env bash
set -e

echo "=========================================================="
echo "  Deploying GitHub Profile Repository: EbParsa/EbParsa"
echo "=========================================================="

REPO_NAME="EbParsa/EbParsa"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$CURRENT_DIR"

# 1. Initialize git if not already present
if [ ! -d ".git" ]; then
  echo "[-] Initializing git repository..."
  git init -b main
else
  echo "[✓] Git repository already initialized."
fi

# Configure local git user if unset
if [ -z "$(git config user.name)" ]; then
  git config user.name "Parsa Ebrahimi"
fi
if [ -z "$(git config user.email)" ]; then
  git config user.email "ebparsa1388@gmail.com"
fi

# 2. Stage and commit files
echo "[-] Staging files..."
git add .
if git diff --cached --quiet; then
  echo "[✓] No changes to commit."
else
  git commit -m "feat: design modern GitHub profile README with banner and snake workflow"
  echo "[✓] Changes committed to main."
fi

# 3. Check GitHub CLI authentication
echo "[-] Checking gh authentication..."
if ! gh auth status >/dev/null 2>&1; then
  echo "[!] GitHub CLI is not authenticated. Please run 'gh auth login' first."
  exit 1
fi

# 4. Check if remote repo exists or create it
echo "[-] Checking remote repository $REPO_NAME on GitHub..."
if gh repo view "$REPO_NAME" >/dev/null 2>&1; then
  echo "[✓] Repository $REPO_NAME exists on GitHub."
  if ! git remote | grep -q "origin"; then
    git remote add origin "https://github.com/$REPO_NAME.git"
  fi
  echo "[-] Pushing to origin main..."
  git push -u origin main
else
  echo "[-] Creating new public repository $REPO_NAME via GitHub CLI..."
  gh repo create "$REPO_NAME" --public --source=. --remote=origin --push
  echo "[✓] Successfully created and pushed $REPO_NAME!"
fi

echo ""
echo "=========================================================="
echo "  ✨ Deployment Complete!"
echo "  Check out your new profile at: https://github.com/EbParsa"
echo "=========================================================="
