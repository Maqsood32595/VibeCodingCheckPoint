# VibeCodingCheckpoint

⚠️ **Use with caution** - This tool modifies your Git repository. Always ensure your important work is committed to your main branch before experimenting.

A simple Git-based checkpoint system for experimental coding. Create a safety net before trying risky changes, then easily rollback if things go wrong.

## What It Does

VibeCodingCheckpoint lets you quickly save your current progress and experiment freely, knowing you can always return to your saved state with a single command.

**Basic workflow:**
1. `makecheckpoint` - Save current state
2. Experiment with your code
3. `resetcheckpoint` - Go back if you mess up, or
4. `deletecheckpoint` - Remove checkpoint if you like your changes

## Quick Start

### Load the functions:
```powershell
# Windows PowerShell
. .\VibeCodingCheckpoint.ps1

# Then in any Git repository:
makecheckpoint
# ... code and experiment ...
resetcheckpoint  # if needed
```

## Available Commands

| Command | Description |
|---------|-------------|
| `makecheckpoint` | Save current state as a checkpoint |
| `resetcheckpoint` | Return to saved checkpoint (asks for confirmation) |
| `checkcheckpoint` | See if checkpoint exists and when it was created |
| `deletecheckpoint` | Remove current checkpoint |
| `checkpointhelp` | Show all available commands |

## How It Works

The tool uses Git tags to mark specific points in your code history:

1. **makecheckpoint**: Stages your changes, creates a temporary commit, tags it as "checkpointcreated", then removes the commit from history while keeping your work intact
2. **resetcheckpoint**: Resets your code back to the tagged checkpoint state

## Installation Options

### Temporary (current session only):
```powershell
# Windows PowerShell
. .\VibeCodingCheckpoint.ps1

# Linux/Mac
source ./vibecheckpoint.sh
```

### Permanent (load automatically in any folder):

**Windows PowerShell:** Add to your PowerShell profile ($PROFILE):
```powershell
# Add this line to your $PROFILE file:
. "C:\path\to\VibeCodingCheckpoint.ps1"
```

**Linux/Mac (bash/zsh):** Add to your shell profile (~/.bashrc or ~/.zshrc):
```bash
# Add this line to your shell profile:
source /path/to/vibecheckpoint.sh
```

### To use globally in any folder:
1. Add the script directory to your system PATH
2. Or place the scripts in a directory already in your PATH  
3. Then you can load from anywhere with:
```powershell
# Windows
. VibeCodingCheckpoint.ps1

# Linux/Mac  
source vibecheckpoint.sh
```

## Use Cases

**Good for:**
- Trying experimental refactoring
- Testing different approaches to a problem  
- Learning new techniques without fear
- Quick prototyping sessions
- Making risky changes with an easy undo

**Not ideal for:**
- Long-term development branches
- Team collaboration
- Managing multiple features simultaneously
- Production code management

## Requirements

- Git installed and accessible from PowerShell
- Working in a Git repository (`git init` if needed)
- PowerShell execution policy allows script loading

## Important Notes

- **One checkpoint at a time**: Each new checkpoint replaces the previous one
- **Local only**: Checkpoints don't sync with remote repositories  
- **Confirmation required**: `resetcheckpoint` asks before discarding changes
- **Timestamp tracking**: Shows when checkpoint was created

## Safety Features

- Validates Git repository before running
- Asks for confirmation before destructive operations
- Shows timestamp of checkpoint before resetting
- Handles common error conditions gracefully

## Example Session

```powershell
PS> makecheckpoint
Checkpoint created: 2024-03-15 14:30:22

# Try some experimental changes...
# Oops, broke something!

PS> resetcheckpoint
This will reset all changes to checkpoint from 2024-03-15 14:30:22. Continue? (y/N): y
Reset to checkpoint: 2024-03-15 14:30:22

# Back to working state!
```

## Troubleshooting

**"Not a Git repository" error:**
- Run `git init` in your project folder first

**"No checkpoint found" error:**  
- Create a checkpoint first with `makecheckpoint`

**Commands not recognized:**
- Make sure you loaded the script: `. .\VibeCodingCheckpoint.ps1`

---

A practical tool for safer experimental coding. Not magic, just useful.
