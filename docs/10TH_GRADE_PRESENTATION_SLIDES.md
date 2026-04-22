# Introduction to Computer Science: Game Design & Programming
## Presentation Slides for 10th Grade
### Based on Galaga Wars Codebase

---

# SLIDE 1: Title Slide

## Introduction to Computer Science
### Game Design & Programming with Galaga Wars

**What You'll Learn Today:**
- How real games are built
- Professional programming concepts
- Code organization and design patterns
- Why good code matters

**This is production code from an actual game!**

---

# SLIDE 2: Who Am I? (Speaker Intro)

- Software engineer with experience in game development
- This codebase was written for actual players
- Same patterns used at major game studios
- Here to share what real code looks like

**Your job:** Ask questions, participate, challenge ideas

---

# SLIDE 3: Today's Agenda

```
 0:00 - 0:05   Opening & Game History
 0:05 - 0:10   What is GameMaker?
 0:10 - 0:15   The Codebase Overview
 0:15 - 0:35   Key Programming Concepts
 0:35 - 0:50   Design Patterns in Action
 0:50 - 0:55   Live Code Walkthrough
 0:55 - 0:58   Testing & Error Handling
 0:58 - 1:00   Q&A & Challenges
```

**Total: 60 minutes**

---

# SLIDE 4: The Original Galaga (1981)

[IMAGE: Original Galaga arcade cabinet]

### Key Facts:
- Released by Namco, August 1981
- One of the most iconic arcade games
- Millions of quarters spent in arcades
- Simple but addictive gameplay

### Why Revolutionary?
- ✓ Enemies had "personality" (dive attacks)
- ✓ Formation system (5×8 grid)
- ✓ Tractor beam to capture ships
- ✓ Progressive difficulty

### Original Hardware:
```
CPU: Zilog Z80 (3.1 MHz)
RAM: 4 KB
Screen: 224×288 pixels
```
**Your phone is 1,000,000× more powerful!**

---

# SLIDE 5: Galaga Wars - Modern Remake

[IMAGE: Galaga Wars screenshot with X-Wing]

### What's Different?

| Feature | 1981 | 2024 |
|---------|------|------|
| Theme | Generic aliens | Star Wars |
| Resolution | 224×288 | 1920×1080 |
| FPS | 60 (simulated) | 60 (actual) |
| Colors | 256 | Millions |
| Audio | Bleeps/bloops | Full orchestral |
| Code | Hardcoded | Data-driven |
| Testing | Manual | Automated |

---

# SLIDE 6: By The Numbers

### Galaga Wars Codebase

```
11,000+  Lines of Code
 30+     Game Objects
 50+     Script Modules
  9      Test Suites
 10+     JSON Config Files
100+     Movement Paths
320+     Sprite Assets
 25+     Sound Files
  6      Months to Build
```

### Perspective

```
Mobile App:     10,000 - 100,000 lines
AAA Game:       1,000,000+ lines
Galaga Wars:    11,000 lines (focused, clean, efficient)
```

---

# SLIDE 7: What is a Game Engine?

### Without a Game Engine
You code everything from scratch:
- Graphics rendering
- Physics simulation
- Collision detection
- Input handling
- Audio management
- Memory management

**Years of work before you have a game**

### With a Game Engine
You focus on:
- Game logic
- Enemy behavior
- Score system
- Art & sound

**Days of work to have a game**

---

# SLIDE 8: GameMaker Studio 2

### What is It?
Commercial game engine by YoYo Games

### Who Uses It?
- Indie developers (Cuphead, Hyper Light Drifter)
- Educational institutions
- Professional studios
- Hobbyists

### Key Features
- Visual editor (drag-and-drop)
- GameMaker Language (GML)
- Event system (Create, Step, Draw, Collision)
- Path editor
- Export to: Windows, Mac, Linux, HTML5, iOS, Android

---

# SLIDE 9: GameMaker Language (GML)

### Simple Example

```gml
// Initialize (Create event)
var speed = 5;
var health = 100;

// Update each frame (Step event)
x += speed;

// Remove when off-screen
if (x > room_width) {
    instance_destroy();
}
```

### Similar To...
- JavaScript (web development)
- Python (data science)
- C# (Unity game engine)

**Easy to learn, powerful enough for production games**

---

# SLIDE 10: Codebase Structure

```
Galaga/
├── objects/            ← Game entities
│   ├── oGameManager    ← Main controller
│   ├── oEnemyBase      ← Enemy parent class
│   ├── oTieFighter     ← Enemy type 1
│   ├── oPlayer         ← Player ship
│   └── ...
├── scripts/            ← Reusable code (8,302 lines)
│   ├── GameManager_STEP_FNs.gml
│   ├── ErrorHandling.gml
│   └── ...
├── datafiles/          ← Configuration
│   ├── game_config.json
│   ├── wave_spawn.json
│   └── ...
└── rooms/, paths/, sprites/, sounds/
```

---

# SLIDE 11: Code Organization

### By Responsibility (Clean Architecture)

```
Core Systems:
├─ GameConstants       (enums, configuration)
├─ ErrorHandling       (defensive programming)
└─ AssetCache          (performance optimization)

Game Controllers:
├─ WaveSpawner         (enemy spawning)
├─ ScoreManager        (points & lives)
├─ AudioManager        (sound management)
└─ GameManager         (orchestrator)

Game Systems:
├─ EnemyBehavior       (AI & movement)
├─ CollisionHelpers    (collision detection)
├─ ObjectPool          (memory efficiency)
└─ UIManager           (user interface)
```

**Each module has one responsibility = easier to understand and modify**

---

# SLIDE 12: Key Concept #1: State Machines

### What's a State Machine?

A system that can be in **one state at a time** and **transitions between states** in defined ways.

### Real-World Example: Traffic Light

```
  🔴 RED
   ↓ (30 sec)
  🟡 YELLOW
   ↓ (5 sec)
  🟢 GREEN
   ↓ (25 sec)
  🔴 RED (repeat)
```

**Always one state. Clear transitions. Never invalid.**

---

# SLIDE 13: Game State Machine (12 States)

### Galaga Wars Flow

```
           START
             ↓
      ATTRACT_MODE ← title screen, wait
             ↓
       INSTRUCTIONS ← show controls
             ↓
  GAME_PLAYER_MESSAGE ← show level
             ↓
  GAME_STAGE_MESSAGE ← "Get Ready!"
             ↓
  SPAWN_ENEMY_WAVES
             ↓
      GAME_ACTIVE ← MAIN GAME
             ↓
      SHOW_RESULTS
             ↓
     ENTER_INITIALS
             ↓
Back to ATTRACT_MODE
```

---

# SLIDE 14: State Machine Code

```gml
enum GameMode {
    ATTRACT_MODE,
    GAME_ACTIVE,
    GAME_PAUSED,
    SHOW_RESULTS,
    ...
}

// In game loop
switch(global.gameMode) {
    case GameMode.ATTRACT_MODE:
        draw_title_screen();
        if (keyboard_check_pressed(vk_space)) {
            global.gameMode = GameMode.GAME_ACTIVE;
        }
        break;

    case GameMode.GAME_ACTIVE:
        Game_Loop();  // Main gameplay
        break;

    case GameMode.GAME_PAUSED:
        draw_pause_overlay();
        break;
}
```

---

# SLIDE 15: Why State Machines?

| Benefit | Why It Matters |
|---------|----------------|
| **Clear Logic** | Can't be PLAYING and PAUSED simultaneously |
| **Easy Debugging** | Know exactly where you are |
| **Self-Documenting** | Names explain intent |
| **Scalable** | Easy to add new states |
| **Professional** | Used in ALL major game engines |

---

# SLIDE 16: Key Concept #2: Inheritance

### The Problem: Duplicate Code

Three enemy types: TieFighter, TieIntercepter, ImperialShuttle

**Without inheritance:**
```gml
// Copy this 600 lines for EACH enemy type!
oTieFighter {
    speed = 6;
    formation = true;
    can_dive = true;
    health = 1;
    // ... 50+ more lines ...
}
// Repeat for TieIntercepter... Repeat for ImperialShuttle...
```

**Total: 1,800 lines of nearly identical code**

---

# SLIDE 17: The Solution: Inheritance

### Parent Class (oEnemyBase) - Shared Code

```gml
function Create_0() {
    // SHARED by all enemies
    baseSpeed = 6;
    enemyState = EnemyState.ENTER_SCREEN;
    formation = global.formation_data;
    xstart = formation.POSITION[INDEX]._x;
    ystart = formation.POSITION[INDEX]._y;
    // ... path following, health, etc.
}
```

### Child Classes - Only What's Unique

```gml
// oTieFighter/Create_0.gml
ENEMY_NAME = "oTieFighter";
INDEX = spawn_index;
PATH_NAME = entrance_path;
// Just 3 lines!
```

---

# SLIDE 18: Inheritance Hierarchy

```
           oEnemyBase
          /    |     \
         /     |      \
  oTieFighter | oTieIntercepter | oImperialShuttle
```

### What's Inherited?

All child classes automatically have:
- ✓ Path following
- ✓ Formation positioning
- ✓ Dive attack patterns
- ✓ Health/collision detection
- ✓ Animation system

### Result

```
Without Inheritance: 600 lines
With Inheritance:    200 shared + 9 unique = 209 lines
Code saved:         65% smaller!
```

---

# SLIDE 19: The DRY Principle

### DRY = Don't Repeat Yourself

```gml
❌ BAD (With Repetition)
// Update formation in TieFighter
function update_formation() { ... 20 lines ... }

// Update formation in TieIntercepter
function update_formation() { ... 20 lines ... }

// Update formation in ImperialShuttle
function update_formation() { ... 20 lines ... }
// Change logic? Fix it 3 places!


✓ GOOD (With Inheritance)
// Base class
function update_formation() { ... 20 lines ... }

// All enemies inherit it
// Change logic? Fix it 1 place!
```

---

# SLIDE 20: Key Concept #3: Data-Driven Design

### The Problem: Hardcoding Levels

```gml
function spawn_wave() {
    spawn_enemy("oTieFighter", 100, -20, "Path1");
    spawn_enemy("oTieFighter", 200, -20, "Path1");
    spawn_enemy("oTieFighter", 300, -20, "Path1");
    // ... 37 more hardcoded ...
}

// To change wave:
// 1. Edit code
// 2. Recompile (30 seconds)
// 3. Test
// 4. Repeat
```

**To test 10 variations = 5+ minutes waiting for compiles**

---

# SLIDE 21: The Solution: Data-Driven Design

### Store Configuration in JSON Files

```json
{
  "PATTERN": [{
    "WAVE": [{
      "SPAWN": [
        {
          "ENEMY": "oTieFighter",
          "SPAWN_XPOS": 100,
          "SPAWN_YPOS": -20,
          "INDEX": 1,
          "PATH": "Path1"
        },
        // More spawns...
      ]
    }]
  }]
}
```

### In Code: Read from JSON

```gml
function spawnEnemy() {
    var spawn_data = spawn_data.PATTERN[0]
                                      .WAVE[0]
                                      .SPAWN[spawn_count];
    // Create enemy from data
    instance_create_layer(
        spawn_data.SPAWN_XPOS,
        spawn_data.SPAWN_YPOS,
        "GameSprites",
        asset_get_index(spawn_data.ENEMY)
    );
}
```

---

# SLIDE 22: Benefits of Data-Driven Design

| Benefit | Impact |
|---------|--------|
| **Instant Testing** | Change JSON, test in 1 second |
| **No Coding Required** | Designers can modify waves |
| **Version Control** | Diffs show exactly what changed |
| **Easy Modding** | Players can create custom levels |
| **Easy Balancing** | Adjust difficulty in JSON |

**Test 10 variations: 30 seconds (vs 5+ minutes with hardcoding)**

---

# SLIDE 23: Key Concept #4: Enums (Readability)

### The Problem: Magic Numbers

```gml
❌ BAD
if (global.gameMode == 0) { ... }
if (global.gameMode == 1) { ... }
if (enemy_state == 3) { ... }

// What do these numbers mean?
// Easy to make mistakes!
// Hard to remember!
```

### The Solution: Enums

```gml
✓ GOOD
enum GameMode {
    ATTRACT_MODE,        // 0
    GAME_ACTIVE,         // 1
    GAME_PAUSED,         // 2
    SHOW_RESULTS         // 3
}

if (global.gameMode == GameMode.GAME_ACTIVE) { ... }
// Crystal clear!
```

---

# SLIDE 24: Why Enums Matter

### Benefits

1. **Self-Documenting**
   ```gml
   GameMode.GAME_ACTIVE  // Obvious!
   vs.
   global.gameMode == 1  // What's 1?
   ```

2. **Typo Prevention**
   - IDE autocomplete shows all options
   - Can't type wrong value

3. **Professional**
   - Industry standard everywhere
   - Used in all major languages

---

# SLIDE 25: Key Concept #5: Error Handling

### The Problem: Undefended Code

```gml
❌ CRASH
var enemy_id = asset_get_index("oWrongName");
instance_create_layer(x, y, "GameSprites", enemy_id);
// enemy_id = -1 → CRASH!

var data = json_parse("missing_file.json");
// File doesn't exist → CRASH!

var value = array[999];  // Array only 10 items
// Out of bounds → CRASH or undefined!
```

---

# SLIDE 26: The Solution: Safe Functions

```gml
✓ SAFE
function safe_get_asset(asset_name, default_val) {
    // Step 1: Validate input
    if (!is_string(asset_name)) {
        log_error("Invalid asset name", "safe_get_asset", 2);
        return default_val;
    }

    // Step 2: Try to get asset
    var asset_id = asset_get_index(asset_name);

    // Step 3: Check if exists
    if (asset_id == -1) {
        log_error("Asset not found: " + asset_name,
                  "safe_get_asset", 1);
        return default_val;
    }

    return asset_id;  // Safe!
}
```

### Usage

```gml
var enemy_id = safe_get_asset("oTieFighter", -1);
if (enemy_id != -1) {
    instance_create_layer(x, y, "GameSprites", enemy_id);
} else {
    log_error("Can't spawn enemy", "spawn_function", 2);
    // Game continues!
}
```

---

# SLIDE 27: Safe Functions Library

Galaga Wars provides:

```
safe_get_asset(asset, default)
safe_load_json(file, default)
safe_struct_get(struct, key, default)
safe_array_get(array, index, default)
validate_json_structure(data, required_keys, context)
is_null_or_empty(value)
coalesce(v1, v2, v3)
log_error(message, context, severity)
```

### The Result

| Without | With |
|---------|------|
| Game crashes | Game continues |
| Player frustrated | Problem logged |
| Hard to debug | Easy to debug |

---

# SLIDE 28: Design Pattern #1: Object Pooling

### The Problem: Memory Allocations

```gml
// Every frame, enemies fire
for (var i = 0; i < 40; i++) {
    instance_create(..., oShot);  // NEW instance
}
// 40 new instances per frame
// 2,400 per second
// Garbage collection hiccups = FPS drops
```

---

# SLIDE 29: The Solution: Object Pooling

### Pre-Create a Pool

```gml
function ObjectPool(object_type, initial_size) constructor {
    // Create 50 shots at startup
    inactive_pool = ds_list_create();
    for (var i = 0; i < 50; i++) {
        var inst = instance_create(0, 0, object_type);
        instance_deactivate_object(inst);
        ds_list_add(inactive_pool, inst);
    }
}
```

### Reuse Instead of Create/Destroy

```gml
// When shooting:
var shot = pool.acquire(x, y);  // Get from pool
shot.x = x;
shot.y = y;

// When hit by enemy:
pool.release(shot);  // Return to pool
```

### The Impact

```
Without Pooling: 2,400 instances created/destroyed per second
With Pooling:    50 instances reused forever
                 = 0 garbage collection = smooth 60 FPS
```

---

# SLIDE 30: Design Pattern #2: Event System

### GameMaker Object Lifecycle

```
CREATE EVENT
    (1 time - initialization)
    ↓
STEP EVENT
    (every frame - game logic)
    ↓
DRAW EVENT
    (every frame - rendering)
    ↓
COLLISION EVENTS
    (when touching other objects)
    ↓
DESTROY EVENT
    (1 time - cleanup)
```

---

# SLIDE 31: Events in Action

```gml
// CREATE - Initialize
function Create_0() {
    health = 100;
    speed = 5;
}

// STEP - Update every frame
function Step_0() {
    x += speed;
    if (health <= 0) {
        instance_destroy();
    }
}

// DRAW - Render sprite
function Draw_0() {
    draw_sprite(sprite_index, 0, x, y);
}

// COLLISION - Hit by missile
function Collision_oMissile() {
    health -= 10;
}

// DESTROY - Cleanup
function Clean Up_0() {
    ds_list_delete(global.enemies, ds_list_find_index(...));
}
```

---

# SLIDE 32: Design Pattern #3: State Machines in Objects

### Enemies Have States Too

```gml
enum EnemyState {
    ENTER_SCREEN,           // Following entrance path
    MOVE_INTO_FORMATION,    // Moving to grid position
    IN_FORMATION,           // Waiting in grid
    RETURN_PATH,            // Coming back from dive
    IN_DIVE_ATTACK,         // Diving at player
    IN_LOOP_ATTACK,         // Looping back
    IN_FINAL_ATTACK         // Last enemies aggressive
}
```

### State-Based Logic

```gml
function Step_0() {
    switch(enemyState) {
        case EnemyState.ENTER_SCREEN:
            // Path moves automatically
            if (path_position >= 1) {
                path_end();
                enemyState = EnemyState.MOVE_INTO_FORMATION;
            }
            break;

        case EnemyState.IN_FORMATION:
            // Breathing animation
            breath_angle += 0.02;
            // Random dive
            if (irandom(100) < 2) {
                enemyState = EnemyState.IN_DIVE_ATTACK;
            }
            break;
    }
}
```

---

# SLIDE 33: Design Pattern #4: Formation System

### 5×8 Grid (40 Positions)

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

### How It Works

```gml
// Spawn data specifies grid position
var spawn_data = {
    INDEX: 5  // Position 5 in grid
};

// Enemy moves to that position
xstart = formation_grid[5].x;
ystart = formation_grid[5].y;

// Smooth movement
x = lerp(x, xstart, 0.05);
y = lerp(y, ystart, 0.05);
```

---

# SLIDE 34: Code Walkthrough: How an Enemy is Born

### Step 1: Game Decides to Spawn

```gml
// In Game_Loop()
if (!waveComplete()) {
    if (alarm[SPAWN_TIMER] == -1) {
        spawnEnemy();  // CREATE AN ENEMY!
    }
}
```

---

# SLIDE 35: Code Walkthrough: Step 2

### Read Configuration from JSON

```gml
function spawnEnemy() {
    // Navigate JSON structure
    var spawn_data = spawn_data.PATTERN[0]
                               .WAVE[0]
                               .SPAWN[spawn_count];

    // spawn_data contains:
    // ENEMY: "oTieFighter"
    // SPAWN_XPOS: 256
    // SPAWN_YPOS: -20
    // INDEX: 5 (grid position)
    // PATH: "entrance_path"
}
```

---

# SLIDE 36: Code Walkthrough: Step 3

### Safely Get Enemy Type

```gml
var enemy_id = safe_get_asset(
    spawn_data.ENEMY,  // "oTieFighter"
    -1                 // default if not found
);

if (enemy_id == -1) {
    // Enemy doesn't exist
    log_error("Enemy not found", "spawnEnemy", 2);
    return;  // Don't crash!
}
```

---

# SLIDE 37: Code Walkthrough: Step 4

### Create the Enemy

```gml
instance_create_layer(
    spawn_data.SPAWN_XPOS,   // X: 256
    spawn_data.SPAWN_YPOS,   // Y: -20 (above screen)
    "GameSprites",           // Which layer
    enemy_id,                // oTieFighter object ID
    {
        ENEMY_NAME: "oTieFighter",
        INDEX: 5,
        PATH_NAME: "entrance_path",
        MODE: EnemyMode.STANDARD
    }
);
```

---

# SLIDE 38: Code Walkthrough: Step 5

### Enemy's Create Event Runs

```gml
function Create_0() {
    // Load attributes from JSON
    attributes = safe_struct_get(
        global.enemy_attributes,
        ENEMY_NAME,
        {}
    );

    hitCount = safe_struct_get(
        attributes,
        "HEALTH",
        1
    );

    // Get grid position
    xstart = formation.POSITION[5]._x;
    ystart = formation.POSITION[5]._y;

    // Start following path
    var path_id = safe_get_asset(PATH_NAME, -1);
    if (path_id != -1) {
        path_start(path_id, 4, path_action_stop, false);
    }
}
```

---

# SLIDE 39: Code Walkthrough: Complete Lifecycle

```
spawn_enemy() called
    ↓
Read JSON spawn data
    ↓
Safely get enemy type ID
    ↓
instance_create_layer() → Creates enemy
    ↓
Create_0.gml runs
    ├─ Load attributes
    ├─ Initialize state
    ├─ Set grid position
    └─ Start entrance path
    ↓
Every Frame:
    ├─ Step_0.gml (update logic)
    │  └─ Check if finished path
    │  └─ Move toward formation
    │  └─ Apply breathing animation
    ├─ Draw_0.gml (render sprite)
    └─ Check collision events
    ↓
If hit by player missile:
    → Collision_oMissile() runs
    → hitCount--
    → If health = 0:
       → Create explosion
       → instance_destroy()
    ↓
Destroy event runs (cleanup)
    ↓
Enemy removed from game memory
```

---

# SLIDE 40: Testing Framework

### Why Test?

```
❌ WITHOUT TESTS
Change code → Compile (30 sec) → Manually test
→ Oops, broke something → Debug → Fix → Repeat
→ Time: 5+ minutes per test

✓ WITH TESTS
Change code → Automated tests run (2 seconds)
→ All scenarios tested instantly
→ Bug caught immediately
→ Time: 2 seconds
```

---

# SLIDE 41: Galaga Wars Test Suite

### 9 Test Suites

```
TestWaveSpawner          (139 lines)
TestCollisionSystem      (164 lines)
TestEnemyStateMachine    (234 lines)
TestBeamWeaponLogic      (290 lines)
TestEnemyManagement      (282 lines)
TestScoreAndChallenge    (211 lines)
TestHighScoreSystem      (144 lines)
TestLevelProgression     (152 lines)
TestAudioManager         (307 lines)
─────────────────────────────────
Total: ~1,900 lines of test code
```

---

# SLIDE 42: Example Test

```gml
function test_waveSpawner_creates40Enemies() {
    var spawner = WaveSpawner(spawn_data,
                              challenge_data,
                              rogue_config);
    spawner.spawnWave(0);

    assert_equals(
        instance_number(oEnemyBase),
        40,
        "Wave 0 should spawn 40 enemies"
    );
}
```

### How It Works

1. Create test wave spawner
2. Run `spawnWave(0)`
3. Count enemies created
4. Assert count equals 40
5. Pass ✓ or Fail ✗

**All tests run in 2 seconds**

---

# SLIDE 43: Error Handling Philosophy

### Errors Will Happen

- Missing asset files
- Corrupted JSON
- Out of bounds access
- Unexpected player input
- Memory constraints

### Graceful Degradation

```gml
✓ GOOD
var sprite = safe_get_asset("sprite_name", -1);
if (sprite == -1) {
    log_error("Missing sprite", "draw_enemy", 1);
    sprite = sPlaceholder;  // Use default
}
draw_sprite(sprite, 0, x, y);  // Game continues!

❌ BAD
var sprite = safe_get_asset("sprite_name", -1);
draw_sprite(sprite, 0, x, y);  // CRASH if sprite == -1!
```

---

# SLIDE 44: Logging System

### Log Levels

```
DEBUG (0)     - Development info
WARNING (1)   - Non-critical issues
ERROR (2)     - Critical but handled
CRITICAL (3)  - System failure
```

### Example

```gml
log_error("Asset not found: oTieFighter_sprite",
          "draw_enemy",
          1);  // WARNING level
```

### Creates Entry in error_log.txt

```
[2024-11-16 14:30:45] [WARNING] draw_enemy:
    Asset not found: oTieFighter_sprite
[2024-11-16 14:30:46] [ERROR] spawnEnemy:
    Wave spawning failed: Invalid JSON
```

**Post-release debugging: Check log file**

---

# SLIDE 45: Real-World Applications

### These Concepts Are EVERYWHERE

| Concept | Where |
|---------|-------|
| **State Machines** | Traffic lights, elevators, ATMs, websites, apps |
| **Inheritance** | All OOP languages (Java, C#, Python) |
| **Data-Driven Design** | Web apps (JSON), databases, config files |
| **Error Handling** | EVERY professional codebase |
| **Object Pooling** | Game engines, web servers, memory systems |
| **Event Systems** | All modern UI frameworks (React, Vue) |

---

# SLIDE 46: Career Paths Using This Code

### Game Development
- Game Programmer (Unreal, Unity, custom engines)
- Game Designer
- Technical Director

### Web Development
- Frontend Engineer (React = components like objects)
- Full-stack Engineer (state management = state machines)

### Mobile Development
- iOS/Android Engineer (event lifecycle system)

### Other
- Roboticist (state machines for behavior)
- ML Engineer (game AI training)
- VFX Programmer (effects using pooling)

---

# SLIDE 47: What Made This Code "Good"?

### The Galaga Wars Codebase Has:

```
✓ Clear Organization        (modular design)
✓ Meaningful Names           (enums, descriptive functions)
✓ Single Responsibility      (each object = one job)
✓ Error Handling             (defensive programming)
✓ Testing                    (9 test suites)
✓ Documentation              (comments explain WHY)
✓ Scalability                (handles 40+ enemies)
✓ Maintainability            (easy to modify)
✓ Performance                (60 FPS with pooling)
✓ Professional Patterns      (used everywhere)
```

---

# SLIDE 48: Key Takeaways

### Programming Concepts You Learned

1. **State Machines** - Organize complex logic
2. **Inheritance** - Reuse code across similar objects
3. **Data-Driven Design** - Separate code from content
4. **Error Handling** - Make robust software
5. **Design Patterns** - Proven solutions
6. **Events** - Objects responding to happenings
7. **Performance** - How to handle many objects

---

# SLIDE 49: The Three Types of Code

```
❌ BEGINNER CODE
- Lots of duplication
- Magic numbers
- No error handling
- Hard to change
- Works for small projects
- Falls apart at scale

⚠️ STUDENT CODE
- Some organization
- Starting to see patterns
- Basic error handling
- Can handle medium projects

✓ PROFESSIONAL CODE
- Modular
- Well-tested
- Defensive
- Documented
- Actually shipped
- Used by millions
```

**Galaga Wars is Professional Code**

---

# SLIDE 50: Most Important Concept

### Good code is like good writing:

```
❌ BAD WRITING
"The thing did the stuff and the other thing was
like when it did the other thing."
(Unclear, confusing, hard to follow)

✓ GOOD WRITING
"The enemy entered formation and waited to dive."
(Clear, specific, easy to understand)
```

### Same with Code

```gml
❌ global.m = 0;
   global.s = 100;

✓ enum GameMode { ATTRACT_MODE, ... }
   global.gameMode = GameMode.GAME_ACTIVE;
```

**Code should explain itself to other humans**

---

# SLIDE 51: Closing Thought

### The Journey of Galaga Wars

```
Day 1:    Wrote first enemy class
Week 1:   Basic spawning works
Week 2:   Collision detection added
Week 3:   Refactored for inheritance
Week 4:   Added error handling
Week 5:   Wrote test suite
Week 6:   Performance optimization
...
Month 6:  Released to players
```

**Professional code isn't perfect on day 1.**

**It's built piece by piece, tested thoroughly, and refined constantly.**

---

# SLIDE 52: Your Challenge

### Easy (Comprehension)
1. Draw the game state machine
2. Explain inheritance in your own words
3. Why use JSON instead of hardcoding?

### Medium (Application)
4. Write JSON to spawn 3 enemies in a line
5. How would you add a TUTORIAL state?
6. What files for a new enemy type?

### Hard (Critical Thinking)
7. How support 1000 enemies instead of 40?
8. How would multiplayer change the code?
9. Write a test for formation alignment?

---

# SLIDE 53: Questions to Ponder

### Before Next Class, Think About:

1. **What state machine exists in YOUR favorite game?**
   - How many states?
   - What are transitions?

2. **How would you improve Galaga Wars?**
   - New feature?
   - Different gameplay?

3. **How do professionals manage huge codebases?**
   - Tools? Teams? Processes?

4. **What's your biggest question about game programming?**

---

# SLIDE 54: Resources for Learning

### Documentation
- **GameMaker Manual:** https://manual.yoyogames.com
- **This Project:** ARCHITECTURE.md, DEVELOPER_GUIDE.md

### Books
- **"Game Programming Patterns"** by Robert Nystrom (free!)
- **"Head First Design Patterns"** by Freeman & Freeman

### Online
- **Project Euler** - Programming challenges
- **LeetCode** - Coding practice
- **GitHub** - Study open-source code
- **GDC Vault** - Game dev conference talks (free)

---

# SLIDE 55: Thank You!

## Any Questions?

```
Remember:
□ Start simple (Pong, Snake)
□ Use patterns (they exist for a reason)
□ Test early, test often
□ Get feedback from others
□ Iterate, iterate, iterate

The code you write today
is the foundation for tomorrow's career!
```

---

# SLIDE 56: Bonus: Glossary (Optional)

### Programming Terms

| Term | Meaning |
|------|---------|
| **Class** | Blueprint for objects |
| **Instance** | Individual object |
| **Inheritance** | Child inherits from parent |
| **Method** | Function in a class |
| **Enum** | Named set of constants |
| **State** | Current condition |
| **Event** | Something that happened |

---

# SLIDE 57: Bonus: Design Patterns Summary

### Patterns Used in Galaga Wars

```
✓ State Machine       - Game and enemy states
✓ Inheritance        - Enemy hierarchy
✓ Factory            - spawnEnemy() creates correct type
✓ Singleton          - GameManager (only one instance)
✓ Object Pool        - Reuse missiles, enemies
✓ Event System       - Create, Step, Draw, Collision
✓ Data-Driven        - Configuration in JSON
✓ Error Handling     - Safe functions
```

---

# SLIDE 58: Bonus: Performance Optimization

### How Galaga Wars Handles 40 Enemies

```
✓ Object Pooling     - Reuse instead of create/destroy
✓ Asset Caching      - Load once, use many times
✓ Collision Shortcuts- Only check nearby objects
✓ Path System        - GameMaker handles movement
✓ Event Cleanup      - Remove when no longer needed
✓ Efficient Drawing  - Simple sprite rendering
```

**Result: Smooth 60 FPS with minimal CPU usage**

---

# SLIDE 59: About the Code

### Where to Find It

- **Repository:** GitHub (Galaga)
- **Language:** GameMaker Language (GML)
- **Engine:** GameMaker Studio 2
- **Total Lines:** ~11,000 (including tests)
- **Time to Build:** ~6 months
- **Status:** Complete, playable game

### Can You...

- ✓ Run the game
- ✓ Read the source code
- ✓ Modify and recompile
- ✓ Add features
- ✓ Study patterns in detail

---

# SLIDE 60: Final Inspiration

### Think About This

```
1981: Namco releases Galaga arcade game
      - 2-3 year development
      - ~10 programmers
      - ~10,000 lines of assembly code
      - Limited hardware

2024: You study modern Galaga remake
      - 6 month development
      - 1-2 person team
      - ~11,000 lines of GML
      - Professional tools

Future: YOU could build the next great game
      - Your ideas
      - Your creativity
      - Your code
      - For millions of players
```

**Anything is possible with good code, good patterns, and determination.**

---

**Total Slides: 60 (fits 1-hour presentation)**
**Each slide: ~30-60 seconds speaking time**
**Format: Markdown (convert to PowerPoint/Google Slides)**

---

## Notes for Presenter

### Timing Guide
- Slides 1-10: Introduction (10 min)
- Slides 11-27: Concepts (16 min)
- Slides 28-39: Patterns & Walkthrough (12 min)
- Slides 40-44: Testing & Error Handling (5 min)
- Slides 45-60: Applications & Closing (7 min)

### Speaking Tips
- Pause on code slides to let students read
- Ask comprehension questions mid-way
- Show actual game running (if possible)
- Emphasize "this is real code"
- Use analogies (traffic light for state machine)
- Be enthusiastic about the subject!

### Engagement
- Ask class "What would happen if...?"
- Invite students to predict outcomes
- Show mistakes (what NOT to do)
- Connect to games students play
- Show career opportunities

### Success Indicators
- Students ask questions
- Heads nodding in understanding
- Some students excited about learning more
- Good discussion during Q&A
- Students thinking about applying concepts
