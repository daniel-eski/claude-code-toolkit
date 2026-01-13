#!/bin/bash
# Claude Learnings Plugin - Setup Script
# Creates required data directories and initial queue file

set -e

echo "Setting up Claude Learnings Plugin..."

# Create learnings directory
mkdir -p ~/.claude/learnings/checkpoints

# Create initial queue file if it doesn't exist
if [ ! -f ~/.claude/learnings/queue.json ]; then
    echo '{"entries":[]}' > ~/.claude/learnings/queue.json
    echo "Created ~/.claude/learnings/queue.json"
else
    echo "Queue file already exists, skipping..."
fi

# Verify setup
echo ""
echo "Setup complete! Directory structure:"
ls -la ~/.claude/learnings/

echo ""
echo "Next steps:"
echo "  1. Restart Claude Code or run /clear"
echo "  2. Try: /log Test entry to verify installation"
