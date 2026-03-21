#!/bin/bash
# OpenClaw Backup Script
# Backup workspace configs to GitHub (excluding sensitive data)

BACKUP_DATE=$(date +%Y-%m-%d)
BACKUP_DIR=~/.openclaw/backup-temp
REPO_DIR=~/.openclaw/workspace/bear-app-studio/openclaw-backup
CONFIG_FILE=~/.openclaw/openclaw.json

echo "=== OpenClaw Backup Started: $BACKUP_DATE ==="

# Create temp backup directory
mkdir -p "$BACKUP_DIR/openclaw-workspace"
mkdir -p "$BACKUP_DIR/kuromi-workspace"

# Backup Teddy's workspace files
echo "Backing up Teddy's workspace..."
cp ~/.openclaw/workspace/IDENTITY.md "$BACKUP_DIR/openclaw-workspace/" 2>/dev/null
cp ~/.openclaw/workspace/USER.md "$BACKUP_DIR/openclaw-workspace/" 2>/dev/null
cp ~/.openclaw/workspace/AGENTS.md "$BACKUP_DIR/openclaw-workspace/" 2>/dev/null
cp ~/.openclaw/workspace/MEMORY.md "$BACKUP_DIR/openclaw-workspace/" 2>/dev/null
cp ~/.openclaw/workspace/SOUL.md "$BACKUP_DIR/openclaw-workspace/" 2>/dev/null
cp ~/.openclaw/workspace/TOOLS.md "$BACKUP_DIR/openclaw-workspace/" 2>/dev/null

# Backup Kuromi's workspace files
echo "Backing up Kuromi's workspace..."
cp ~/.openclaw/melody-workspace/IDENTITY.md "$BACKUP_DIR/kuromi-workspace/" 2>/dev/null
cp ~/.openclaw/melody-workspace/USER.md "$BACKUP_DIR/kuromi-workspace/" 2>/dev/null
cp ~/.openclaw/melody-workspace/AGENTS.md "$BACKUP_DIR/kuromi-workspace/" 2>/dev/null
cp ~/.openclaw/melody-workspace/MEMORY.md "$BACKUP_DIR/kuromi-workspace/" 2>/dev/null
cp ~/.openclaw/melody-workspace/SOUL.md "$BACKUP_DIR/kuromi-workspace/" 2>/dev/null
cp ~/.openclaw/melody-workspace/TOOLS.md "$BACKUP_DIR/kuromi-workspace/" 2>/dev/null

# Backup OpenClaw config (redacted)
echo "Backing up OpenClaw config (redacted)..."
if [ -f "$CONFIG_FILE" ]; then
    python3 -c "
import json
import sys

with open('$CONFIG_FILE', 'r') as f:
    config = json.load(f)

# Redact sensitive fields
def redact(obj, path=''):
    if isinstance(obj, dict):
        for key in list(obj.keys()):
            if key in ['apiKey', 'token', 'password', 'secret', 'privateKey']:
                obj[key] = '__REDACTED__'
            else:
                redact(obj[key], f'{path}.{key}')
    elif isinstance(obj, list):
        for item in obj:
            redact(item, path)

redact(config)

# Also redact specific nested fields
if 'gateway' in config and 'auth' in config['gateway']:
    config['gateway']['auth']['token'] = '__REDACTED__'

print(json.dumps(config, indent=2))
" > "$BACKUP_DIR/openclaw-config-redacted.json"
fi

# Copy to repo
echo "Copying to backup repo..."
mkdir -p "$REPO_DIR"
cp -r "$BACKUP_DIR/"* "$REPO_DIR/"

# Add timestamp
echo "$BACKUP_DATE" > "$REPO_DIR/last-backup.txt"

# Git operations
cd "$REPO_DIR"
git add -A
git commit -m "Backup: $BACKUP_DATE" 2>/dev/null

# Try to push (might fail if no remote, that's ok)
git push origin main 2>/dev/null || echo "Note: No remote configured or push failed"

# Cleanup
rm -rf "$BACKUP_DIR"

echo "=== OpenClaw Backup Completed: $BACKUP_DATE ==="
