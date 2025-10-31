# Galaga Wars: AP Computer Science Presentation
## Slide Deck Format (for Powerpoint/Google Slides)

---

# SLIDE 1: Title Slide

## Galaga Wars
### A Study in Game Design & Object-Oriented Programming

**Learn how 2500+ lines of code create a complete arcade game**

- Engine: GameMaker Studio 2
- Language: GameMaker Language (GML)
- Real Production Code
- Industry-Standard Patterns

---

# SLIDE 2: What is Galaga Wars?

![Galaga Wars Screenshot]

**Galaga Wars** - A modern arcade game with Star Wars theme

- **Classic Gameplay:** Defend against enemy waves
- **Modern Implementation:** Professional game development practices
- **Real Code:** Shipped production version
- **Learning Tool:** Demonstrates programming concepts

### Key Stats:
- ~2500 lines of production code
- 8+ game states
- 40 enemies per level
- Multiple difficulty levels
- Professional error handling

---

# SLIDE 3: Why Study This Code?

### Four Reasons

1. **Real Production Code**
   - Not simplified examples
   - Professional quality
   - Actually shipped to players

2. **Industry-Standard Patterns**
   - State machines
   - Object-oriented design
   - Data-driven architecture
   - Error handling

3. **Scalable Architecture**
   - Hundreds of moving objects
   - Smooth 60 FPS gameplay
   - Memory efficient
   - Easy to modify

4. **Career-Relevant Skills**
   - Game studios use these exact patterns
   - Web development uses state machines
   - Mobile apps use event-driven programming
   - Robotics uses path planning

---

# SLIDE 4: Project Structure

```
Galaga/
├── objects/
│   ├── oGameManager (controller)
│   ├── oEnemyBase (parent class)
│   ├── oTieFighter, oTieIntercepter, etc. (enemies)
│   └── oPlayer (player ship)
│
├── scripts/
│   ├── GameManager_STEP_FNs.gml (game loop)
│   ├── ErrorHandling.gml (robust code)
│   └── ... other utilities
│
├── datafiles/
│   ├── wave_spawn.json (enemy waves)
│   ├── challenge_spawn.json (bonus stages)
│   └── formation_coordinates.json (grid positions)
│
└── rooms/, paths/, sprites/
```

### Key Insight:
**Code + Data Separation**
- Code defines HOW enemies work
- JSON defines WHAT waves look like
- Enables iteration without recompiling

---

# SLIDE 5: Codebase Breakdown

| Component | Lines | Purpose |
|-----------|-------|---------|
| Game Logic | 905 | Main game loop, spawning, progression |
| Enemy Behavior | 600+ | Movement, attacks, intelligence |
| Error Handling | 250+ | Defensive programming |
| UI & Sound | 800+ | Visual/audio feedback |
| **Total** | **~2500+** | Complete functional game |

### Perspective:
- Mobile app: 10,000-100,000 lines
- AAA game: 1,000,000+ lines
- Galaga Wars: Focused, clean, efficient

---

# SLIDE 6: Game States (State Machine)

```
          ┌─ ATTRACT_MODE
          │      ↓
      START   INSTRUCTIONS
       GAME        ↓
     ACTIVE ← GAME_PLAYER_MESSAGE
       ↓ ↑         ↓
     PAUSE    GAME_STAGE_MESSAGE
       ↓           ↓
   PAUSED      SPAWN_ENEMY_WAVES
                    ↓
              GAME_ACTIVE (main loop)
                    ↓
              SHOW_RESULTS
                    ↓
              ENTER_INITIALS
                    ↓
              Back to ATTRACT_MODE
```

### Why?
- Clear transitions
- Only one state at a time
- Prevents invalid combinations
- Easy to debug

---

# SLIDE 7: Object-Oriented Programming

### Inheritance Hierarchy

```
        oEnemyBase
       /    |     \
      /     |      \
 oTieFighter oTieIntercepter oImperialShuttle
```

### What's Inherited?
- Path following
- Formation positioning
- Dive attack patterns
- Health/collision detection

### What's Different?
- Sprite appearance
- Speed values
- Health amount
- Special abilities

### Result:
**DRY Principle** (Don't Repeat Yourself)
- Shared code in parent class
- No duplication across 3 enemy types
- Change one thing affects all enemies

---

# SLIDE 8: Data-Driven Design

### The Problem (Hardcoded):
```gml
// Enemy 1
spawn_enemy("oTieFighter", 500, -20, "path1");
spawn_enemy("oTieIntercepter", 400, -20, "path2");
spawn_enemy("oTieIntercepter", 600, -20, "path2");

// ... 37 more enemies hardcoded ...
// To change wave, recompile!
```

### The Solution (Data-Driven):
```json
{
  "WAVE": [{
    "SPAWN": [
      {
        "ENEMY": "oTieFighter",
        "SPAWN_XPOS": 500,
        "INDEX": 1,
        "PATH": "path1"
      }
    ]
  }]
}
```

### Benefits:
✓ Change level design in seconds
✓ Non-programmers can design levels
✓ Easy version control
✓ Supports modding

---

# SLIDE 9: Key Programming Concept: Enums

### Without Enums (Bad)
```gml
global.gameMode = 0;  // What does 0 mean?

if (global.gameMode == 0) { ... }      // Confusing!
if (global.gameMode == 1) { ... }      // What is 1?
```

### With Enums (Good)
```gml
enum GameMode {
    ATTRACT_MODE,
    GAME_ACTIVE,
    GAME_PAUSED
}

global.gameMode = GameMode.GAME_ACTIVE; // Clear!

if (global.gameMode == GameMode.GAME_ACTIVE) { ... } // Obvious!
```

### Key Insight:
**Code should read like English**
- Self-documenting
- Easier to debug
- Fewer mistakes

---

# SLIDE 10: Game Loop - Coordination

```gml
function Game_Loop() {
    // 1. Safety checks
    if (global.isGamePaused) return;
    if (readyForNextLevel()) return;

    // 2. Game mechanics
    checkForExtraLives();
    checkDiveCapacity();
    controlEnemyFormation();

    // 3. Spawn enemies
    if (!waveComplete()) {
        if (alarm[2] == -1) {
            spawnEnemy();
        }
    }

    // 4. Check progression
    if (waveComplete()) {
        global.wave += 1;
    }
}
```

### Execution Every Frame:
```
Check pause → Check level done → Award lives → Update AI → Spawn → Check wave
1 frame = 1/60 second = Run all this!
```

---

# SLIDE 11: Error Handling - Defensive Code

### Without Error Handling (Crashes)
```gml
var enemy_id = asset_get_index("oWrongName");
instance_create_layer(x, y, "GameSprites", enemy_id);
// CRASH! enemy_id is -1, not a valid object
```

### With Error Handling (Graceful)
```gml
var enemy_id = safe_get_asset("oWrongName", -1);
if (enemy_id != -1) {
    instance_create_layer(x, y, "GameSprites", enemy_id);
} else {
    log_error("Enemy not found: oWrongName", "spawnEnemy", 2);
    // Game continues, logs the problem
}
```

### Professional Principle:
**Expect the unexpected**
- Missing assets
- Corrupted data
- Edge cases
- User errors

---

# SLIDE 12: Safe Functions Library

### Safe Asset Lookup
```gml
var id = safe_get_asset("assetName", -1);
```

### Safe JSON Loading
```gml
var data = safe_load_json("file.json", {});
```

### Safe Struct Access
```gml
var value = safe_struct_get(struct, "key", default);
```

### Benefits:
✓ Prevents crashes
✓ Provides fallbacks
✓ Logs what went wrong
✓ Game continues running

---

# SLIDE 13: Complete Enemy Spawn Flow

```
Game_Loop() decides to spawn
    ↓
spawnEnemy() reads JSON
    ↓
JSON says: ENEMY = "oTieFighter"
    ↓
safe_get_asset() validates
    ↓
instance_create_layer() creates object
    ↓
Create_0.gml initializes (enemyState = ENTER_SCREEN)
    ↓
Every frame:
    Step_0.gml updates (move along path)
    Draw_0.gml renders (draw sprite)
    Collision events (if hit player)
    ↓
When health = 0:
    Destroy event (cleanup)
```

---

# SLIDE 14: Design Decision 1: Why JSON?

### Question: Why not hardcode level data?

### Answers:

**Speed:** Change levels without recompiling (10x faster)

**Collaboration:** Designers create levels without programming

**Version Control:** Diffs show exactly what changed

**Modding:** Players create custom levels

**Flexibility:** Change behavior through data, not code

---

# SLIDE 15: Design Decision 2: State Machine vs. Flags

### Flag Approach (Wrong)
```gml
global.isPlaying = true;
global.isPaused = false;
global.isShowingResults = false;

// What if all three are true? Invalid state!
```

### State Machine (Right)
```gml
global.gameMode = GameMode.GAME_ACTIVE;
// Only ONE mode at a time
// Impossible to have invalid combinations
```

### Benefits:
✓ Logically correct
✓ Prevents bugs
✓ Clear transitions
✓ Self-documenting

---

# SLIDE 16: Design Decision 3: Inheritance

### Question: Why not copy code for each enemy?

### Inheritance (What We Do)
```gml
oTieFighter extends oEnemyBase
// Reuses: path following, formation, dive attacks
// Defines: unique sprite, health, speed
```

### Result:
- oTieFighter: 20 lines
- oTieIntercepter: 20 lines
- oImperialShuttle: 20 lines
- Total: 60 lines + shared code in oEnemyBase

### Without Inheritance:
- Each enemy: 200+ lines
- Total: 600+ lines (10x more!)
- Changes to formation must be made 3 places

---

# SLIDE 17: Event-Driven Programming

### Lifecycle of an Enemy Object

```
Event              When                   Code
─────────────────────────────────────────────────────
Create             Object created once    Initialize variables
Step               Every frame (60x/sec)   Update logic
Draw               Every frame (60x/sec)   Render sprite
Collision_oShot    Hit by player shot      Take damage
Destroy            Object deleted          Cleanup
```

### Example: 1 Second of Gameplay

```
0ms - Create Event (constructor)
     Step: move, check formation
     Draw: show sprite
17ms - Step, Draw
33ms - Step, Draw
50ms - Collision Event (hit by player shot)
     hitCount--;
67ms - Step, Draw (but damaged)
...continuing...
```

---

# SLIDE 18: Paths - Moving on Curves

### Visual Editor (Drag nodes)
```
       ↗ ←Start
      /   \
     /     ↘ ←End
```

### GameMaker Code
```gml
path_start(path_id, speed, path_action, closed);
// Automatically moves object along path
// Each frame: adjust x, y to next position
```

### Advantages:
✓ Design movements visually
✓ Smooth, choreographed motion
✓ Easy to tweak
✓ Reusable paths

---

# SLIDE 19: Performance - 40 Enemies at 60 FPS

### What's Running Every Frame?

```
60 frames per second = 1 frame every 16.7 milliseconds

Each frame:
  • 40 enemies × Step events
  • 40 enemies × Collision checks
  • 40 enemies × Draw events
  • Game logic (spawning, state management)
  • Player input handling
  • Audio management

Total: ~1000+ operations per frame
```

### Optimization Techniques Used:
1. **Lazy Initialization** - Load JSON once, not every frame
2. **Spatial Partitioning** - Only check nearby collisions
3. **Pooling** - Reuse objects instead of create/destroy
4. **Dirty Flag Pattern** - Only recalculate when changed

---

# SLIDE 20: Testing the Code

### How You'd Test This:

1. **Functional Testing**
   ```gml
   // Verify wave 1 spawns correct enemies
   assert(nOfEnemies() == 40);
   ```

2. **Error Testing**
   ```gml
   // Delete a path file, verify error handling
   test_missing_asset("NonexistentPath");
   ```

3. **Performance Testing**
   ```gml
   // Measure frame rate with 40 enemies
   measure_fps();
   ```

4. **Gameplay Testing**
   ```gml
   // Manually play, check if fun!
   // Does difficulty feel right?
   // Are waves balanced?
   ```

---

# SLIDE 21: Real-World Applications

### This Code Structure Appears In:

**Game Development**
- Unreal Engine (C++) uses state machines
- Unity uses component-based architecture
- Every game uses asset management

**Web Development**
- React uses component hierarchy (like inheritance)
- Redux uses state management (like our gameMode)
- Data-driven design everywhere

**Mobile Apps**
- Event-driven lifecycle (Create/Destroy)
- State machines for navigation
- Error handling for network failures

**Robotics**
- State machines for behavior (Idle → Attack → Retreat)
- Path planning (ROS, navigation)
- Sensor error handling

---

# SLIDE 22: Code Quality Principles

### This Codebase Demonstrates:

| Principle | Example |
|-----------|---------|
| **DRY** | Inheritance eliminates duplicate enemy code |
| **KISS** | Simple state machine instead of complex flags |
| **YAGNI** | No unnecessary features |
| **Single Responsibility** | Each object handles one thing |
| **Error Handling** | safe_get_asset() prevents crashes |
| **Documentation** | Comments explain WHY, not WHAT |
| **Modular Design** | Easy to test individual components |

---

# SLIDE 23: Potential Improvements

### What Could We Enhance?

1. **Object Pooling**
   - Reuse enemy instances instead of create/destroy
   - Reduces memory allocation

2. **Particle Systems**
   - Explosions, effects, visual polish
   - Hundreds of particles with GPU acceleration

3. **AI Improvements**
   - Machine learning for difficulty scaling
   - Enemies learn from player behavior

4. **Multiplayer**
   - Two players simultaneously
   - Cooperative vs. competitive modes

5. **Procedural Generation**
   - Randomly generate levels
   - Infinite replayability

---

# SLIDE 24: Your Turn - Challenge Questions

### Easy:
1. Draw the state machine for Galaga Wars
2. What does oEnemyBase inherit to oTieFighter?
3. Why use JSON instead of hardcoded code?

### Medium:
4. Write a safe function to load a JSON file
5. How would you add a new game state (TUTORIAL)?
6. Design a new enemy type - what would you create?

### Hard:
7. How would you support 1000 enemies instead of 40?
8. Design a multiplayer version - what changes?
9. Write an automated test for wave spawning

---

# SLIDE 25: Career Connections

### Programming Jobs That Use These Concepts:

**Game Development**
- Programmer, Designer, Technical Director
- Studios: Activision, EA, Ubisoft, Rockstar Games

**Web Development**
- Frontend Engineer (React, Vue, Angular)
- State management, component architecture

**Mobile Development**
- iOS/Android Engineer
- Event-driven programming, lifecycle management

**Robotics**
- Roboticist, Controls Engineer
- State machines, path planning, error handling

**Machine Learning**
- Game AI Programmer
- Behavior trees, state machines for NPC behavior

---

# SLIDE 26: Key Takeaways

### What You've Learned:

1. **State Machines** - Structure complex programs
2. **Inheritance** - Share code across similar objects
3. **Data-Driven Design** - Separate code from content
4. **Error Handling** - Make robust software
5. **Game Loops** - Coordinate multiple systems
6. **Professional Practices** - How real code is written
7. **Design Patterns** - Proven solutions to common problems

### Most Important:
**Good code is:**
- ✓ Readable (others understand it)
- ✓ Maintainable (easy to change)
- ✓ Robust (handles errors gracefully)
- ✓ Efficient (performs well)
- ✓ Documented (explains WHY)

---

# SLIDE 27: Resources for Further Learning

### GameMaker
- Official docs: https://manual.yoyogames.com
- Free game engine with good tutorials

### Design Patterns
- "Game Programming Patterns" (free online)
- "Head First Design Patterns" (book)

### Game Development
- "The Art of Game Design" by Jesse Schell
- GDC Vault (free conference talks)

### Programming
- Project Euler (programming problems)
- LeetCode (coding interviews)
- GitHub (study open-source code)

---

# SLIDE 28: Final Question

## If you could build ANY game...

### What would it be?

Think about:
- What story would you tell?
- What mechanics would be fun?
- What systems would you need?
- What challenges would you face?

**This is where game design begins!**

---

# SLIDE 29: Thank You!

## Questions?

**Remember:**
- Start simple (Pong, Tetris)
- Use established patterns
- Test constantly
- Get feedback early
- Iterate, iterate, iterate

**The code you write today is the foundation for tomorrow's career!**

---

# APPENDIX: Glossary Slides (Optional)

## Glossary 1: OOP Terms

| Term | Definition |
|------|-----------|
| **Class** | Blueprint for objects |
| **Instance** | Individual object created from class |
| **Inheritance** | Child class inherits from parent |
| **Method** | Function belonging to object |
| **Property** | Variable belonging to object |
| **Polymorphism** | Same method, different behavior |

## Glossary 2: Game Terms

| Term | Definition |
|------|-----------|
| **Spawn** | Create new instance dynamically |
| **State** | Current mode/condition of object |
| **Collision** | Two objects touching |
| **Path** | Predefined trajectory |
| **Formation** | Organized group arrangement |
| **Frame** | One screen render (60 per second) |

## Glossary 3: Software Terms

| Term | Definition |
|------|-----------|
| **Algorithm** | Step-by-step problem solving |
| **Data Structure** | Way to organize data |
| **Design Pattern** | Proven solution to common problem |
| **Refactoring** | Improving code without changing behavior |
| **DRY** | Don't Repeat Yourself principle |
| **SOLID** | Five principles of good design |

