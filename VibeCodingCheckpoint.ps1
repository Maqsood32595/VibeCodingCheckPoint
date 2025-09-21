# VibeCodingCheckpoint - Single Checkpoint System
# Usage: . .\VibeCodingCheckpoint.ps1 to load the functions

# Create a single checkpoint
function makecheckpoint {
    if (-not (Test-Path ".git")) {
        Write-Error "Error: This is not a Git repository!"
        return
    }
    
    # Create timestamp
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    # Remove any existing checkpoint first
    git tag -d "checkpointcreated" 2>$null
    
    # Create the checkpoint
    git add . 2>$null
    git commit -m "checkpointcreated-$timestamp" --no-verify 2>$null
    
    if ($LASTEXITCODE -eq 0) {
        # Tag with fixed name "checkpointcreated"
        git tag -f "checkpointcreated" 2>$null
        # Reset back
        git reset --hard HEAD~1 2>$null
        Write-Host "Checkpoint created: $timestamp" -ForegroundColor Green
        
        # Store timestamp in git config
        git config vibecheckpoint.timestamp "$timestamp"
    } else {
        Write-Error "Checkpoint failed! Please check if there are changes to save."
    }
}

# Reset to checkpoint
function resetcheckpoint {
    if (-not (Test-Path ".git")) {
        Write-Error "Error: This is not a Git repository!"
        return
    }
    
    # Check if checkpoint exists
    git rev-parse "checkpointcreated" 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Error "No checkpoint found!"
        return
    }
    
    # Get timestamp from config
    $timestamp = git config --get vibecheckpoint.timestamp
    if (-not $timestamp) {
        $timestamp = "unknown time"
    }
    
    # Confirm reset
    $confirm = Read-Host "This will reset all changes to checkpoint from $timestamp. Continue? (y/N)"
    if ($confirm -notin @('y', 'Y')) {
        Write-Host "Reset cancelled." -ForegroundColor Yellow
        return
    }
    
    # Reset to checkpoint
    git reset --hard "checkpointcreated" 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Reset to checkpoint: $timestamp" -ForegroundColor Green
    } else {
        Write-Error "Reset failed!"
    }
}

# Check if checkpoint exists
function checkcheckpoint {
    if (-not (Test-Path ".git")) {
        Write-Error "Error: This is not a Git repository!"
        return
    }
    
    # Check if tag exists
    git rev-parse "checkpointcreated" 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "No checkpoint exists." -ForegroundColor Yellow
        return
    }
    
    # Get timestamp from config
    $timestamp = git config --get vibecheckpoint.timestamp
    if (-not $timestamp) {
        $timestamp = "unknown time"
    }
    
    Write-Host "Checkpoint exists: $timestamp" -ForegroundColor Green
    Write-Host "Tag: checkpointcreated" -ForegroundColor Cyan
}

# Delete current checkpoint
function deletecheckpoint {
    if (-not (Test-Path ".git")) {
        Write-Error "Error: This is not a Git repository!"
        return
    }
    
    # Delete the tag
    git tag -d "checkpointcreated" 2>$null
    
    # Remove config
    git config --unset vibecheckpoint.timestamp 2>$null
    
    Write-Host "Checkpoint deleted" -ForegroundColor Green
}

# Help function
function checkpointhelp {
    Write-Host "VibeCodingCheckpoint Commands:" -ForegroundColor Green
    Write-Host "  makecheckpoint    - Create a single checkpoint with timestamp"
    Write-Host "  resetcheckpoint   - Reset to the checkpoint"
    Write-Host "  checkcheckpoint   - Check if checkpoint exists and show timestamp"
    Write-Host "  deletecheckpoint  - Delete the current checkpoint"
    Write-Host ""
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "  . .\VibeCodingCheckpoint.ps1 to load functions"
    Write-Host "  Then run commands in any Git repository directory"
    Write-Host ""
    Write-Host "Note: Only one checkpoint named 'checkpointcreated' is maintained"
}
