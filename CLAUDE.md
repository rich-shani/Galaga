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

- **oGameManager**: Central controller managing game state, scoring, lives, wave progression, and UI. Handles all game modes and transitions.
- **oGlobalVars**: Initializes global variables used throughout the game
- **oPlayer**: Player-controlled ship (X-Wing)
- **oEnemyBase**: Base class for all enemies with shared behavior (path following, formation management, diving attacks)
- **oTieFighter**, **oTieIntercepter**, **oImperialShuttle**: Specific enemy types that inherit from oEnemyBase
- **oGameCamera**: Manages camera/viewport
- **oAttractMode**: Handles attract mode (demo) sequence
- **oSplashScreen**: Initial splash screen display

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

Key globals defined in `oGameManager/Create_0.gml`:
- **global.gameMode**: Current GameMode state
- **global.p1score**, **global.p1lives**: Player score and lives
- **global.wave**: Current wave number
- **global.scale**: Display scale (1 for original Galaga rooms, 2 for GalagaWars)
- **global.roomname**: Current room name
- **global.isChallengeStage**: Whether current stage is a challenge stage
- **global.isGameOver**, **global.isGamePaused**: Game state flags

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

## Special Considerations

- The game supports two visual modes: original arcade sprites (global.ArcadeSprites) and Star Wars-themed sprites
- All enemy instances use the same base object pattern but load different attributes from JSON
- Path system uses string-based asset lookup with `asset_get_index()` for dynamic path loading
- The game uses GameMaker's legacy coordinate system (y-up) and pixel-perfect rendering
- Scale factor (global.scale) affects movement speeds, positions, and should be applied to all spatial calculations
