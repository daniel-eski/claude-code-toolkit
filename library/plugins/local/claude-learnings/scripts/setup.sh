#!/bin/bash
# Claude Learnings Plugin v2 - Setup Script
# Creates required directories for checkpoints and learnings

set -e

echo "Setting up Claude Learnings Plugin v2..."

# Create directories
mkdir -p ~/.claude/learnings/checkpoints

# Note: v2 no longer uses queue.json
# Learnings are saved as markdown files via /save-learnings

echo ""
echo "Setup complete! Directory structure:"
ls -la ~/.claude/learnings/

echo ""
echo "Next steps:"
echo "  1. Restart Claude Code or run /clear"
echo "  2. Work on your task, then run /reflect"
echo "  3. Use /save-learnings to persist reflections"
