# Galaga Wars: Student Exercises & Code Challenges
## AP Computer Science - Hands-On Learning

---

## Exercise Set 1: Understanding State Machines

### Exercise 1.1: Draw the State Diagram

**Difficulty:** Easy (15 minutes)

Draw a state diagram for the Galaga Wars game flow shown below. Use boxes for states and arrows for transitions.

```
States: ATTRACT_MODE, INSTRUCTIONS, GAME_ACTIVE, GAME_PAUSED, SHOW_RESULTS, ENTER_INITIALS

Transitions:
- ATTRACT_MODE → INSTRUCTIONS (when player presses START)
- INSTRUCTIONS → GAME_ACTIVE (when player confirms)
- GAME_ACTIVE → GAME_PAUSED (when player presses PAUSE)
- GAME_PAUSED → GAME_ACTIVE (when player resumes)
- GAME_ACTIVE → SHOW_RESULTS (when all enemies defeated)
- SHOW_RESULTS → ENTER_INITIALS (after delay)
- ENTER_INITIALS → ATTRACT_MODE (after initials entered)
```

**Questions:**
a) How many states are there?
b) What transitions happen from GAME_ACTIVE?
c) Is there any state you can't reach from ATTRACT_MODE?
d) What would break if we added both "isPlaying" AND "isPaused" flags?

---

### Exercise 1.2: Implement a Simple State Machine

**Difficulty:** Medium (30 minutes)

Implement a traffic light system using a state machine:

```gml
enum TrafficLight {
    RED,
    YELLOW,
    GREEN
}

function traffic_light_step() {
    switch(current_state) {
        case TrafficLight.RED:
            // TODO: After 30 seconds, go to GREEN
            break;

        case TrafficLight.GREEN:
            // TODO: After 25 seconds, go to YELLOW
            break;

        case TrafficLight.YELLOW:
            // TODO: After 5 seconds, go to RED
            break;
    }
}
```

**Implementation Hints:**
- Use `alarm` system to track time
- When alarm reaches 0, transition state
- Set new alarm for next state's duration

**Extension Challenge:**
- Add pedestrian button that changes RED → walk signal
- Add emergency vehicle priority (RED → GREEN immediately)

---

### Exercise 1.3: State Machine Analysis

**Difficulty:** Medium (20 minutes)

**Question:** In Galaga Wars, why is using a state machine better than using multiple boolean flags?

Compare these two approaches:

**Approach A (Flags - BAD):**
```gml
global.isPlaying = true;
global.isPaused = false;
global.isShowingResults = false;
global.isEnteringInitials = false;
```

**Approach B (State Machine - GOOD):**
```gml
enum GameMode {
    GAME_ACTIVE,
    GAME_PAUSED,
    SHOW_RESULTS,
    ENTER_INITIALS
}
global.gameMode = GameMode.GAME_ACTIVE;
```

**Write a short answer (3-4 sentences) explaining:**
1. What's wrong with Approach A?
2. Why is Approach B better?
3. Give an example of an invalid state in Approach A
4. How does Approach B prevent that?

---

## Exercise Set 2: Object-Oriented Programming

### Exercise 2.1: Understand Inheritance

**Difficulty:** Easy (20 minutes)

Given the following class hierarchy:

```
        oEnemyBase
       /    |     \
oTieFighter oTieIntercepter oImperialShuttle
```

**Shared in oEnemyBase:**
- `path_start()` - Follow entrance path
- `formation positioning` - Move to grid position
- `dive attack()` - Attack player
- `check collision with shot()`
- `health tracking`

**Unique to each enemy type:**
- Sprite image
- Speed value
- Health points
- Attack pattern

**Questions:**

a) How many lines of code would the project have if we wrote each enemy separately (no inheritance)?

b) If we want to change the formation positioning for ALL enemies, how many places do we need to edit?
   - With inheritance: ___
   - Without inheritance: ___

c) Write pseudocode for a new enemy type (TIE Bomber):
```gml
function TIEBomber_Create() {
    // What do we inherit?
    // What do we define uniquely?
}
```

---

### Exercise 2.2: Create a New Enemy Type

**Difficulty:** Hard (45 minutes)

Design a new enemy type called "Imperial Officer" with these properties:
- Slower movement than TIE Fighter (speed = 4)
- More health (health = 8)
- Worth more points (points = 200)
- Uses a special spiral attack pattern (new path)

**Tasks:**

1. Write the Create_0.gml file for Imperial Officer:
```gml
// Imperial Officer / Create_0.gml

// TODO: Set ENEMY_NAME
// TODO: Set unique properties
// TODO: Call parent initialization

function Create_0() {
    // Fill in the details
}
```

2. Create a JSON entry for the new enemy:
```json
// Add to Patterns/oImperialOfficer.json
{
  "HEALTH": ?,
  "POINTS": ?,
  "DESCRIPTION": "The commander of enemy forces"
}
```

3. Add the new enemy to a wave:
```json
// In wave_spawn.json, add this spawn:
{
  "ENEMY": "oImperialOfficer",
  "SPAWN_XPOS": 512,
  "SPAWN_YPOS": -16,
  "INDEX": 20,
  "PATH": "Ent_Top_L2R",
  "COMBINE": false
}
```

**Testing:**
- Launch the game and verify new enemy spawns
- Check that it has correct health
- Verify it follows the path correctly

---

### Exercise 2.3: Polymorphism in Action

**Difficulty:** Medium (25 minutes)

**Question:** All enemies inherit from oEnemyBase and all have a dive attack. But different enemies might attack differently:

- TieFighter: Straight line dive
- TieIntercepter: Zigzag dive
- ImperialShuttle: Spiral dive

How would you implement this using polymorphism?

**Write pseudocode:**
```gml
// In oEnemyBase:
function do_dive_attack() {
    // Each subclass overrides this
    // TieFighter does straight line
    // TieIntercepter does zigzag
}

// In oTieFighter:
function do_dive_attack() {
    // Straight line attack
}

// In oTieIntercepter:
function do_dive_attack() {
    // Zigzag attack
}
```

**Reflection Question:**
What advantage does this have over having a `attack_type` variable that controls behavior?

---

## Exercise Set 3: Data-Driven Design

### Exercise 3.1: Design a New Wave

**Difficulty:** Easy (20 minutes)

Create a JSON snippet that spawns 8 enemies in a horizontal line at the top of the screen:

```json
{
  "WAVE": [
    {
      "SPAWN": [
        // TODO: Add 8 spawns here
        // Enemies should be evenly spaced horizontally
        // Y position: -20 (above screen)
        // Spacing: 64 pixels apart
        // Starting X: 200
      ]
    }
  ]
}
```

**Expected positions:**
```
Enemy 1: X=200, Enemy 2: X=264, Enemy 3: X=328, ... Enemy 8: X=648
```

**Questions:**
- What JSON structure should each SPAWN have?
- How would you test this configuration?
- What happens if you make an error in the JSON?

---

### Exercise 3.2: Wave Difficulty Scaling

**Difficulty:** Hard (40 minutes)

**Challenge:** Design 5 progressive waves of increasing difficulty.

**Requirements:**
- Wave 1: Easy (10 TieFighters)
- Wave 2: Medium (8 TieFighters + 2 TieIntercepters)
- Wave 3: Hard (4 TieFighters + 4 TieIntercepters + 2 ImperialShuttles)
- Wave 4: Very Hard (6 ImperialShuttles + 2 rare enemies)
- Wave 5: Expert (Mixed formation with rare attack patterns)

**Write the JSON:**
```json
{
  "PATTERN": [
    {
      "WAVE": [
        {
          "SPAWN": [
            // Wave 1 enemies
          ]
        },
        {
          "SPAWN": [
            // Wave 2 enemies
          ]
        },
        // ... etc
      ]
    }
  ]
}
```

**Design Questions:**
1. What makes a wave harder: more enemies, stronger enemies, or better formation?
2. Should wave difficulty be predictable or surprising?
3. How would you balance so players learn at each stage?

**Testing Plan:**
Write a plan for how you'd test this difficulty progression:
- How do you measure if it's too easy/hard?
- What metrics would you track?
- How would you gather player feedback?

---

### Exercise 3.3: Data vs. Code Debate

**Difficulty:** Medium (30 minutes)

**Scenario:** You need to add 5 new variations of waves. You have two options:

**Option A: Hardcode in C++**
```cpp
wave1.add_enemy(TIE_FIGHTER, 200, -20);
wave1.add_enemy(TIE_FIGHTER, 264, -20);
wave1.add_enemy(TIE_FIGHTER, 328, -20);
// ... 37 more enemies
```

**Option B: Data in JSON**
```json
{
  "WAVE": [
    {
      "ENEMY": "oTieFighter",
      "SPAWN_XPOS": 200,
      "SPAWN_YPOS": -20
    }
  ]
}
```

**Write a comparison (1-2 pages):**
1. **Iteration Speed:** How long to make a change?
2. **Collaboration:** Can non-programmers help?
3. **Reusability:** Can you reuse wave definitions?
4. **Error Handling:** What happens if data is wrong?
5. **Performance:** Any difference in runtime?

**Conclusion:** Which is better and why?

---

## Exercise Set 4: Error Handling

### Exercise 4.1: Identify Error Scenarios

**Difficulty:** Easy (15 minutes)

**Scenario:** Your code tries to spawn an enemy:

```gml
var enemy_id = asset_get_index(enemy_name);
instance_create_layer(x, y, "GameSprites", enemy_id);
```

**Questions:**

1. What could go wrong here? List 3 possible error scenarios.
2. What happens if `enemy_name` is "oWrongSpelling"?
3. How would the player experience this error?
4. What information do you need to debug it?

**Example answers:**
- Scenario: `enemy_name` is "oTieFighter" but object doesn't exist
  - Result: `enemy_id = -1`, `instance_create_layer()` creates invalid object
  - Player sees: Enemy doesn't appear, game might crash

---

### Exercise 4.2: Implement Safe Functions

**Difficulty:** Medium (35 minutes)

**Task:** Write three safe functions for error handling:

**1. Safe Asset Lookup**
```gml
function safe_get_asset(_asset_name, _default = -1) {
    // TODO: Implement
    // 1. Validate that _asset_name is a string
    // 2. Get asset with asset_get_index()
    // 3. Check if found (id != -1)
    // 4. If not found, log error and return default
    // 5. Otherwise return asset_id
}
```

**2. Safe JSON Loading**
```gml
function safe_load_json(_filepath, _default = {}) {
    // TODO: Implement
    // 1. Check file exists
    // 2. Read file content
    // 3. Parse JSON
    // 4. Catch parse errors
    // 5. Return parsed data or default
}
```

**3. Safe Struct Access**
```gml
function safe_struct_get(_struct, _key, _default = undefined) {
    // TODO: Implement
    // 1. Validate _struct is a struct
    // 2. Check if _key exists
    // 3. Return value or default
}
```

**Testing:**
Write test cases for each function:
```gml
// Test 1: Valid asset
assert(safe_get_asset("oTieFighter", -1) != -1);

// Test 2: Invalid asset
assert(safe_get_asset("oWrongName", -1) == -1);

// Test 3: Valid JSON
var data = safe_load_json("waves.json", {});
assert(is_struct(data));

// Add more tests...
```

---

### Exercise 4.3: Defensive Programming Pattern

**Difficulty:** Hard (40 minutes)

**Challenge:** You're writing a function to spawn enemies from JSON. Implement defensive programming:

```gml
function spawn_wave_from_json(_filepath) {
    // TODO: Implement with defensive checks

    // Step 1: Safely load JSON
    var wave_data = safe_load_json(_filepath, undefined);
    if (wave_data == undefined) {
        // Error already logged by safe_load_json
        return; // Exit early
    }

    // Step 2: Validate structure
    if (!struct_exists(wave_data, "SPAWN")) {
        show_debug_message("Error: JSON missing SPAWN field");
        return;
    }

    // Step 3: Iterate through spawns
    var spawns = wave_data.SPAWN;
    if (!is_array(spawns)) {
        show_debug_message("Error: SPAWN is not an array");
        return;
    }

    for (var i = 0; i < array_length(spawns); i++) {
        var spawn = spawns[i];

        // Step 4: Validate each spawn
        if (!is_struct(spawn)) {
            show_debug_message("Error: SPAWN[" + string(i) + "] is not a struct");
            continue; // Skip this spawn, continue with others
        }

        // TODO: Add validation for required fields
        // Required: ENEMY, SPAWN_XPOS, SPAWN_YPOS, PATH

        // Step 5: Safely spawn
        var enemy_id = safe_get_asset(spawn.ENEMY, -1);
        if (enemy_id != -1) {
            instance_create_layer(spawn.SPAWN_XPOS, spawn.SPAWN_YPOS,
                                "GameSprites", enemy_id);
        }
    }
}
```

**Tasks:**
1. Complete the validation for required fields
2. Add error logging for each validation failure
3. Test with corrupted JSON files
4. Verify game continues gracefully with errors

---

## Exercise Set 5: Code Analysis

### Exercise 5.1: Performance Analysis

**Difficulty:** Medium (30 minutes)

**Question:** Galaga Wars runs 40 enemies at 60 FPS. Analyze the performance:

**Given Information:**
- 60 frames per second = 16.7 milliseconds per frame
- Each enemy's Step event: ~50 operations
- Each enemy's Draw event: ~10 operations
- Game logic: ~200 operations

**Calculate:**
1. Total operations per frame with 40 enemies
2. Operations per millisecond
3. Can this run on a phone? (estimate phone can do 10,000 ops/ms)
4. How many enemies could we support?

**Answer the questions:**
1. What's the bottleneck (slowest part)?
2. How would you optimize?
3. At what point does frame rate drop below 60 FPS?

---

### Exercise 5.2: Code Quality Review

**Difficulty:** Hard (45 minutes)

**Task:** Review this code and identify issues:

```gml
function spawn_enemies() {
    for (var i = 0; i < 8; i++) {
        var x = 200 + (i * 50);
        var y = -20;
        var enemy = asset_get_index("oTieFighter");
        instance_create_layer(x, y, "GameSprites", enemy);

        global.totalEnemies++;

        alarm[2] = 30;
    }
}
```

**Issues to Find:**
1. What happens if "oTieFighter" doesn't exist?
2. Why is `alarm[2] = 30` inside the loop?
3. How would you improve readability?
4. How would you make it maintainable?

**Rewrite the function better:**
```gml
function spawn_enemies_safely() {
    // TODO: Improved version
    // Use error handling
    // Use better variable names
    // Add comments explaining why
    // Remove magic numbers
}
```

---

### Exercise 5.3: Design Pattern Identification

**Difficulty:** Medium (25 minutes)

**Task:** Identify which design patterns are used in Galaga Wars:

**Patterns to look for:**
1. **State Machine** - Managing game flow
2. **Inheritance** - Enemy types
3. **Singleton** - Only one GameManager
4. **Factory** - Creating enemies
5. **Observer** - Event system
6. **Decorator** - Effects/modifications
7. **Strategy** - Different AI behaviors

**For each pattern found:**
- Identify where it's used (filename, class name)
- Explain why it's used there
- What would break if we removed it?
- Could you replace it with a different pattern?

**Example:**
```
Pattern: State Machine
Location: oGameManager/Step_0.gml
Why: Manages game flow (Attract → Game → Results → Attract)
Without it: Multiple flags would conflict
Alternative: If/else chains (bad for readability)
```

---

## Exercise Set 6: Design Your Own Game

### Exercise 6.1: Game Design Document

**Difficulty:** Hard (1-2 hours)

**Task:** Using Galaga Wars as inspiration, design your own arcade-style game.

**Write a 2-3 page document including:**

1. **Game Concept**
   - What's the gameplay?
   - What's the theme?
   - Why would people play it?

2. **Core Mechanics**
   - How does player move?
   - How does player attack?
   - What's the win condition?

3. **Game States**
   - Draw state machine diagram
   - List all transitions
   - What happens in each state?

4. **Enemy Design**
   - How many enemy types?
   - What makes each unique?
   - Draw inheritance diagram

5. **Level Design**
   - How many levels?
   - How do they get harder?
   - Sketch JSON structure for a level

6. **Art Assets**
   - What sprites do you need?
   - What audio?
   - Rough sketches or descriptions

7. **Technical Architecture**
   - What objects do you need?
   - What scripts/functions?
   - How will you handle errors?

---

### Exercise 6.2: Prototype Implementation Plan

**Difficulty:** Very Hard (3-5 hours of implementation)

**Challenge:** Implement a simple version of your game design from 6.1.

**Scope (to be completed):**
1. Player movement (left/right, shoot)
2. One wave of 8 enemies spawning from JSON
3. Basic collision detection
4. Score tracking
5. One game state (GAME_ACTIVE)

**Do NOT try to implement:**
- Multiple enemy types (start with one)
- Complex AI
- All game states
- Fancy graphics

**Deliverables:**
1. Source code (game files)
2. JSON wave definition
3. Brief write-up of what works and what doesn't
4. Ideas for next steps

**Guidance:**
- Start with player movement
- Then add one spawned enemy
- Then add collision detection
- Then add more enemies
- Iterate and improve

---

## Exercise Set 7: Interview Preparation

### Exercise 7.1: Explain Key Concepts

**Difficulty:** Medium (20 minutes each)

Prepare 2-3 minute explanations for:

1. **State Machines**
   - What are they?
   - Why use them?
   - Give a real-world example
   - Draw a diagram

2. **Inheritance**
   - What is it?
   - When to use it?
   - Disadvantages?
   - Example from Galaga Wars

3. **Error Handling**
   - Why is it important?
   - How do you implement it?
   - What's the cost/benefit?
   - Example defensive code

4. **Data-Driven Design**
   - How does it work?
   - Advantages?
   - Disadvantages?
   - When to use it?

**Practice:**
- Record yourself explaining each
- Listen back and improve clarity
- Explain to a classmate
- Time yourself

---

### Exercise 7.2: Technical Interview Questions

**Difficulty:** Hard (30-45 minutes)

These are actual interview questions from game studios:

**Q1: Scalability**
> "Galaga Wars supports 40 enemies. How would you redesign the system to support 1000 enemies?"

**Your answer should cover:**
- Performance concerns
- Memory usage
- Entity management
- Optimization techniques

**Q2: Edge Cases**
> "What happens if wave_spawn.json is corrupted?"

**Your answer should cover:**
- Error detection
- User experience
- Recovery options
- Logging strategy

**Q3: Design Decisions**
> "Why did Galaga Wars use data-driven design instead of hardcoding?"

**Your answer should cover:**
- Development speed
- Iteration
- Collaboration
- Testing

**Q4: Debugging**
> "A player reports enemies sometimes don't spawn. How would you debug this?"

**Your answer should cover:**
- Hypothesis testing
- Logging strategy
- Reproduction steps
- Root cause analysis

**Q5: Refactoring**
> "The Game_Loop() function is 300 lines. How would you improve it?"

**Your answer should cover:**
- Breaking into smaller functions
- Readability improvements
- Testing strategy
- Performance implications

---

### Exercise 7.3: Tell Your Story

**Difficulty:** Medium (30 minutes)

**Task:** Prepare a 3-5 minute story about what you learned:

**Structure:**
1. **Hook** (30 seconds)
   - "When I started learning about game architecture..."

2. **Challenge** (1 minute)
   - "I didn't understand why state machines were important..."

3. **Solution** (1 minute)
   - "Then I realized how they prevent..."

4. **Learning** (1 minute)
   - "This taught me that..."

5. **Application** (1 minute)
   - "Now I use this concept to..."

**Practice telling this story.**
**Record yourself and review.**
**Refine based on feedback.**

---

## Answer Key (Teacher Edition)

### [Answers available from instructor]

---

## Challenge Problems (For Experts)

### Challenge 1: Multiplayer Implementation

How would you modify the state machine and game loop to support two players simultaneously?

### Challenge 2: Procedural Level Generation

Write an algorithm that generates random but balanced waves programmatically.

### Challenge 3: AI Learning

How could enemies learn from player behavior and adapt their strategy?

### Challenge 4: Performance Profiling

Implement a profiler that measures which operations are slowest in each frame.

### Challenge 5: Accessibility Features

Design error handling for players with disabilities (colorblind, hearing impaired, etc.).

---

## Project Ideas (For Continued Learning)

1. **Expansion Pack** - Add 5 new levels with increasing difficulty
2. **Arcade Cabins** - Create cabinet mode with high scores
3. **Custom Leveleds** - Level editor for creating custom waves
4. **Mobile Port** - Adapt for touch controls
5. **Procedural Generation** - Infinite random waves
6. **Multiplayer** - Co-op or PvP modes
7. **Enhanced AI** - Enemy learning and adaptation
8. **Particle Effects** - Explosions and visual polish
9. **Sound Design** - Custom soundtrack and effects
10. **Leaderboards** - Online high score tracking

---

## Submission Guidelines

### For Each Exercise:

1. **Code Files** (if applicable)
   - Well-commented
   - Proper variable names
   - Error handling

2. **Written Answers**
   - Complete sentences
   - Diagrams where helpful
   - Explain your reasoning

3. **Test Results**
   - Show that code works
   - List any edge cases tested
   - Performance metrics

4. **Reflection**
   - What did you learn?
   - What was challenging?
   - What would you improve?

### Due Dates:
- Exercises 1-3: [Due date 1]
- Exercises 4-6: [Due date 2]
- Challenge problems: [Due date 3]

---

## Getting Help

### Resources:
- GameMaker Manual: https://manual.yoyogames.com
- Stack Overflow: Tag [gml] for GameMaker questions
- Discord Communities: GameMaker Discord, general programming
- Office Hours: [Instructor times]

### Debugging Tips:
1. Enable debug console (Alt+O in GameMaker)
2. Add `show_debug_message()` to trace execution
3. Check variable values at each step
4. Look for off-by-one errors in loops
5. Verify JSON is valid (use JSON validator online)

Good luck, and happy coding!

