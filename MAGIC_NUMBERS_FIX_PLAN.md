# Galaga Wars - Magic Numbers Refactoring Plan

**Quick Action Items to Eliminate Hardcoded Values**

---

## 🔴 CRITICAL - Do This First (2-3 hours)

### Task 1: Add Level Progression Constants

**File:** `scripts/GameConstants/GameConstants.gml`

**Add this section after line 671:**

```gml
// ========================================================================
// LEVEL PROGRESSION CONSTANTS
// ========================================================================
// These thresholds define when difficulty mechanics activate.
// Used by scripts/newlevel/newlevel.gml to escalate gameplay difficulty

/// @macro LEVEL_ROGUE_1_START
/// Starting level for rogue enemies (level 3+)
#macro LEVEL_ROGUE_1_START 3

/// @macro LEVEL_ROGUE_2_START
/// Level 7+: Rogue level 2 + fast entry mode begins
#macro LEVEL_ROGUE_2_START 7

/// @macro LEVEL_FASTENTER_RESET
/// Level 10: Fast entry resets, rogue level resets to 1
#macro LEVEL_FASTENTER_RESET 10

/// @macro LEVEL_ROGUE_3_START
/// Level 11+: Rogue level 3, speed mode, 3 shots, boss dive cap 2
#macro LEVEL_ROGUE_3_START 11

/// @macro LEVEL_ROGUE_4_START
/// Level 15+: Rogue level 4 activated
#macro LEVEL_ROGUE_4_START 15

/// @macro LEVEL_ADVANCED_SHOTS
/// Level 19+: 4 shots, boss dive cap 4
#macro LEVEL_ADVANCED_SHOTS 19

/// @macro LEVEL_CHALLENGE_THRESHOLD
/// Challenge stages occur every N levels (every 4th level)
#macro LEVEL_CHALLENGE_THRESHOLD 4
```

**Then update `scripts/newlevel/newlevel.gml`:**

**Old Code (lines 5-47):**
```gml
if (global.Game.Level.current > 3) {
    global.Game.Enemy.rogueLevel = 1;
}
if (global.Game.Level.current > 7) {
    global.Game.Enemy.rogueLevel = 2;
    global.Game.Difficulty.fastEnter = 1;
}
// ... etc
```

**New Code (replace entire block):**
```gml
// === LEVEL PROGRESSION - Dynamic difficulty scaling ===
// Each threshold activates new enemy behaviors and game mechanics

if (global.Game.Level.current > LEVEL_ROGUE_1_START) {
    global.Game.Enemy.rogueLevel = 1;
}

if (global.Game.Level.current > LEVEL_ROGUE_2_START) {
    global.Game.Enemy.rogueLevel = 2;
    global.Game.Difficulty.fastEnter = 1;
}

if (global.Game.Level.current == LEVEL_FASTENTER_RESET) {
    // Reset difficulty parameters at level 10
    global.Game.Difficulty.fastEnter = 0;
    global.Game.Enemy.rogueLevel = 1;
}

if (global.Game.Level.current > LEVEL_ROGUE_3_START) {
    global.Game.Enemy.rogueLevel = 3;
    global.Game.Difficulty.speedMode = 1;
    global.Game.Enemy.shotNumber = 3;
    global.Game.Enemy.bossDiveCap = 2;
}

if (global.Game.Level.current > LEVEL_ROGUE_4_START) {
    global.Game.Enemy.rogueLevel = 4;
}

if (global.Game.Level.current > LEVEL_ADVANCED_SHOTS) {
    global.Game.Enemy.shotNumber = 4;
    global.Game.Enemy.bossDiveCap = 4;
}

// Challenge stages occur every LEVEL_CHALLENGE_THRESHOLD levels
if (global.Game.Level.current == LEVEL_CHALLENGE_THRESHOLD ||
    global.Game.Level.current == LEVEL_CHALLENGE_THRESHOLD * 2 ||
    global.Game.Level.current == LEVEL_CHALLENGE_THRESHOLD * 3 ||
    global.Game.Level.current == LEVEL_CHALLENGE_THRESHOLD * 4) {
    // Trigger challenge stage
}
```

**Files to Update:**
- [x] `scripts/GameConstants/GameConstants.gml` - Add constants
- [x] `scripts/newlevel/newlevel.gml` - Use constants instead of hardcoded values

---

### Task 2: Add Bonus/Scoring Constants

**File:** `scripts/GameConstants/GameConstants.gml`

**Add after Level Progression section:**

```gml
// ========================================================================
// BONUS & SCORING CONSTANTS
// ========================================================================

/// @macro ENEMIES_PER_BONUS
/// Every N destroyed enemies triggers transformation bonus
#macro ENEMIES_PER_BONUS 8

/// @macro TRANSFORMATION_BONUS
/// Points awarded when player gets ENEMIES_PER_BONUS consecutive kills
#macro TRANSFORMATION_BONUS 160

/// @macro PERFECT_CLEAR_BONUS
/// Bonus for clearing entire wave with 100% accuracy
#macro PERFECT_CLEAR_BONUS 10000
```

**Files to Update:**
- `objects/oEnemyBase/Destroy_0.gml` - Replace hardcoded 8 and 160
- `objects/oGameManager/Alarm_2.gml` - Replace hardcoded 10000

**Changes in oEnemyBase/Destroy_0.gml (line 70):**

Old:
```gml
if (global.Game.Player.shotCount == 8) {
    global.Game.Player.score += 160;
```

New:
```gml
if (global.Game.Player.shotCount == ENEMIES_PER_BONUS) {
    global.Game.Player.score += TRANSFORMATION_BONUS;
```

---

### Task 3: Standardize Screen Coordinates

**File:** `scripts/GameConstants/GameConstants.gml`

**Verify these exist and add clarification:**

```gml
// ========================================================================
// SCREEN COORDINATE CONSTANTS
// ========================================================================
// Important: These are LOGICAL coordinates at base resolution (224x288).
// Remember to scale by global.Game.Display.scale when using!

/// @macro SCREEN_CENTER_X
/// Horizontal center of playfield
#macro SCREEN_CENTER_X 224

/// @macro PLAYER_SPAWN_Y
/// Y-coordinate where player respawns
#macro PLAYER_SPAWN_Y 528

/// @macro SCREEN_BOTTOM_Y
/// Y-coordinate of screen bottom boundary (enemies off-screen below this)
#macro SCREEN_BOTTOM_Y 592

/// @macro ROGUE_TRANSITION_Y
/// Y-coordinate where rogue enemies change behavior
#macro ROGUE_TRANSITION_Y 462
```

**Files to Update - Replace hardcoded values:**

1. **objects/oPlayer/Step_0.gml**
   - Line 217: `if (x < 448)` → `if (x < SCREEN_CENTER_X * global.Game.Display.scale)`
   - Line 220: `else if (x > 448)` → `else if (x > SCREEN_CENTER_X * global.Game.Display.scale)`
   - Line 277: `x = 224*global.Game.Display.scale` → `x = SCREEN_CENTER_X * global.Game.Display.scale`
   - Line 278: `y = 528*global.Game.Display.scale` → `y = PLAYER_SPAWN_Y * global.Game.Display.scale`

2. **objects/oEnemyShot/Step_2.gml**
   - Line 66: `if (y > 576*global.Game.Display.scale)` → `if (y > SCREEN_BOTTOM_Y * global.Game.Display.scale)`
   - (Note: Verify 576 should be 592 - might be intentional offset)

3. **scripts/rogueturn/rogueturn.gml**
   - Line 3: `if y > 496` → `if y > ROGUE_TRANSITION_Y * global.Game.Display.scale`
   - Line 11: `targy = 528` → `targy = PLAYER_SPAWN_Y`
   - Line 16: `if targy < 528` → `if targy < PLAYER_SPAWN_Y`

---

## 🟡 HIGH - Do Next (1-2 hours)

### Task 4: Add Formation Grid Constants

**File:** `scripts/GameConstants/GameConstants.gml`

```gml
// ========================================================================
// FORMATION GRID CONSTANTS
// ========================================================================

/// @macro FORMATION_GRID_SIZE
/// Total enemy slots in formation grid (5 rows × 8 columns = 40)
#macro FORMATION_GRID_SIZE 40
```

**Files to Update:**
- `scripts/ErrorHandling/ErrorHandling.gml:487` - Use constant for validation
- `scripts/GameManager_STEP_FNs/GameManager_STEP_FNs.gml` - Replace hardcoded 40s

---

### Task 5: Add Timing Constants

**File:** `scripts/GameConstants/GameConstants.gml`

```gml
// ========================================================================
// TIMING CONSTANTS (Frame-based, 60 FPS)
// ========================================================================
// Note: 1 second = 60 frames at 60 FPS

/// @macro FRAMES_PER_SECOND
/// GameMaker runs at 60 FPS (frames per second)
#macro FRAMES_PER_SECOND 60

/// @macro ONE_SECOND_FRAMES
/// Number of frames in 1 second
#macro ONE_SECOND_FRAMES 60

/// @macro TWO_SECOND_FRAMES
/// Number of frames in 2 seconds
#macro TWO_SECOND_FRAMES 120

/// @macro HALF_SECOND_FRAMES
/// Number of frames in 0.5 seconds
#macro HALF_SECOND_FRAMES 30
```

---

### Task 6: Fix Enemy Shot Boundary Inconsistency

**Issue:** `objects/oEnemyShot/Step_2.gml:66` uses 576, but SCREEN_BOTTOM_Y = 592

**Action:**
1. Open both files and verify which value is correct
2. Add comment explaining the difference if intentional
3. Use constant consistently

**Current:**
```gml
if (y > 576*global.Game.Display.scale) {
    // Destroy enemy shot
}
```

**Should be:**
```gml
if (y > SCREEN_BOTTOM_Y * global.Game.Display.scale) {
    // Destroy enemy shot when off-screen
}
```

---

## 🟢 MEDIUM - Nice to Have (2-3 hours)

### Task 7: Add Animation Constants

```gml
#macro ANIMATION_FRAME_COUNT 96      // 24 frames * 4 = 96
#macro ANIMATION_LERP_SMOOTH 0.2     // Camera lerp value
#macro ANIMATION_LERP_FAST 0.1       // Faster lerp
#macro BEAM_ANIMATION_FRAMES 12      // Beam weapon sprite frames
```

### Task 8: Add UI Constants

```gml
#macro SPLASH_SCREEN_DURATION 170    // Frames to show splash
#macro CHARACTER_SPACING 24           // Pixels between text characters
#macro CREDITS_THRESHOLD 10           // Minimum credits to play
```

### Task 9: Add Gameplay Constants

```gml
#macro PLAYER_MAX_BULLETS 2           // Max simultaneous player shots
#macro ROGUE_ENEMY_SPEED 6            // Speed of rogue enemies
#macro GAMEPAD_DEADZONE 0.1           // Deadzone for analog stick
```

---

## Testing Checklist

After making changes:

- [ ] Run game with F5 - no crashes
- [ ] Verify level progression still works (check difficulty spikes at levels 3, 7, 11, 15, 19)
- [ ] Test player movement (should still center properly)
- [ ] Test challenge stages trigger at correct levels (4, 8, 12, 16)
- [ ] Run test suites: `runWaveSpawnerTests()`, etc.
- [ ] Verify high score system still works
- [ ] Check enemy behavior at different levels

---

## Implementation Progress Tracker

```
CRITICAL TASKS:
[ ] Task 1: Add Level Progression Constants
[ ] Task 2: Add Bonus/Scoring Constants
[ ] Task 3: Standardize Screen Coordinates

HIGH PRIORITY TASKS:
[ ] Task 4: Add Formation Grid Constants
[ ] Task 5: Add Timing Constants
[ ] Task 6: Fix Enemy Shot Boundary

MEDIUM PRIORITY TASKS:
[ ] Task 7: Add Animation Constants
[ ] Task 8: Add UI Constants
[ ] Task 9: Add Gameplay Constants

VALIDATION:
[ ] Run game and play through levels 1-20
[ ] Run automated test suites
[ ] Commit changes with reference to MAGIC_NUMBERS_AUDIT.md
[ ] Update ARCHITECTURE.md with new constants location
```

---

## Commit Message Template

```
refactor: Replace magic numbers with named constants

- Add Level Progression Constants (LEVEL_ROGUE_*_START, etc.)
- Add Bonus/Scoring Constants (TRANSFORMATION_BONUS, etc.)
- Standardize screen coordinate usage (use SCREEN_CENTER_X, PLAYER_SPAWN_Y)
- Add Formation Grid, Timing, and Animation constants
- Update newlevel.gml to use constants for difficulty progression
- Update player/enemy positioning to use coordinate constants

Fixes issues identified in MAGIC_NUMBERS_AUDIT.md
- 39+ hardcoded values replaced with named macros
- Improves code readability and maintainability
- Makes difficulty tuning easier for future development
- Resolves boundary inconsistency (576 vs 592)

All tests pass, no gameplay changes.
```

---

## Files to Modify Summary

| File | Changes | Est. Time |
|------|---------|-----------|
| `scripts/GameConstants/GameConstants.gml` | Add 8 constant groups | 30 min |
| `scripts/newlevel/newlevel.gml` | Replace 15+ hardcoded values | 30 min |
| `objects/oEnemyBase/Destroy_0.gml` | Replace 2 values (8, 160) | 10 min |
| `objects/oGameManager/Alarm_2.gml` | Replace 1 value (10000) | 10 min |
| `objects/oPlayer/Step_0.gml` | Replace 4 values (224, 448, 528) | 20 min |
| `objects/oEnemyShot/Step_2.gml` | Replace 1 value (576) | 10 min |
| `scripts/rogueturn/rogueturn.gml` | Replace 3 values | 15 min |
| Testing & Validation | Run tests, verify gameplay | 30 min |

**Total Estimated Time: 2.5-3 hours**

---

## Success Criteria

✅ All magic numbers listed in MAGIC_NUMBERS_AUDIT.md replaced with constants
✅ Game runs without errors
✅ All difficulty progression works as before
✅ Test suites pass
✅ Code is more readable with named constants
✅ Future developers can easily tune game parameters

---

**Ready to Implement?** Start with Task 1: Level Progression Constants

This will have the biggest impact on code clarity and maintainability.
