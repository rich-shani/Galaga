# Galaga Wars - Complete Architecture & Developer Guide

**Last Updated:** November 2024
**Game Version:** 1.0
**Engine:** GameMaker Studio 2 (v2024.14.0.207)
**Language:** GameML (GML)

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Core Architecture](#core-architecture)
3. [Game Flow & State Machine](#game-flow--state-machine)
4. [Key Systems](#key-systems)
5. [Object Hierarchy](#object-hierarchy)
6. [Data Files & Configuration](#data-files--configuration)
7. [Development Guide](#development-guide)
8. [Testing Framework](#testing-framework)
9. [Performance Optimization](#performance-optimization)
10. [Common Patterns & Examples](#common-patterns--examples)
11. [Troubleshooting](#troubleshooting)

---

## Project Overview

**Galaga Wars** is a GameMaker Studio 2 implementation of the classic Galaga arcade game with a Star Wars theme. Players control an X-Wing to defend against waves of TIE Fighters, TIE Interceptors, and Imperial Shuttles.

### Key Features

- **Wave-based Gameplay**: 40 enemies per wave organized in 5×8 formation grid
- **Enemy AI**: Multiple attack patterns (dive, loop, final attacks)
- **Challenge Stages**: Bonus rounds every 4 levels with unique enemy spawn patterns
- **Rogue Enemies**: Enemies that bypass formation and target player directly
- **Capture Mechanics**: Enemy tractor beam can capture player for rescue attempts
- **Visual Effects**: CRT shader with multiple presets, particle effects, explosions
- **High Score System**: Persistent high score table with name entry
- **Modular Architecture**: Specialized controllers reduce code complexity

### Project Statistics

- **11,000+ lines of GML code**
- **40 script files** with reusable functions
- **35+ game objects** organized by category
- **100+ sprite/path assets**
- **10 JSON data files** for game configuration
- **5 test suites** for core systems

---

## Core Architecture

### Architectural Philosophy

Galaga Wars uses a **modular controller pattern** to avoid god object complexity:

- **oGameManager**: Central orchestrator (handles game state, delegates work)
- **WaveSpawner**: Enemy wave spawning logic
- **ScoreManager**: Score tracking and extra life awards
- **ChallengeStageManager**: Challenge stage handling
- **AssetCache**: Performance optimization for asset lookups
- **ObjectPool**: Memory optimization for projectiles/explosions

### Design Patterns Used

1. **State Machine Pattern**: Game state, enemy state, player state
2. **Data-Driven Design**: Configuration in JSON files, not hardcoded
3. **Object Pooling**: Reuse instances instead of create/destroy
4. **Caching**: Cache asset lookups for performance
5. **Struct-based Data**: Use structs for game data organization
6. **Event-Driven Architecture**: Collision events, alarm events

### Dependency Flow

```
oGlobal (Initialization)
    ├── Loads JSON data files
    ├── Initializes global.Game struct
    └── Creates system controllers

oGameManager (Orchestration)
    ├── Manages game state
    ├── Creates WaveSpawner
    ├── Creates ScoreManager
    ├── Creates ChallengeStageManager
    └── Updates player and enemies

Enemy Objects (oTieFighter, etc.)
    ├── Follow state machine
    ├── Use WaveSpawner for creation
    └── Report scores to ScoreManager

Player (oPlayer)
    ├── Responds to input
    ├── Creates missiles
    └── Interacts with enemies
```

---

## Game Flow & State Machine

### High-Level Game States

```
INITIALIZE
    ↓
ATTRACT_MODE (Demo/Title)
    ↓ (Player presses start)
GAME_ACTIVE (Main gameplay loop)
    ├→ PAUSE (Player pauses)
    │   └→ GAME_ACTIVE (Resume)
    ├→ SHOW_RESULTS (Wave complete)
    │   └→ ENTER_INITIALS (If high score)
    │       └→ ATTRACT_MODE
    └→ GAME_OVER
        └→ ENTER_INITIALS (If high score)
            └→ ATTRACT_MODE
```

### Game State Implementation

**Location**: `objects/oGameManager/Step_0.gml`

Game state is managed via the `global.Game.State.mode` struct variable:

```gml
switch(global.Game.State.mode) {
    case GameMode.GAME_ACTIVE:
        Game_Loop();  // Main gameplay
        break;
    case GameMode.ENTER_INITIALS:
        Enter_Initials();  // High score entry
        break;
}
```

### Enemy State Machine

Each enemy progresses through states in this flow:

```
ENTER_SCREEN
    ↓ (Entrance path complete)
MOVE_INTO_FORMATION
    ↓ (Reached formation position)
IN_FORMATION
    ├→ IN_DIVE_ATTACK
    │   ├→ IN_LOOP_ATTACK
    │   │   └→ MOVE_INTO_FORMATION (Standard mode)
    │   └→ (Off-screen)
    │       └→ RETURN_PATH
    │           └→ MOVE_INTO_FORMATION
    └→ IN_FINAL_ATTACK (When 2-3 enemies remain)
        └→ IN_DIVE_ATTACK (Continuous)
```

**Location**: `objects/oEnemyBase/Create_0.gml` and `Step_0.gml`

---

## Key Systems

### 1. Wave Spawner System

**Purpose**: Manages standard enemy wave spawning

**Location**: `scripts/WaveSpawner/WaveSpawner.gml`

**Data Source**: `datafiles/Patterns/wave_spawn.json`

**Key Features**:
- Spawns 40 enemies per wave (5 spawn groups × 8 enemies)
- Loads enemy data from JSON
- Handles path assignment
- Supports combined/paired spawns

**Usage Example**:
```gml
// In oGameManager Create event
wave_spawner = WaveSpawner(
    global.wave_spawn_data,
    global.challenge_spawn_data,
    global.rogue_spawn_config
);

// Later in game loop
var spawned = wave_spawner.spawnStandardEnemy();
```

### 2. Score Manager System

**Purpose**: Tracks player score and extra life awards

**Location**: `scripts/ScoreManager/ScoreManager.gml`

**Key Features**:
- Adds score for destroyed enemies (2x for diving)
- Awards extra lives at milestones (20K, 90K, 160K, ...)
- Tracks shots fired/hit statistics
- Enforces maximum score limit

**Usage Example**:
```gml
score_manager.addEnemyScore("oTieFighter", 50, true);  // 100 points for diving TIE
if (score_manager.checkForExtraLife()) {
    // Extra life awarded!
}
```

### 3. Challenge Stage Manager

**Purpose**: Manages bonus challenge stages (every 4 levels)

**Location**: `scripts/ChallengeStageManager/ChallengeStageManager.gml`

**Data Source**: `datafiles/Patterns/challenge_spawn.json`

**Key Features**:
- Detects when challenge stage should trigger
- Spawns 8 enemies per wave (5 waves per challenge)
- Applies unique paths for challenge stages
- Awards bonus points for perfect clear

**Challenge Pattern Structure**:
```json
{
    "CHALLENGE_ID": 1,
    "WAVES": [
        { "ENEMY": "oTieIntercepter", "DOUBLED": true },
        ...
    ]
}
```

### 4. Asset Cache System

**Purpose**: Optimizes performance by caching asset_get_index() lookups

**Location**: `scripts/AssetCache/AssetCache.gml`

**Performance**: +5-10 FPS improvement, >95% cache hit rate after warmup

**How It Works**:
- First lookup: Asset name → index, store in cache
- Subsequent lookups: Return cached value (no string conversion)
- Prevents repeated expensive string-to-asset conversions

**Usage Example**:
```gml
var path_index = get_cached_asset("Ent_Top_L2R");  // Cached lookup
path_start(path_index, 5, path_action_continue, true);
```

### 5. Object Pool System

**Purpose**: Reuses projectile instances to eliminate GC stutters

**Location**: `scripts/ObjectPool/ObjectPool.gml`

**Pooled Objects**:
- oMissile (player bullets)
- oEnemyShot (enemy projectiles)
- oExplosion (explosions)

**Benefits**:
- Smoother 60 FPS framerate
- Eliminates GC pause spikes
- Consistent frame timing

**Usage Example**:
```gml
var missile = obj_pool.get_missile(x, y);
missile.speed = 8;
```

### 6. Error Handling System

**Purpose**: Centralized error logging and validation

**Location**: `scripts/ErrorHandling/ErrorHandling.gml`

**Key Functions**:
- `log_error(message, context, severity)`: Log errors with context
- `safe_get_asset(name, default)`: Get asset safely, return default if not found
- `get_cached_asset(name)`: Get asset from cache

**Error Codes**:
```gml
ErrorCode.SUCCESS = 0
ErrorCode.FILE_NOT_FOUND = 1
ErrorCode.JSON_PARSE_ERROR = 2
ErrorCode.ASSET_NOT_FOUND = 3
ErrorCode.INVALID_DATA_STRUCTURE = 4
ErrorCode.NULL_REFERENCE = 5
ErrorCode.UNKNOWN_ERROR = 99
```

---

## Object Hierarchy

### Core Objects

#### oGlobal
- **Purpose**: Initialization and global setup
- **Lifecycle**: Created once at game start
- **Responsibilities**: Load JSON, initialize global.Game struct
- **Key Code**: `objects/oGlobal/Create_0.gml`

#### oGameManager
- **Purpose**: Central game orchestrator
- **Lifecycle**: Persistent across rooms
- **Responsibilities**: Game state, spawning, scoring, UI
- **Key Code**:
  - `objects/oGameManager/Create_0.gml` (initialization)
  - `objects/oGameManager/Step_0.gml` (main game loop)
  - `objects/oGameManager/Step_1.gml` (pending change)

#### oPlayer
- **Purpose**: Player-controlled X-Wing
- **Lifecycle**: Respawns when destroyed
- **Responsibilities**: Input handling, movement, shooting, capture logic
- **Key Code**: `objects/oPlayer/Step_0.gml` (control logic)
- **Ship States**:
  - ACTIVE: Normal control
  - CAPTURED: Held by tractor beam
  - DEAD: Destroyed, waiting to respawn
  - RESPAWN: Animation in progress
  - RELEASING: Being freed from capture

#### oEnemyBase (Abstract Base Class)
- **Purpose**: Base class for all enemy types
- **Children**: oTieFighter, oTieIntercepter, oImperialShuttle
- **Lifecycle**: Created by WaveSpawner, destroyed when health = 0
- **Key Code**:
  - `objects/oEnemyBase/Create_0.gml` (initialization)
  - `objects/oEnemyBase/Step_0.gml` (state machine, behavior)
  - `objects/oEnemyBase/Alarm_*.gml` (timing events)
- **Spawning**: Handled by WaveSpawner (not directly instantiated)

#### oMissile
- **Purpose**: Player projectile
- **Lifecycle**: Fires on SPACEBAR, despawns when hits enemy or leaves screen
- **Pooling**: Reused via ObjectPool to reduce GC pressure

#### oEnemyShot
- **Purpose**: Enemy projectile
- **Lifecycle**: Spawned during enemy attack, despawns when hits player or leaves screen
- **Pooling**: Reused via ObjectPool

### Supporting Objects

- **oGameCamera**: Camera/viewport management
- **oPointsDisplay**: Floating point displays when enemies die
- **oExplosion**: Particle effect for enemy destruction
- **oSplashScreen**: Initial loading/intro screen
- **oTitleScreen**: Title and attract mode
- **crt**: CRT shader effect handler
- **oLaserEmit**: Laser firing effect

### Deactivated/Legacy Objects
- _OLD_Butterfly1AltFlip (legacy enemy type)
- Various old path assets

---

## Data Files & Configuration

### JSON Data Files

All JSON files are located in `datafiles/Patterns/`

#### wave_spawn.json

Defines standard enemy wave patterns.

**Structure**:
```json
{
  "PATTERN": [
    {
      "WAVE": [
        {
          "SPAWN": [
            {
              "ENEMY": "oTieFighter",
              "PATH": "Ent1e1",
              "SPAWN_XPOS": 512,
              "SPAWN_YPOS": -16,
              "INDEX": 1,
              "COMBINE": false
            }
          ]
        }
      ]
    }
  ]
}
```

**Rules**:
- Each WAVE must contain exactly 40 enemies (sum of all SPAWN entries)
- INDEX 1-40 maps to formation grid positions
- INDEX -1 means no formation (challenge/rogue)
- COMBINE spawns paired enemies simultaneously

#### challenge_spawn.json

Defines challenge stage patterns (bonus rounds every 4 levels).

**Structure**:
```json
{
  "CHALLENGES": [
    {
      "CHALLENGE_ID": 1,
      "PATH1": "Chall1_Path1",
      "PATH1_FLIP": "Chall1_Path1_Flip",
      "PATH2": "Chall1_Path2",
      "PATH2_FLIP": "Chall1_Path2_Flip",
      "WAVES": [
        { "ENEMY": "oTieIntercepter", "DOUBLED": true }
      ]
    }
  ]
}
```

**Rules**:
- 8 challenges (CHALLENGE_ID 1-8)
- Each challenge has 5 waves
- DOUBLED: true spawns 2 enemies per spawn call
- Waves 0, 3, 4 use PATH1/PATH1_FLIP
- Waves 1, 2 use PATH2/PATH2_FLIP

#### Enemy Attribute Files

Each enemy type has individual configuration:
- `oTieFighter.json`
- `oTieIntercepter.json`
- `oImperialShuttle.json`

**Structure**:
```json
{
  "HEALTH": 1,
  "POINTS_BASE": 50,
  "STANDARD": {
    "DIVE_PATH1": "TF_Dive1",
    "DIVE_ALT_PATH1": "TF_Dive1_Flip",
    "DIVE_PATH2": "TF_Dive2",
    "DIVE_ALT_PATH2": "TF_Dive2_Flip"
  },
  "CAN_LOOP": true,
  "LOOP_PATH": "TF_Loop",
  "LOOP_ALT_PATH": "TF_Loop_Flip"
}
```

#### game_config.json

Central configuration for all gameplay parameters.

**Structure**:
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
  "DIFFICULTY": {
    "SPEED_MULTIPLIER_BASE": 1.0
  }
}
```

#### formation_coordinates.json

Defines 5×8 formation grid positions (40 total).

**Structure**:
```json
{
  "POSITION": [
    { "_x": 128, "_y": 96 },
    { "_x": 144, "_y": 96 },
    ...
  ]
}
```

#### rogue_spawn.json

Configures rogue enemy spawning (enemies outside formation).

**Structure**:
```json
{
  "ROGUE_LEVELS": [
    {
      "LEVEL": 0,
      "SPAWN_COUNT": [0, 0, 1, 2, 3]
    }
  ]
}
```

### Configuration Access

**Function**: `get_config_value(section, key, default)`

**Usage**:
```gml
var starting_lives = get_config_value("PLAYER", "STARTING_LIVES", 3);
var challenge_interval = get_config_value("CHALLENGE_STAGES", "INTERVAL_LEVELS", 4);
```

---

## Development Guide

### Setting Up Development Environment

1. **Install GameMaker Studio 2**
   - Version 2024.13.1.193 or later
   - Link GitHub account if using version control

2. **Clone Repository**
   ```bash
   git clone https://github.com/yourusername/Galaga.git
   cd Galaga
   ```

3. **Open Project**
   - Launch GameMaker Studio 2
   - Open `Galaga.yyp` project file
   - Wait for indexing to complete

4. **Run Game**
   - Press F5 or click "Run" button
   - Allows testing and debugging

### Project Structure

```
Galaga/
├── objects/                    # Game objects
│   ├── oGameManager/          # Central orchestrator
│   ├── oPlayer/               # Player ship
│   ├── oEnemyBase/            # Enemy base class
│   ├── oTieFighter/           # Enemy type 1
│   ├── oTieIntercepter/       # Enemy type 2
│   ├── oImperialShuttle/      # Enemy type 3
│   └── ...
├── scripts/                    # Reusable functions
│   ├── WaveSpawner/           # Enemy spawning
│   ├── ScoreManager/          # Score tracking
│   ├── ChallengeStageManager/ # Bonus stages
│   ├── AssetCache/            # Performance optimization
│   ├── ObjectPool/            # Instance pooling
│   ├── ErrorHandling/         # Error logging
│   ├── TestFramework/         # Unit test framework
│   ├── TestWaveSpawner/       # Wave tests
│   ├── TestCollisionSystem/   # Collision tests
│   ├── TestEnemyStateMachine/ # State machine tests
│   ├── TestScoreAndChallenge/ # Score/challenge tests
│   └── ...
├── rooms/                      # Game levels
│   ├── SplashScreen/
│   ├── GalagaWars/            # Main gameplay
│   ├── Galaga2/               # Original theme variant
│   ├── TitleScreen/
│   └── ...
├── sprites/                    # Visual assets
├── paths/                      # Movement paths (100+)
├── datafiles/                  # Configuration
│   └── Patterns/
│       ├── wave_spawn.json
│       ├── challenge_spawn.json
│       ├── formation_coordinates.json
│       ├── game_config.json
│       └── ...
├── sounds/                     # Audio files
├── shaders/                    # CRT effects
└── ARCHITECTURE.md             # This file
```

### Code Style Guide

#### Naming Conventions

```gml
// Objects: prefix with 'o'
oGameManager, oPlayer, oEnemyBase

// Sprites: prefix with 's'
sTieFighter, sExplosion, sGreenLazer

// Paths: descriptive names with direction suffix
Ent_Top_L2R, TF_Dive1_Flip, Chall1_Path1

// Enums: CamelCase
GameMode, EnemyState, ShipState

// Functions: snake_case or CamelCase
spawnStandardEnemy(), addScore(), Game_Loop()

// Variables: snake_case
spawn_counter, next_extra_life_score

// Instance variables: camelCase
enemyState, moveSpeed, targetX
```

#### Comment Style

**Top-of-file documentation**:
```gml
/// @file WaveSpawner.gml
/// @description Specialized controller for wave spawning
///
/// RESPONSIBILITIES:
///   - Standard wave spawning
///   - Challenge stage spawning
///   - Rogue enemy spawning
```

**Function documentation**:
```gml
/// @function addScore
/// @description Adds points to player score and checks for extra lives
/// @param {Real} _points Points to add
/// @return {Bool} True if extra life was awarded
static addScore = function(_points) {
    // ...
};
```

**Inline comments**:
```gml
// Brief explanation of non-obvious logic
// Reference issue tracker if fixing a bug

// === SECTION HEADER ===
// Use section headers to organize long functions
```

#### Code Organization

- **One object per file** (folder structure mirrors object names)
- **Related functions in same script** (e.g., all sound functions in sound_*.gml)
- **Avoid god objects** (extract functionality into controllers)
- **Keep functions under 200 lines** (split into smaller functions if larger)

### Adding a New Feature

**Example: Add new enemy type (Stormtrooper)**

1. **Create enemy object**
   ```
   objects/oStormtrooper/
       ├── Create_0.gml  (initialize with parent: oEnemyBase)
       ├── Step_0.gml    (inherit from parent)
       └── oStormtrooper.yy
   ```

2. **Create sprite**
   ```
   sprites/sStormtrooper/sStormtrooper.yy
   ```

3. **Add configuration**
   ```json
   // datafiles/Patterns/oStormtrooper.json
   {
       "HEALTH": 2,
       "POINTS_BASE": 75,
       ...
   }
   ```

4. **Add to wave_spawn.json**
   ```json
   {
       "ENEMY": "oStormtrooper",
       "PATH": "Ent1e1",
       ...
   }
   ```

5. **Update nOfEnemies() function**
   ```gml
   // scripts/GameManager_STEP_FNs.gml
   function nOfEnemies() {
       return instance_number(oTieFighter) +
              instance_number(oTieIntercepter) +
              instance_number(oImperialShuttle) +
              instance_number(oStormtrooper);  // Add this
   }
   ```

### Best Practices

1. **Use data files for configuration**, not hardcoded values
2. **Validate data** at initialization, fail gracefully if missing
3. **Cache expensive lookups** (asset_get_index, instance_number)
4. **Document complex algorithms** with comments and diagrams
5. **Test new code** with test framework before committing
6. **Avoid global state** where possible (use structs/objects)
7. **Handle errors gracefully** (log and continue, don't crash)

---

## Testing Framework

### Overview

The test framework provides unit and integration testing capabilities using assertion-based validation.

**Location**: `scripts/TestFramework/TestFramework.gml`

### Available Assertions

```gml
// Equality
assert_equals(actual, expected, message)
assert_not_equals(actual, not_expected, message)

// Boolean
assert_true(condition, message)
assert_false(condition, message)
assert_is_true(condition, message)
assert_is_false(condition, message)

// Null/Undefined
assert_is_null(value, message)
assert_is_not_null(value, message)

// Type checking
assert_is_array(value, message)
assert_is_struct(value, message)

// Comparisons
assert_greater_than(actual, threshold, message)
assert_less_than(actual, threshold, message)
assert_between(actual, min, max, message)
assert_in_range(actual, min, max, message)

// Collections
assert_array_length(arr, expected_length, message)
assert_struct_has_property(str, property_name, message)

// Strings
assert_string_contains(str, substring, message)

// Instances
assert_instance_exists(object_type, message)
assert_instance_not_exists(object_type, message)
```

### Running Tests

**From code**:
```gml
setupTestEnvironment();

beginTestSuite("My Test Suite");
test_myFunction_returnsExpectedValue();
test_myFunction_handlesNullInput();
endTestSuite();

teardownTestEnvironment();
```

**From test object** (oTestRunner):
- Create oTestRunner instance in a debug room
- Calls all test_* functions automatically

### Test Organization

Each major system has a dedicated test file:

1. **TestFramework.gml**: Core test utilities and assertions
2. **TestWaveSpawner.gml**: Wave spawning logic
3. **TestScoreAndChallenge.gml**: Score and challenge stages
4. **TestCollisionSystem.gml**: Collision detection
5. **TestEnemyStateMachine.gml**: Enemy AI and states
6. **TestHighScoreSystem.gml**: High score management
7. **TestLevelProgression.gml**: Level progression logic
8. **TestBeamWeaponLogic.gml**: Tractor beam mechanics
9. **TestEnemyManagement.gml**: Enemy spawning and management

### Writing Tests

**Template**:
```gml
/// @function test_mySystem_specificBehavior
/// @description Tests that system does expected thing
function test_mySystem_specificBehavior() {
    var result = myFunction(test_input);
    assert_equals(result, expected_output, "myFunction should return expected output");
}
```

**Naming Convention**:
- `test_[SystemName]_[Behavior]`
- `test_waveSpawner_spawnsCorrectEnemyCount`
- `test_scoreManager_awardsExtraLifeAtMilestone`

### Test Results

Tests print to debug console with format:

```
[PASS] Test description
[FAIL] Test description
       Expected: value
       Actual:   value
```

Summary at end:
```
########################################
# TEST RESULTS SUMMARY
########################################
Total Tests:  45
Passed:       43 (95%)
Failed:       2
Duration:     125 ms
```

---

## Performance Optimization

### Current Optimizations

1. **AssetCache**: Caches asset_get_index() calls
   - Prevents string→asset conversions each frame
   - Expected: +5-10 FPS improvement
   - Cache hit rate: >95% after warmup

2. **ObjectPool**: Reuses instances
   - Eliminates create/destroy GC spikes
   - Missiles, enemy shots, explosions are pooled
   - Maintains consistent 60 FPS

3. **Enemy Count Caching**: Caches instance_number() calls
   - Called ~3+ times per frame without caching
   - Now called once, result stored in global.Game.Enemy.count
   - Reduces function call overhead

4. **Formation Breathing Animation**: Sin/cos calculation
   - Applied to 40 enemies each frame
   - Could be optimized with lookup table if performance needed

### Profiling Performance

**In-game Performance Monitoring**:
- Use `get_timer()` to measure frame time
- Log unusual spikes in debug output
- Profile before and after optimization

**Example**:
```gml
var t_start = get_timer();

// Code to profile
for (var i = 0; i < 1000; i++) {
    myFunction();
}

var t_end = get_timer();
var elapsed_ms = (t_end - t_start) / 1000;
show_debug_message("Elapsed: " + string(elapsed_ms) + " ms");
```

### Optimization Opportunities

1. **Formation Breathing**: Use lookup table instead of sin/cos
2. **Path System**: Cache path asset indices like AssetCache
3. **Path Following**: Could batch path updates
4. **Collision Detection**: Spatial partitioning for large enemy counts
5. **Particle System**: More sophisticated pooling

### Performance Targets

- **Framerate**: 60 FPS consistently
- **Memory**: <100 MB (modest arcade game)
- **Load Time**: <5 seconds
- **Frame Time**: <16.67 ms (1/60 second)

---

## Common Patterns & Examples

### Pattern 1: State Machine Implementation

**Template**:
```gml
// Initialization
current_state = STATE_ACTIVE;

// In Step event
switch (current_state) {
    case STATE_ACTIVE:
        // Handle active state
        if (condition) {
            current_state = STATE_PAUSED;
        }
        break;

    case STATE_PAUSED:
        // Handle paused state
        if (condition) {
            current_state = STATE_ACTIVE;
        }
        break;
}
```

**Real Example** (Enemy states):
```gml
// In oEnemyBase Step_0.gml
switch (enemyState) {
    case EnemyState.ENTER_SCREEN:
        // Follow entrance path
        if (path_index <= 0) {
            enemyState = EnemyState.MOVE_INTO_FORMATION;
        }
        break;

    case EnemyState.IN_FORMATION:
        // Breathing animation
        breathex = sin(global.Game.Anim.breath_cycle * 0.1) * 5;
        // Check for dive attack
        if (should_dive_attack()) {
            enemyState = EnemyState.IN_DIVE_ATTACK;
        }
        break;
}
```

### Pattern 2: Data-Driven Spawning

**Instead of**:
```gml
// DON'T DO THIS
instance_create_layer(100, 50, "GameSprites", oTieFighter);
instance_create_layer(150, 50, "GameSprites", oTieFighter);
instance_create_layer(200, 50, "GameSprites", oTieIntercepter);
// ... hardcoded 40 times
```

**Do this**:
```gml
// Load from JSON
var spawn_data = global.wave_spawn_data.PATTERN[0].WAVE[0].SPAWN;

for (var i = 0; i < array_length(spawn_data); i++) {
    var enemy_cfg = spawn_data[i];
    var enemy_type = asset_get_index(enemy_cfg.ENEMY);
    var path = asset_get_index(enemy_cfg.PATH);

    var enemy = instance_create_layer(
        enemy_cfg.SPAWN_XPOS,
        enemy_cfg.SPAWN_YPOS,
        "GameSprites",
        enemy_type
    );

    path_start(enemy, path, 5, path_action_continue, true);
}
```

### Pattern 3: Safe Asset Access

**Instead of**:
```gml
// Assumes asset exists, crashes if not
var path_id = asset_get_index("InvalidPath");
path_start(path_id, ...);  // CRASH!
```

**Do this**:
```gml
// Safe version with error handling
var path_id = get_cached_asset("InvalidPath");
if (path_id == -1) {
    log_error("Path not found: InvalidPath", "myFunction", 2);
    return false;  // Graceful failure
}
path_start(path_id, ...);
```

### Pattern 4: Score Management

```gml
// Initialize
score_manager = ScoreManager();

// Add score when enemy dies
var points = score_manager.addEnemyScore(
    enemy.ENEMY_NAME,
    base_points,
    enemy.enemyState == EnemyState.IN_DIVE_ATTACK
);

// Show points floating up
instance_create_layer(
    enemy.x, enemy.y, "UI",
    oPointsDisplay,
    { value: points }
);
```

### Pattern 5: Error Recovery

```gml
// Try to load data
if (!file_exists("datafiles/Patterns/wave_spawn.json")) {
    log_error("wave_spawn.json not found", "oGlobal.Create_0", 3);
    global.wave_spawn_data = { PATTERN: [] };  // Fallback
    return;  // Can't continue
}

var raw_json = string_lower(
    string_trim(
        buffer_read(
            buffer_load("datafiles/Patterns/wave_spawn.json"),
            buffer_text
        )
    )
);

global.wave_spawn_data = json_parse(raw_json);
log_error("wave_spawn.json loaded successfully", "oGlobal.Create_0", 1);
```

---

## Troubleshooting

### Common Issues & Solutions

#### Issue: "Asset not found" error at runtime

**Problem**: Path, sprite, or sound asset doesn't exist
**Solution**:
1. Check asset name spelling (case-sensitive)
2. Verify asset exists in project
3. Use `safe_get_asset()` instead of direct lookup
4. Check JSON configuration for correct asset names

#### Issue: Enemies not spawning

**Problem**: No enemies appear on screen
**Solution**:
1. Verify `wave_spawn.json` is loaded (check oGlobal initialization)
2. Confirm `oGameManager.wave_spawner` was created
3. Check game state (must be GAME_ACTIVE)
4. Verify spawn coordinates aren't off-screen (check SPAWN_XPOS/YPOS)
5. Run test: `runWaveSpawnerTests()`

#### Issue: Player movement feels unresponsive

**Problem**: Lag between input and movement
**Solution**:
1. Check that player Step event is executing
2. Verify input is being detected (add debug output)
3. Look for long-running loops in Update event
4. Profile with `get_timer()` to find bottleneck
5. Check framerate (should be 60 FPS)

#### Issue: Performance drops/stuttering

**Problem**: Framerate inconsistent
**Solution**:
1. Check for large loop iterations
2. Profile with `get_timer()` per system
3. Look for repeated `instance_number()` calls (should be cached)
4. Check asset lookups (should use AssetCache)
5. Verify Object Pool is reusing instances
6. Profile GC with built-in profiler

#### Issue: Game crashes during high score entry

**Problem**: Game crashes when entering initials
**Solution**:
1. Check that high score system is initialized
2. Verify string input validation
3. Look for array bounds errors
4. Check global.Game.Player struct exists

#### Issue: Challenge stages not triggering

**Problem**: Level 4, 8, etc. are regular waves, not challenges
**Solution**:
1. Verify `global.challcount` is incremented after each wave
2. Check challenge trigger condition: `global.challcount >= 4`
3. Verify ChallengeStageManager was created
4. Check `challenge_spawn.json` is loaded
5. Run test: `runScoreAndChallengeTests()`

### Debug Output

To enable verbose logging:

```gml
// In oGlobal Create_0.gml
DEBUG_MODE = true;

// Then in ErrorHandling.gml
function log_error(_error_msg, _context = "Unknown", _severity = 2) {
    if (DEBUG_MODE || _severity >= 2) {
        show_debug_message("[" + _context + "] " + _error_msg);
    }
}
```

### Testing & Validation

Run automated tests to validate systems:

```gml
// In debug room, Create event
setupTestEnvironment();

runWaveSpawnerTests();
runCollisionSystemTests();
runEnemyStateMachineTests();
runScoreAndChallengeTests();

teardownTestEnvironment();
```

---

## Contributing Guidelines

### Before Making Changes

1. **Create a branch**: `git checkout -b feature/my-feature`
2. **Understand existing code**: Read relevant sections of this guide
3. **Check BUGS.md**: Verify bug isn't already known
4. **Run tests**: Ensure current tests pass

### When Making Changes

1. **Add comments** for non-obvious logic
2. **Follow code style** (see Code Style Guide section)
3. **Update documentation** if behavior changes
4. **Add tests** for new functionality
5. **Profile performance** for critical paths

### Before Committing

1. **Run all tests**: Ensure nothing breaks
2. **Clean up debug code**: Remove temporary logging
3. **Write clear commit message**: Describe what changed and why
4. **Reference issues**: Link to relevant GitHub issues

### Pull Request Checklist

- [ ] Tests pass locally
- [ ] Code follows style guide
- [ ] Comments explain complex logic
- [ ] Documentation updated (if applicable)
- [ ] No performance regressions
- [ ] Commit messages are clear

---

## Glossary

- **State Machine**: System that transitions between defined states
- **Pooling**: Reusing objects instead of creating/destroying
- **Asset Cache**: Storing frequently-used asset lookups
- **GC (Garbage Collection)**: Automatic memory cleanup (can cause stuttering)
- **Formation Grid**: 5×8 layout of enemy positions
- **Dive Attack**: Aggressive downward attack pattern
- **Loop Attack**: Return path from dive back to formation
- **Challenge Stage**: Special bonus stage with unique enemies
- **Rogue Enemy**: Enemy that ignores formation, targets player
- **Tractor Beam**: Enemy capture mechanic

---

## Additional Resources

- **GameMaker Documentation**: https://docs.yoyogames.com/
- **GML Reference**: https://docs.yoyogames.com/source/dadiospice/002_reference/gml_overview/gml_overview.html
- **Galaga Strategy**: https://en.wikipedia.org/wiki/Galaga
- **Game Design Patterns**: https://gameprogrammingpatterns.com/

---

**Last Updated:** November 2024
**Maintained By:** Development Team
**License:** [Your License Here]
