# Galaga Wars - UML Architecture Diagrams

This directory contains PlantUML diagrams documenting the architecture of the Galaga Wars project.

## Diagram Files

### State Machines
1. **01_gamemode_state_machine.puml** - Main game state machine
   - Shows transitions between game modes (INITIALIZE → GAME_ACTIVE → SHOW_RESULTS, etc.)
   - Managed by `oGameManager`
   - Key states: GAME_ACTIVE, SPAWN_ENEMY_WAVES, ENTER_INITIALS, GAME_PAUSED

2. **02_enemy_state_machine.puml** - Enemy AI state machine
   - Shows enemy behavior states (ENTER_SCREEN → IN_FORMATION → IN_DIVE_ATTACK, etc.)
   - Managed by `oEnemyBase`
   - Key states: IN_FORMATION, IN_DIVE_ATTACK, IN_LOOP_ATTACK

3. **03_player_state_machine.puml** - Player ship state machine
   - Shows player states (SPAWNING → RELEASING → NORMAL → DESTROYED)
   - Managed by `oPlayer`
   - Includes invulnerability periods and respawn logic

### Architecture Diagrams
4. **04_controller_architecture.puml** - Controller architecture
   - Shows relationships between oGameManager and specialized controllers
   - Controllers: WaveSpawner, ScoreManager, ChallengeStageManager, HighScoreSystem
   - Demonstrates the coordinator pattern

5. **05_object_hierarchy.puml** - Object inheritance hierarchy
   - Shows class inheritance (oEnemyBase → oTieFighter, oTieIntercepter, oImperialShuttle)
   - Includes game objects, managers, UI, and effects
   - Shows pooled object relationships

6. **06_data_flow_diagram.puml** - Data flow architecture
   - Shows how data flows from JSON files → Controllers → Game Objects
   - Includes object pool lifecycle
   - Demonstrates data-driven design pattern

## Viewing the Diagrams

### Option 1: Online PlantUML Viewer
1. Go to http://www.plantuml.com/plantuml/uml/
2. Copy the contents of a `.puml` file
3. Paste into the text area
4. Click "Submit" to render

### Option 2: VS Code Extension
1. Install "PlantUML" extension by jebbs
2. Open a `.puml` file
3. Press `Alt+D` (or `Option+D` on Mac) to preview
4. Or right-click → "Preview Current Diagram"

### Option 3: Command Line
```bash
# Install PlantUML
npm install -g node-plantuml

# Generate PNG images
puml generate 01_gamemode_state_machine.puml -o ./output

# Or generate all diagrams
puml generate *.puml -o ./output
```

### Option 4: IntelliJ/WebStorm Plugin
1. Install "PlantUML integration" plugin
2. Open a `.puml` file
3. View rendered diagram in side panel

## Architecture Overview

The Galaga Wars project uses several key architectural patterns:

### 1. **State Machine Pattern**
- **GameMode**: Main game flow (INITIALIZE → GAME_ACTIVE → SHOW_RESULTS)
- **EnemyState**: AI behavior (ENTER_SCREEN → IN_FORMATION → IN_DIVE_ATTACK)
- **ShipState**: Player states (SPAWNING → NORMAL → DESTROYED)

### 2. **Coordinator Pattern**
- `oGameManager` acts as a coordinator, delegating to specialized controllers
- Controllers: WaveSpawner, ScoreManager, ChallengeStageManager, HighScoreSystem
- Reduces god object complexity from 1000+ lines to manageable modules

### 3. **Object Pooling**
- Pools for missiles, enemy shots, and explosions
- Eliminates garbage collection stutters
- Pre-allocated instances with `poolReset()` methods
- Lifecycle: create → deactivate → acquire → use → release → reactivate

### 4. **Data-Driven Design**
- Wave patterns: `wave_spawn.json`
- Challenge stages: `challenge_spawn.json`
- Enemy attributes: `enemy_attributes/*.json`
- Formation positions: `formation_coordinates.json`
- Game config: `game_config.json`

### 5. **Inheritance Hierarchy**
- Base class: `oEnemyBase`
- Children: `oTieFighter`, `oTieIntercepter`, `oImperialShuttle`
- Shared AI logic in base class
- Enemy-specific data loaded from JSON

## Key Insights from Diagrams

### GameMode State Machine
- **Critical transitions**: GAME_ACTIVE can pause (→ GAME_PAUSED) or end (→ SHOW_RESULTS → ENTER_INITIALS)
- **Challenge stages**: Every 4 levels, SPAWN_ENEMY_WAVES uses `challenge_spawn.json` instead of `wave_spawn.json`
- **High score flow**: SHOW_RESULTS → ENTER_INITIALS (if high score) → GAME_PLAYER_MESSAGE

### Enemy State Machine
- **Formation management**: 40 enemies (5×8 grid), each with INDEX (1-40)
- **Dive cap**: Max 2 enemies can dive simultaneously (prevents overwhelming player)
- **Attack patterns**: DIVE → LOOP (return) or FINAL (straight down, no return)
- **Path system**: Different paths for left vs right side (PATH1 vs PATH1_FLIP)

### Controller Architecture
- **WaveSpawner**: Manages wave patterns, enemy spawning, formation coordination
- **ScoreManager**: Tracks score, hit ratio, extra lives, combos
- **ChallengeStageManager**: Detects challenge stages, spawns challenge patterns, awards bonuses
- **HighScoreSystem**: Persists high scores, manages leaderboard, handles initials entry

### Data Flow
- **JSON → Controller**: Data files loaded at startup
- **Controller → Game Object**: Controllers spawn and configure objects
- **Game Object → Pool**: Objects acquired/released from pools
- **Game Object → Controller**: Events reported back (kills, shots fired)
- **Controller → Storage**: High scores persisted to disk

## Related Documentation

- `CLAUDE.md` - Project overview and architecture guide
- `POOLING_BUGFIXES.md` - Object pooling implementation details
- `INTEGRATION_COMPLETE.md` - Sprint 2 & 3 integration summary
- `STRUCTURE_SUMMARY.txt` - File structure overview
- `datafiles/Patterns/README.md` - JSON schema documentation

## Maintenance

These diagrams were generated as part of code cleanup and documentation efforts. When making architectural changes:

1. **Update the diagrams** to reflect new states, controllers, or data flows
2. **Regenerate images** if using rendered versions
3. **Update CLAUDE.md** to keep project guide in sync
4. **Consider adding** new diagrams for new subsystems

## Questions?

If you have questions about the architecture, refer to:
- These UML diagrams for visual overview
- `CLAUDE.md` for detailed implementation notes
- Source code comments (all files are well-documented)

---

**Generated**: January 12, 2025
**PlantUML Version**: Compatible with v1.2023.0+
**Project**: Galaga Wars (GameMaker Studio 2)
