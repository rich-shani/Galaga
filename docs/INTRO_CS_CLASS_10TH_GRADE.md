# Introduction to Computer Science: Game Design & Programming
## Galaga Wars - A Complete Game Codebase Study
### For 10th Grade Computer Science Students

---

## Table of Contents
1. **Opening & Game History (5 min)**
2. **What is GameMaker? (5 min)**
3. **The Codebase: A Real Game (5 min)**
4. **Key Programming Concepts (20 min)**
5. **Design Patterns in Action (15 min)**
6. **Live Code Walkthrough (5 min)**
7. **Testing & Error Handling (3 min)**
8. **Q&A & Challenges (2 min)**

**Total: 60 minutes**

---

# PART 1: OPENING & GAME HISTORY (5 min)

## Welcome!

### What We're Going to Learn Today

Today, we're exploring **real game code** that was actually shipped to players. You'll see how professional programmers structure games, handle thousands of moving objects, and build systems that scale.

By the end of this class, you'll understand:
- ✓ How games are organized
- ✓ Object-oriented programming in action
- ✓ Professional coding patterns
- ✓ Why good design matters

**This is not a simplified tutorial - this is production code.**

---

## A Brief History of Galaga

### The Original: Galaga (1981)

**Basic Facts:**
- Released by Namco in 1981
- One of the most iconic arcade games ever
- Gameplay: Defend your ship from enemy waves
- Simple but addictive mechanics
- Millions of quarters spent in arcades

**Why was it revolutionary?**
- First game where enemies had "personality" (diving attacks)
- Formation system (enemies in grid, break formation)
- Tractor beam to capture your ship
- Progressive difficulty
- Replayability through high score chasing

**Original Hardware:**
```
Processor: Zilog Z80 (3.1 MHz)
Memory: 4 KB RAM
Graphics: 224×288 pixels
Sound: Simple synthesized beeps
```

*For comparison: Your smartphone is 1,000,000x more powerful.*

---

## Modern Remake: Galaga Wars (Star Wars Edition)

### Why This Version?

The codebase you're studying is **Galaga Wars** - a modern reimagining of the 1981 classic with a Star Wars theme.

**Changes from original:**
- TIE Fighters instead of Alien ships
- X-Wing instead of Spaceship
- 60 FPS instead of arcade hardware
- Professional graphics and audio
- Data-driven design (no hardcoding)
- Comprehensive error handling
- Automated testing

### Key Stats

| Metric | Value |
|--------|-------|
| Lines of Code | 11,000+ |
| Game Objects | 30+ |
| Script Modules | 50+ |
| Test Suites | 9 |
| JSON Config Files | 10+ |
| Animation Paths | 100+ |
| Time to Build | ~6 months |

---

## The Arcade Experience vs. Modern Code

### What Changed?

| 1981 Galaga | Galaga Wars 2024 |
|-------------|------------------|
| Hardcoded enemy waves | JSON configuration files |
| Minimal error checking | Comprehensive error handling |
| Simple state machine | 12-state game state machine |
| Manual memory management | Object pooling & cleanup |
| No testing framework | 9 test suites with 2000+ lines |
| Single difficulty | Adaptive difficulty scaling |

---

# PART 2: WHAT IS GAMEMAKER? (5 min)

## Understanding Game Engines

### What is a Game Engine?

A game engine is **software that handles the hard stuff** so you can focus on game design.

**Without an engine, you'd code:**
- Graphics rendering
- Physics simulation
- Collision detection
- Input handling
- Audio management
- Memory management

**With an engine, you just code:**
- Game logic
- Enemy behavior
- Score system
- UI

---

## GameMaker Studio 2

### What is It?

**GameMaker Studio 2** is a commercial game engine by YoYo Games.

**Who uses it?**
- Indie developers (Cuphead, Hyper Light Drifter)
- Educational institutions
- Professional studios
- Hobbyists

### Key Features

| Feature | What It Does |
|---------|-------------|
| **Visual Editor** | Drag-and-drop rooms, objects, sprites |
| **GML Language** | GameMaker Language (similar to JavaScript) |
| **Events System** | Create, Step, Draw, Collision, Destroy |
| **Paths** | Visual path editor for choreographed movement |
| **Physics** | Built-in physics engine (optional) |
| **Multiplayer** | Networking support |
| **Export** | Windows, Mac, Linux, HTML5, iOS, Android |

### GameMaker Language (GML)

GML is similar to JavaScript but designed for games.

```gml
// Simple example
var enemy_speed = 5;
x += enemy_speed;  // Move right each frame

if (x > room_width) {
    instance_destroy();  // Remove when off-screen
}
```

---

## Why GameMaker for Learning?

### Perfect for Beginners

1. **Visual + Code** - Combine drag-and-drop with scripting
2. **Quick Feedback** - See changes immediately
3. **Real Game Engine** - Used by professionals
4. **Extensive Docs** - Excellent tutorials and documentation
5. **Community** - Large community with examples

### Perfect for Production

The Galaga Wars codebase shows GameMaker can handle:
- Hundreds of moving objects
- Complex state management
- Professional architecture
- Shipped commercial games

---

# PART 3: THE CODEBASE - A REAL GAME (5 min)

## Project Organization

```
Galaga/
├── objects/               (30+ game entities)
│   ├── oGameManager/      (main controller)
│   ├── oEnemyBase/        (base enemy class)
│   ├── oTieFighter/       (enemy type 1)
│   ├── oTieIntercepter/   (enemy type 2)
│   ├── oImperialShuttle/  (boss enemy)
│   ├── oPlayer/           (player ship)
│   └── ... UI objects
│
├── scripts/               (50+ modules, 8,302 lines)
│   ├── GameManager_STEP_FNs.gml    (game loop)
│   ├── ErrorHandling.gml            (robust code)
│   ├── WaveSpawner.gml              (enemy spawning)
│   ├── CollisionHelpers.gml         (collision detection)
│   ├── ObjectPool.gml               (performance)
│   ├── AudioManager.gml             (sound)
│   ├── TestFramework.gml            (testing)
│   └── ... 40+ more
│
├── datafiles/             (configuration in JSON)
│   ├── game_config.json         (all settings)
│   ├── wave_spawn.json          (enemy waves)
│   ├── challenge_spawn.json     (bonus stages)
│   └── formation_coordinates.json (grid positions)
│
├── rooms/                 (game levels)
│   ├── SplashScreen/
│   ├── GalagaWars/       (main game)
│   └── TitleScreen/
│
├── paths/                 (100+ movement patterns)
├── sprites/               (320+ images)
└── sounds/                (25+ audio files)
```

---

## Code Statistics

### Breakdown by Component

```
Game Logic Components:
  ├─ GameManager (main controller)      :  ~500 lines
  ├─ Enemy Behavior & AI                :  ~600+ lines
  ├─ Player Ship & Input                :  ~300+ lines
  ├─ Collision System                   :  ~200 lines
  ├─ Score & Progression                :  ~250 lines
  └─ Audio Management                   :  ~200 lines

Infrastructure:
  ├─ Error Handling                     :  ~550 lines
  ├─ Object Pooling                     :  ~150 lines
  ├─ Asset Caching                      :  ~100 lines
  └─ UI & HUD Rendering                 :  ~400 lines

Testing:
  ├─ Test Framework                     :  ~549 lines
  └─ 9 Test Suites                      :  ~2,000 lines

Total Production Code:  ~3,500 lines
Total Test Code:       ~2,000 lines
Total:                 ~5,500 lines (excluding config)
```

### What This Means

- Small enough to understand in one semester
- Large enough to see real patterns
- Well-organized for learning
- Actually played and reviewed by players

---

# PART 4: KEY PROGRAMMING CONCEPTS (20 min)

## Concept 1: State Machines (Most Important!)

### What is a State Machine?

A **state machine** is a system that can be in one of several states, and transitions between them in defined ways.

**Real-world example: Traffic Light**

```
🔴 RED
 ↓ (30 seconds)
🟡 YELLOW
 ↓ (5 seconds)
🟢 GREEN
 ↓ (25 seconds)
🔴 RED (back to start)
```

Only one state at a time. Clear transitions. No invalid combinations.

---

### Game State Machine (12 States)

Galaga Wars has a similar state machine for game flow:

```
INITIALIZE
    ↓
ATTRACT_MODE (title screen)
    ↓
INSTRUCTIONS
    ↓
GAME_PLAYER_MESSAGE (show level number)
    ↓
GAME_STAGE_MESSAGE (get ready)
    ↓
SPAWN_ENEMY_WAVES
    ↓
GAME_ACTIVE ← Main gameplay happens here
    ↓
SHOW_RESULTS (wave complete)
    ↓
ENTER_INITIALS (high score entry)
    ↓
CHALLENGE_STAGE_MESSAGE (bonus round)
    ↓
Back to ATTRACT_MODE
```

### Implementation in Code

```gml
// Using an ENUM (enumerated type)
enum GameMode {
    INITIALIZE,
    ATTRACT_MODE,
    INSTRUCTIONS,
    GAME_PLAYER_MESSAGE,
    GAME_STAGE_MESSAGE,
    SPAWN_ENEMY_WAVES,
    GAME_ACTIVE,
    SHOW_RESULTS,
    ENTER_INITIALS,
    CHALLENGE_STAGE_MESSAGE,
    GAME_PAUSED
}

// In Game Loop - switch between states
switch(global.gameMode) {
    case GameMode.ATTRACT_MODE:
        // Show title screen, wait for player
        draw_title_screen();
        if (keyboard_check_pressed(vk_space)) {
            global.gameMode = GameMode.INSTRUCTIONS;
        }
        break;

    case GameMode.GAME_ACTIVE:
        // Main gameplay
        Game_Loop();
        break;

    case GameMode.SHOW_RESULTS:
        // Show wave complete screen
        draw_results();
        if (alarm[ADVANCE_TIMER] == 0) {
            global.gameMode = GameMode.ENTER_INITIALS;
        }
        break;
}
```

### Why State Machines?

| Benefit | Example |
|---------|---------|
| **Clear Logic** | Only one state at a time (can't be PLAYING and PAUSED) |
| **Easy Debugging** | Know exactly where you are in game flow |
| **Self-Documenting** | Names explain intent (GAME_ACTIVE, SHOW_RESULTS) |
| **Scalable** | Easy to add new states |
| **Professional** | Used in all major game engines |

---

## Concept 2: Object-Oriented Programming (Inheritance)

### The Problem: Code Duplication

Imagine we have 3 enemy types: TieFighter, TieIntercepter, ImperialShuttle.

Without inheritance, we'd write this 3 times:

```gml
// TieFighter code
function TieFighter_Create() {
    // Movement
    speed = 6;

    // Formation
    grid_x = 0;
    grid_y = 0;

    // Attack
    can_dive = true;
    dive_timer = 0;

    // Health
    health = 1;

    // Animation
    sprite = sprite_index;
}

// Then repeat for TieIntercepter...
// Then repeat for ImperialShuttle...
// 600+ lines of duplicated code!
```

### The Solution: Inheritance

**Parent Class (oEnemyBase)** - Shared code for ALL enemies:

```gml
function oEnemyBase_Create() {
    // Movement (shared)
    baseSpeed = 6;
    moveSpeed = baseSpeed * global.speedMultiplier;

    // State machine (shared)
    enemyState = EnemyState.ENTER_SCREEN;

    // Formation (shared)
    formation = global.formation_data;
    xstart = formation.POSITION[INDEX]._x;
    ystart = formation.POSITION[INDEX]._y;

    // Path following (shared)
    var path_id = safe_get_asset(PATH_NAME, -1);
    if (path_id != -1) {
        path_start(path_id, entranceSpeed, 0, 0);
    }

    // Health (shared)
    hitCount = safe_struct_get(attributes, "HEALTH", 1);
}
```

**Child Classes** - Only unique properties:

```gml
// oTieFighter/Create_0.gml (just 3 lines!)
ENEMY_NAME = "oTieFighter";
INDEX = spawn_index;
PATH_NAME = entrance_path;

// oTieIntercepter/Create_0.gml (also 3 lines!)
ENEMY_NAME = "oTieIntercepter";
INDEX = spawn_index;
PATH_NAME = entrance_path;

// oImperialShuttle/Create_0.gml (also 3 lines!)
ENEMY_NAME = "oImperialShuttle";
INDEX = spawn_index;
PATH_NAME = entrance_path;
```

### The Inheritance Hierarchy

```
         oEnemyBase
        /    |      \
       /     |       \
  oTieFighter | oTieIntercepter | oImperialShuttle

All three "inherit from" (are subclasses of) oEnemyBase
All three share the code in oEnemyBase
All three override what they need to be unique
```

### Why This Matters

| Without Inheritance | With Inheritance |
|-------------------|-----------------|
| 3 × 200 = 600 lines | 200 shared + 3×3 = 209 lines |
| Change formation? 3 places | Change formation? 1 place |
| Copy-paste errors | Single source of truth |
| Hard to add 4th enemy type | Easy to add 4th type |

**Result: Code is 3× smaller, easier to maintain, less buggy.**

---

## Concept 3: Data-Driven Design

### The Problem: Hardcoding

```gml
// BAD: Hardcoded enemy wave
function spawn_wave_1() {
    spawn_enemy("oTieFighter", 100, -20, "Path1");
    spawn_enemy("oTieFighter", 200, -20, "Path1");
    spawn_enemy("oTieFighter", 300, -20, "Path1");
    spawn_enemy("oTieIntercepter", 150, -20, "Path2");
    spawn_enemy("oTieIntercepter", 250, -20, "Path2");
    spawn_enemy("oTieIntercepter", 350, -20, "Path2");
    // ... 34 more enemies hardcoded ...
    // To change the wave, you must:
    // 1. Edit this file
    // 2. Recompile
    // 3. Wait 30 seconds
    // 4. Test
}
```

**Problems:**
- Takes 30+ seconds to test a change
- Non-programmers can't design levels
- Easy to make typos
- Hard to version control

### The Solution: Data-Driven Design (JSON)

Store wave configuration in **JSON files** instead of code:

```json
{
  "PATTERN": [
    {
      "WAVE": [
        {
          "SPAWN": [
            {
              "ENEMY": "oTieFighter",
              "SPAWN_XPOS": 100,
              "SPAWN_YPOS": -20,
              "INDEX": 1,
              "PATH": "Path1",
              "COMBINE": false
            },
            {
              "ENEMY": "oTieFighter",
              "SPAWN_XPOS": 200,
              "SPAWN_YPOS": -20,
              "INDEX": 2,
              "PATH": "Path1",
              "COMBINE": false
            }
            // ... more spawns ...
          ]
        }
      ]
    }
  ]
}
```

### How It Works

```gml
// GOOD: Data-driven spawning
function spawnEnemy() {
    // Read from JSON
    var enemy_data = spawn_data.PATTERN[global.pattern]
                                      .WAVE[global.wave]
                                      .SPAWN[global.spawnCounter];

    // Get the enemy type
    var enemy_id = safe_get_asset(enemy_data.ENEMY, -1);

    if (enemy_id != -1) {
        // Create it
        instance_create_layer(
            enemy_data.SPAWN_XPOS,
            enemy_data.SPAWN_YPOS,
            "GameSprites",
            enemy_id,
            {
                ENEMY_NAME: enemy_data.ENEMY,
                INDEX: enemy_data.INDEX,
                PATH_NAME: enemy_data.PATH
            }
        );
    }
}
```

### Benefits of Data-Driven Design

| Benefit | Impact |
|---------|--------|
| **Instant Testing** | Change JSON, refresh in 1 second |
| **No Programming Required** | Designers can modify JSON |
| **Version Control** | Diffs show exactly what changed |
| **Easy Modding** | Players can create custom waves |
| **Scalable** | Support 100 waves without new code |

---

## Concept 4: Enums (Making Code Readable)

### The Problem: Magic Numbers

```gml
// What does this even mean?
if (global.gameMode == 0) { ... }
if (global.gameMode == 1) { ... }
if (enemy_state == 3) { ... }

// Later, someone else changes it:
if (global.gameMode == 1) { ... }  // Did they swap modes? Bug?
```

### The Solution: Enums

```gml
// Define meaningful names
enum GameMode {
    INITIALIZE,           // 0
    ATTRACT_MODE,         // 1
    INSTRUCTIONS,         // 2
    GAME_PLAYER_MESSAGE,  // 3
    GAME_STAGE_MESSAGE,   // 4
    SPAWN_ENEMY_WAVES,    // 5
    GAME_ACTIVE,          // 6
    SHOW_RESULTS,         // 7
    ENTER_INITIALS,       // 8
    CHALLENGE_STAGE_MESSAGE, // 9
    GAME_PAUSED           // 10
}

// Now code is self-documenting!
if (global.gameMode == GameMode.GAME_ACTIVE) { ... }   // Clear!
if (enemy_state == EnemyState.IN_FORMATION) { ... }    // Obvious!
```

### Enemy States (Another Enum)

```gml
enum EnemyState {
    ENTER_SCREEN,           // Following entrance path
    MOVE_INTO_FORMATION,    // Moving to grid position
    IN_FORMATION,           // Waiting in formation
    RETURN_PATH,            // Coming back from dive
    IN_DIVE_ATTACK,         // Diving at player
    IN_LOOP_ATTACK,         // Looping back up
    IN_FINAL_ATTACK         // Last few enemies, aggressive
}

// In code:
if (enemyState == EnemyState.IN_FORMATION) {
    apply_breathing_animation();
}
```

### Why Enums Matter

1. **Self-Documenting** - Code explains itself
2. **Typo Prevention** - IDE autocomplete suggests options
3. **Easier Refactoring** - Rename one place, everywhere updates
4. **Professional** - Industry standard everywhere

---

## Concept 5: Error Handling (Robust Code)

### The Problem: Undefended Code

```gml
// RISKY: What if asset doesn't exist?
var enemy_id = asset_get_index("oWrongEnemyName");
instance_create_layer(x, y, "GameSprites", enemy_id);
// CRASH! enemy_id is -1, not a valid object

// What if JSON file is missing?
var data = json_parse_file("missing_file.json");
// CRASH! Can't parse non-existent file

// What if array index out of bounds?
var value = my_array[999];  // Array only has 10 items
// Undefined behavior or crash
```

### The Solution: Defensive Programming

Use **safe functions** that validate input and return defaults:

```gml
/// @function safe_get_asset
/// Safely retrieves an asset with error checking
function safe_get_asset(_asset_name, _default = -1) {
    // Step 1: Validate input
    if (!is_string(_asset_name) || string_length(_asset_name) == 0) {
        log_error("Invalid asset name", "safe_get_asset", 2);
        return _default;
    }

    // Step 2: Try to get asset
    var _asset_id = asset_get_index(_asset_name);

    // Step 3: Check if it exists
    if (_asset_id == -1) {
        log_error("Asset not found: " + _asset_name, "safe_get_asset", 1);
        return _default;  // Return safe default
    }

    // Step 4: Return valid result
    return _asset_id;
}

// Usage:
var enemy_id = safe_get_asset("oTieFighter", -1);
if (enemy_id != -1) {
    instance_create_layer(x, y, "GameSprites", enemy_id);  // Safe!
} else {
    log_error("Failed to spawn enemy", "spawn_function", 2);
}
```

### Safe Functions Library

Galaga Wars includes many safe functions:

```gml
safe_get_asset(asset_name, default)
safe_load_json(filepath, default)
safe_struct_get(struct, key, default)
safe_array_get(array, index, default)
safe_instance_number(object)
validate_json_structure(data, required_keys, context)
```

### The Difference

| Without Error Handling | With Error Handling |
|----------------------|-------------------|
| Game crashes | Game continues |
| Player frustrated | Player sees error in log |
| No information | Detailed error message |
| Hard to debug | Easy to debug |

---

# PART 5: DESIGN PATTERNS IN ACTION (15 min)

## Pattern 1: Object Pooling (Performance)

### The Problem: Garbage Collection Stutters

```gml
// Every frame, enemies fire shots
for (var i = 0; i < 40; i++) {
    enemy[i].fire_shot();  // Create new shot
}
// 40 new instances created per frame
// After 5 seconds: 240,000+ instances created
// Memory allocation/deallocation = frame rate drops
```

### The Solution: Object Pooling

Pre-create a pool of objects and reuse them:

```gml
/// @function ObjectPool
/// Reusable object pool to avoid garbage collection
function ObjectPool(_object_type, _initial_size = 50) constructor {
    object_type = _object_type;
    inactive_pool = ds_list_create();  // Reusable objects
    active_instances = ds_list_create();

    // Pre-create 50 instances (not activated)
    repeat(_initial_size) {
        var inst = instance_create_layer(0, 0, "Hidden", _object_type);
        instance_deactivate_object(inst);
        ds_list_add(inactive_pool, inst);
    }
}

/// Acquire an object (activate and position)
function acquire(x, y) {
    var inst;

    if (ds_list_size(inactive_pool) > 0) {
        // Reuse from pool
        inst = inactive_pool[| 0];
        ds_list_delete(inactive_pool, 0);
        instance_activate_object(inst);
    } else {
        // Create new if pool empty
        inst = instance_create_layer(x, y, "Projectiles", object_type);
    }

    // Position and add to active list
    inst.x = x;
    inst.y = y;
    ds_list_add(active_instances, inst);
    return inst;
}

/// Release an object (return to pool)
function release(inst) {
    instance_deactivate_object(inst);
    ds_list_add(inactive_pool, inst);
}
```

### How It Works

```
Initialization:
  Pool: [Missile1, Missile2, Missile3, ... Missile50]

Frame 1 (player fires):
  Pool: [Missile2, Missile3, ... Missile50]
  Active: [Missile1 (at player position)]

Frame 2 (player fires again):
  Pool: [Missile3, ... Missile50]
  Active: [Missile1, Missile2]

Player's missile hits enemy (returns to pool):
  Pool: [Missile1, Missile3, ... Missile50]
  Active: [Missile2]

Frame 3 (player fires again, reuses Missile1):
  Pool: [Missile3, ... Missile50]
  Active: [Missile2, Missile1]
```

### Impact

```
Without Pooling:
  60 frames × 40 enemies × 1 shot = 2,400 creations per second
  Garbage collection hiccups → FPS drops from 60 to 30

With Pooling:
  50 objects created once at startup
  Reused endlessly
  0 garbage collection → smooth 60 FPS
```

---

## Pattern 2: Event-Driven Architecture

### GameMaker Event System

GameMaker objects respond to events at specific times:

```gml
// CREATE EVENT - Runs when object is created
function Create_0() {
    health = 100;
    speed = 5;
    ammo = 30;
}

// STEP EVENT - Runs every frame (60 times per second)
function Step_0() {
    // Move
    x += speed;

    // Fire weapon
    if (ammo > 0 && alarm[FIRE_TIMER] == -1) {
        fire_weapon();
        alarm[FIRE_TIMER] = 30;
    }
}

// DRAW EVENT - Runs every frame after Step
function Draw_0() {
    draw_sprite(sprite_index, image_index, x, y);
    draw_text(x, y + 20, "Health: " + string(health));
}

// COLLISION EVENT - Runs when touching another object
function Collision_oMissile() {
    health -= 10;
    if (health <= 0) {
        instance_destroy();
    }
}

// DESTROY EVENT - Runs when object is deleted
function Clean Up_0() {
    // Cleanup: remove from lists, release resources
    ds_list_delete(global.enemies, ds_list_find_index(global.enemies, id));
}
```

### Object Lifecycle Diagram

```
                    ╔═══════════════════╗
                    ║  CREATE EVENT     ║
                    ║  (1 time)         ║
                    ╚═════════╤═════════╝
                              │
              ┌───────────────┴───────────────┐
              │                               │
        ╔═════▼════════╗             ╔════════▼═════╗
        ║ STEP EVENT   ║ ◄─────────► ║ DRAW EVENT   ║
        ║ (60× per sec)║             ║ (60× per sec)║
        ╚═════╤════════╝             ╚════════╤═════╝
              │                               │
        ┌─────┼───────────────────────────────┤
        │ COLLISION EVENTS                    │
        │ (When touching other objects)       │
        │                                     │
        └─────┬──────────────────────────────┘
              │
        ╔═════▼═══════════════╗
        ║ DESTROY EVENT       ║
        ║ (1 time)            ║
        ║ Cleanup & Resources ║
        ╚═════════════════════╝
```

### Event Example: Enemy Movement

```gml
// CREATE - Initialize
function Create_0() {
    x = 0;
    y = 0;
    speed = 3;
    angle = 0;
}

// STEP - Update logic every frame
function Step_0() {
    // Move in a circle
    angle += 2;  // Rotate 2 degrees per frame
    x = 256 + cos(angle) * 100;
    y = 256 + sin(angle) * 100;
}

// DRAW - Render sprite
function Draw_0() {
    draw_sprite_ext(
        sprite_index,
        image_index,
        x, y,
        1, 1,  // scale
        angle,  // rotation
        c_white,
        1  // alpha
    );
}

// COLLISION - Hit by player shot
function Collision_oMissile() {
    // Create explosion effect
    instance_create_layer(x, y, "Effects", oExplosion);
    instance_destroy();  // Remove this enemy
}
```

---

## Pattern 3: State Machines Within Objects

### Enemy State Machine

Just like the game has states (ATTRACT, ACTIVE, PAUSED), enemies have states:

```gml
enum EnemyState {
    ENTER_SCREEN,           // Following path into view
    MOVE_INTO_FORMATION,    // Moving to grid position
    IN_FORMATION,           // Waiting in 5×8 grid
    RETURN_PATH,            // Coming back from dive
    IN_DIVE_ATTACK,         // Actively diving
    IN_LOOP_ATTACK,         // Looping back up
    IN_FINAL_ATTACK         // Last enemies, aggressive
}

// In Step event
function Step_0() {
    switch(enemyState) {
        case EnemyState.ENTER_SCREEN:
            // Path is handled automatically by GameMaker
            // Check if finished
            if (path_position >= 1) {
                path_end();
                enemyState = EnemyState.MOVE_INTO_FORMATION;
            }
            break;

        case EnemyState.MOVE_INTO_FORMATION:
            // Smoothly move to grid position
            x = lerp(x, xstart, 0.05);
            y = lerp(y, ystart, 0.05);

            if (distance_to_point(xstart, ystart) < 5) {
                enemyState = EnemyState.IN_FORMATION;
            }
            break;

        case EnemyState.IN_FORMATION:
            // Breathing animation + random dive
            apply_breathing_animation();

            if (global.divecap > 0 && irandom(5) == 0) {
                enemyState = EnemyState.IN_DIVE_ATTACK;
                start_dive_attack();
            }
            break;

        case EnemyState.IN_DIVE_ATTACK:
            // Follow dive path
            if (path_position >= 1) {
                path_end();
                enemyState = EnemyState.IN_LOOP_ATTACK;
            }
            break;
    }
}
```

### Visualization

```
Enemy Progress Through States

Frame 0:      ENTER_SCREEN (following path from top)
              ↓
Frames 10-30: Moving along path
              ↓
Frame 30:     Reached formation, switch to MOVE_INTO_FORMATION
              ↓
Frames 31-60: Smoothly move to grid position [3, 2]
              ↓
Frame 60:     Reached position, switch to IN_FORMATION
              ↓
Frames 61+:   Breathing animation, waiting...
              ↓
Frame 85:     Random check says "dive!", switch to IN_DIVE_ATTACK
              ↓
Frames 86-150: Following dive path (swooping down and back)
              ↓
Frame 150:    Finished dive path, switch to IN_LOOP_ATTACK
              ↓
Frame 155:    Looped back, switch back to IN_FORMATION
              ↓
Breathing animation, waiting for next dive...
```

---

## Pattern 4: Formation System

### Grid-Based Positioning

Enemies organize in a 5×8 grid (40 positions):

```
[1]  [2]  [3]  [4]  [5]
[6]  [7]  [8]  [9]  [10]
[11] [12] [13] [14] [15]
[16] [17] [18] [19] [20]
[21] [22] [23] [24] [25]
[26] [27] [28] [29] [30]
[31] [32] [33] [34] [35]
[36] [37] [38] [39] [40]
```

### How Spawning Assigns Grid Positions

```gml
// Wave data specifies which grid position
var spawn_data = {
    ENEMY: "oTieFighter",
    INDEX: 5,  // Position 5 in the grid
    PATH: "entrance_path",
    SPAWN_XPOS: 256,
    SPAWN_YPOS: -20
};

// Create enemy with INDEX
var new_enemy = instance_create_layer(...);
new_enemy.INDEX = spawn_data.INDEX;  // Assign grid position

// In enemy's Create event:
function Create_0() {
    // Load grid coordinates from JSON
    formation = global.formation_data;  // 40 positions
    xstart = formation.POSITION[INDEX]._x;   // Position 5's X
    ystart = formation.POSITION[INDEX]._y;   // Position 5's Y
}

// In MOVE_INTO_FORMATION state:
function Step_0() {
    if (enemyState == EnemyState.MOVE_INTO_FORMATION) {
        x = lerp(x, xstart, 0.05);  // Smoothly move to xstart
        y = lerp(y, ystart, 0.05);  // Smoothly move to ystart
    }
}
```

### Result

Every enemy knows its grid position and smoothly moves there. The grid breathes as one unit. Makes formation look alive!

---

# PART 6: LIVE CODE WALKTHROUGH (5 min)

## How an Enemy Gets Created (Complete Flow)

### Step 1: Game Loop Decides to Spawn

```gml
// In GameManager Step event
function Game_Loop() {
    // ... other stuff ...

    // Spawn enemies if more remain in this wave
    if (!waveComplete()) {
        if (alarm[SPAWN_TIMER] == -1) {
            spawnEnemy();  // Call spawn function!
            alarm[SPAWN_TIMER] = 10;  // Wait 10 frames
        }
    }
}
```

---

### Step 2: Spawn Function Reads JSON

```gml
function spawnEnemy() {
    // Navigate nested JSON structure
    var spawn_data = spawn_data.PATTERN[global.pattern]
                               .WAVE[global.wave]
                               .SPAWN[global.spawnCounter];

    // spawn_data now contains:
    // {
    //   ENEMY: "oTieFighter",
    //   SPAWN_XPOS: 256,
    //   SPAWN_YPOS: -20,
    //   INDEX: 5,
    //   PATH: "Ent_Top_L2R"
    // }

    // Increment for next call
    global.spawnCounter++;
}
```

---

### Step 3: Safely Get Enemy Type

```gml
// Get the enemy object type with error handling
var enemy_id = safe_get_asset(spawn_data.ENEMY, -1);

if (enemy_id == -1) {
    // Enemy doesn't exist, log error, continue
    log_error("Enemy type not found: " + spawn_data.ENEMY,
              "spawnEnemy", 2);
    return;  // Don't crash, just skip
}
```

---

### Step 4: Create Enemy Instance

```gml
// Create the enemy with initialization data
instance_create_layer(
    spawn_data.SPAWN_XPOS,      // Starting X
    spawn_data.SPAWN_YPOS,      // Starting Y (-20 = above screen)
    "GameSprites",              // Which layer
    enemy_id,                   // Which object type
    {
        ENEMY_NAME: spawn_data.ENEMY,      // "oTieFighter"
        INDEX: spawn_data.INDEX,           // Grid position (5)
        PATH_NAME: spawn_data.PATH,        // Entrance path
        MODE: EnemyMode.STANDARD           // Standard wave
    }
);

// 4th parameter is initialization struct
// Gets passed to Create event automatically
```

---

### Step 5: Enemy's Create Event Runs

```gml
// oEnemyBase/Create_0.gml
function Create_0() {
    // Called automatically when instance created

    // Load attributes from JSON based on type
    attributes = safe_struct_get(
        global.enemy_attributes,
        ENEMY_NAME,
        {}
    );

    // Get health from attributes
    hitCount = safe_struct_get(attributes, "HEALTH", 1);

    // Initialize state
    enemyState = EnemyState.ENTER_SCREEN;

    // Get formation position
    formation = global.formation_data;
    xstart = formation.POSITION[INDEX]._x;
    ystart = formation.POSITION[INDEX]._y;

    // Start following entrance path
    var path_id = safe_get_asset(PATH_NAME, -1);
    if (path_id != -1) {
        path_start(path_id, 4, path_action_stop, false);
    }
}
```

---

### Step 6: Every Frame - Step & Draw Events

```gml
// oEnemyBase/Step_0.gml
function Step_0() {
    // Check current state
    switch(enemyState) {
        case EnemyState.ENTER_SCREEN:
            // Path moves automatically
            // Check if path finished
            if (path_position >= 1) {
                path_end();
                enemyState = EnemyState.MOVE_INTO_FORMATION;
            }
            break;

        case EnemyState.MOVE_INTO_FORMATION:
            // Smoothly move to grid position
            x = lerp(x, xstart, 0.05);
            y = lerp(y, ystart, 0.05);

            if (distance_to_point(xstart, ystart) < 5) {
                enemyState = EnemyState.IN_FORMATION;
            }
            break;

        case EnemyState.IN_FORMATION:
            // Apply breathing animation
            breath_angle += 0.02;
            breathex = sin(breath_angle) * 2;
            breathey = cos(breath_angle) * 2;

            // Randomly dive
            if (global.divecap > 0 && irandom(100) < 2) {
                enemyState = EnemyState.IN_DIVE_ATTACK;
            }
            break;
    }
}

// oEnemyBase/Draw_0.gml
function Draw_0() {
    // Draw with breathing offset
    draw_sprite_ext(
        sprite_index,
        image_index,
        x + breathex,
        y + breathey,
        1, 1,          // scale
        0,             // rotation
        c_white,       // color
        1              // alpha
    );
}
```

---

### Step 7: Collision Event (If Hit by Missile)

```gml
// oEnemyBase/Collision_oMissile.gml
function Collision_oMissile() {
    other.instance_destroy();  // Destroy the missile

    hitCount--;  // Damage the enemy

    if (hitCount <= 0) {
        // Enemy destroyed!
        score_add(points_value);  // Award points

        // Create explosion effect
        instance_create_layer(x, y, "Effects", oExplosion);

        // Destroy this enemy
        instance_destroy();
    }
}
```

---

### Complete Lifecycle Summary

```
TIME 0ms:     spawnEnemy() called
              ↓
              safe_get_asset("oTieFighter") → returns valid ID
              ↓
              instance_create_layer() creates enemy at (256, -20)
              ↓
TIME 0.1ms:   Create_0() runs:
              - enemyState = ENTER_SCREEN
              - Load attributes from JSON
              - path_start() begins entrance path
              ↓
TIME ~300ms:  Enemy entering formation
              (Step event: path moves automatically)
              (Draw event: rendered every frame)
              ↓
TIME ~600ms:  Reached formation grid position
              enemyState = MOVE_INTO_FORMATION → IN_FORMATION
              ↓
TIME ~1000ms: Enemy in formation, breathing
              (Might dive randomly)
              ↓
TIME ~2000ms: If hit by player missile:
              - Collision_oMissile() runs
              - hitCount decreases
              - If health = 0:
                - Create explosion
                - instance_destroy()
                ↓
TIME ~2001ms: Destroy event runs (if defined)
              - Clean up resources
              ↓
TIME ~2002ms: Enemy completely gone from memory
```

---

# PART 7: TESTING & ERROR HANDLING (3 min)

## Testing Framework

### Why Test?

Game has 40 enemies, multiple game states, complex collision detection.

**Without testing:**
```
Developer changes code
  ↓
Compiles
  ↓
Runs game manually
  ↓
Tries to create specific scenario
  ↓
"Wait, how do I spawn 40 enemies quickly to test formation?"
  ↓
Takes 5 minutes per test
  ↓
Only tests happy path
  ↓
Bugs slip through to release
```

**With automated tests:**
```
Developer changes code
  ↓
Automated test suite runs in 2 seconds
  ↓
Tests all scenarios:
  - Spawn 40 enemies?
  - Formation alignment?
  - Collision detection?
  - Score calculation?
  ↓
All pass or fail immediately
  ↓
Bugs caught before release
```

### Test Framework

Galaga Wars includes a simple assertion-based testing system:

```gml
/// Test: Wave spawning creates correct number of enemies
function test_waveSpawner_createsEnemies() {
    var spawner = WaveSpawner(spawn_data, challenge_data, rogue_config);
    spawner.spawnWave(0);  // Spawn wave 0

    assert_equals(
        instance_number(oEnemyBase),  // Count enemies
        40,                            // Should be 40
        "Wave 0 should spawn 40 enemies"
    );
}

/// Test: Collision detection works
function test_collision_missileHitsEnemy() {
    var enemy = instance_create_layer(256, 256, "Test", oTieFighter);
    var missile = instance_create_layer(256, 256, "Test", oMissile);

    assert_equals(
        collision_rectangle(missile.x, missile.y,
                          missile.x+10, missile.y+10,
                          enemy, false),  // Check collision
        enemy,  // Should return the enemy
        "Missile should collide with enemy at same position"
    );

    // Cleanup
    instance_destroy(enemy);
    instance_destroy(missile);
}
```

### Test Results

Galaga Wars includes **9 test suites** with **2000+ lines of test code**:

1. **TestWaveSpawner** - Enemy spawning
2. **TestCollisionSystem** - Collision detection
3. **TestEnemyStateMachine** - Enemy states
4. **TestBeamWeaponLogic** - Tractor beam
5. **TestEnemyManagement** - Enemy lifecycle
6. **TestScoreAndChallenge** - Scoring system
7. **TestHighScoreSystem** - High scores
8. **TestLevelProgression** - Difficulty
9. **TestAudioManager** - Sound system

---

## Error Handling Philosophy

### Errors Will Happen

- Asset files missing
- JSON malformed
- Player does unexpected input
- Collision detection edge cases
- Memory limits

### Graceful Degradation

Instead of crashing, handle errors gracefully:

```gml
// Example: Missing enemy sprite
var sprite = safe_get_asset("oTieFighter_sprite", -1);

if (sprite == -1) {
    log_error("Enemy sprite missing, using placeholder",
              "draw_enemy", 1);  // Log as warning
    sprite = sPlaceholder;  // Use default sprite
}

draw_sprite(sprite, 0, x, y);  // Game continues
```

### Logging System

Errors logged to console AND file:

```gml
log_error("Asset not found: oTieFighter_sprite",
          "draw_enemy",  // Function name
          1);            // Severity: WARNING

// Creates entry in error_log.txt:
// [2024-11-16 14:30:45] [WARNING] draw_enemy: Asset not found...
```

**Severities:**
- **DEBUG (0)** - Development info
- **WARNING (1)** - Non-critical issues
- **ERROR (2)** - Critical but handled
- **CRITICAL (3)** - System failure

---

# PART 8: Q&A & CHALLENGES (2 min)

## Challenge Questions for Students

### Easy (Comprehension)

1. **Draw the game state machine** - What are the 12 states and how do they connect?

2. **Explain inheritance** - What code does oTieFighter inherit from oEnemyBase?

3. **Why JSON?** - List three advantages of data-driven design.

### Medium (Application)

4. **Modify a wave** - Write JSON to spawn 3 TieFighters in a diagonal line.

5. **Add a new state** - What code would you change to add a TUTORIAL state?

6. **Create a new enemy** - What files/events needed for a TIE Bomber?

### Hard (Critical Thinking)

7. **Scale to 1000 enemies** - What problems would appear? How solve?

8. **Multiplayer mode** - How would the state machine change?

9. **Write a test** - Automated test for formation alignment?

---

## Real-World Connections

### These Concepts Are Used Everywhere

| Concept | Where It's Used |
|---------|-----------------|
| **State Machines** | Games, traffic lights, elevators, ATMs, websites |
| **Inheritance** | All object-oriented languages (Java, C#, Python) |
| **Data-Driven Design** | Web apps (JSON), databases, configuration files |
| **Error Handling** | Every professional codebase |
| **Object Pooling** | Game engines, web servers, memory-constrained systems |

### Career Paths That Use This

- **Game Developer** (Unreal, Unity, custom engines)
- **Web Developer** (React components = objects, Redux = state machine)
- **Mobile Developer** (iOS/Android lifecycle = events)
- **Roboticist** (State machines for behavior)
- **Machine Learning Engineer** (Training on game data)

---

## Key Takeaways

### What You've Learned Today

1. **State Machines** - Organize complex logic into clear states
2. **Object-Oriented Programming** - Reuse code through inheritance
3. **Data-Driven Design** - Separate code from content
4. **Error Handling** - Make robust software that doesn't crash
5. **Design Patterns** - Proven solutions to common problems
6. **Professional Practices** - How real code is structured

### Most Important Concept

**Good code is:**
- ✓ **Readable** - Others can understand it
- ✓ **Maintainable** - Easy to change
- ✓ **Robust** - Handles errors gracefully
- ✓ **Efficient** - Performs well
- ✓ **Documented** - Explains WHY, not WHAT

### Closing Thought

The Galaga Wars codebase wasn't perfect on day one. It was:
1. Built piece by piece
2. Tested thoroughly
3. Refactored when needed
4. Documented extensively
5. Shipped to real players

**That's how professional code works.**

---

## Resources for Further Learning

### Official Documentation
- **GameMaker Manual:** https://manual.yoyogames.com
- **GML Reference:** https://manual.yoyogames.com/GameMaker_Language/GML_Reference/

### Books
- **"Game Programming Patterns"** by Robert Nystrom (free online)
- **"Head First Design Patterns"** by Freeman & Freeman
- **"The Art of Game Design"** by Jesse Schell

### Online
- **Project Euler** - Programming challenges
- **LeetCode** - Coding interview practice
- **GitHub** - Study open-source code
- **GDC Vault** - Free game development conference talks

### This Project
- **ARCHITECTURE.md** - Detailed system architecture
- **DEVELOPER_GUIDE.md** - How to set up and extend
- **ERROR_HANDLING_QUICK_REFERENCE.md** - All safe functions
- **Test Files** - 9 complete test suites as examples

---

## Final Questions for Reflection

Before next class, think about:

1. **What state machine exists in YOUR favorite game?**
   - How many states?
   - What are the transitions?

2. **How would you improve Galaga Wars?**
   - New enemy type?
   - Multiplayer mode?
   - Power-ups?

3. **How do professionals manage 100,000+ line codebases?**
   - Modules? Teams? Tools?

4. **What's your biggest question about game programming?**

---

## APPENDIX: Glossary (Optional Reference)

### Programming Terms

| Term | Definition | Example |
|------|-----------|---------|
| **Class** | Blueprint for objects | `oEnemyBase` |
| **Instance** | Individual object | `enemy_id = 12345` |
| **Inheritance** | Child inherits from parent | `oTieFighter extends oEnemyBase` |
| **Method** | Function in a class | `Take_Damage(amount)` |
| **Property** | Variable in a class | `health = 100` |
| **Polymorphism** | Same method, different behavior | All enemies have `Update()` |
| **Enum** | Named set of constants | `EnemyState.IN_FORMATION` |

### Game Terms

| Term | Definition | Example |
|------|-----------|---------|
| **Spawn** | Create dynamically | `spawnEnemy()` |
| **State** | Current condition | `enemyState` |
| **Collision** | Two objects touching | Missile hits enemy |
| **Path** | Predefined trajectory | Entrance paths |
| **Formation** | Organized arrangement | 5×8 grid of enemies |
| **Frame** | One render cycle | 60 frames per second |
| **Pool** | Reused objects | Object pooling for missiles |

### Software Terms

| Term | Definition | Example |
|------|-----------|---------|
| **Algorithm** | Step-by-step solution | Enemy spawning logic |
| **Data Structure** | Way to organize data | JSON formation grid |
| **Design Pattern** | Proven solution | State machine, inheritance |
| **Refactoring** | Improve without changing behavior | Extracting common code |
| **DRY** | Don't Repeat Yourself | Inheritance removes duplication |
| **Error Handling** | Deal with problems gracefully | `safe_get_asset()` |

---

## One Hour Lecture Breakdown

```
0:00 - 0:05   Opening & Game History
              - Welcome & overview
              - Galaga 1981 history
              - Galaga Wars modern version

0:05 - 0:10   What is GameMaker?
              - Game engine overview
              - GameMaker features
              - Why GameMaker for learning

0:10 - 0:15   The Codebase Overview
              - Project structure
              - Code statistics
              - Organization

0:15 - 0:35   Key Programming Concepts (20 min)
              - State Machines (5 min)
              - Inheritance (5 min)
              - Data-Driven Design (5 min)
              - Enums (3 min)
              - Error Handling (2 min)

0:35 - 0:50   Design Patterns (15 min)
              - Object Pooling (4 min)
              - Event-Driven Architecture (4 min)
              - State Machines in Objects (4 min)
              - Formation System (3 min)

0:50 - 0:55   Live Code Walkthrough (5 min)
              - Enemy creation flow
              - Complete lifecycle

0:55 - 0:58   Testing & Error Handling (3 min)
              - Why test
              - Test framework
              - Error philosophy

0:58 - 1:00   Q&A & Closing (2 min)
              - Challenge questions
              - Key takeaways
              - Resources
```

---

## How to Present This Material

### Recommended Delivery

1. **Start with the cool part** (Galaga history) to grab attention
2. **Explain GameMaker briefly** to set context
3. **Walk through concepts ONE AT A TIME** with examples
4. **Show actual code** (but don't overwhelm)
5. **Use diagrams** (state machines, inheritance trees)
6. **Ask questions** to check understanding
7. **End with challenges** to inspire

### Tips for Success

- **Pace yourself** - 60 minutes goes fast
- **Practice transitions** - Between topics
- **Use visuals** - Diagrams, code snippets
- **Relate to students** - "This is used in Fortnite"
- **Encourage questions** - "Ask anytime"
- **Show passion** - You're sharing something cool!

---

## Student Takeaway Document

After class, students should understand:

□ What a state machine is and how it organizes complex logic
□ Why inheritance eliminates code duplication
□ How data-driven design enables rapid iteration
□ Why error handling prevents crashes
□ What a game engine handles for you
□ How professional code differs from tutorial code
□ These patterns exist everywhere in software
□ How to approach learning large codebases

**Stretch Goals:**
□ Could implement a simple state machine
□ Could design a new game state
□ Could add error handling to existing code
□ Would study this codebase independently

---

## Teacher's Notes

### Timing Considerations

- **Shorter version (30 min):** Skip design patterns, reduce concepts
- **Longer version (90 min):** Add second code walkthrough, student exercises
- **Workshop format:** 2-3 hours with hands-on coding

### Class Discussion Ideas

1. "How many hidden state machines have you used today?"
   - Phone apps, games, websites...

2. "What would happen if a game didn't have error handling?"
   - Crashes at worst moments, data loss...

3. "Why do you think they chose JSON instead of another format?"
   - Human readable, standard, good tool support...

4. "How would you test a game?"
   - Automated tests, but also manual playtesting...

### Extensions

**For 11th-12th graders:**
- Dive deeper into data structures
- Explain memory pools in detail
- Discuss performance profiling tools
- Compare GameMaker vs. Unity vs. Unreal

**For educators:**
- This is a complete project that works
- Code can be compiled and played
- Architecture is production-quality
- Great code review example

---

**Created: November 16, 2024**
**Duration: 60 minutes (adjustable)**
**Level: 10th Grade Computer Science**
**Audience: Students new to programming or game development**
