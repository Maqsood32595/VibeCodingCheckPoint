#!/bin/bash
# VibeCodingCheckpoint - Single Checkpoint System for Linux/Mac
# Usage: source ./vibecheckpoint.sh to load the functions

# Create a single checkpoint
makecheckpoint() {
    if [ ! -d ".git" ]; then
        echo "Error: This is not a Git repository!" >&2
        return 1
    fi
    
    # Create timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    
    # Remove any existing checkpoint first
    git tag -d "checkpointcreated" 2>/dev/null
    
    # Create the checkpoint
    git add . 2>/dev/null
    git commit -m "checkpointcreated-$timestamp" --no-verify 2>/dev/null
    
    if [ $? -eq 0 ]; then
        # Tag with fixed name "checkpointcreated"
        git tag -f "checkpointcreated" 2>/dev/null
        # Reset back (CRITICAL FIX: --soft instead of --hard)
        git reset --soft HEAD~1 2>/dev/null
        echo -e "\033[32mCheckpoint created: $timestamp\033[0m"
        
        # Store timestamp in git config
        git config vibecheckpoint.timestamp "$timestamp"
    else
        echo "Error: Checkpoint failed! Please check if there are changes to save." >&2
    fi
}

# Reset to checkpoint
resetcheckpoint() {
    if [ ! -d ".git" ]; then
        echo "Error: This is not a Git repository!" >&2
        return 1
    fi
    
    # Check if checkpoint exists
    git rev-parse "checkpointcreated" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "Error: No checkpoint found!" >&2
        return 1
    fi
    
    # Get timestamp from config
    timestamp=$(git config --get vibecheckpoint.timestamp)
    if [ -z "$timestamp" ]; then
        timestamp="unknown time"
    fi
    
    # Confirm reset
    echo -n "This will reset all changes to checkpoint from $timestamp. Continue? (y/N): "
    read -r confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "\033[33mReset cancelled.\033[0m"
        return
    fi
    
    # Reset to checkpoint
    git reset --hard "checkpointcreated" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "\033[32mReset to checkpoint: $timestamp\033[0m"
    else
        echo "Error: Reset failed!" >&2
    fi
}

# Check if checkpoint exists
checkcheckpoint() {
    if [ ! -d ".git" ]; then
        echo "Error: This is not a Git repository!" >&2
        return 1
    fi
    
    # Check if tag exists
    git rev-parse "checkpointcreated" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "\033[33mNo checkpoint exists.\033[0m"
        return
    fi
    
    # Get timestamp from config
    timestamp=$(git config --get vibecheckpoint.timestamp)
    if [ -z "$timestamp" ]; then
        timestamp="unknown time"
    fi
    
    echo -e "\033[32mCheckpoint exists: $timestamp\033[0m"
    echo -e "\033[36mTag: checkpointcreated\033[0m"
}

# Delete current checkpoint
deletecheckpoint() {
    if [ ! -d ".git" ]; then
        echo "Error: This is not a Git repository!" >&2
        return 1
    fi
    
    # Delete the tag
    git tag -d "checkpointcreated" 2>/dev/null
    
    # Remove config
    git config --unset vibecheckpoint.timestamp 2>/dev/null
    
    echo -e "\033[32mCheckpoint deleted\033[0m"
}

# Help function
checkpointhelp() {
    echo -e "\033[32mVibeCodingCheckpoint Commands:\033[0m"
    echo "  makecheckpoint    - Create a single checkpoint with timestamp"
    echo "  resetcheckpoint   - Reset to the checkpoint"
    echo "  checkcheckpoint   - Check if checkpoint exists and show timestamp"
    echo "  deletecheckpoint  - Delete the current checkpoint"
    echo ""
    echo -e "\033[33mUsage:\033[0m"
    echo "  source ./vibecheckpoint.sh to load functions"
    echo "  Then run commands in any Git repository directory"
    echo ""
    echo "Note: Only one checkpoint named 'checkpointcreated' is maintained"
}
