# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a GameMaker Studio 2 implementation of Galaga with a Star Wars theme ("Galaga Wars"). The game features classic Galaga-style gameplay with TIE Fighters, TIE Interceptors, Imperial Shuttles, and X-Wings replacing the original Galaga enemies.

**Engine**: GameMaker Studio 2 (IDE Version 2024.13.1.193)
**Language**: GameML (GameMaker Language)
**Project Files**: `.yyp` (GameMaker project), `.yy` (resource files), `.gml` (code files)

## How to Run/Test

This is a GameMaker Studio 2 project. To run:
1. Open `Galaga.yyp` in GameMaker Studio 2
2. Press F5 to run the game
3. Or use the "Run" button in the GameMaker Studio 2 IDE

The game has no command-line build system - it must be opened and run through GameMaker Studio 2.

## Architecture

### Core Game Flow

The game uses a state machine managed by `oGameManager` with these states (defined in `GameMode` enum):

1. **INITIALIZE** → **ATTRACT_MODE** (demo/title screen)
2. **INSTRUCTIONS** (if player requests)
3. **GAME_PLAYER_MESSAGE** → **GAME_STAGE_MESSAGE** → **SPAWN_ENEMY_WAVES**
4. **GAME_READY** → **GAME_ACTIVE** (main gameplay)
5. **SHOW_RESULTS** → **ENTER_INITIALS** (if high score achieved)
6. **GAME_PAUSED** (when player pauses)

State transitions are managed primarily in `oGameManager` Step events and Alarm events.

### Key Objects

- **oGameManager**: Central game orchestrator with specialized controllers
- **oGlobal**: Initializes global.Game struct and asset systems
- **oPlayer**: Player-controlled ship (X-Wing)
- **oEnemyBase**: Base class for all enemies with shared behavior (path following, formation management, diving attacks)
- **oTieFighter**, **oTieIntercepter**, **oImperialShuttle**: Specific enemy types that inherit from oEnemyBase
- **oGameCamera**: Manages camera/viewport
- **oAttractMode**: Handles attract mode (demo) sequence
- **oSplashScreen**: Initial splash screen display

### Specialized Controllers (Sprint 2 Refactoring)

The game uses a modular controller architecture to reduce god object complexity:

- **WaveSpawner** (`scripts/WaveSpawner/WaveSpawner.gml`): Manages enemy spawning
  - Standard wave spawning (40 enemies per wave)
  - Challenge stage spawning (8 enemies per wave, 5 waves)
  - Rogue enemy spawning
  - Spawn timing and delays

- **ScoreManager** (`scripts/ScoreManager/ScoreManager.gml`): Manages scoring system
  - Score tracking and updates
  - Extra life awarding at milestones
  - High score management
  - Results screen bonuses

- **ChallengeStageManager** (`scripts/ChallengeStageManager/ChallengeStageManager.gml`): Manages challenge stages
  - Challenge stage detection and triggering (every 4 levels)
  - Wave path selection (eliminates 60+ lines of duplicate code via lookup table)
  - Challenge results and bonuses

- **AssetCache** (`scripts/AssetCache/AssetCache.gml`): Performance optimization
  - Caches asset_get_index() lookups to prevent repeated string→asset conversions
  - Expected performance gain: +5-10 FPS
  - Cache hit rate: >95% after warmup

- **ObjectPool** (`scripts/ObjectPool/ObjectPool.gml`): Memory optimization
  - Pools projectiles (oEnemyShot, oMissile, oExplosion) to eliminate GC stutters
  - Reuses instances instead of create/destroy
  - Smoother frame times, consistent 60 FPS

### Enemy System

Enemies use a state-based system (defined in `EnemyState` enum in `objects/oEnemyBase/Create_0.gml`):
- **ENTER_SCREEN**: Following entrance path
- **MOVE_INTO_FORMATION**: Transitioning to formation position
- **IN_FORMATION**: Stationary in grid formation
- **IN_DIVE_ATTACK**: Performing diving attack
- **IN_LOOP_ATTACK**: Performing loop attack
- **IN_FINAL_ATTACK**: Special attack pattern

Each enemy has:
- An `INDEX` (1-40) determining formation position
- A `PATH_NAME` for entrance/attack patterns
- `COMBINE` flag indicating if enemies can combine/transform
- `HEALTH` value loaded from JSON attributes

### Data-Driven Wave Spawning

Wave patterns are defined in `datafiles/Patterns/wave_spawn.json`:
- Contains multiple WAVE definitions
- Each wave has multiple SPAWN groups (5 groups of 8 enemies = 40 enemies per wave)
- Each spawn defines: ENEMY type, SPAWN_XPOS, SPAWN_YPOS, INDEX, PATH, COMBINE flag

Enemy attributes (health, scoring, etc.) are in individual JSON files:
- `datafiles/Patterns/oTieFighter.json`
- `datafiles/Patterns/oTieIntercepter.json`
- `datafiles/Patterns/oImperialShuttle.json`

Formation positions are defined in `datafiles/Patterns/formation_coordinates.json`.

### Challenge Stage System

Challenge stages occur every 4 levels (when `global.challcount` reaches 4). They are defined in `datafiles/Patterns/challenge_spawn.json`:
- Contains 8 different challenge patterns (CHALLENGE_ID 1-8)
- Each challenge has 5 waves (WAVE_ID 0-4)
- Each wave defines:
  - ENEMY: Enemy type to spawn
  - DOUBLED: Boolean indicating if enemies spawn in pairs (mirrored paths)
  - PATH1, PATH2, PATH1_FLIP, PATH2_FLIP: Path names for enemy entry
- Challenge stages spawn 8 enemies per wave (40 total per challenge)
- Enemies in challenge stages use INDEX: -1 (no formation position)
- Challenge stage logic is in `GameManager_STEP_FNs.gml` in the `Game_Loop()` function (else branch)

### Path System

Enemies follow predefined paths for:
- **Entrance**: Top/Bottom, Left/Right variations (e.g., `Ent_Top_L2R`, `Ent_Bot_R2L`)
- **Attack patterns**: Dive, loop, and challenge stage patterns
- **Attract mode**: Special paths for demo mode

Paths are defined in the `paths/` directory. Path naming convention:
- `Ent_*`: Entrance paths
- `*_Flip`: Mirrored version for opposite side
- `*_IN` / `*_OUT`: Inner/outer formation paths
- `Chall*`: Challenge stage paths
- `TF_*`, `TI_*`, `IS_*`: Enemy-specific paths for TIE Fighters, TIE Interceptors, Imperial Shuttles

### Scripts Organization

Scripts are organized into logical groups:

- **GameManager_STEP_FNs.gml**: Helper functions for game manager (Enter_Initials, nOfEnemies, checkForExtraLives, readyForNextLevel)
- **oEnemyBase_FNs.gml**: Shared enemy behavior functions
- **ship_functions.gml**: Player ship logic
- **Hud.gml**: HUD rendering
- **Controller_draw_fns.gml**: Drawing functions for game manager
- **CRTFunctions.gml**: CRT shader effect management
- **compatibility/**: Legacy GM8 compatibility layer for sound, tiles, instances

### Global Variables

Key globals defined in `oGlobal/Create_0.gml` (global.Game struct):
- **global.Game.State.mode**: Current GameMode state
- **global.Game.Player.score**, **global.Game.Player.lives**: Player score and lives
- **global.Game.Level.wave**: Current wave number
- **global.Game.Display.scale**: Display scale (1 for original Galaga rooms, 2 for GalagaWars)
- **global.Game.Challenge.isActive**: Whether current stage is a challenge stage
- **global.Game.State.isGameOver**, **global.Game.State.isPaused**: Game state flags

### Rooms

- **SplashScreen**: Initial loading screen
- **GalagaWars**: Main Star Wars-themed game room (scale=2)
- **Galaga**, **Galaga2**: Original Galaga-themed rooms (scale=1)
- **AttractMode**: Demo mode room

Room order is defined in Galaga.yyp: SplashScreen → GalagaWars → Galaga2 → Galaga

### Visual Effects

- **CRT Shader**: Retro CRT monitor effect with presets (480i, NES, PVM, VGA)
- **Particle System**: StarFieldEmitter for scrolling star background
- **Pause Effect**: FX layer effect when game is paused
- **ScrollingNebula**: Animated background layer

## Common Patterns

### Adding a New Enemy Type

1. Create new object inheriting from `oEnemyBase`
2. Set `ENEMY_NAME` variable (must match JSON filename)
3. Create `datafiles/Patterns/[ENEMY_NAME].json` with HEALTH and other attributes
4. Add sprite with appropriate animations
5. Add enemy type to `nOfEnemies()` function in `GameManager_STEP_FNs.gml`
6. Update `wave_spawn.json` to include new enemy in spawn patterns

### Modifying Wave Patterns

Edit `datafiles/Patterns/wave_spawn.json`. Each wave must have exactly 40 enemies across all SPAWN groups to fill the formation grid.

### Modifying Challenge Stages

Edit `datafiles/Patterns/challenge_spawn.json`:
1. Each challenge pattern has 8 challenges with 5 waves each
2. Set `DOUBLED: true` to spawn enemies in mirrored pairs
3. Set `ENEMY` to the enemy object name (e.g., "oTieFighter", "oImperialShuttle", "oTieIntercepter")
4. Paths are referenced by name (PATH1, PATH2, PATH1_FLIP, PATH2_FLIP)
5. Each wave spawns 8 enemies for a total of 40 enemies per challenge stage

### Adding New Paths

1. Create path in GameMaker path editor
2. Follow naming convention: Use descriptive name + `_Flip` for mirrored version
3. Reference by name (as string) in wave_spawn.json or enemy logic

### Working with Game States

Game state transitions are handled via:
- Setting `global.gameMode` to appropriate `GameMode` enum value
- Using Alarm events in `oGameManager` for timed transitions
- Checking state in Step events to execute state-specific logic

## File Structure Notes

- **objects/**: All game objects (`.yy` definition + `.gml` event scripts)
- **sprites/**: Sprite assets organized by type (LoadingScreens/Splash, Lazers, tilesets, etc.)
- **paths/**: Path definitions organized by category (GalagaWars/, original/)
- **scripts/**: Reusable function scripts
- **datafiles/**: JSON data files for patterns and fonts
- **sounds/**: Audio files (prefixed with G for Galaga sounds)
- **rooms/**: Room/level definitions
- **shaders/**: CRT shader effects (shd_crt, shd_crt_fast, shd_raw)

## JSON Data File Schemas

The game uses JSON files for data-driven configuration. Below are the schemas for each JSON file type.

### wave_spawn.json Schema

Defines standard wave enemy spawning patterns.

```json
{
  "PATTERN": [
    {
      "WAVE": [
        {
          "SPAWN": [
            {
              "ENEMY": "oTieFighter",     // Enemy object name (must match GML object)
              "PATH": "Ent1e1",            // Path name (no prefix, system adds as needed)
              "SPAWN_XPOS": 512,           // Spawn X coordinate (pixels)
              "SPAWN_YPOS": -16,           // Spawn Y coordinate (typically off-screen)
              "INDEX": 1,                  // Formation position (1-40) or -1 for no formation
              "COMBINE": false             // If true, spawns paired enemy immediately after
            }
          ]
        }
      ]
    }
  ]
}
```

**Key Rules**:
- Each WAVE must have exactly 40 enemies total (sum of all SPAWN entries)
- INDEX values 1-40 map to 5×8 formation grid positions
- COMBINE spawns happen in same frame (useful for synchronized entries)

### challenge_spawn.json Schema

Defines challenge stage patterns (bonus stages every 4 levels).

```json
{
  "CHALLENGES": [
    {
      "CHALLENGE_ID": 1,
      "PATH1": "Chall1_Path1",            // Primary path name
      "PATH1_FLIP": "Chall1_Path1_Flip",  // Mirrored version of PATH1
      "PATH2": "Chall1_Path2",            // Secondary path name
      "PATH2_FLIP": "Chall1_Path2_Flip",  // Mirrored version of PATH2
      "WAVES": [
        {
          "ENEMY": "oTieIntercepter",     // Enemy object name
          "DOUBLED": true                  // If true, spawns mirrored pairs
        }
      ]
    }
  ]
}
```

**Key Rules**:
- 8 challenges total (CHALLENGE_ID 1-8)
- Each challenge has 5 waves
- DOUBLED: true spawns 2 enemies per spawn call (total 8 per wave)
- Waves 0, 3, 4 use PATH1/PATH1_FLIP
- Waves 1, 2 use PATH2/PATH2_FLIP
- Total enemies per challenge: 40 (8 enemies × 5 waves)

### Enemy Attribute JSON Schema

Individual files for each enemy type (e.g., `oTieFighter.json`).

```json
{
  "HEALTH": 1,                          // Hit points (1 = single hit to kill)
  "POINTS_BASE": 50,                    // Base score value
  "STANDARD": {
    "DIVE_PATH1": "TF_Dive1",           // Right side dive path
    "DIVE_ALT_PATH1": "TF_Dive1_Flip",  // Left side dive path
    "DIVE_PATH2": "TF_Dive2",           // Right side return path
    "DIVE_ALT_PATH2": "TF_Dive2_Flip"   // Left side return path
  },
  "CAN_LOOP": true,                     // If true, enemy loops back to formation
  "LOOP_PATH": "TF_Loop",               // Return loop path (right side)
  "LOOP_ALT_PATH": "TF_Loop_Flip"       // Return loop path (left side)
}
```

**Key Rules**:
- HEALTH determines hit count needed to destroy enemy
- Path names must match existing path assets in GameMaker
- DIVE_PATH1/2 used based on formation position (left vs right side)
- If CAN_LOOP is false, enemy goes straight down after dive

### rogue_spawn.json Schema

Defines rogue enemy spawning (enemies that don't join formation).

```json
{
  "ROGUE_LEVELS": [
    {
      "LEVEL": 0,                       // Rogue level index
      "SPAWN_COUNT": [0, 0, 1, 2, 3]   // Number of rogues per wave [wave0, wave1, ...]
    }
  ]
}
```

**Key Rules**:
- Rogue enemies use "ROGUE_" prefixed paths
- They target player directly after entrance path completion
- Don't count toward formation (INDEX: -1)

### formation_coordinates.json Schema

Defines the 5×8 grid formation positions.

```json
{
  "POSITION": [
    {
      "_x": 128,                        // X coordinate for formation position
      "_y": 96                          // Y coordinate for formation position
    }
  ]
}
```

**Key Rules**:
- 40 positions total (indices 0-39, accessed as 1-40 in code)
- Coordinates are base positions; breathing animation adds oscillation
- Typically arranged as:
  - Rows 1-2 (INDEX 1-16): Top enemies
  - Row 3 (INDEX 17-24): Middle enemies
  - Rows 4-5 (INDEX 25-40): Bottom enemies

### game_config.json Schema

Central configuration for gameplay parameters.

```json
{
  "PLAYER": {
    "STARTING_LIVES": 3,
    "EXTRA_LIFE_FIRST": 20000,
    "EXTRA_LIFE_ADDITIONAL": 70000
  },
  "ENEMIES": {
    "MAX_DIVE_CAP": 2,
    "DIVE_CAP_START": 2,
    "MAX_BOSS_DIVE_CAP": 2
  },
  "CHALLENGE_STAGES": {
    "INTERVAL_LEVELS": 4
  },
  "HIGH_SCORES": {
    "GAME_TAG": "unique_game_identifier",
    "REFRESH_INTERVAL_SECONDS": 300
  },
  "DIFFICULTY": {
    "SPEED_MULTIPLIER_BASE": 1.0
  }
}
```

**Key Rules**:
- All values have hardcoded fallbacks in GameConstants.gml
- Use `get_config_value(section, key, default)` to access
- Allows difficulty tuning without code changes

## Special Considerations

- The game supports two visual modes: original arcade sprites (global.ArcadeSprites) and Star Wars-themed sprites
- All enemy instances use the same base object pattern but load different attributes from JSON
- Path system uses string-based asset lookup with `asset_get_index()` for dynamic path loading
- The game uses GameMaker's legacy coordinate system (y-up) and pixel-perfect rendering
- Scale factor (global.scale) affects movement speeds, positions, and should be applied to all spatial calculations
