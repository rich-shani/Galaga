# Galaga Wars - Developer Guide

**Quick Start for Contributors**

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Environment Setup](#environment-setup)
3. [Project Structure](#project-structure)
4. [Running & Testing](#running--testing)
5. [Common Tasks](#common-tasks)
6. [Code Review Checklist](#code-review-checklist)
7. [FAQ](#faq)

---

## Quick Start

### For New Developers

1. **Clone Repository**
   ```bash
   git clone https://github.com/yourusername/Galaga.git
   cd Galaga
   ```

2. **Open in GameMaker**
   - Launch GameMaker Studio 2
   - File → Open Project
   - Select `Galaga.yyp`
   - Wait for project indexing (~1-2 minutes)

3. **Run Game**
   - Press F5 or click "Run" button
   - Game opens in new window
   - Press ESC to close

4. **Read Architecture**
   - Open `ARCHITECTURE.md` for system overview
   - Read relevant sections before making changes

5. **Run Tests**
   - Create `oTestRunner` in debug room
   - Run game and observe test results in console
   - All tests should pass

---

## Environment Setup

### Requirements

- **GameMaker Studio 2** (v2024.13.1.193+)
  - Download: https://gms.yoyogames.com/
  - Free version works (no paid features used)

- **Git** (for version control)
  - Download: https://git-scm.com/

- **Text Editor** (for editing GML)
  - Built into GameMaker (recommended)
  - Or use VS Code, Sublime Text, etc.

### Initial Setup Steps

1. **Install GameMaker**
   ```
   Download from https://gms.yoyogames.com/
   Follow installation wizard
   Launch GameMaker Studio 2
   ```

2. **Configure Git** (first time only)
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

3. **Clone Repository**
   ```bash
   cd ~/Documents/GitHub  # or your preferred location
   git clone https://github.com/yourusername/Galaga.git
   cd Galaga
   ```

4. **Verify Installation**
   ```bash
   git status  # Should show "On branch main"
   ```

### First Run

1. Open `Galaga.yyp` in GameMaker
2. Press F5 to run
3. You should see the splash screen → title screen → gameplay
4. Press ESC to close
5. Check output console (bottom) for any errors

---

## Project Structure

### Key Directories

```
Galaga/
├── objects/                       # Game objects
│   ├── oGameManager/             # Central game controller
│   ├── oPlayer/                  # Player X-Wing
│   ├── oEnemyBase/               # Enemy base class
│   ├── oTieFighter/              # TIE Fighter enemy
│   ├── oTieIntercepter/          # TIE Interceptor enemy
│   ├── oImperialShuttle/         # Imperial Shuttle enemy
│   └── ...
│
├── scripts/                       # Reusable functions
│   ├── WaveSpawner/             # Enemy wave spawning
│   ├── ScoreManager/            # Score tracking
│   ├── ChallengeStageManager/   # Bonus stages
│   ├── AssetCache/              # Performance optimization
│   ├── ObjectPool/              # Instance pooling
│   ├── ErrorHandling/           # Error handling
│   ├── TestFramework/           # Test utilities
│   ├── TestWaveSpawner/         # Wave spawning tests
│   ├── TestCollisionSystem/     # Collision tests
│   ├── TestEnemyStateMachine/   # State machine tests
│   ├── TestScoreAndChallenge/   # Score/challenge tests
│   ├── GameManager_STEP_FNs/    # Game loop helpers
│   └── ...
│
├── rooms/                        # Game levels
│   ├── SplashScreen/            # Loading screen
│   ├── GalagaWars/              # Main game (Star Wars theme)
│   ├── Galaga2/                 # Variant room
│   └── TitleScreen/             # Title/attract mode
│
├── sprites/                      # Visual assets (320+)
│   ├── sTieFighter/             # Enemy sprites
│   ├── sExplosion/              # Explosion animations
│   └── ...
│
├── paths/                        # Movement paths (100+)
│   ├── Ent_Top_L2R/            # Entrance paths
│   ├── TF_Dive1/               # Dive attack paths
│   ├── Chall1_Path1/           # Challenge stage paths
│   └── ...
│
├── datafiles/                    # Game configuration
│   └── Patterns/
│       ├── wave_spawn.json      # Standard wave patterns
│       ├── challenge_spawn.json # Challenge stage patterns
│       ├── formation_coordinates.json # Formation grid
│       ├── game_config.json     # Global config
│       ├── oTieFighter.json     # Enemy attributes
│       └── ...
│
├── sounds/                       # Audio assets (20+)
├── shaders/                      # CRT shader effects
├── fonts/                        # Text rendering
│
├── ARCHITECTURE.md              # Full technical guide
├── DEVELOPER_GUIDE.md           # This file
├── BUGS.md                      # Known issues
└── Galaga.yyp                   # Project file
```

### File Naming Convention

| Type | Prefix | Example |
|------|--------|---------|
| Objects | `o` | `oGameManager`, `oPlayer`, `oEnemyBase` |
| Sprites | `s` | `sTieFighter`, `sExplosion`, `sBlueLazer` |
| Paths | `Ent_`, `TF_`, `Chall` | `Ent_Top_L2R`, `TF_Dive1`, `Chall1_Path1` |
| Scripts | `verb_Noun` | `ErrorHandling`, `WaveSpawner` |
| Sounds | `G` | `GDie`, `GBeam`, `GBoss1` |

---

## Running & Testing

### Running the Game

**From GameMaker**:
- Press F5 or click "Run" button
- Game launches in new window
- Press ESC to close game and return to editor

**Controls**:
- **A / D**: Move left/right
- **SPACE**: Fire missile
- **ESC**: Pause (in arcade rooms)
- **Gamepad**: L stick = move, A button = fire

### Running Tests

**Option 1: Create Test Room**

1. Create new room: Right-click Rooms → Create Room
2. Name it "DebugRoom"
3. In Room Editor:
   - Add `oGlobal` to room (required for initialization)
   - Add `oTestRunner` to room
4. Run game with F5
5. Watch test output in console at bottom

**Option 2: Run Tests Manually**

Create a script called in game:
```gml
// Example: Run in oTestRunner Create event
setupTestEnvironment();

runWaveSpawnerTests();
runCollisionSystemTests();
runEnemyStateMachineTests();
runScoreAndChallengeTests();

teardownTestEnvironment();
```

**Option 3: Debug Tests in Code**

```gml
// In any script
resetTestResults();
beginTestSuite("Debug Test");

assert_equals(1 + 1, 2, "Math should work");
assert_true(true, "Boolean test");

endTestSuite();
reportTestResults();
```

### Viewing Test Results

Tests output to **Output Console** (bottom of GameMaker editor):

```
========================================
TEST SUITE: WaveSpawner Tests
========================================
[PASS] WaveSpawner should return a struct
[PASS] WaveSpawner should have spawn_data property
[FAIL] WaveSpawner spawn_counter should equal 0
       Expected: 0
       Actual:   1

========================================
# TEST RESULTS SUMMARY
========================================
Total Tests:  3
Passed:       2 (67%)
Failed:       1
Duration:     5 ms
```

### Debugging Techniques

**Add Debug Output**:
```gml
show_debug_message("Value of x: " + string(x));
show_debug_message("Enemy state: " + string(enemyState));
show_debug_message("Current score: " + string(global.Game.Player.score));
```

**Use Breakpoints**:
1. Click line number in code editor
2. Blue dot appears
3. Run game
4. Game pauses at breakpoint
5. Step through code with debugger

**Profile Performance**:
```gml
var t_start = get_timer();

// Code to profile
for (var i = 0; i < 1000; i++) {
    myFunction();
}

var elapsed = (get_timer() - t_start) / 1000;
show_debug_message("Time: " + string(elapsed) + " ms");
```

---

## Common Tasks

### Task 1: Fix a Bug

**Workflow**:
1. Read bug description in `BUGS.md`
2. Understand what's supposed to happen
3. Reproduce the bug (play game until it occurs)
4. Find relevant code in architecture guide
5. Add debug output to understand issue
6. Make minimal fix
7. Write test to verify fix
8. Run all tests to ensure no regression

**Example: Enemy spawning in wrong position**

```gml
// 1. Check spawn configuration
// In WaveSpawner.spawnStandardEnemy()
var enemy_data = wave_data.SPAWN[spawn_counter];
show_debug_message("Spawn position: " + string(enemy_data.SPAWN_XPOS) + ", " + string(enemy_data.SPAWN_YPOS));

// 2. Check if coordinate is valid
if (enemy_data.SPAWN_XPOS < 0 || enemy_data.SPAWN_XPOS > GAME_WIDTH + 100) {
    log_error("Invalid spawn X: " + string(enemy_data.SPAWN_XPOS), "WaveSpawner", 2);
}

// 3. Verify instance was created at correct position
show_debug_message("Created at: " + string(enemy.x) + ", " + string(enemy.y));
```

### Task 2: Add New Feature

**Example: Add difficulty selector**

1. **Plan the feature** (read ARCHITECTURE.md first)
2. **Add menu option** in title screen
3. **Update game_config.json** with difficulty levels
4. **Modify enemy stats** based on difficulty
5. **Write tests** for difficulty system
6. **Test extensively** at each difficulty level

### Task 3: Modify Wave Pattern

**Without coding** (JSON only):

1. Open `datafiles/Patterns/wave_spawn.json` in text editor
2. Find wave you want to modify
3. Change enemy types, positions, or paths
4. Save file
5. Run game and test wave

**Example - Swap enemy types in wave 2**:
```json
{
  "SPAWN": [
    {
      "ENEMY": "oTieIntercepter",  // Changed from oTieFighter
      "PATH": "Ent1e1",
      "SPAWN_XPOS": 100,
      ...
    }
  ]
}
```

### Task 4: Change Visual Effect

1. Open relevant sprite in Sprite Editor
2. Modify animation or appearance
3. Save sprite
4. Test in game

**Common sprite changes**:
- Enemy appearance: `sprites/sTieFighter/`
- Explosion effect: `sprites/sExplosion/`
- UI elements: `sprites/spr_*/`

### Task 5: Add Sound Effect

1. Place `.wav` or `.mp3` file in `sounds/` directory
2. Right-click in Sounds folder → Create Sound
3. Name sound (convention: `G` prefix, e.g., `GMyEffect`)
4. Test in code:
   ```gml
   sound_play(GMyEffect);
   ```

---

## Code Review Checklist

Before committing, verify:

- [ ] **Code Style**: Follows naming conventions (see ARCHITECTURE.md)
- [ ] **Comments**: Complex logic has explanatory comments
- [ ] **Error Handling**: Invalid inputs handled gracefully
- [ ] **Data Validation**: Checks for null/undefined
- [ ] **No Hardcoding**: Uses JSON configuration where possible
- [ ] **Performance**: No unnecessary function calls in loops
- [ ] **Tests Pass**: Run test suite and all pass
- [ ] **No Regression**: Changed feature works, others unaffected
- [ ] **Documentation Updated**: ARCHITECTURE.md or relevant docs updated
- [ ] **Commit Message**: Clear, descriptive message (50 chars or less)

### Sample Good Commit Message

```
Fix enemy spawn position validation

- Add bounds checking for SPAWN_XPOS in WaveSpawner
- Enemies now spawn within valid screen area
- Add test for spawn boundary validation
- Fixes issue #42
```

### Sample Bad Commit Message

```
Fixed stuff
```

---

## FAQ

### Q: How do I test my changes?

**A:**
1. Run game with F5
2. Play through affected features
3. Check console for errors
4. Run automated tests: `runWaveSpawnerTests()`
5. Verify no regression in other systems

### Q: How do I debug a crash?

**A:**
1. Check Output Console for error message
2. Error message shows file, line number, and description
3. Open that file and check that line
4. Add debug output before the error
5. Use breakpoints to pause execution

**Example Error**:
```
Variable <unknown_variable> not set before reading it.
 at gml_Object_oEnemyBase_Step_0_1 (line 245)
 called from gml_Object_oEnemyBase_Step_0 (line 1)
```

Look at line 245 of `objects/oEnemyBase/Step_0.gml`

### Q: How do I add a new enemy type?

**A:** See "Adding a New Feature" section in ARCHITECTURE.md

### Q: Why is my code slow?

**A:**
1. Use `get_timer()` to profile
2. Check for loops over all instances
3. Check for repeated `instance_number()` calls (should be cached)
4. Check for asset lookups (should use `get_cached_asset()`)
5. Look for `with` statements iterating all instances
6. Profile GC with GameMaker profiler

### Q: How do I make the game harder/easier?

**A:** Edit `datafiles/Patterns/game_config.json`:
```json
{
  "DIFFICULTY": {
    "SPEED_MULTIPLIER_BASE": 1.5  // Increase for harder
  }
}
```

Or modify `enemy_spawn.json` to spawn more/fewer enemies

### Q: Why are tests failing?

**A:**
1. Read test output - it tells you what failed and why
2. Check what the test is testing
3. Verify that system works as expected
4. Debug with print statements
5. Fix the code or the test (only if test is wrong)

### Q: How do I update documentation?

**A:**
1. Edit `ARCHITECTURE.md` or `DEVELOPER_GUIDE.md`
2. Make changes
3. Commit with message: `docs: Update [topic]`

### Q: I broke something, how do I revert?

**A:**
```bash
# Revert last commit
git revert HEAD

# Or reset to previous version
git reset --hard HEAD~1

# Or just undo file changes
git checkout -- filepath.gml
```

### Q: How do I add a new test?

**A:**
1. Find relevant test file (`TestWaveSpawner.gml`, etc.)
2. Add function:
   ```gml
   function test_mySystem_specificBehavior() {
       var result = myFunction(input);
       assert_equals(result, expected, "Description");
   }
   ```
3. Call from test suite runner
4. Run tests with F5

### Q: Can I modify the original Galaga rules?

**A:** Yes! Modify `datafiles/Patterns/game_config.json`:
- Enemy health
- Points per enemy
- Extra life thresholds
- Difficulty multiplier
- Challenge stage interval

### Q: Where do I find existing code for [feature]?

**A:** Use this guide:
- **Wave Spawning**: `scripts/WaveSpawner/`
- **Score Tracking**: `scripts/ScoreManager/`
- **Challenge Stages**: `scripts/ChallengeStageManager/`
- **Enemy AI**: `objects/oEnemyBase/Step_0.gml`
- **Player Control**: `objects/oPlayer/Step_0.gml`
- **High Scores**: `scripts/HighScoreSystem/`

See ARCHITECTURE.md Table of Contents for more

---

## Getting Help

- **Read ARCHITECTURE.md**: Most answers are there
- **Check existing code**: Look for similar implementations
- **Check BUGS.md**: Known issues and workarounds
- **Run tests**: Tests show expected behavior
- **Add debug output**: Print values to understand state
- **Ask on Discord/Slack**: Community can help

---

## Next Steps

1. ✅ Clone repository and run game
2. ✅ Read ARCHITECTURE.md completely
3. ✅ Run test suite and verify all pass
4. ✅ Find a task (bug to fix, feature to add)
5. ✅ Make changes following guide
6. ✅ Write tests for changes
7. ✅ Submit PR with clear description

Happy coding! 🚀

---

**Last Updated:** November 2024
**Questions?** See ARCHITECTURE.md or check existing code examples
