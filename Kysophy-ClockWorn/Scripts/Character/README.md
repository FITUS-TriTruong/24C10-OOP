# Character System Refactoring

The character system has been refactored into multiple files following the Single Responsibility Principle (SRP) and good Object-Oriented Programming practices.

## File Structure

### Core Files

1. **`character_main.gd`** - Main character controller that orchestrates all components
2. **`character_constants.gd`** - All character-related constants
3. **`character_state.gd`** - Character state enumerations

### Component Files

4. **`character_movement.gd`** - Handles all movement logic, input processing, state management, and ladder system
5. **`character_animation_controller.gd`** - Manages sprite animations and visual feedback
6. **`character_health.gd`** - Handles health, fall damage, and death logic
7. **`character_interaction.gd`** - Manages interactions with objects and environment

## Architecture Overview

```
Character (CharacterBody2D)
├── CharacterMovement (Node)
│   ├── Movement Logic
│   ├── Input Handling
│   ├── State Management
│   └── Ladder System
├── CharacterAnimationController (Node)
│   ├── Sprite Direction
│   ├── Animation States
│   └── Visual Feedback
├── CharacterHealth (Node)
│   ├── Health Management
│   ├── Fall Damage
│   └── Death Handling
└── CharacterInteraction (Node)
	├── Object Detection
	├── Push/Pull System
	└── Environment Interactions
```

## Component Responsibilities

### CharacterMovement
- Input handling for movement and sitting
- Speed calculation and velocity management
- State determination (idle, walking, running, jumping, sitting, etc.)
- Action states (attacking, kicking)
- Push/pull mechanics with cooldown
- **NEW:** Ladder system integration
- Gravity application (disabled on ladders)

### CharacterAnimationController
- Sprite direction management (flip_h)
- Animation state transitions
- Animation playback coordination
- Visual feedback for all actions
- **UPDATED:** Added ATTACKING and KICKING states

### CharacterHealth
- Health management and status tracking
- Fall damage calculation and threshold checking
- Death state handling and respawn logic
- Life/death status tracking

### CharacterInteraction
- Object interaction detection (trees, leaf items)
- Dialogue system integration (commented out)
- Stamina-based action validation
- Environment interaction callbacks
- Push/pull area detection and collision handling

## New Features Added

### Ladder System
- Characters can climb ladders without gravity affecting them
- Integrated into movement controller
- Proper entry/exit detection

### Enhanced State System
- Added ATTACKING and KICKING states
- Better state transition handling
- Action locking during special animations

### Improved Push System
- Push cooldown management
- Collision layer switching
- Height-based push validation

## Benefits of This Structure

1. **Separation of Concerns**: Each file has a single, well-defined responsibility
2. **Maintainability**: Changes to one system don't affect others
3. **Testability**: Each component can be tested independently
4. **Reusability**: Components can be reused in other character types
5. **Scalability**: Easy to add new features without modifying existing code
6. **Debugging**: Easier to isolate and fix issues in specific systems

## Usage

### Migration from Original character.gd

1. **Replace** your current character.gd with `character_main.gd`
2. **Update** your scene script reference to point to `character_main.gd`
3. **Keep** all component files in the same Character directory
4. **No changes needed** to your existing scene node structure or signal connections

### Scene Setup

The main character file will automatically create and initialize all components. Ensure your scene has:

- AnimatedSprite2D node as `$AnimatedSprite2D`
- StaminaSystem node as `$StaminaSystem`
- ProgressBar in CanvasLayer as `$CanvasLayer/ProgressBar`

### Signal Connections

Connect these signals in your scene to the corresponding methods in `character_main.gd`:

- Detection areas → `_on_detection_area_body_entered/exited`
- Leaf detection → `_on_leaf_detection_body_entered/exited`
- Push areas → `_on_area_2d_body_entered/exited`
- **NEW:** Ladder areas → `_on_ladder_body_entered/exited`

## Migration Notes

- All original functionality is preserved
- All public methods and signals remain the same
- Scene connections work without modification
- Constants are now accessed via `CharacterConstants.CONSTANT_NAME`
- States are now accessed via `CharacterState.State.STATE_NAME`
- **NEW:** Added `is_on_ladder()` method to public API

## Future Enhancements

This modular structure makes it easy to add:

- **Combat system** (new component for attacks/kicks)
- **Inventory management** (new component)
- **Skill/level system** (new component)
- **Status effects** (extension to health component)
- **Different movement modes** (extension to movement component)
- **Advanced ladder mechanics** (extension to movement component)
- **Interactive dialogue system** (extension to interaction component)

## Performance Considerations

- Components are lightweight Node objects
- Initialization happens once in `_ready()`
- No performance impact compared to monolithic approach
- Better memory organization and cache efficiency