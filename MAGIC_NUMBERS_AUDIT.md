# Galaga Wars - Magic Numbers Audit Report

**Date:** November 2024
**Status:** Complete Analysis
**Total Magic Numbers Found:** 39+
**Critical Issues:** 5
**High Priority:** 9
**Medium Priority:** 24
**Low Priority:** 2

---

## Executive Summary

A comprehensive audit of the codebase identified **39+ hardcoded magic numbers** that should be replaced with named constants. These numbers are scattered across game logic, timing, positioning, and scoring systems.

**Key Findings:**
- **Level progression thresholds** (3, 4, 7, 8, 10, 11, 12, 15, 19) are the biggest offender - used 15+ times across multiple files without constants
- **Screen coordinates** (224, 448, 528, 576, 592) hardcoded in many places instead of using existing constants
- **Formation count (40)** referenced throughout without dedicated constant
- **Timing values** (60, 120, 180, 240, 300) inconsistently applied

**Impact:**
- ❌ Difficult to modify game parameters (especially difficulty progression)
- ❌ Inconsistent values in different files (e.g., 576 vs 592 for bottom boundary)
- ❌ Reduces code readability and maintainability
- ❌ Makes tuning gameplay difficult

---

## CRITICAL - Magic Numbers (5 Issues)

### 1. Level Progression Thresholds (Levels: 3, 4, 7, 8, 10, 11, 12, 15, 19)

**Severity:** 🔴 CRITICAL - Most Frequently Used Magic Numbers

**Locations:**
- `scripts/newlevel/newlevel.gml:5-47` (Primary location - 15+ uses)
- `objects/oEnemyBase/Alarm_5.gml:21` (Secondary uses)
- `objects/oGameManager/Step_1.gml` (Implied checks)

**Current Usage:**
```gml
// Level 3+: Introduce rogue level 1
if (global.Game.Level.current > 3) {
    global.Game.Enemy.rogueLevel = 1;
}

// Level 7+: Rogue level 2, fastEnter begins
if (global.Game.Level.current > 7) {
    global.Game.Enemy.rogueLevel = 2;
    global.Game.Difficulty.fastEnter = 1;
}

// Level 10: Reset fastEnter, rogue reset
if (global.Game.Level.current == 10) {
    global.Game.Difficulty.fastEnter = 0;
    global.Game.Enemy.rogueLevel = 1;
}

// Level 11+: Fast mode, advanced shots
if (global.Game.Level.current > 11) {
    global.Game.Enemy.rogueLevel = 3;
    global.Game.Difficulty.speedMode = 1;
    global.Game.Enemy.shotNumber = 3;
}

// Level 15+: Rogue level 4
if (global.Game.Level.current > 15) {
    global.Game.Enemy.rogueLevel = 4;
}

// Level 19+: 4 shots, boss cap 4
if (global.Game.Level.current > 19) {
    global.Game.Enemy.shotNumber = 4;
    global.Game.Enemy.bossDiveCap = 4;
}

// Challenge cycle: Every 4 levels
if (global.Game.Level.current == 4 || global.Game.Level.current == 8 ||
    global.Game.Level.current == 12 || global.Game.Level.current == 16) {
    // Challenge stage triggers
}
```

**Problem:** These thresholds define core difficulty progression but are hardcoded throughout the codebase. Changing difficulty curve requires finding and updating multiple scattered values.

**Solution:** Create level progression constants:
```gml
// Level Progression Milestones
#macro LEVEL_ROGUE_1_START 3      // Rogue enemies appear
#macro LEVEL_ROGUE_2_START 7      // Rogue level 2, fast entry begins
#macro LEVEL_FASTENTER_RESET 10   // Fast entry resets, rogue level resets
#macro LEVEL_ROGUE_3_START 11     // Rogue level 3, fast mode, 3 shots
#macro LEVEL_ROGUE_4_START 15     // Rogue level 4
#macro LEVEL_ADVANCED_SHOTS 19    // 4 shots, boss cap 4

// Challenge Stage Progression (Every 4 levels)
#macro LEVEL_CHALLENGE_THRESHOLD 4
#macro CHALLENGE_AT_LEVEL_4 4
#macro CHALLENGE_AT_LEVEL_8 8
#macro CHALLENGE_AT_LEVEL_12 12
#macro CHALLENGE_AT_LEVEL_16 16
```

**Files to Update:**
- `scripts/newlevel/newlevel.gml` (Primary - 15+ replacements)
- `objects/oEnemyBase/Alarm_5.gml` (2-3 replacements)
- `objects/oGameManager/Step_1.gml` (2-3 replacements)

**Estimated Impact:** HIGH - Affects game progression, difficulty tuning

---

### 2. Formation Grid Size: 40 Enemies

**Severity:** 🔴 CRITICAL - Fundamental System Design

**Locations:**
- `objects/oEnemyBase/Destroy_0.gml:70` - "if 8 kills = bonus" (part of 40 system)
- `scripts/ChallengeStageManager/ChallengeStageManager.gml:154` - Enemy tracking
- `scripts/ErrorHandling/ErrorHandling.gml:487` - Grid validation
- `scripts/GameManager_STEP_FNs/GameManager_STEP_FNs.gml:339, 347, 423` - Comments
- `scripts/ScoreManager/ScoreManager.gml:111, 122` - Perfect game tracking
- Various draw and UI functions

**Current Usage:**
```gml
// Formation validation
if (array_length(positions) != 40) {
    log_error("Formation grid must have exactly 40 positions", ...);
}

// Perfect clear detection
if (shots_hit == 40 && shots_fired == 40) {
    // Perfect clear bonus
}

// Formation loop (rare but present)
for (i = 0; i < 40; i++) {
    // Process formation position
}
```

**Problem:** The number 40 appears throughout the codebase. It's partially defined by enum but inconsistently referenced.

**Solution:** Use existing constant consistently:
```gml
#macro FORMATION_GRID_SIZE 40              // Already partially defined
#macro FORMATION_ROWS 5                    // Already defined
#macro FORMATION_COLS 8                    // Already defined

// Verify consistency
// FORMATION_ROWS * FORMATION_COLS should equal FORMATION_GRID_SIZE
```

**Current Status:**
- ✅ `FORMATION_ROWS = 5` exists
- ✅ `FORMATION_COLS = 8` exists
- ❌ Direct `40` still used instead of consistent macro

**Files to Update:**
- `scripts/ChallengeStageManager/ChallengeStageManager.gml` (2-3 uses)
- `scripts/ErrorHandling/ErrorHandling.gml` (1-2 uses)
- `scripts/GameManager_STEP_FNs/GameManager_STEP_FNs.gml` (3-4 uses)

---

### 3. Screen Center X: 224 (or 448 when scaled)

**Severity:** 🔴 CRITICAL - Widely Used Positioning

**Locations:**
- `objects/oPlayer/Step_0.gml:217, 220` - Player centering
- `objects/oPlayer/Step_0.gml:277` - Player spawn X
- `objects/oTieIntercepter/Alarm_4.gml:1` - Enemy positioning
- `scripts/rogueturn/rogueturn.gml:9, 11` - Rogue enemy targeting
- Multiple Draw_Hud functions - UI positioning

**Current Usage:**
```gml
// Player movement boundaries
if (x < 448) {
    x += moveSpeed;
} else if (x > 448) {
    x -= moveSpeed;
}

// Player spawn position
x = 224 * global.Game.Display.scale;

// Rogue enemy targeting
if (x < SCREEN_CENTER_X * global.Game.Display.scale) {
    targx = 448;  // Right side
} else {
    targx = 224;  // Left side
}
```

**Problem:** Hardcoded 224/448 values scattered throughout. Existing constant `SCREEN_CENTER_X = 224` exists but not consistently used.

**Solution:**
```gml
// Use existing constant instead of hardcoded values
#macro SCREEN_CENTER_X 224  // Already exists in GameConstants.gml

// In code, always use:
x = SCREEN_CENTER_X * global.Game.Display.scale;

// Not:
x = 224 * global.Game.Display.scale;
```

**Files to Update:**
- `objects/oPlayer/Step_0.gml` (3-4 uses)
- `objects/oTieIntercepter/Alarm_4.gml` (1-2 uses)
- `scripts/rogueturn/rogueturn.gml` (2-3 uses)
- Various Draw_Hud functions (3-4 uses)

**Estimated Impact:** MEDIUM - Positioning issues if changed, but important for consistency

---

### 4. Screen Bottom Y: 528 (Player Spawn) and 592 (Off-Screen Threshold)

**Severity:** 🔴 CRITICAL - Inconsistent Boundary Values

**Locations:**
- `objects/oPlayer/Step_0.gml:278` - Player spawn Y (uses 528)
- `objects/oEnemyShot/Step_2.gml:66` - Enemy shot destruction (uses 576)
- `scripts/rogueturn/rogueturn.gml:11, 16` - Rogue enemy behavior (uses 528)

**Current Usage:**
```gml
// Player spawn position (528)
y = 528 * global.Game.Display.scale;

// Enemy shot off-screen check (576 - INCONSISTENT!)
if (y > 576 * global.Game.Display.scale) {
    instance_destroy();
}

// Different value used elsewhere
SCREEN_BOTTOM_Y = 592  // Defined in GameConstants but not always used
```

**Problem:** Three different values (528, 576, 592) used for similar purposes without clear distinction. Creates confusion and potential bugs.

**Solution:**
```gml
// Clarify each value's purpose
#macro PLAYER_SPAWN_Y 528        // Where player respawns
#macro ENEMY_SHOT_THRESHOLD 576  // Where enemy shots disappear (intermediate)
#macro SCREEN_BOTTOM_Y 592       // True screen bottom (off-screen)

// Use consistently:
y = PLAYER_SPAWN_Y * global.Game.Display.scale;
if (y > SCREEN_BOTTOM_Y * global.Game.Display.scale) {
    instance_destroy();
}
```

**Current Status:**
- ✅ `PLAYER_SPAWN_Y = 528` exists
- ✅ `SCREEN_BOTTOM_Y = 592` exists
- ❌ Direct hardcoded values still used
- ❌ Inconsistency with 576 vs 592

**Files to Update:**
- `objects/oPlayer/Step_0.gml` (1-2 uses of 528)
- `objects/oEnemyShot/Step_2.gml` (1 use of 576 - verify correct value)
- `scripts/rogueturn/rogueturn.gml` (2-3 uses)

---

### 5. Bonus/Scoring Thresholds: 8, 160, 10000

**Severity:** 🔴 CRITICAL - Game Balance Parameters

**Locations:**
- `objects/oEnemyBase/Destroy_0.gml:70` - "8 kills = bonus"
- `objects/oEnemyBase/Destroy_0.gml:79` - 160 point transformation bonus
- `objects/oGameManager/Alarm_2.gml:23` - 10000 point perfect clear bonus

**Current Usage:**
```gml
// Every 8 kills, award bonus
if (global.Game.Player.shotCount == 8) {
    global.Game.Player.score += 160;  // Transformation bonus
    sound_play(GTransform);
}

// Perfect clear (40/40 kills with 40/40 shots)
if (perfect_clear) {
    global.Game.Player.score += 10000;
}
```

**Problem:** Bonus thresholds hardcoded and inconsistently documented. Changing game balance requires finding scattered values.

**Solution:**
```gml
#macro ENEMIES_PER_BONUS 8
#macro TRANSFORMATION_BONUS 160
#macro PERFECT_CLEAR_BONUS 10000

// In code:
if (global.Game.Player.shotCount == ENEMIES_PER_BONUS) {
    global.Game.Player.score += TRANSFORMATION_BONUS;
}
```

**Files to Update:**
- `objects/oEnemyBase/Destroy_0.gml` (2 uses)
- `objects/oGameManager/Alarm_2.gml` (1 use)
- Any scoring-related scripts (2-3 uses)

---

## HIGH - Magic Numbers (9 Issues)

### 6. Frame-Based Timing: 60 (1 Second), 120 (2 Seconds)

**Files:**
- `objects/oGameManager/Step_1.gml:13` - `if global.Game.Display.flip == 60`
- `objects/oPlayer/Alarm_11.gml:29` - `alarm[0] = 120`
- `scripts/GameConstants/GameConstants.gml:196` - `#macro FORMATION_ALARM_DELAY 60`

**Issue:** Common timing values (60 frames = 1 sec, 120 = 2 sec at 60 FPS) used without explanation

**Solution:**
```gml
#macro FRAMES_PER_SECOND 60        // GameMaker runs at 60 FPS
#macro ONE_SECOND_FRAMES 60        // 60 frames = 1 second
#macro TWO_SECOND_FRAMES 120       // 120 frames = 2 seconds
#macro HALF_SECOND_FRAMES 30       // 30 frames = 0.5 seconds
```

---

### 7. Spawn/Formation Timers: 250, 300

**Files:**
- `objects/oGameManager/Step_1.gml:95` - `alarm[11] = 250`
- `objects/oGameManager/Alarm_10.gml` - Related timing
- Various spawn sequences

**Issue:** Specific timing values without clear purpose or documentation

**Already Exists:** Partially covered but not comprehensively

---

### 8. Enemy Shot Destruction Boundaries: 576 vs 592

**Files:**
- `objects/oEnemyShot/Step_2.gml:66` - Uses 576
- `GameConstants.gml` - Defines 592 as SCREEN_BOTTOM_Y

**Issue:** Inconsistent boundary values for same purpose

**Recommendation:** Verify which is correct, then use one consistently

---

### 9. Transformation/Combo Counts: 3, 4

**Files:**
- `objects/oEnemyBase/Destroy_0.gml:82` - `if transformCount == 3`
- `scripts/newlevel/newlevel.gml:63` - `if global.Game.Enemy.transformNum = 4`

**Issue:** Transformation system uses hardcoded combo numbers

**Solution:**
```gml
#macro MAX_TRANSFORMATION_COMBO 3
#macro TRANSFORMATION_RESET_COUNT 4
```

---

### 10. Challenge System: 8 Challenges, 9 Cycle

**Files:**
- `scripts/ChallengeStageManager/ChallengeStageManager.gml:58` - Challenge ID 0-7 (8 total)
- `scripts/newlevel/newlevel.gml:61` - `if global.Game.Challenge.current = 9`

**Current Status:**
- ✅ Partially defined (CHALLENGE_ENEMIES_PER_WAVE = 8)
- ❌ Challenge count not consistently defined

**Solution:**
```gml
#macro TOTAL_CHALLENGE_COUNT 8
#macro CHALLENGE_CYCLE_RESET 9     // Reset to 1 when reaches 9
```

---

### 11-13. Additional Timing Values

- **Beam Capture Alarms:** 180, 240 frames (mostly covered)
- **Animation Frame Counts:** 96 frames (24*4)
- **Display Flip Counter:** 60 frames (mostly covered)

---

## MEDIUM - Magic Numbers (24 Issues)

### Primary Issues:

| # | Value | Purpose | Location | Type |
|---|-------|---------|----------|------|
| 14 | 0.1 | Gamepad deadzone | oPlayer:45 | Input |
| 15 | 2 | Player max bullets | oPlayer:109 | Weapon |
| 16 | 0.2, 0.1 | Animation lerp | oGameCamera:23-24 | Animation |
| 17 | 3, 4 | Transform combos | Destroy_0:82 | Game Logic |
| 18 | 9 | Challenge cycle reset | newlevel:61 | Challenge |
| 19 | 1 | Challenge count threshold | newlevel:5 | Challenge |
| 20 | 64 | Splash dimensions | oSplashScreen:3 | UI |
| 21 | 170 | Splash duration | oSplashScreen:18 | UI |
| 22 | 180, 30 | Various alarms | Multiple | Timing |
| 23 | 450 | Game over transition | oPlayer:18 | Game Flow |
| 24 | 70 | Destroy alarm | Multiple | Timing |
| 25 | 14 | Formation countdown | Step_1:96 | Formation |
| 26 | 496 | Rogue transition Y | rogueturn:3 | Enemy AI |
| 27 | 6 | Rogue speed | rogueturn:3 | Movement |
| 28 | 3 | Centering adjustment | Multiple | Positioning |
| 29 | 24 | Character spacing | TextScroller:23 | UI |
| 30 | 180, 800 | Particle lifetime | StarfieldGenerator:19 | Particles |
| 31 | 90 | Repeat alarm | Alarm_11:15 | Timing |
| 32 | 633 | Attract mode loop | Alarm_7:19 | Audio |
| 33 | 102 | Results sequence | Alarm_2:32 | Game Flow |
| 34 | 210, 300 | Level transition | Alarm_2:39 | Game Flow |
| 35 | 10 | Credits threshold | KeyPress_49:2 | Game Logic |
| 36 | 12 | Beam animation | Step_0:12 | Animation |
| 37 | -400 | Death Star scroll | Step_0:2 | Animation |

---

## LOW - Magic Numbers (2 Issues)

### 38. Sprite Index Values: 1, 2, 3

**Files:** `objects/oPlayer/Step_0.gml:48, 53, 58, 74, 75`

**Status:** ✅ Already has constants (SHIP_SPRITE_LEFT=1, etc.)
**Issue:** Direct values used instead of constants in some places
**Severity:** LOW - Already partially constantized

---

### 39. Path Position = 1.0

**Files:** `objects/oEnemyBase/Step_0.gml:19, 29`

**Usage:** `if (path_position >= 1)`

**Status:** ✅ GameMaker API standard
**Severity:** LOW - API standard, not actual magic number

---

## Summary by File

### Files with Most Magic Numbers:

| File | Magic Numbers | Density | Priority |
|------|---------------|---------|----------|
| `scripts/newlevel/newlevel.gml` | 15+ | Very High | 🔴 CRITICAL |
| `objects/oEnemyBase/Destroy_0.gml` | 6+ | High | 🔴 CRITICAL |
| `objects/oGameManager/Step_1.gml` | 4+ | High | 🔴 CRITICAL |
| `objects/oPlayer/Step_0.gml` | 4+ | High | 🔴 CRITICAL |
| `objects/oGameManager/Alarm_2.gml` | 4+ | High | 🟡 HIGH |
| `scripts/rogueturn/rogueturn.gml` | 4+ | High | 🟡 HIGH |
| `objects/oEnemyShot/Step_2.gml` | 2 | Medium | 🟡 HIGH |
| `objects/oTieIntercepter/Alarm_3.gml` | 2+ | Medium | 🟡 HIGH |

---

## Recommended Implementation Plan

### Phase 1: CRITICAL (1-2 hours)

1. **Add Level Progression Constants** to `GameConstants.gml`
2. **Update `newlevel.gml`** to use constants (15+ replacements)
3. **Add Bonus/Scoring Constants** (TRANSFORMATION_BONUS, PERFECT_CLEAR_BONUS, etc.)
4. **Standardize Screen Coordinates** (use SCREEN_CENTER_X consistently)

### Phase 2: HIGH (1-2 hours)

5. **Create Formation Grid Constants** (ensure 40 = 5×8 consistency)
6. **Add Timing Constants** (FRAMES_PER_SECOND, ONE_SECOND_FRAMES, etc.)
7. **Fix Enemy Shot Boundaries** (reconcile 576 vs 592 inconsistency)
8. **Standardize Challenge System** (TOTAL_CHALLENGE_COUNT macro)

### Phase 3: MEDIUM (2-3 hours)

9. **Add Input Constants** (GAMEPAD_DEADZONE usage)
10. **Create UI Constants** (SPLASH_SCREEN_DURATION, CHARACTER_SPACING)
11. **Add Weapon Constants** (BEAM_ANIMATION_FRAMES, PLAYER_MAX_BULLETS)
12. **Create Animation Constants** (ANIMATION_LERP values)

### Phase 4: Testing & Validation (1 hour)

13. **Run full test suite** to ensure no regressions
14. **Verify all constants are used consistently**
15. **Update documentation** with new constants
16. **Commit with clear message** referencing this audit

---

## Implementation Example

### Before (Current Code):
```gml
// Level progression scattered throughout newlevel.gml
if (global.Game.Level.current > 3) {
    global.Game.Enemy.rogueLevel = 1;
}

if (global.Game.Level.current > 7) {
    global.Game.Enemy.rogueLevel = 2;
    global.Game.Difficulty.fastEnter = 1;
}

if (global.Game.Level.current > 11) {
    global.Game.Enemy.rogueLevel = 3;
}
```

### After (With Constants):
```gml
// GameConstants.gml - Define once, use everywhere
#macro LEVEL_ROGUE_1_START 3
#macro LEVEL_ROGUE_2_START 7
#macro LEVEL_ROGUE_3_START 11

// newlevel.gml - Much clearer intent
if (global.Game.Level.current > LEVEL_ROGUE_1_START) {
    global.Game.Enemy.rogueLevel = 1;
}

if (global.Game.Level.current > LEVEL_ROGUE_2_START) {
    global.Game.Enemy.rogueLevel = 2;
    global.Game.Difficulty.fastEnter = 1;
}

if (global.Game.Level.current > LEVEL_ROGUE_3_START) {
    global.Game.Enemy.rogueLevel = 3;
}
```

---

## Benefits of Consolidation

✅ **Easier Tuning:** Change difficulty progression in one place
✅ **Better Readability:** Code intent is immediately clear
✅ **Consistency:** Same values used everywhere
✅ **Maintainability:** Future developers understand purpose of values
✅ **Testing:** Can create tests around constants
✅ **Documentation:** Constants document game design decisions

---

## Appendix: Complete Constants List to Create

```gml
// ================================================================
// LEVEL PROGRESSION CONSTANTS
// ================================================================

#macro LEVEL_ROGUE_1_START 3
#macro LEVEL_ROGUE_2_START 7
#macro LEVEL_FASTENTER_RESET 10
#macro LEVEL_ROGUE_3_START 11
#macro LEVEL_ROGUE_4_START 15
#macro LEVEL_ADVANCED_SHOTS 19
#macro LEVEL_CHALLENGE_THRESHOLD 4

// ================================================================
// FORMATION & GRID CONSTANTS
// ================================================================

#macro FORMATION_GRID_SIZE 40
#macro ENEMIES_PER_BONUS 8
#macro TOTAL_CHALLENGE_COUNT 8
#macro CHALLENGE_CYCLE_RESET 9

// ================================================================
// SCREEN BOUNDARY CONSTANTS (Already exist, ensure usage)
// ================================================================

#macro SCREEN_CENTER_X 224
#macro PLAYER_SPAWN_Y 528
#macro SCREEN_BOTTOM_Y 592
#macro ROGUE_TRANSITION_Y 496

// ================================================================
// SCORING CONSTANTS
// ================================================================

#macro TRANSFORMATION_BONUS 160
#macro PERFECT_CLEAR_BONUS 10000
#macro COMBO_MAX 3
#macro COMBO_RESET 4

// ================================================================
// TIMING CONSTANTS (Frame-based, 60 FPS)
// ================================================================

#macro FRAMES_PER_SECOND 60
#macro ONE_SECOND_FRAMES 60
#macro TWO_SECOND_FRAMES 120
#macro HALF_SECOND_FRAMES 30
#macro FORMATION_COUNTDOWN 14
#macro SPAWN_TIMER 250
#macro REPEAT_ALARM 90
#macro SEQUENCE_TIMER 102
#macro LEVEL_TRANSITION_1 210
#macro LEVEL_TRANSITION_2 300
#macro GAME_OVER_SEQUENCE 450
#macro ATTRACT_MODE_LOOP 633

// ================================================================
// ANIMATION CONSTANTS
// ================================================================

#macro ANIMATION_FRAME_COUNT 96
#macro ANIMATION_LERP_SMOOTH 0.2
#macro ANIMATION_LERP_FAST 0.1
#macro BEAM_ANIMATION_FRAMES 12
#macro PARTICLE_LIFETIME 800

// ================================================================
// UI CONSTANTS
// ================================================================

#macro SPLASH_SCREEN_WIDTH 896
#macro SPLASH_SCREEN_HEIGHT 1152
#macro SPLASH_SCREEN_DURATION 170
#macro CHARACTER_SPACING 24

// ================================================================
// GAMEPLAY CONSTANTS
// ================================================================

#macro PLAYER_MAX_BULLETS 2
#macro GAMEPAD_DEADZONE 0.1
#macro ROGUE_ENEMY_SPEED 6
#macro DEATH_STAR_SCROLL_LIMIT -400
#macro CREDITS_THRESHOLD 10
```

---

## Conclusion

The Galaga Wars codebase contains **39+ magic numbers** that reduce maintainability and make parameter tuning difficult. By implementing the recommended constants, especially the **Level Progression Constants** in `scripts/newlevel/newlevel.gml`, the codebase will be significantly more maintainable and easier to modify.

**Priority Recommendation:** Start with Phase 1 (Level Progression Constants) as it will have the most impact on code clarity and game balance tuning.

---

**Report Prepared:** November 2024
**Audit Tool:** Automated Codebase Analysis
**Status:** Ready for Implementation
