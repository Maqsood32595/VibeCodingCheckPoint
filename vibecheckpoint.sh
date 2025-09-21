#!/bin/bash

# VibeCodingCheckpoint - Single Checkpoint System for Bash
# Usage: source vibecheckpoint.sh to load the functions

# Create a single checkpoint
makecheckpoint() {
    if [ ! -d ".git" ]; then
        echo "Error: This is not a Git repository!"
        return 1
    fi
    
    # Create timestamp
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    
    # Remove any existing checkpoint first
    git tag -d "checkpointcreated" 2>/dev/null
    
    # Create the checkpoint
    git add . >/dev/null 2>&1
    git commit -m "checkpointcreated-$timestamp" --no-verify >/dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        # Tag with fixed name "checkpointcreated"
        git tag -f "checkpointcreated" >/dev/null 2>&1
        # Reset back
        git reset --hard HEAD~1 >/dev/null 2>&1
        echo "✅ Checkpoint created: $timestamp"
        
        # Store timestamp in git config
        git config vibecheckpoint.timestamp "$timestamp"
    else
        echo "❌ Checkpoint failed! Please check if there are changes to save."
        return 1
    fi
}

# Reset to checkpoint
resetcheckpoint() {
    if [ ! -d ".git" ]; then
        echo "Error: This is not a Git repository!"
        return 1
    fi
    
    # Check if checkpoint exists
    git rev-parse "checkpointcreated" >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "❌ No checkpoint found!"
        return 1
    fi
    
    # Get timestamp from config
    local timestamp=$(git config --get vibecheckpoint.timestamp)
    if [ -z "$timestamp" ]; then
        timestamp="unknown time"
    fi
    
    # Confirm reset
    read -p "⚠️  This will reset all changes to checkpoint from $timestamp. Continue? (y/N): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "Reset cancelled."
        return 0
    fi
    
    # Reset to checkpoint
    git reset --hard "checkpointcreated" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✅ Reset to checkpoint: $timestamp"
    else
        echo "❌ Reset failed!"
        return 1
    fi
}

# Check if checkpoint exists
checkcheckpoint() {
    if [ ! -d ".git" ]; then
        echo "Error: This is not a Git repository!"
        return 1
    fi
    
    # Check if tag exists
    git rev-parse "checkpointcreated" >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "❌ No checkpoint exists."
        return 1
    fi
    
    # Get timestamp from config
    local timestamp=$(git config --get vibecheckpoint.timestamp)
    if [ -z "$timestamp" ]; then
        timestamp="unknown time"
    fi
    
    echo "✅ Checkpoint exists: $timestamp"
    echo "📛 Tag: checkpointcreated"
}

# Delete current checkpoint
deletecheckpoint() {
    if [ ! -d ".git" ]; then
        echo "Error: This is not a Git repository!"
        return 1
    fi
    
    # Delete the tag
    git tag -d "checkpointcreated" >/dev/null 2>&1
    
    # Remove config
    git config --unset vibecheckpoint.timestamp >/dev/null 2>&1
    
    echo "✅ Checkpoint deleted"
}

# Help function
checkpointhelp() {
    echo "🎯 VibeCodingCheckpoint Commands:"
    echo "  makecheckpoint    - Create a single checkpoint with timestamp"
    echo "  resetcheckpoint   - Reset to the checkpoint (with confirmation)"
    echo "  checkcheckpoint   - Check if checkpoint exists and show timestamp"
    echo "  deletecheckpoint  - Delete the current checkpoint"
    echo ""
    echo "💡 Usage:"
    echo "  source vibecheckpoint.sh to load functions"
    echo "  Then run commands in any Git repository directory"
    echo ""
    echo "🎨 Vibe Coding: Experiment fearlessly with a safety net!"
}

# Show welcome message when sourced
echo "🎉 VibeCodingCheckpoint loaded! Type 'checkpointhelp' for commands."
