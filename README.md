# ClockWorn
## Group 11 - Object-Oriented Programming Project
**Members:**
- Trương Minh Trí (24127135)
- Mã Đức Khải (24127407)
- Trần Nhựt Đăng Khoa (24127427)
- Nguyễn Trương Ngọc Thảo (24127543)

---

## 🎮 About the Game

**ClockWorn** is a 2D platformer adventure game built with **Godot Engine 4.5**. Players control a clockwork character navigating through post-apocalyptic environments while managing stamina and uncovering memories through interactive storytelling.

### 🎯 Game Features
- **Multi-Stage Progression**: 4 unique stages with increasing difficulty
- **Stamina Management**: Dynamic stamina system affecting movement and abilities
- **Interactive Dialogue**: Rich dialogue system with choices and consequences
- **Memory Collection**: Discover story fragments through collectible memories
- **Save/Load System**: Persistent progress tracking across play sessions
- **Audio Integration**: Immersive sound effects and ambient music

---

## 🏗️ Project Structure

```
ClockWorn/
├── 📁 Assets/           # Game assets (sprites, textures, fonts)
├── 📁 Class/            # Scene files (.tscn)
├── 📁 Scripts/          # GDScript files
│   ├── Character/       # Character controller components
│   ├── Stages/          # Stage-specific logic
│   └── global.gd        # Global game state management
├── 📁 Template/         # Reusable templates and base classes
├── 📁 UI/              # User interface components
├── 📁 Music & SFX/     # Audio files
└── 📁 DialogueGuide/   # Documentation for dialogue system
```

---

## 🎮 How to Play

### Controls
- **A/D Keys**: Move left/right
- **W Key**: Jump/Climb ladders
- **S Key**: Interact with objects
- **ESC**: Pause menu

### Objective
Navigate through each stage while managing your stamina, collect memories to unlock story content, and progress through increasingly challenging environments.

### Stamina System
- **Stamina depletes** during movement and actions
- **Recharges automatically** when stationary
- **Different levels** have different stamina configurations
- **Progress carries over** between stages

---

## 🛠️ Technical Implementation

### Engine & Tools
- **Game Engine**: Godot 4.5
- **Language**: GDScript
- **Platform**: PC (Windows executable included)
- **Architecture**: Component-based with inheritance patterns

### Key Systems

#### 🏗️ **Stage Template System**
- Base `StageTemplate` class provides common functionality
- Individual stages inherit and extend base behavior
- Consistent level progression and state management

#### 👤 **Character Controller**
- Modular component architecture
- Separate systems for movement, health, and interaction
- State management for different character conditions

#### 💾 **Global State Management**
- Persistent save/load system using JSON
- Level progression tracking
- Stamina persistence across sessions

#### 💬 **Dialogue System**
- Resource-based dialogue implementation
- Support for choices and branching conversations
- Integration with game events and functions

---

## 🏗️ OOP Design Patterns

### Design Patterns Implemented

#### 🏛️ **Template Method Pattern**
```gdscript
# StageTemplate.gd - Base template with overridable methods
class_name StageTemplate extends Node2D

func _ready():
    stage_ready()  # Template method

func stage_ready():
    pass  # Override in derived classes
```

#### 🔧 **Composite Pattern**
```gdscript
# Character system with modular components organized hierarchically
class_name Character extends CharacterBody2D

# Components form a tree structure
var movement_controller: CharacterMovement
var animation_controller: CharacterAnimationController  
var health_controller: CharacterHealth
var interaction_controller: CharacterInteraction

func _setup_components():
    # All components treated uniformly despite different implementations
    movement_controller = CharacterMovement.new()
    add_child(movement_controller)  # Composite relationship
```

#### 🌍 **Singleton Pattern**
```gdscript
# Global.gd - Game state management
extends Node

var game_data = {
    "unlocked_level": 1,
    "current_stamina": 500.0,
    "level_stamina": {...}
}
```

#### 🏗️ **Factory Method Pattern** (Implicit)
```gdscript
# StageTemplate creates different types of interactive objects
func create_interactive_object(type: String):
    match type:
        "memory": return Memory.new()
        "key": return Key.new()
        "note": return Note.new()
```

#### 👀 **Observer Pattern** (Signal-based)
```gdscript
# Character emits signals that UI components observe
signal health_changed(new_health: int)
signal state_changed(new_state: CharacterState.State)

# UI components listen for changes
health_controller.health_changed.connect(_on_health_changed)
```

### OOP Principles Applied

#### ✅ **Encapsulation**
- Private variables with underscore prefix
- Controlled access through public methods
- Data hiding for internal state management

#### ✅ **Inheritance**
- Stage hierarchy: `StageTemplate` → `Stage_1`, `Stage_2`, etc.
- Interactive objects: `InteractiveObject` → `Memory`, `Key`, `Note`
- Proper extension of Godot base classes

#### ✅ **Polymorphism**
- Virtual methods in base classes
- Stage-specific behavior overrides
- Component interface implementations

#### ✅ **Abstraction**
- Abstract base classes for common functionality
- Interface segregation for different systems
- Clear separation of concerns

---

## 🎮 How to Play ClockWorn - Complete Guide

### 📋 System Requirements

#### Minimum Requirements
- **Operating System**: Windows 10/11 (64-bit)
- **RAM**: 4 GB minimum, 8 GB recommended
- **Storage**: 500 MB free space
- **Graphics**: DirectX 11 compatible graphics card

### 🚀 Quick Start - Playing the Game

#### Option 1: Download and Play (Recommended for Players)

1. **Get the Game**
   ```bash
   git clone https://github.com/FITUS-TriTruong/24C10-OOP.git
   cd 24C10-OOP/Kysophy-ClockWorn
   ```

2. **Launch ClockWorn**
   - **Method A**: Double-click `Clockworn.exe`
   - **Method B**: Run from PowerShell:
     ```powershell
     .\Clockworn.exe
     ```
   - **Debug Mode**: Use `Clockworn.console.exe` for debug output

3. **Start Playing**
   - Game launches to main menu
   - Click "Play" to start Stage 1
   - Use Level Select to choose unlocked stages

### 🎮 Game Controls & Mechanics

#### Basic Controls
- **Movement**: A/D keys (left/right)
- **Jump**: W key (also used for climbing ladders)
- **Interact**: S key (collect memories, read notes, use keys)
- **Pause**: ESC key (pause menu with resume/quit options)

#### Game Mechanics
- **Stamina System**: Your robot has limited energy that depletes with movement
- **Memory Collection**: Find and collect 9 memory fragments to unlock the full story
- **Level Progression**: Complete stages to unlock the next level
- **Save System**: Progress automatically saves (stamina, unlocked levels, collected memories)

#### Tips for Success
- **Manage Stamina**: Plan your movements carefully, stamina recharges when stationary
- **Explore Thoroughly**: Memories are hidden throughout stages
- **Use Checkpoints**: Recharge stations restore your stamina
- **Read Everything**: Notes and dialogue provide story context and hints

### 🏆 Complete Gameplay Experience

#### Stage Progression
1. **Stage 1**: Tutorial - Learn basic mechanics and story setup
2. **Stage 2**: Expanded platforming with environmental hazards  
3. **Stage 3**: Complex navigation with puzzle elements
4. **Final Stage**: Climactic ending with all story revelations

#### Collectibles Guide
- **Memory Fragments (9 total)**: Unlock story segments and lore
- **Keys**: Required to progress through locked doors
- **Notes**: Additional world-building and character backstory
- **Recharge Stations**: Restore stamina during challenging sections

#### Completion Goals
- **Story Completion**: Reach the Final Stage and see the ending
- **Full Collection**: Find all 9 memory fragments for complete story
- **Exploration**: Read all notes and dialogue for full narrative experience

### 🔄 Reset Game Progress

If you want to start over or reset your progress:

```powershell
# Navigate to game directory
cd "C:\path\to\your\24C10-OOP\Kysophy-ClockWorn"

# Delete save file to reset all progress
Remove-Item "$env:APPDATA\Godot\app_userdata\Clockworn\progress.dat" -ErrorAction SilentlyContinue

# Or reset using PowerShell script
$resetData = @{
    unlocked_level = 1
    current_stamina = 500.0
    level_stamina = @{
        "1" = 500.0; "2" = 500.0; "3" = 500.0; "4" = 500.0
    }
    collected_memories = @{
        "memory0" = $false; "memory1" = $false; "memory2" = $false
        "memory3" = $false; "memory4" = $false; "memory5" = $false
        "memory6" = $false; "memory7" = $false; "memory8" = $false
    }
    found_key = $false
    given_key = $false
    package = $true
    ending = ""
} | ConvertTo-Json -Compress

$resetData | Out-File -FilePath "$env:APPDATA\Godot\app_userdata\Clockworn\progress.dat" -Encoding UTF8 -NoNewline
Write-Host "Game progress reset successfully!"
```

#### What Gets Reset
- **Level Progress**: Back to Stage 1 only
- **Memory Collection**: All memories need to be found again
- **Stamina**: Reset to full (500.0) for all levels
- **Story Progress**: All dialogue and story elements reset

### 🛠️ For Developers - Development Setup

#### Development Environment

1. **Install Godot Engine 4.5+**
   - Download from: https://godotengine.org/download
   - Extract to preferred location (e.g., `C:\Godot\`)

2. **Clone and Open Project**
   ```bash
   git clone https://github.com/FITUS-TriTruong/24C10-OOP.git
   cd 24C10-OOP
   ```

3. **Open in Godot**
   ```bash
   # If Godot is in PATH
   godot Kysophy-ClockWorn/project.godot
   
   # Or use Godot Project Manager:
   # 1. Launch Godot
   # 2. Click "Import"  
   # 3. Select Kysophy-ClockWorn/project.godot
   ```

#### Running in Development
- **Play Game**: Press F5 in Godot Editor
- **Play Current Scene**: Press F6
- **Main Scene**: `UI/Scripts/main_menu.tscn`

#### Step 2: Clone and Open Project

1. **Clone the Repository**
   ```bash
   git clone https://github.com/FITUS-TriTruong/24C10-OOP.git
   cd 24C10-OOP
   ```

2. **Open in Godot Editor**
   ```bash
   # Method 1: Using Godot executable
   godot Kysophy-ClockWorn/project.godot
   
   # Method 2: Through Godot Project Manager
   # 1. Launch Godot
   # 2. Click "Import"
   # 3. Navigate to Kysophy-ClockWorn/project.godot
   # 4. Click "Import & Edit"
   ```

#### Step 3: Running in Development Mode

1. **Run the Game**
   - Press `F5` or click the "Play" button in Godot Editor
   - First time: Select `UI/Scripts/main_menu.tscn` as the main scene

2. **Run Specific Scenes**
   - Press `F6` to run current scene
   - Useful for testing individual levels

### 🏗️ Building/Compiling the Project

#### Preparing Export Templates

1. **Download Export Templates**
   - In Godot: Go to `Editor → Manage Export Templates`
   - Click "Download and Install" for version 4.5

#### Building for Windows

1. **Set Up Export Preset**
   ```
   Project → Export → Add... → Windows Desktop
   ```

2. **Configure Export Settings**
   - **Executable Name**: `Clockworn`
   - **Application Icon**: Use `icon.svg`
   - **Debug**: Uncheck for release builds

3. **Build the Project**
   ```
   # Method 1: Through Editor
   Project → Export → Export Project
   
   # Method 2: Command Line
   godot --headless --export-release "Windows Desktop" ./build/Clockworn.exe
   ```

#### Building for Other Platforms

1. **Linux**
   ```bash
   # Add Linux export preset first
   godot --headless --export-release "Linux/X11" ./build/Clockworn_Linux
   ```

2. **macOS** (requires macOS or cross-compilation setup)
   ```bash
   godot --headless --export-release "macOS" ./build/Clockworn.app
   ```

### 🐛 Troubleshooting

#### Common Issues and Solutions

1. **"Godot not found" Error**
   ```bash
   # Solution: Add Godot to PATH or use full path
   C:\Godot\godot.exe Kysophy-ClockWorn/project.godot
   ```

2. **Missing Export Templates**
   ```
   # In Godot Editor:
   Editor → Manage Export Templates → Download and Install
   ```

3. **Save File Issues**
   ```bash
   # Reset game progress (if needed)
   # Navigate to project directory and run:
   powershell -Command "Remove-Item '$env:APPDATA\Godot\app_userdata\Clockworn\progress.dat' -ErrorAction SilentlyContinue"
   ```

4. **Audio Issues**
   - Ensure Windows audio drivers are up to date
   - Check audio device settings in Windows

#### Debug Mode

1. **Enable Debug Console**
   ```bash
   # Run with console output
   ./Clockworn.console.exe
   ```

2. **Godot Remote Debugger**
   ```
   # In Godot Editor:
   Debug → Deploy with Remote Debug
   ```

### 📁 Project File Structure

```
24C10-OOP/
├── Kysophy-ClockWorn/           # Main game directory
│   ├── Clockworn.exe            # Built executable (Windows)
│   ├── Clockworn.console.exe    # Debug executable
│   ├── project.godot            # Godot project file
│   ├── Assets/                  # Game assets
│   ├── Scripts/                 # GDScript source files
│   ├── Class/                   # Scene files
│   └── UI/                      # User interface
├── README.md                    # This file
├── OOP_Design_Review.md         # Technical documentation
└── UML.uxf                      # UML diagrams
```

### 🔧 Advanced Development

#### Custom Build Scripts

Create `build.bat` for automated building:
```batch
@echo off
echo Building ClockWorn...
godot --headless --export-release "Windows Desktop" ./build/Clockworn.exe
echo Build complete!
pause
```

#### Version Control

```bash
# Recommended .gitignore additions for Godot
echo "# Godot 4+ specific" >> .gitignore
echo ".godot/" >> .gitignore
echo "*.tmp" >> .gitignore
echo "*.import" >> .gitignore
```

---

## 🎮 Gameplay Guide

### Stage Progression
1. **Stage 1**: Tutorial and basic mechanics introduction
2. **Stage 2**: Expanded platforming with hazards
3. **Stage 3**: Complex navigation and puzzle elements
4. **Final Stage**: Climactic conclusion with all mechanics

### Collectibles
- **Memories**: Story fragments that unlock lore
- **Keys**: Required for progression through locked areas
- **Notes**: Additional context and world-building

### Tips for Players
- **Manage stamina carefully** - plan your movements
- **Explore thoroughly** - memories provide valuable story content
- **Use save stations** - progress is automatically saved at checkpoints
- **Experiment with interactions** - many objects provide useful information

---

## 📚 Documentation

### Additional Resources
- `DialogueGuide/` - Documentation for implementing dialogue
- `OOP_Design_Review.md` - Detailed analysis of design patterns
- `AI_LOG.md` - Development process documentation
- `UML.uxf` - UML diagrams for system architecture

### Code Documentation
- All major classes include inline documentation
- Function signatures follow Godot conventions
- Clear variable naming and structure

---

## 👥 Team Contributions

**Group 11 Members:**
- **Trần Nhựt Đăng Khoa (24127427)**: Gameplay Programmer, Project Lead
- **Mã Đức Khải (24127407)**: Gameplay Programmer, Documentation
- **Nguyễn Trường Ngọc Thảo (24127543)**: Map designer, Level Designer
- **Trương Minh Trí (24127135)**: UI/UX designer, Systems Programmer

---

## 📄 License

This project is developed as part of an Object-Oriented Programming course assignment.

---

## 🤝 Acknowledgments

- **Godot Engine** community for excellent documentation and resources
- **Asset creators** for visual and audio resources used in the project
- **Course instructors** for guidance on OOP principles and design patterns

---

## 📚 Troubleshooting & Support

### Common Issues

#### Game Won't Launch
- Ensure you have Windows 10/11 (64-bit)
- Install Microsoft Visual C++ Redistributable if missing
- Verify DirectX 11 compatibility
- Try running as administrator

#### Save File Problems
- Save location: `%APPDATA%\Godot\app_userdata\Clockworn\progress.dat`
- Delete save file if corrupted and restart game
- Use the reset instructions above to restore default state

#### Performance Issues
- Close other applications to free up memory
- Update graphics drivers to latest version
- Reduce screen resolution if experiencing lag
- Check Task Manager for high CPU/memory usage

#### Audio Problems
- Verify Windows audio settings are correct
- Ensure audio drivers are up to date
- Adjust in-game volume if sound is too quiet/loud
- Test with different audio output devices

### Getting Help
- **Bug Reports**: Create an issue on the GitHub repository
- **Questions**: Use GitHub Discussions for community support
- **Documentation**: Check the project Wiki for detailed guides
- **Direct Contact**: Reach out to team members listed above

---

## 🎯 Final Publication Notes

### About ClockWorn
ClockWorn is a story-driven 2D platformer where you control a robot exploring post-apocalyptic environments while uncovering fragments of memory from the past. The game combines:

- **Narrative Exploration**: Discover the story through scattered memory fragments
- **Strategic Platforming**: Manage your robot's stamina while navigating challenging terrain
- **Environmental Storytelling**: Rich world-building through visual design and interactive elements
- **Progressive Gameplay**: Three main stages plus a climactic final stage

### Complete Experience Checklist
- ✅ **Launch the Game**: Run `Clockworn.exe` and start your adventure
- ✅ **Master the Controls**: Learn movement, jumping, and interaction mechanics
- ✅ **Collect All Memories**: Find all 9 memory fragments for the complete story
- ✅ **Explore Every Stage**: Progress through all levels to reach the ending
- ✅ **Discover the Lore**: Read notes and dialogue for full narrative context

### Ready to Begin?
Your ClockWorn journey starts now! Simply double-click `Clockworn.exe` in the `Kysophy-ClockWorn` folder and immerse yourself in this post-apocalyptic robot adventure. Remember - every memory you collect brings you closer to understanding the truth.

**The mysteries of ClockWorn await your discovery!** 🤖⚙️🎮

---
