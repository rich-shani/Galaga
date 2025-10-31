# Galaga Wars: A Study in Game Design & Object-Oriented Programming
## Presentation for AP Computer Science Students

---

## Table of Contents
1. [Introduction](#introduction)
2. [Codebase Overview](#codebase-overview)
3. [Architecture & Design Patterns](#architecture--design-patterns)
4. [Key Concepts](#key-concepts)
5. [Code Examples](#code-examples)
6. [Design Decisions](#design-decisions)
7. [Real-World Applications](#real-world-applications)
8. [Discussion Questions](#discussion-questions)

---

## Introduction

### What is Galaga Wars?
**Galaga Wars** is a modern reimagining of the classic 1981 Galaga arcade game, reskinned with a Star Wars theme. Instead of alien invaders, you're defending against TIE Fighters, TIE Interceptors, and Imperial Shuttles from the Star Wars universe.

### Game Overview
- **Engine:** GameMaker Studio 2 (commercial game development tool)
- **Language:** GameMaker Language (GML) - similar to JavaScript
- **Genre:** Fixed-shooter arcade game
- **Scale:** ~905 lines of core game code + 1000+ lines of supporting scripts

### Why Study This?
- **Real production code** written for actual game shipped to players
- **Industry-standard patterns** used in professional game development
- **Object-oriented design** applied to solve complex gameplay problems
- **Data-driven architecture** for easy content creation and modification
- **Error handling** and robust code practices

---

## Codebase Overview

### File Structure
```
Galaga/
├── objects/              # Game entities (player, enemies, UI)
│   ├── oGameManager/     # Central game controller
│   ├── oEnemyBase/       # Base enemy class
│   ├── oTieFighter/      # Enemy type 1
│   ├── oTieIntercepter/  # Enemy type 2
│   ├── oImperialShuttle/ # Enemy type 3
│   ├── oPlayer/          # Player ship
│   └── ... other objects
├── scripts/              # Reusable functions
│   ├── GameManager_STEP_FNs.gml    # Game loop logic
│   ├── ship_functions.gml           # Player movement
│   ├── ErrorHandling.gml            # Error management
│   ├── Hud.gml                      # UI rendering
│   └── ... other utilities
├── rooms/                # Game levels
│   ├── SplashScreen/
│   ├── GalagaWars/       # Main game
│   ├── Galaga/
│   └── AttractMode/
├── datafiles/            # Game configuration (JSON)
│   └── Patterns/
│       ├── wave_spawn.json          # Enemy waves
│       ├── challenge_spawn.json     # Bonus stages
│       ├── formation_coordinates.json # Enemy positions
│       └── oTieFighter.json         # Enemy stats
├── paths/                # Movement paths for enemies
└── sprites/              # Visual assets
```

### Lines of Code Breakdown

| Component | Lines | Purpose |
|-----------|-------|---------|
| GameManager_STEP_FNs | 905 | Main game logic & spawning |
| oEnemyBase objects | 600+ | Enemy behavior |
| Error Handling | 250+ | Robust error management |
| Supporting scripts | 800+ | UI, sound, utilities |
| **Total** | **~2500+** | Complete functional game |

---

## Architecture & Design Patterns

### 1. **State Machine Pattern** (Core Architecture)

The game uses a **finite state machine** to manage game flow:

```
INITIALIZE
    ↓
ATTRACT_MODE (title screen)
    ↓
INSTRUCTIONS
    ↓
GAME_PLAYER_MESSAGE (show level info)
    ↓
GAME_STAGE_MESSAGE (ready screen)
    ↓
SPAWN_ENEMY_WAVES
    ↓
GAME_ACTIVE (main gameplay)
    ↓
SHOW_RESULTS
    ↓
ENTER_INITIALS (high score entry)
    ↓
Back to ATTRACT_MODE
```

**Why State Machines?**
- Clear transitions between game phases
- Each state has distinct behavior
- Prevents invalid state combinations
- Easy to debug (know exactly what state you're in)

---

### 2. **Object-Oriented Programming (OOP)**

#### Inheritance Hierarchy
```
oEnemyBase (parent class)
    ↓
    ├── oTieFighter (inherits from oEnemyBase)
    ├── oTieIntercepter (inherits from oEnemyBase)
    └── oImperialShuttle (inherits from oEnemyBase)
```

**Key Principle:** Instead of copying code, child classes inherit shared behavior:
- Formation management
- Path following
- Diving attack patterns
- Health tracking

Each enemy type only defines what makes it different (sprite, speed, health value).

---

### 3. **Data-Driven Architecture**

Instead of hardcoding enemy waves, the game reads from **JSON configuration files**:

#### Wave Spawn Configuration
```json
{
  "PATTERN": [
    {
      "WAVE": [
        {
          "SPAWN": [
            {
              "ENEMY": "oTieFighter",
              "SPAWN_XPOS": 512,
              "SPAWN_YPOS": -16,
              "INDEX": 1,
              "PATH": "Ent1e1",
              "COMBINE": false
            }
          ]
        }
      ]
    }
  ]
}
```

**Benefits:**
- Change gameplay without recompiling code
- Non-programmers can design levels
- Easy to create variations and mods
- Version control friendly (text-based)

---

### 4. **Component-Based Architecture**

Each game object has specialized components:

```
oGameManager
├── State Management (which game mode)
├── Score Tracking (points, lives)
├── Wave Progression (current level)
├── Spawning Logic (when/how enemies appear)
└── Game Loop Coordination (timing everything)

oEnemyBase
├── Movement (follow paths)
├── Formation (grid positioning)
├── Attack Behavior (diving, shooting)
├── Animation (sprite updates)
└── Health/Collision Detection
```

This separation of concerns makes code:
- More modular
- Easier to test
- Simpler to modify one aspect without breaking others

---

### 5. **Design Patterns Summary**

| Pattern | Used For | Example |
|---------|----------|---------|
| **State Machine** | Game flow control | Attract → Game → Results |
| **Inheritance** | Shared enemy behavior | All enemies inherit from oEnemyBase |
| **Data-Driven Design** | Level/enemy configuration | JSON wave definitions |
| **Singleton** | oGameManager | Only one instance manages entire game |
| **Factory** | Creating enemies | spawnEnemy() creates correct type |
| **Error Handling** | Robustness | safe_load_json(), safe_get_asset() |

---

## Key Concepts

### Concept 1: Enums (Enumerated Types)

Enums make code readable by replacing magic numbers with meaningful names:

```gml
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
    GAME_PAUSED
}

// Instead of writing: if (global.gameMode == 0)
// We write:          if (global.gameMode == GameMode.GAME_ACTIVE)
```

**Why?** Numbers are meaningless. Names are self-documenting.

---

### Concept 2: Global Variables & Global State

The game tracks state in global variables:

```gml
global.gameMode = GameMode.GAME_ACTIVE;  // Current game state
global.p1score = 0;                       // Player score
global.p1lives = 3;                       // Lives remaining
global.wave = 0;                          // Current wave (0-4)
global.divecap = 2;                       // Enemy dive capacity
global.formation_data = {...};            // Enemy grid positions
global.enemy_attributes = {...};          // Enemy stats from JSON
```

**Tradeoff:**
- ✓ Fast access from anywhere
- ✓ Survives room changes
- ✗ Hard to trace where changes happen
- ✗ Can lead to difficult bugs

**Best Practice:** Minimize globals, use them strategically for truly global state.

---

### Concept 3: Event-Driven Programming

GameMaker objects respond to events:

```gml
// Create Event - runs when object is created
function Create_0() {
    health = 100;
    speed = 5;
}

// Step Event - runs every frame (60 times per second)
function Step_0() {
    // Update position, check collisions, etc.
}

// Collision Event - runs when object touches another
function Collision_oPlayer() {
    other.health -= 10;
}

// Draw Event - runs every frame after logic
function Draw_0() {
    draw_sprite(sprite_index, image_index, x, y);
}
```

**Lifecycle of an object:**
```
Create Event (1 time)
    ↓
Step Event (every frame)
    ↓
Draw Event (every frame)
    ↓
Destroy Event (1 time)
```

---

### Concept 4: Path Following System

Enemies follow predefined paths for smooth, choreographed movements:

```gml
// In oEnemyBase Create Event:
if (PATH_NAME != noone) {
    var path_id = asset_get_index(PATH_NAME);
    if (path_id != -1) {
        path_start(path_id, entranceSpeed, 0, 0);
    }
}

// GameMaker automatically moves the enemy along the path
// Each frame, the enemy's position updates based on path definition
```

**Paths are defined visually** in the GameMaker editor, making level design intuitive.

---

### Concept 5: Alarm System (Scheduled Events)

Instead of tracking timers manually, use alarms:

```gml
// Set an alarm to trigger in 120 frames (2 seconds @ 60fps)
alarm[5] = 120;

// In Alarm Event 5:
function Alarm_5() {
    // Fire a shot
    instance_create_layer(x, y, "Shots", oShot);
}
```

**Benefits:**
- Clean, readable code
- Built-in countdown
- Automatically resets to -1 when done
- Can check if alarm is active: `if (alarm[5] == -1)`

---

## Code Examples

### Example 1: State Machine Implementation

**Location:** `oGameManager/Step_0.gml`

```gml
// Main game loop - handles state transitions
switch(global.gameMode) {
    case GameMode.ATTRACT_MODE:
        // Show title screen, wait for input
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
        // Advance after delay
        if (alarm[AlarmIndex.ADVANCE_AFTER_RESULTS] == 0) {
            global.gameMode = GameMode.ENTER_INITIALS;
        }
        break;

    case GameMode.GAME_PAUSED:
        // Draw pause overlay
        draw_pause_screen();
        // Check for resume input
        if (keyboard_check_pressed(vk_space)) {
            global.gameMode = GameMode.GAME_ACTIVE;
        }
        break;
}
```

**Student Discussion:**
- What are the advantages of using a switch statement vs nested if/else?
- How would you add a new game state (e.g., GAME_OVER)?
- What happens if the state machine tries to transition to an invalid state?

---

### Example 2: Inheritance - Enemy Base Class

**Location:** `objects/oEnemyBase/Create_0.gml`

```gml
// ===== SHARED ENEMY INITIALIZATION =====

// Movement properties (inherited by ALL enemies)
baseSpeed = 6;
moveSpeed = baseSpeed * global.speedMultiplier;
entranceSpeed = baseSpeed + (baseSpeed * global.speedMultiplier);

// State management (used by all enemy types)
enemyState = EnemyState.ENTER_SCREEN;
enemyMode = EnemyMode.STANDARD;

// Load attributes from JSON based on enemy type
attributes = safe_struct_get(global.enemy_attributes, ENEMY_NAME, {});
hitCount = safe_struct_get(attributes, "HEALTH", 1);

// Formation position (where this enemy goes in the grid)
formation = global.formation_data;
xstart = formation.POSITION[INDEX]._x;
ystart = formation.POSITION[INDEX]._y;

// Path following
if (PATH_NAME != noone) {
    var path_id = safe_get_asset(PATH_NAME, -1);
    if (path_id != -1) {
        path_start(path_id, entranceSpeed, 0, 0);
    }
}
```

**How Inheritance Works:**

When you create an `oTieFighter` (which inherits from `oEnemyBase`):
1. oEnemyBase Create event runs (sets up shared code above)
2. oTieFighter Create event runs (sets TieFighter-specific properties)
3. oTieFighter inherits all variables and methods from oEnemyBase

**Result:** Each enemy type only needs to specify what's unique:

```gml
// oTieFighter/Create_0.gml (only 3 lines!)
ENEMY_NAME = "oTieFighter";
INDEX = spawn_index;
PATH_NAME = entrance_path;
```

**Student Discussion:**
- What code is being reused across all enemy types?
- How many lines of code would this game need WITHOUT inheritance?
- Can you think of other game objects that could inherit from a base class?

---

### Example 3: Data-Driven Spawning

**Location:** `scripts/GameManager_STEP_FNs/GameManager_STEP_FNs.gml`

```gml
/// @function spawnEnemy
/// Spawns a single enemy from the JSON wave data
function spawnEnemy() {
    // Get enemy data from JSON configuration
    var enemy_data = spawn_data.PATTERN[global.pattern]
                                      .WAVE[global.wave]
                                      .SPAWN[global.spawnCounter];

    // enemy_data contains:
    // - ENEMY: "oTieFighter" (which object to create)
    // - SPAWN_XPOS, SPAWN_YPOS: Starting position
    // - INDEX: Position in the grid (1-40)
    // - PATH: Which path to follow
    // - COMBINE: Is this a paired spawn?

    // Safely get the asset
    var enemy_id = safe_get_asset(enemy_data.ENEMY, -1);

    if (enemy_id != -1) {
        // Create the enemy with initialization data
        instance_create_layer(
            enemy_data.SPAWN_XPOS,
            enemy_data.SPAWN_YPOS,
            "GameSprites",
            enemy_id,
            {
                ENEMY_NAME: enemy_data.ENEMY,
                INDEX: enemy_data.INDEX,
                PATH_NAME: enemy_data.PATH,
                MODE: "STANDARD"
            }
        );
    }

    // Advance spawn counter
    global.spawnCounter++;

    // Handle combination spawns (paired enemies)
    if (enemy_data.COMBINE) {
        spawnEnemy(); // Recursively spawn the pair
    }
}
```

**How It Works:**

1. **Read from JSON:** Get spawn configuration for current wave
2. **Validate:** Use `safe_get_asset()` to check enemy exists
3. **Create:** Instantiate enemy with initialization data
4. **Recursive spawning:** If enemies should spawn together, call spawnEnemy() again

**JSON Configuration Example:**
```json
{
  "SPAWN": [
    {
      "ENEMY": "oTieFighter",
      "SPAWN_XPOS": 500,
      "SPAWN_YPOS": -20,
      "INDEX": 1,
      "PATH": "Ent_Top_L2R",
      "COMBINE": true  // This spawns two enemies
    }
  ]
}
```

**Student Discussion:**
- Why pass initialization data via struct instead of global variables?
- How does this enable non-programmers to design levels?
- What would happen if JSON had invalid enemy name?

---

### Example 4: Error Handling - Defensive Programming

**Location:** `scripts/ErrorHandling/ErrorHandling.gml`

```gml
/// @function safe_get_asset
/// Safely retrieves an asset ID with validation
function safe_get_asset(_asset_name, _default = -1) {
    // Step 1: Validate input
    if (!is_string(_asset_name) || string_length(_asset_name) == 0) {
        log_error("Invalid asset name provided", "safe_get_asset", 2);
        return _default;
    }

    // Step 2: Try to get the asset
    var _asset_id = asset_get_index(_asset_name);

    // Step 3: Check if asset was found
    if (_asset_id == -1) {
        log_error("Asset not found: " + _asset_name, "safe_get_asset", 1);
        return _default;
    }

    // Step 4: Return valid asset
    return _asset_id;
}

// Usage in code:
var enemy_id = safe_get_asset("oTieFighter", -1);
if (enemy_id != -1) {
    instance_create_layer(x, y, "GameSprites", enemy_id);
} else {
    log_error("Failed to spawn enemy", "my_function", 2);
}
```

**Defensive Programming Principles:**

1. **Validate inputs** - Check assumptions before using values
2. **Use defaults** - Return safe values instead of crashing
3. **Log errors** - Record what went wrong for debugging
4. **Fail gracefully** - Let game continue with reduced functionality

**Without error handling (BAD):**
```gml
var enemy_id = asset_get_index(enemy_name);
instance_create_layer(x, y, "GameSprites", enemy_id); // CRASH if enemy_id == -1!
```

**With error handling (GOOD):**
```gml
var enemy_id = safe_get_asset(enemy_name, -1);
if (enemy_id != -1) {
    instance_create_layer(x, y, "GameSprites", enemy_id); // Safe!
}
```

**Student Discussion:**
- What kinds of errors can occur in game development?
- How does error handling improve user experience?
- When should a game log warnings vs. errors vs. critical messages?

---

### Example 5: Game Loop - Coordinating Everything

**Location:** `scripts/GameManager_STEP_FNs/GameManager_STEP_FNs.gml`

```gml
/// @function Game_Loop
/// Main game loop - coordinates all active gameplay
function Game_Loop() {
    // Safety check - don't run if paused
    if (global.isGamePaused) return;

    // Check if we should advance to next level
    if (readyForNextLevel()) return;

    // === EXTRA LIVES ===
    checkForExtraLives();

    // === ENEMY DIVE CAPACITY ===
    checkDiveCapacity();

    // === BREATHING ANIMATION ===
    controlEnemyFormation();

    // === SPAWN ENEMIES ===
    if (!patternComplete()) {
        // Keep spawning enemies from current wave
        if (!waveComplete()) {
            if (alarm[2] == -1) {  // Only spawn when timer ready
                spawnEnemy();
            }
        }
        // Check if wave spawning is done
        if (waveComplete() && (global.divecap == global.divecapstart)) {
            global.wave += 1;  // Move to next wave
            global.spawnCounter = 0;  // Reset counter
        }
    }
    // Check if all patterns complete
    else {
        global.open = 0;
    }
}
```

**Execution Order (Every Frame):**
```
Game_Loop()
    1. Check if paused → exit if true
    2. Check if level complete → exit if true
    3. Award extra lives if earned
    4. Update enemy dive capacity
    5. Update breathing animation
    6. Spawn next enemy (if ready)
    7. Check wave completion
    8. Advance to next wave if complete
```

**Why Coordination Matters:**
- Prevents race conditions (things happening in wrong order)
- Ensures consistent game state
- Makes debugging easier (step through in order)
- Allows tweaking gameplay by reordering operations

**Student Discussion:**
- What would happen if we spawned enemies before checking pause state?
- How does the dive capacity affect enemy spawning?
- Why check `alarm[2] == -1` before spawning?

---

## Design Decisions

### Decision 1: Why Use JSON for Configuration?

**Question:** Why not just hardcode the wave data in code?

**Reasons:**

1. **Iteration Speed**
   - Change level design without recompiling
   - Designer can test 10 variations in 10 minutes vs. 10 compiles = 5+ minutes each

2. **Version Control**
   - JSON diffs show exactly what changed
   - Easy to revert bad level designs
   - Collaborative level design (multiple designers)

3. **Non-Programmer Designers**
   - Artists/designers can modify JSON
   - No coding knowledge required
   - Reduces development time

4. **Modding Support**
   - Players can create custom levels
   - Extends game lifespan
   - Community-driven content

**Tradeoff:**
- ✓ Flexible, fast iteration
- ✗ Slight performance overhead (JSON parsing)
- ✗ Need validation (malformed JSON crashes)

---

### Decision 2: Global vs. Object Properties

**Question:** Should enemy data be stored in global structs or object properties?

**Global Approach (Used):**
```gml
global.enemy_attributes["oTieFighter"] = { HEALTH: 3, POINTS: 50 };
```

**Object Approach:**
```gml
oTieFighter.health = 3;
oTieFighter.points = 50;
```

**Why Global?**
- All enemies of same type share data (memory efficient)
- Can load from JSON once at startup
- Designers can change values without creating new object types
- Easy to compare different enemy types

**Tradeoff:**
- ✓ Efficient, flexible
- ✗ Harder to track modifications
- ✗ Can cause unexpected interactions

---

### Decision 3: State Machine vs. Multiple Flags

**Question:** Why a single `gameMode` state vs. multiple boolean flags?

**State Machine (Used):**
```gml
enum GameMode {
    ATTRACT_MODE,
    GAME_ACTIVE,
    GAME_PAUSED,
    SHOW_RESULTS,
    ...
}

if (global.gameMode == GameMode.GAME_ACTIVE) { ... }
```

**Multiple Flags (Not Used):**
```gml
global.isPlaying = true;
global.isPaused = false;
global.isShowingResults = false;
```

**Why State Machine?**
- Prevents invalid combinations (can't be PLAYING and PAUSED simultaneously)
- Clear state transitions
- Self-documenting code
- Easier to add new states

**Tradeoff:**
- ✓ Logically correct, clear
- ✗ Slightly more verbose
- ✗ New developers might not understand switch statement

---

### Decision 4: Inheritance vs. Composition

**Question:** Should different enemy types inherit from oEnemyBase or use composition?

**Inheritance (Used):**
```gml
oTieFighter extends oEnemyBase
oTieIntercepter extends oEnemyBase
oImperialShuttle extends oEnemyBase

// All share: path following, formation, dive attacks
// Each defines: ENEMY_NAME, appearance, unique behavior
```

**Composition:**
```gml
oEnemy
├── MovementComponent
├── FormationComponent
├── AttackComponent
└── HealthComponent
```

**Why Inheritance?**
- Simpler for small team
- GameMaker naturally supports inheritance
- Less boilerplate code
- Clear "is-a" relationship (TieFighter IS an Enemy)

**Tradeoff:**
- ✓ Natural, less code
- ✗ Inflexible if behavior changes significantly
- ✗ Deep hierarchies become hard to manage

---

## Real-World Applications

### How This Applies to Other Games

| Concept | Used In | Example |
|---------|---------|---------|
| **State Machine** | All games | Menu → Level → Pause → Game Over |
| **Inheritance** | All games | Player, Enemy, NPC all inherit from Character |
| **Data-Driven Design** | RPGs, Strategy | Quests, inventory, skills stored in JSON/databases |
| **Path Following** | All games | NPCs walking patrol routes, cameras following objects |
| **Error Handling** | Production code | Graceful failure when assets missing |
| **Event System** | Game engines | Unity/Unreal use event/message systems |
| **Enums** | Professional code | Replaces magic numbers everywhere |

### Beyond Games

These principles apply to:
- **Web applications** (React components = objects, state management)
- **Mobile apps** (app lifecycle = state machine, data-driven UI)
- **Robotics** (state machines for robot behavior)
- **Autonomous vehicles** (pathfinding, collision detection)

---

## Discussion Questions

### Comprehension Questions

1. **What is a state machine?** Draw the state diagram for Galaga Wars game flow.

2. **Explain inheritance:** What code does oTieFighter inherit from oEnemyBase? What does it define specifically?

3. **Why JSON?** List three advantages of storing wave data in JSON instead of C++ code.

4. **Event-driven programming:** Explain the order of events: Create → Step → Draw → Destroy.

5. **Error handling:** What happens in `safe_get_asset()` if the asset doesn't exist? Why not just return -1?

---

### Application Questions

6. **Modify a wave:** Write a JSON snippet that spawns 4 TieFighters in a straight line with even spacing.

7. **Add a new state:** How would you add a TUTORIAL state to the game? What code needs to change?

8. **Create a new enemy:** What files would you need to create to add a new enemy type (e.g., TIE Bomber)?

9. **Debug scenario:** A challenge stage crashes trying to spawn enemies. How would the error handling help diagnose the problem?

10. **Design decision:** Should the enemy difficulty increase based on the level? How would you implement this?

---

### Critical Thinking Questions

11. **Scalability:** How would you modify the codebase to support 1000 enemies instead of 40?

12. **Performance:** What could cause frame rate drops? How would you optimize?

13. **Multiplayer:** How would state machine change if two players competed simultaneously?

14. **Modding:** What would you need to expose to allow players to create custom enemy waves?

15. **Testability:** How would you write automated tests for the wave spawning system?

---

### Open-Ended Discussion

16. **Compare approaches:** State machines vs. if/else chains - when to use each?

17. **Real-world analogy:** How is game state machine like a traffic light?

18. **Potential bugs:** What could go wrong if `global.divecap` is calculated incorrectly?

19. **Code quality:** Why is defensive programming (error handling) important even in games?

20. **Career:** What programming concepts here are most valuable for computer science careers?

---

## Code Walkthrough: Complete Enemy Spawn Flow

### How an enemy gets created (step-by-step):

**Step 1: Game Loop Decides to Spawn**
```gml
// In Game_Loop() function
if (!waveComplete()) {
    if (alarm[2] == -1) {
        spawnEnemy();  // Call spawn function
    }
}
```

**Step 2: Spawn Function Reads JSON**
```gml
function spawnEnemy() {
    // Read from JSON:
    // spawn_data.PATTERN[0].WAVE[1].SPAWN[5]
    // Returns: {ENEMY: "oTieFighter", SPAWN_XPOS: 500, ...}
    var enemy_data = spawn_data.PATTERN[global.pattern]
                                      .WAVE[global.wave]
                                      .SPAWN[global.spawnCounter];

    // Get enemy type (with error handling)
    var enemy_id = safe_get_asset(enemy_data.ENEMY, -1);

    if (enemy_id != -1) {
        // Create the instance with initialization data
        instance_create_layer(
            enemy_data.SPAWN_XPOS,
            enemy_data.SPAWN_YPOS,
            "GameSprites",
            enemy_id,
            {
                ENEMY_NAME: enemy_data.ENEMY,
                INDEX: enemy_data.INDEX,
                PATH_NAME: enemy_data.PATH,
                MODE: "STANDARD"
            }
        );
    }
}
```

**Step 3: Enemy's Create Event Runs**
```gml
// oEnemyBase/Create_0.gml
enemyState = EnemyState.ENTER_SCREEN;
hitCount = safe_struct_get(attributes, "HEALTH", 1);

// Start following entrance path
var path_id = safe_get_asset(PATH_NAME, -1);
if (path_id != -1) {
    path_start(path_id, entranceSpeed, 0, 0);
}
```

**Step 4: Every Frame - Enemy Step Event Runs**
```gml
// oEnemyBase/Step_0.gml
// Check if enemy finished entrance path
if (path_position >= 1 && enemyState == EnemyState.ENTER_SCREEN) {
    path_end();
    enemyState = EnemyState.MOVE_INTO_FORMATION;
    // Start moving to formation position
}

// Move toward formation position
if (enemyState == EnemyState.MOVE_INTO_FORMATION) {
    x = lerp(x, xstart, 0.05);
    y = lerp(y, ystart, 0.05);

    if (distance_to_point(xstart, ystart) < 5) {
        enemyState = EnemyState.IN_FORMATION;
    }
}

// In formation - breathe and prepare to dive
if (enemyState == EnemyState.IN_FORMATION) {
    // Apply breathing animation
    // Check if should dive
    if (global.divecap > 0 && irandom(5) == 0) {
        enemyState = EnemyState.IN_DIVE_ATTACK;
    }
}
```

**Step 5: Every Frame - Enemy Draw Event Runs**
```gml
// Draw the enemy sprite
draw_sprite_ext(
    sprite_index,      // Which image
    image_index,       // Frame (animation)
    x + breathex,      // Position (with breathing offset)
    y + breathey,
    1, 1,              // Scale
    0,                 // Rotation
    c_white,           // Color
    1                  // Alpha
);
```

**Summary Diagram:**
```
Game_Loop() decides to spawn
    ↓
spawnEnemy() reads JSON
    ↓
instance_create_layer() creates object
    ↓
Create_0.gml runs (initialize)
    ↓
Loop every frame:
    ├─ Step_0.gml (update logic)
    ├─ Draw_0.gml (render sprite)
    └─ Collision events (if hit player/shot)
    ↓
Destroy event (when health = 0)
```

---

## Key Takeaways for Students

### Programming Concepts Demonstrated
1. **Object-Oriented Programming** - Inheritance, encapsulation, polymorphism
2. **Data Structures** - Structs, arrays, JSON, enums
3. **Design Patterns** - State machine, factory, singleton
4. **Algorithms** - Path following, collision detection, formation management
5. **Error Handling** - Defensive programming, graceful failure
6. **Code Organization** - Modular design, separation of concerns
7. **Performance** - Managing hundreds of moving objects, memory efficiency

### Professional Practices
1. **Documentation** - Comments explaining complex logic
2. **Testing** - Defensive checks prevent crashes
3. **Version Control** - Modular code easier to track changes
4. **Code Review** - Clear patterns easier to understand
5. **Performance Profiling** - Knowing bottlenecks (instance_number() calls)
6. **User Experience** - Error handling = smooth gameplay

### Career Relevance
- Game studios use these exact patterns (Unreal Engine, Unity)
- Web developers use similar state machines (React)
- Mobile developers use event-driven architecture
- Roboticists use state machines and path planning
- All software benefits from error handling

---

## References & Further Learning

### GameMaker Documentation
- [GameMaker Official Docs](https://manual.yoyogames.com)
- [GML Reference](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/GML_Reference.htm)
- [Object Events](https://manual.yoyogames.com/The_Asset_Editors/Object_Properties/Object_Events.htm)

### Design Pattern Books
- "Game Programming Patterns" by Robert Nystrom (free online)
- "Head First Design Patterns" by Freeman & Freeman
- "The Art of Game Design" by Jesse Schell

### Related Topics
- [State Machines](https://en.wikipedia.org/wiki/Finite-state_machine)
- [Object-Oriented Programming](https://en.wikipedia.org/wiki/Object-oriented_programming)
- [Game Architecture](https://www.gamedev.net/tutorials/)

---

## Appendix: Glossary

| Term | Definition |
|------|-----------|
| **Enum** | Enumerated type - set of named constants |
| **State Machine** | System that transitions between discrete states |
| **Inheritance** | Child class inherits properties/methods from parent |
| **Event** | Happens at specific time (Create, Step, Draw) |
| **Instance** | Individual object created from a class |
| **Data-Driven** | Configuration in data files, not code |
| **Path** | Predefined trajectory for movement |
| **Formation** | Grid arrangement of enemies |
| **Spawning** | Creating new instances dynamically |
| **Error Handling** | Dealing with unexpected situations gracefully |

---

## Questions for Students

Before next class, think about:

1. What state machine exists in YOUR favorite game?
2. How would you improve the Galaga Wars architecture?
3. What other games use data-driven design?
4. How do professional studios handle 1000+ lines of code?
5. What's your biggest question about game programming?

**Submit thoughts to instructor before next class!**

