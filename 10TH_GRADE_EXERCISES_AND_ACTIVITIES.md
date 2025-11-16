# 10th Grade Computer Science Exercises
## Based on Galaga Wars Codebase
### Activities for Understanding Game Design & Programming

---

## Activity 1: Understanding State Machines (15 min)

### Exercise 1.1: Draw the Game State Machine

**Instructions:**
1. On paper or whiteboard, draw the 12-state game state machine for Galaga Wars
2. Show all transitions (arrows between states)
3. Label each state with what happens in that state

**What to draw:**
```
Each state should show:
- State name
- What happens in that state
- Arrow showing next state

Example:
┌─────────────────────┐
│  ATTRACT_MODE       │
│  (Show title,       │
│   wait for input)   │
└────────────┬────────┘
             │ (Player presses space)
             ↓
         INSTRUCTIONS
```

**Discussion Questions:**
- Can you go directly from ATTRACT_MODE to GAME_ACTIVE? Why/why not?
- What would happen if we forgot a state transition?
- Why is it impossible to be in two states at once?

---

### Exercise 1.2: Trace the State Machine

**Instructions:**
Playing through Galaga Wars, trace the states in order:

```
1. Game boots up → What's the first state?
   ANSWER: _______________

2. Player waits watching title → What state?
   ANSWER: _______________

3. Player presses Space → What states happen next?
   ANSWER: _____________ → _____________ → _____________

4. Game is running, player dies → What states?
   ANSWER: _____________ → _____________

5. Game complete, show high score entry → What state?
   ANSWER: _______________
```

**Extension:** Think of a different game (Fortnite, Minecraft, Mario). What states would THAT game have?

---

### Exercise 1.3: Design Your Own State Machine

**Instructions:** Design a simple game: "Rock Paper Scissors"

```
Possible states:
1. MENU
2. WAITING_FOR_PLAYER_INPUT
3. COMPARING_CHOICES
4. SHOWING_RESULT
5. ???

Complete the list and draw the transitions.
```

**What transitions make sense?**
```
MENU → WAITING_FOR_PLAYER_INPUT → COMPARING_CHOICES
         → ??? (what's next?)
```

---

## Activity 2: Understanding Inheritance (15 min)

### Exercise 2.1: Find the Shared Code

**Instructions:**
Looking at three enemy types (TieFighter, TieIntercepter, ImperialShuttle), what code is SHARED by all three?

**Work in groups:**

```
TieFighter:
- Follows paths
- Forms in grid
- Can dive attack
- Takes damage
- Plays death sound

TieIntercepter:
- Follows paths
- Forms in grid
- Can dive attack
- Takes damage
- Plays death sound

ImperialShuttle:
- Follows paths
- Forms in grid
- Can dive attack (different rate)
- Takes damage (more health)
- Plays death sound

SHARED CODE (in base class):
✓ Path following
✓ Grid formation
✓ Dive attack (mechanics)
✓ Damage system
✓ Sound system

UNIQUE CODE (in each class):
✓ Sprite/appearance
✓ Speed values
✓ Health amount
✓ Special abilities
```

**Questions:**
- How many lines would this be WITHOUT inheritance? (3× as much)
- How many lines WITH inheritance? (1/3 as much)
- If we found a bug in "take damage," how many places would we fix?

---

### Exercise 2.2: Design an Inheritance Hierarchy

**Instructions:** You're adding 5 new enemy types to Galaga Wars:

```
New enemies needed:
1. TIE Bomber (drops bombs)
2. TIE Advanced (faster)
3. Star Destroyer (large, slow boss)
4. Interceptor (quick, fewer health)
5. Scout (weak, but fast)
```

**Design the hierarchy:**

```
oEnemyBase (parent - shared code)
    ├─ oTieFighter
    ├─ oTieIntercepter
    ├─ oImperialShuttle
    ├─ ??? (new)
    ├─ ??? (new)
    ├─ ??? (new)
    ├─ ??? (new)
    └─ ??? (new)

What would you name each new class?
oTIE_Bomber? o_TieBomber? oTieBomber?
```

**Questions:**
- Would ALL five inherit from oEnemyBase?
- Could you create a sub-hierarchy (medium-sized enemies)?
- What's an example of something that would break if not inherited?

---

### Exercise 2.3: Spot the Duplicate Code

**Instructions:** Here's code WITHOUT inheritance:

```gml
// oTieFighter/Create_0.gml
function Create_0() {
    baseSpeed = 6;
    moveSpeed = baseSpeed * global.speedMultiplier;
    enemyState = EnemyState.ENTER_SCREEN;
    formation = global.formation_data;
    xstart = formation.POSITION[INDEX]._x;
    ystart = formation.POSITION[INDEX]._y;
    hitCount = 1;
}

// oTieIntercepter/Create_0.gml
function Create_0() {
    baseSpeed = 6;
    moveSpeed = baseSpeed * global.speedMultiplier;
    enemyState = EnemyState.ENTER_SCREEN;
    formation = global.formation_data;
    xstart = formation.POSITION[INDEX]._x;
    ystart = formation.POSITION[INDEX]._y;
    hitCount = 2;  // Different health!
}

// oImperialShuttle/Create_0.gml
function Create_0() {
    baseSpeed = 6;
    moveSpeed = baseSpeed * global.speedMultiplier;
    enemyState = EnemyState.ENTER_SCREEN;
    formation = global.formation_data;
    xstart = formation.POSITION[INDEX]._x;
    ystart = formation.POSITION[INDEX]._y;
    hitCount = 3;  // Different health!
}
```

**Task:**
1. Circle all the DUPLICATED code
2. What's UNIQUE in each class?
3. Rewrite using inheritance

---

## Activity 3: Data-Driven Design (15 min)

### Exercise 3.1: Hardcoding vs. JSON

**Part A: The Hardcoded Way**

```gml
❌ HARDCODED (takes 30 seconds to test a change)

function spawn_level_1() {
    spawn_enemy("oTieFighter", 100, -20, "path1");
    spawn_enemy("oTieFighter", 200, -20, "path1");
    spawn_enemy("oTieIntercepter", 150, -20, "path2");
    // ... 37 more enemies ...
}
```

**Instructions:** Count how many steps to test a change:
1. Edit code
2. Save file
3. Recompile (30 sec wait)
4. Run game
5. Test
6. Repeat

**Time for 10 variations:** 5+ minutes

---

**Part B: The Data-Driven Way**

```json
✓ DATA-DRIVEN (takes 1 second to test a change)

{
  "WAVE": [{
    "SPAWN": [
      {
        "ENEMY": "oTieFighter",
        "SPAWN_XPOS": 100,
        "SPAWN_YPOS": -20,
        "PATH": "path1"
      },
      {
        "ENEMY": "oTieFighter",
        "SPAWN_XPOS": 200,
        "SPAWN_YPOS": -20,
        "PATH": "path1"
      }
    ]
  }]
}
```

**Instructions:** Count steps to test a change:
1. Edit JSON file
2. Save
3. Refresh game (engine reloads JSON)
4. Test

**Time for 10 variations:** 30 seconds

---

### Exercise 3.2: Create a Wave Configuration

**Instructions:** Write JSON to create a wave with 6 enemies in specific patterns:

**Pattern 1: Horizontal line (3 enemies)**
```
[1]  [2]  [3]
```

**Pattern 2: Diagonal line (3 enemies)**
```
[1]
     [2]
          [3]
```

**Write JSON:**
```json
{
  "WAVE": [{
    "SPAWN": [
      {
        "ENEMY": "oTieFighter",
        "SPAWN_XPOS": ???,
        "SPAWN_YPOS": ???,
        "PATH": "entrance_path",
        "INDEX": ???
      },
      // ... more enemies ...
    ]
  }]
}
```

**Hints:**
- X coordinates for horizontal: 150, 250, 350
- Y coordinates: -20 (above screen)
- Use different INDEX values (1-6)

---

### Exercise 3.3: Compare Approaches

**Instructions:** Fill in the table:

| Aspect | Hardcoded | Data-Driven |
|--------|-----------|-------------|
| Time to test a change | | |
| Can non-programmers use it? | | |
| Easy to create variations? | | |
| Easy to version control? | | |
| How many places to edit? | | |
| Support for modding? | | |

**Discussion:**
- Which approach is better? Why?
- When might hardcoding be acceptable?
- What if you need 100 different waves?

---

## Activity 4: Error Handling (10 min)

### Exercise 4.1: Spot the Crashes

**Instructions:** These code snippets will crash. Find the crash and explain why:

**Example 1:**
```gml
var enemy_id = asset_get_index("oWrongEnemyType");
instance_create_layer(x, y, "GameSprites", enemy_id);
// Crashes because: ___________________
```

**Example 2:**
```gml
var data = json_parse_file("missing_file.json");
var enemy_count = data.enemies.count;
// Crashes because: ___________________
```

**Example 3:**
```gml
var my_array = [1, 2, 3];
var value = my_array[999];
draw_text(10, 10, "Value: " + string(value));
// Crashes because: ___________________
```

**Example 4:**
```gml
var health_value = safe_struct_get(global.enemy_stats, "health", 100);
if (health_value == undefined) {
    // This code runs sometimes
}
// Problem: ___________________
```

---

### Exercise 4.2: Write Safe Functions

**Instructions:** Rewrite the crashing code to be safe:

**Before (Crashes):**
```gml
var enemy_id = asset_get_index("oTieFighter");
instance_create_layer(x, y, "GameSprites", enemy_id);
```

**After (Safe):**
```gml
var enemy_id = safe_get_asset("oTieFighter", -1);
if (enemy_id != -1) {
    instance_create_layer(x, y, "GameSprites", enemy_id);
} else {
    log_error("Enemy type not found", "spawn_enemy", 2);
}
```

**Now rewrite these:**

```gml
// 1. Loading JSON file
var config = json_parse_file("config.json");
show_message("Loaded: " + config.title);


// 2. Accessing array
var enemies = [enemy1, enemy2, enemy3];
var selected = enemies[5];
show_message(selected.name);


// 3. Getting struct property
var stats = global.player_stats;
show_message("Health: " + stats.health);
```

---

### Exercise 4.3: Error Handling Philosophy

**Instructions:** For each scenario, decide: Crash or Continue?

```
1. Missing enemy sprite
   ☐ Crash immediately
   ☐ Use placeholder sprite, log warning

   Why? ___________________

2. JSON wave data corrupted
   ☐ Crash with error
   ☐ Skip that wave, log error, continue

   Why? ___________________

3. Player attempts invalid move
   ☐ Crash and exit game
   ☐ Ignore input, show message

   Why? ___________________

4. Out of memory
   ☐ Crash (can't recover)
   ☐ Clean up unused objects, continue

   Why? ___________________
```

**Key Principle:** Players prefer a game that continues with reduced functionality over a crash.

---

## Activity 5: Polymorphism (10 min)

### Exercise 5.1: Understanding Polymorphism

**Definition:** "Many forms" - same method, different behavior based on object type

### Exercise 5.2: Same Method, Different Behavior

**Instructions:** All three enemy types have these methods:

```gml
function move_toward_formation() { ... }
function start_dive_attack() { ... }
function take_damage(amount) { ... }
```

**Question:** Are they the SAME code or DIFFERENT?

```
TieFighter.move_toward_formation()
    → Speed: 6
    → Animation: Standard

ImperialShuttle.move_toward_formation()
    → Speed: 3 (slower boss)
    → Animation: Heavy movement

Both are "move_toward_formation()" but behave differently!
This is POLYMORPHISM.
```

**Task:**
Design how take_damage() might be different:

```gml
// TieFighter - takes normal damage
function take_damage(amount) {
    hitCount -= amount;  // Takes full damage
}

// ImperialShuttle - takes reduced damage (tougher)
function take_damage(amount) {
    hitCount -= (amount * 0.5);  // Takes half damage
}
```

---

## Activity 6: Testing (10 min)

### Exercise 6.1: Write Test Cases

**Instructions:** For a wave spawner that should spawn 40 enemies, write test cases:

```gml
✓ TEST 1: Correct Number of Enemies
function test_spawn_40_enemies() {
    spawn_wave(1);  // Spawn wave 1

    assert_equals(
        instance_number(oEnemyBase),
        40,
        "Wave should spawn exactly 40 enemies"
    );
}

NOW WRITE:

□ TEST 2: Correct Enemy Types
   (Should spawn specific enemy types: TieFighter, Intercepter, etc.)

   assert_equals(...) or assert_true(...)

□ TEST 3: Correct Positions
   (Enemies should start at spawn positions specified in JSON)

□ TEST 4: Formation Grid Assignment
   (Each enemy should know which grid position to move to)
```

---

### Exercise 6.2: What Could Go Wrong?

**Instructions:** For enemy collision detection, what could break?

```
SCENARIO 1: What if player moves too fast?
Possible issue: _____________________
How to test: _____________________

SCENARIO 2: What if two enemies occupy same grid position?
Possible issue: _____________________
How to test: _____________________

SCENARIO 3: What if enemy has 0 health but doesn't die?
Possible issue: _____________________
How to test: _____________________
```

---

## Activity 7: Design Decisions (10 min)

### Exercise 7.1: Why These Design Choices?

**Question 1: Why use enum instead of magic numbers?**

```gml
❌ Magic Numbers
if (global.gameMode == 3) { ... }

✓ Enums
if (global.gameMode == GameMode.GAME_ACTIVE) { ... }

Why is ✓ better?
```

**Your answer:**
- Readability: ___________________
- Debugging: ___________________
- Maintainability: ___________________

---

**Question 2: Why inheritance instead of copying code?**

```gml
❌ Copy-Paste
// Same code in 3 files

✓ Inheritance
// Shared in 1 file, used by 3

Benefits:
- Code size: ___________________
- Maintenance: ___________________
- Bug fixes: ___________________
```

---

**Question 3: Why object pooling?**

```gml
❌ Create/Destroy
Each shot: instance_create()
2,400 shots per second = garbage collection hiccups

✓ Object Pooling
Reuse 50 shot objects forever = smooth frame rate

What's the performance impact?
- FPS without pooling: ___________________
- FPS with pooling: ___________________
- User experience difference: ___________________
```

---

### Exercise 7.2: Make Your Own Design Decision

**Scenario:** You want to add power-ups to Galaga Wars.

```
Questions to answer:

1. Hardcoded power-ups or JSON-based?
   Advantages: ___________________
   Disadvantages: ___________________

2. Inherit from oPickupBase or composition?
   Advantages: ___________________
   Disadvantages: ___________________

3. Same state machine for all power-ups or unique?
   Advantages: ___________________
   Disadvantages: ___________________
```

---

## Activity 8: Code Reading (15 min)

### Exercise 8.1: Trace an Enemy Lifetime

**Instructions:** Follow the code walkthrough and fill in the timeline:

```
Timeline of an Enemy

Frame 0ms:    spawnEnemy() called
              ↓ What happens? _____________________

Frame 0.5ms:  instance_create_layer() executed
              ↓ What happens next? _____________________

Frame 1ms:    Create_0.gml runs
              ↓ What variables initialized? _____________________

Frames 10-100ms: Step_0.gml runs every frame
              ↓ What happens? _____________________

Frames 10-100ms: Draw_0.gml runs every frame
              ↓ What's drawn? _____________________

Frame ~2000ms: Collision with missile
              ↓ What function runs? _____________________

Frame ~2010ms: Enemy destroyed
              ↓ What happens? _____________________
```

---

### Exercise 8.2: Find the Code

**Instructions:** Match the code to the description:

**1. Where does the enemy find its grid position?**
   ```gml
   A) var xstart = formation.POSITION[INDEX]._x;
   B) var enemy_id = asset_get_index("oTieFighter");
   C) path_start(path_id, entranceSpeed, 0, 0);
   D) instance_create_layer(x, y, "GameSprites", enemy_id);
   ```
   Answer: ___

**2. Where does the enemy start following a path?**
   Answer: ___

**3. Where is the enemy object created?**
   Answer: ___

**4. Where is the enemy type validated?**
   Answer: ___

---

## Activity 9: Concept Integration (20 min)

### Exercise 9.1: Full System Analysis

**Instructions:** Explain how these concepts work together:

```
STATE MACHINE + INHERITANCE + DATA-DRIVEN DESIGN

Game is in GAME_ACTIVE state
    ↓
Game_Loop() calls spawnEnemy()
    ↓
spawnEnemy() reads JSON wave configuration
    ↓
Finds enemy type "oTieFighter" in JSON
    ↓
Calls safe_get_asset("oTieFighter", -1)
    ↓
Creates instance_create_layer(..., oTieFighter)
    ↓
oTieFighter Create_0() runs
    ↓
oTieFighter inherits from oEnemyBase
    ↓
oEnemyBase Create_0() runs (initialization)
    ↓
Enemy starts ENTER_SCREEN state
    ↓
Every frame:
    Step_0() updates state based on state machine
    Draw_0() renders sprite
    ↓
If hit by missile:
    Collision_oMissile() runs
    hitCount decreases
    If health = 0: instance_destroy()
    ↓
Destroy event runs (cleanup)
```

**Task:** Identify where each concept appears in this flow:

| Concept | Where in the flow? | Why is it needed? |
|---------|-------------------|------------------|
| State Machine | ______________ | ______________ |
| Inheritance | ______________ | ______________ |
| Data-Driven | ______________ | ______________ |
| Error Handling | ______________ | ______________ |
| Events | ______________ | ______________ |

---

### Exercise 9.2: What If We Removed Each Concept?

**Instructions:** For each concept, explain what breaks if removed:

```
IF WE REMOVED STATE MACHINES:
- Problem: ___________________
- Result: Game would ___________________

IF WE REMOVED INHERITANCE:
- Problem: ___________________
- Result: Code would ___________________

IF WE REMOVED DATA-DRIVEN DESIGN:
- Problem: ___________________
- Result: Developers would ___________________

IF WE REMOVED ERROR HANDLING:
- Problem: ___________________
- Result: Game would ___________________
```

---

## Activity 10: Creative Challenge (20 min)

### Challenge 1: Design a New Game State

**Instructions:** The game needs a TUTORIAL state:

```
Questions to answer:

1. What happens in TUTORIAL state?
   Answer: _____________________

2. Where does it appear in the state machine?
   (Before GAME_ACTIVE? After? Optional?)
   Answer: _____________________

3. What code needs to change?
   - oGameManager/Step_0.gml? (add switch case?)
   - GameManager_STEP_FNs.gml? (add Tutorial_Loop()?)
   - New script? (Tutorial.gml?)

4. How to exit TUTORIAL?
   (Press Space? Finish all lessons?)
   Answer: _____________________

5. What should be drawn?
   (Text, arrows, highlights?)
   Answer: _____________________
```

---

### Challenge 2: Design a New Enemy Type

**Instructions:** Create a TIE Bomber enemy:

```
1. Inheritance:
   oTieBomber extends oEnemyBase ✓

2. What's unique about this enemy?
   - Appearance: _____________________
   - Speed: _____________________
   - Health: _____________________
   - Special ability: _____________________

3. State machine (use standard or custom states?):
   _____________________

4. JSON configuration:
   ```json
   {
     "ENEMY": "oTieBomber",
     "SPAWN_XPOS": ???,
     "SPAWN_YPOS": ???,
     "INDEX": ???,
     "PATH": ???
   }
   ```

5. What new features needed?
   - Bombs drop function: _____________________
   - Bomb collision detection: _____________________
   - New explosion type: _____________________
```

---

### Challenge 3: Improve the Code

**Instructions:** Suggest improvements to Galaga Wars:

```
Question 1: How could we handle 1000 enemies?
   Current: Spawn 40 enemies per wave
   Problem: _____________________
   Solution: _____________________
   (Hint: think about pooling, LOD, frustum culling)

Question 2: How could we add multiplayer?
   Problem: Global game state isn't shared
   Solution: _____________________
   (Hint: what changes in state machine?)

Question 3: How could we add difficulty scaling?
   Current: Difficulty determined by wave number
   Problem: _____________________
   Solution: _____________________
   (Hint: data-driven difficulty curves?)

Question 4: How could we add procedural generation?
   Problem: Levels are static
   Solution: _____________________
   (Hint: generate JSON at runtime?)
```

---

## Activity 11: Research Project (30 min)

### Project 1: Game Architecture Research

**Instructions:** Research a game you like and answer:

```
1. What game did you choose?
   _____________________

2. What state machine does it have?
   (Identify 5+ states)
   _____________________

3. What game objects/entities exist?
   (Would any share code through inheritance?)
   _____________________

4. Is it data-driven?
   (Can you mod levels/content without recompiling?)
   _____________________

5. What design patterns do you think it uses?
   (State machines, inheritance, pooling, etc.)
   _____________________
```

---

### Project 2: Code Quality Analysis

**Instructions:** Analyze Galaga Wars codebase:

```
1. Find examples of each concept in the code:
   - State machine: _____________________
   - Inheritance: _____________________
   - Data-driven design: _____________________
   - Error handling: _____________________
   - Enums: _____________________

2. Find one "good design" decision in the code.
   Why was it a good choice?
   _____________________

3. Find one potential improvement.
   How would you make it better?
   _____________________
```

---

## Activity 12: Reflection & Metacognition (10 min)

### Exercise: What Did You Learn?

**Instructions:** For each topic, rate your understanding:

```
STATE MACHINES
☐ No idea what it is
☐ Understand basic concept
☐ Could explain to a classmate
☐ Could implement one from scratch
☐ Could use in any project

INHERITANCE
☐ No idea what it is
☐ Understand basic concept
☐ Could explain to a classmate
☐ Could implement one from scratch
☐ Could use in any project

DATA-DRIVEN DESIGN
☐ No idea what it is
☐ Understand basic concept
☐ Could explain to a classmate
☐ Could implement one from scratch
☐ Could use in any project

ERROR HANDLING
☐ No idea what it is
☐ Understand basic concept
☐ Could explain to a classmate
☐ Could implement one from scratch
☐ Could use in any project
```

---

### Exercise: Biggest Takeaway

```
What's the most important thing you learned today?

_____________________________________
_____________________________________

Why is it important?

_____________________________________
_____________________________________

How could you use this in your own projects?

_____________________________________
_____________________________________
```

---

### Exercise: Lingering Questions

```
What's still confusing?

1. _____________________________________
2. _____________________________________
3. _____________________________________

What would you like to learn more about?

1. _____________________________________
2. _____________________________________
3. _____________________________________
```

---

## Answer Key (For Teachers)

### Activity 1: State Machines

**Exercise 1.2 Answers:**
1. INITIALIZE
2. ATTRACT_MODE
3. ATTRACT_MODE → INSTRUCTIONS → GAME_PLAYER_MESSAGE
4. GAME_ACTIVE → SHOW_RESULTS
5. ENTER_INITIALS (or CHALLENGE_STAGE_MESSAGE)

---

### Activity 2: Inheritance

**Exercise 2.1 Answer:**
Shared: Path following, grid formation, dive attacks, damage system, death sound
Unique: Sprite, speed, health, special abilities

**Exercise 2.2:**
Could name them: oTieBomber, oTieAdvanced, oStarDestroyer, oInterceptor, oScout
All should inherit from oEnemyBase

---

### Activity 4: Error Handling

**Exercise 4.1 Answers:**
1. asset_get_index returns -1 if asset doesn't exist
2. JSON file doesn't exist, can't parse
3. Array only has 3 items (0-2), accessing index 999 is undefined
4. safe_struct_get returns default value (100), never returns undefined

---

### Activity 8: Code Reading

**Exercise 8.2 Answers:**
1. A (gets xstart from formation grid)
2. C (path_start)
3. D (instance_create_layer)
4. B (asset_get_index is part of safe_get_asset validation)

---

## Supplementary Materials Needed

### To Use These Activities, You Need:

1. **Galaga Wars Codebase**
   - Access to source code
   - Ability to run/compile game
   - IDE (GameMaker Studio 2)

2. **Presentation Materials**
   - INTRO_CS_CLASS_10TH_GRADE.md
   - 10TH_GRADE_PRESENTATION_SLIDES.md
   - This exercises document

3. **Classroom Setup**
   - Whiteboard/markers
   - Computer with GameMaker (optional, for live demo)
   - Projector

4. **Student Materials**
   - Paper for drawing state machines
   - Pens/pencils
   - Computer access for coding exercises (optional)

---

## Timing Guide for Activities

```
Total Activity Time: ~2-3 hours (can be spread over multiple days)

Session 1 (60 min):
- Activity 1: State Machines (15 min)
- Activity 2: Inheritance (15 min)
- Activity 3: Data-Driven Design (15 min)
- Activity 4: Error Handling (10 min)
- Activity 5: Polymorphism (5 min)

Session 2 (60 min):
- Activity 6: Testing (10 min)
- Activity 7: Design Decisions (15 min)
- Activity 8: Code Reading (15 min)
- Activity 9: Concept Integration (20 min)

Session 3 (60+ min):
- Activity 10: Creative Challenge (20 min)
- Activity 11: Research Project (30 min)
- Activity 12: Reflection (10 min)
```

---

## Differentiation for Different Levels

### For Struggling Students
- Focus on Activities 1-5
- Use simpler questions
- Work in pairs/groups
- Provide more scaffolding

### For Advanced Students
- Focus on Activities 10-11
- Design multi-system improvements
- Research game architecture
- Extend challenges

### For Hybrid Learning
- Activities can be done independently
- Use Zoom breakout rooms for group work
- Shared documents for collaboration
- Code can be reviewed on GitHub

---

## Assessment Ideas

### Formative Assessment
- Quiz on state machine transitions (5 min)
- "Find the bug" exercises
- Peer review of design decisions
- Whiteboard drawing of hierarchies

### Summative Assessment
- Design document for new game state
- Code review analysis
- Research project on game architecture
- Creative challenge completion

### Portfolio Ideas
- Screenshots of state machine drawings
- Written explanations of design choices
- Code examples from homework
- Reflection journal

---

**Total: 12 Activities**
**Time: 2-3 hours (or 1-2 class periods)**
**Format: Mix of individual, pair, and group work**
**Difficulty: Scaffolded from easy to challenging**
