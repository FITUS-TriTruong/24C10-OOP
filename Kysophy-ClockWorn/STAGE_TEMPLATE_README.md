# Stage Template System

This project uses a stage template system to create consistent and maintainable stage scripts.

## Overview

The stage template system consists of:
- `StageTemplate.gd` - Base template class with common functionality
- `NewStageTemplate.gd` - Template for creating new stages
- Individual stage scripts that extend the base template

## How to Use

### Creating a New Stage

1. **Copy the template**: Copy `Template/NewStageTemplate.gd` to `Scripts/your_stage_name.gd`

2. **Modify the template**: Update the following in your new stage script:
   ```gdscript
   stage_name = "Your Stage Name"
   next_stage_path = "res://Class/NextStage.tscn"  # or "" if final stage
   previous_stage_path = "res://Class/PreviousStage.tscn"  # or "" if first stage
   ```

3. **Add stage-specific logic**: Implement your stage-specific functionality:
   - `stage_ready()` - Called when stage initializes
   - `stage_process(delta)` - Called every frame
   - Override transition events if needed

4. **Attach to scene**: In your stage scene file (.tscn), attach your new script to the root node

### Stage Template Features

#### Automatic Stage Transitions
- Handles transitions between stages automatically
- Looks for `next_level` and `previous_level` Area2D nodes
- Connects signals automatically

#### Configurable Properties
- `stage_name` - Display name of the stage
- `next_stage_path` - Path to next stage scene
- `previous_stage_path` - Path to previous stage scene

#### Virtual Functions
Override these in your stage scripts:
- `stage_ready()` - Stage initialization
- `stage_process(delta)` - Per-frame updates
- `on_next_level_entered(body)` - Player enters next level area
- `on_next_level_exited(body)` - Player exits next level area
- `on_previous_level_entered(body)` - Player enters previous level area
- `on_previous_level_exited(body)` - Player exits previous level area

#### Utility Functions
- `get_stage_info()` - Returns stage information dictionary
- `set_stage_paths(next, previous)` - Dynamically set stage paths

## Current Stages

### Stage 1 (`Scripts/stage_1.gd`)
- First stage of the game
- Only has next level transition (to Stage 2)
- Uses `next_level` Area2D for transitions

### Stage 2 (`Scripts/stage_2.gd`)
- Middle stage of the game
- Has both next (to Stage 3) and previous (to Stage 1) transitions
- Uses `Area2D` for next level and `Area2D2` for previous level
- Special setup for multiple areas

### Stage 3 (`Scripts/stage_3.gd`)
- Final stage of the game
- Only has previous level transition (to Stage 2)
- Can include end-game logic

## Scene Setup Requirements

For the template to work properly, your stage scenes should have:

1. **Area2D nodes** for transitions:
   - `next_level` - Area2D for going to next stage
   - `previous_level` - Area2D for going to previous stage
   - Alternative names: `Area2D`, `Area2D2` (handled in Stage 2)

2. **Proper collision shapes** on the Area2D nodes

3. **Script attachment** to the root node of the scene

## Example Usage

```gdscript
extends StageTemplate

func _ready() -> void:
    stage_name = "Boss Battle"
    next_stage_path = "res://Class/Victory.tscn"
    previous_stage_path = "res://Class/Stage_3.tscn"
    super._ready()

func stage_ready() -> void:
    print("Boss battle stage loaded!")
    spawn_boss()

func stage_process(delta: float) -> void:
    if is_boss_defeated():
        can_go_to_next_level = true

func spawn_boss() -> void:
    # Spawn boss logic here
    pass

func is_boss_defeated() -> bool:
    # Check if boss is defeated
    return false
```

## Benefits

- **Consistency**: All stages follow the same pattern
- **Maintainability**: Common functionality in one place
- **Extensibility**: Easy to add new features to all stages
- **Debugging**: Centralized transition handling
- **Scalability**: Easy to add new stages without code duplication
