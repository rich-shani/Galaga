# BUG #GW-001: Erratic Path Behavior with Final Enemies - Implementation Document

**Document Version:** 1.0
**Date:** 2025-11-24
**Status:** Analysis Complete - Ready for Implementation
**Severity:** LOW (visual glitch, does not affect gameplay)

---

## Executive Summary

When transitioning to `IN_FINAL_ATTACK` mode (when 2-3 enemies remain), enemies occasionally exhibit erratic path behavior on their **first dive attack** before normalizing on subsequent dives. The root cause is a **missing path initialization** when entering `IN_FINAL_ATTACK` state for the first time.

---

## Problem Statement

### Reproduction Steps
1. Clear all enemies except 2-3
2. Wait for an enemy to complete its dive and respawn at the top of the screen
3. Observe the first dive attack in `IN_FINAL_ATTACK` mode
4. **Result:** Enemy may follow an unexpected path briefly before normalizing

### Expected Behavior
Final enemies should smoothly transition to `IN_FINAL_ATTACK` mode and follow proper dive paths from the first dive onward.

### Current Behavior
- **First dive in IN_FINAL_ATTACK mode:** Path may not be set properly, causing erratic movement
- **Subsequent dives:** Behavior normalizes correctly

---

## Root Cause Analysis

### Code Location
**File:** `objects/oEnemyBase/Step_0.gml`
**Line:** 450-479

### Issue Breakdown

The problem occurs in the state transition logic at line 478:

```gml
// Line 478
if (global.Game.Enemy.count < 3) enemyState = EnemyState.IN_FINAL_ATTACK;
else enemyState = EnemyState.MOVE_INTO_FORMATION;
```

**Problem:** When transitioning to `IN_FINAL_ATTACK`, the code **only changes the state variable** without initializing the path for the first dive.

### Comparison: Normal Dive Flow

**IN_DIVE_ATTACK → Loop Complete → Respawn:**
1. Enemy dives with path set (lines 272-284)
2. Path completes
3. Enemy respawns at top (lines 441-447)
4. **Path is initialized immediately** (lines 511-521) ✓

**IN_FINAL_ATTACK First Entry:**
1. Enemy completes dive
2. Respawns at top (lines 500-501)
3. **Path NOT initialized** ✗
4. Next frame: `update_final_attack()` only sets dive alarm, doesn't start path
5. Player must wait ~30 frames for alarm to trigger before path starts

### The Missing Initialization

When transitioning to `IN_FINAL_ATTACK` at line 478, the code **assumes** the next `Step` iteration will:
1. Call `update_final_attack()` (EnemyBehavior.gml:325)
2. Wait for `alarm[DIVE_ATTACK]` to trigger
3. Then initialize the path

**This creates a gap:** Between state change and path initialization, the enemy has no path and may exhibit undefined movement.

---

## Technical Details

### Current IN_FINAL_ATTACK Implementation

**File:** `scripts/EnemyBehavior/EnemyBehavior.gml` (lines 321-332)

```gml
function update_final_attack(_enemy) {
	with (_enemy) {
		// More aggressive dive timing
		if (alarm[EnemyAlarmIndex.DIVE_ATTACK] == -1 && irandom(5) == 0) {
			alarm[EnemyAlarmIndex.DIVE_ATTACK] = 30; // Faster dive timing
		}
	}
}
```

**Issues:**
1. Does NOT initialize path immediately
2. Only sets an alarm for future dive
3. No handling of the first entry into the state

### Current IN_DIVE_ATTACK Respawn Logic

**File:** `objects/oEnemyBase/Step_0.gml` (lines 440-481)

```gml
else {
	// reset to the top of screen && move into formation
	path_end();
	speed = entranceSpeed;

	x = breathex;
	y = SPAWN_TOP_Y;

	// reset beam state
	if (beam_weapon.available) { beam_weapon.state = BEAM_STATE.READY; }

	// check if we're the last two enemies left ...
	if (global.Game.Enemy.count < 3) enemyState = EnemyState.IN_FINAL_ATTACK;
	else enemyState = EnemyState.MOVE_INTO_FORMATION;
}
```

**What happens next:**
- If transitioning to `MOVE_INTO_FORMATION`: Enemy moves into grid position (lines 181-196)
- If transitioning to `IN_FINAL_ATTACK`: **Nothing happens until next frame's alarm**

---

## Solution

### Recommended Fix: Immediate Path Initialization

**Approach:** Initialize the dive path **immediately** when entering `IN_FINAL_ATTACK` mode for the first time.

**Affected Code Block:** Lines 477-479

### Option A: Inline Path Setup (Simple)

Replace lines 477-479 with:

```gml
// check if we're the last two enemies left ...
if (global.Game.Enemy.count < 3) {
	enemyState = EnemyState.IN_FINAL_ATTACK;

	// Initialize first dive path immediately to prevent erratic behavior
	if (x > SCREEN_CENTER_X * global.Game.Display.scale) {
		if (attributes.STANDARD.DIVE_PATH2 != noone) {
			var path_id = safe_get_asset(attributes.STANDARD.DIVE_PATH2, -1);
			if (path_id != -1) path_start(path_id, moveSpeed, 0, 0);
		}
	} else {
		if (attributes.STANDARD.DIVE_ALT_PATH2 != noone) {
			var path_id = safe_get_asset(attributes.STANDARD.DIVE_ALT_PATH2, -1);
			if (path_id != -1) path_start(path_id, moveSpeed, 0, 0);
		}
	}

	// Fire sound effect
	global.Game.Controllers.audioManager.stopSound(GDive);
	global.Game.Controllers.audioManager.playSound(GDive);

	// Set shooting alarm
	alarm[1] = ENEMY_SHOT_ALARM;
} else {
	enemyState = EnemyState.MOVE_INTO_FORMATION;
}
```

**Advantages:**
- ✓ Simple, straightforward implementation
- ✓ Matches existing `IN_DIVE_ATTACK` respawn behavior (lines 511-521)
- ✓ Minimal code duplication

**Disadvantages:**
- ✗ Duplicates path selection logic (already at lines 511-521)

---

### Option B: Extract Helper Function (Recommended)

Create a helper function in `scripts/EnemyBehavior/EnemyBehavior.gml`:

```gml
/// @function start_final_attack_dive
/// @description Initializes first dive in IN_FINAL_ATTACK mode
/// @param {Id.Instance} _enemy Enemy instance
/// @return {undefined}
function start_final_attack_dive(_enemy) {
	with (_enemy) {
		// Randomize spawn position
		x = SPAWN_EDGE_MARGIN + irandom(global.Game.Display.screenWidth - SPAWN_EDGE_BUFFER);
		y = SPAWN_TOP_Y;

		// Choose path based on position
		if (x > SCREEN_CENTER_X * global.Game.Display.scale) {
			if (attributes.STANDARD.DIVE_PATH2 != noone) {
				var path_id = safe_get_asset(attributes.STANDARD.DIVE_PATH2, -1);
				if (path_id != -1) path_start(path_id, moveSpeed, 0, 0);
			}
		} else {
			if (attributes.STANDARD.DIVE_ALT_PATH2 != noone) {
				var path_id = safe_get_asset(attributes.STANDARD.DIVE_ALT_PATH2, -1);
				if (path_id != -1) path_start(path_id, moveSpeed, 0, 0);
			}
		}

		// Sound and shooting
		global.Game.Controllers.audioManager.stopSound(GDive);
		global.Game.Controllers.audioManager.playSound(GDive);
		alarm[1] = ENEMY_SHOT_ALARM;
	}
}
```

Then update `oEnemyBase/Step_0.gml` (lines 440-481):

```gml
else {
	// reset to the top of screen && move into formation
	path_end();
	speed = entranceSpeed;

	x = breathex;
	y = SPAWN_TOP_Y;

	// reset beam state
	if (beam_weapon.available) { beam_weapon.state = BEAM_STATE.READY; }

	// check if we're the last two enemies left ...
	if (global.Game.Enemy.count < 3) {
		enemyState = EnemyState.IN_FINAL_ATTACK;
		start_final_attack_dive(self);  // Initialize first dive immediately
	} else {
		enemyState = EnemyState.MOVE_INTO_FORMATION;
	}
}
```

And keep `update_final_attack()` in EnemyBehavior.gml unchanged for subsequent dives:

```gml
function update_final_attack(_enemy) {
	with (_enemy) {
		// More aggressive dive timing for dives after the first
		if (alarm[EnemyAlarmIndex.DIVE_ATTACK] == -1 && irandom(5) == 0) {
			alarm[EnemyAlarmIndex.DIVE_ATTACK] = 30;
		}
	}
}
```

**Advantages:**
- ✓ Eliminates code duplication
- ✓ DRY principle: single source of truth for final attack path setup
- ✓ Reusable for other state transitions
- ✓ Easier to test and maintain

**Disadvantages:**
- ✗ Requires adding a new function
- ✗ Slightly more complex

---

## Recommended Implementation: **Option B (Extract Helper)**

This approach is cleaner and follows best practices by eliminating duplication and creating a reusable function.

### Implementation Checklist

- [ ] **Step 1:** Add `start_final_attack_dive()` function to `scripts/EnemyBehavior/EnemyBehavior.gml`
- [ ] **Step 2:** Update `oEnemyBase/Step_0.gml` line 478 to call the helper
- [ ] **Step 3:** Add documentation comments (already included above)
- [ ] **Step 4:** Test with 2-3 enemies remaining
  - [ ] First dive should start with initialized path (no lag)
  - [ ] Subsequent dives should continue smoothly
  - [ ] Path selection should respect left/right position
- [ ] **Step 5:** Run existing test suite to ensure no regressions
  - [ ] `TestEnemyStateMachine.gml`
  - [ ] Manual gameplay testing in IN_FINAL_ATTACK scenario

---

## Testing Strategy

### Unit Test Cases

**Test 1: First Dive Path Initialization**
- Set `global.Game.Enemy.count = 2`
- Trigger enemy to reach `y > DIVE_Y_THRESHOLD`
- Verify: `path_index != -1` (path is set)
- Verify: `x` coordinate is randomized within `[SPAWN_EDGE_MARGIN, screenWidth - SPAWN_EDGE_BUFFER]`

**Test 2: Path Selection (Right Position)**
- Set enemy `x > SCREEN_CENTER_X * scale`
- Call `start_final_attack_dive(self)`
- Verify: `DIVE_PATH2` is requested

**Test 3: Path Selection (Left Position)**
- Set enemy `x <= SCREEN_CENTER_X * scale`
- Call `start_final_attack_dive(self)`
- Verify: `DIVE_ALT_PATH2` is requested

**Test 4: Subsequent Dives**
- Enemy in `IN_FINAL_ATTACK` mode
- Wait 30 frames for alarm to trigger
- Verify: Dive path initializes correctly

### Integration Testing

**Scenario: Complete final wave cleanup**
1. Start game, progress to last 3 enemies
2. Wait for enemy to complete dive and respawn
3. Observe: First dive in IN_FINAL_ATTACK mode
4. **Expected:** Smooth path following from first frame
5. **Verify:** No visual glitches or erratic movement

---

## Impact Assessment

### Affected Components
- `oEnemyBase` Step event: Path initialization logic
- `EnemyBehavior.gml`: New helper function
- `IN_FINAL_ATTACK` state machine behavior

### Risk Level: **MINIMAL**
- Changes only affect enemies in `IN_FINAL_ATTACK` mode (rare scenario)
- Does not modify core state machine logic
- Helper function follows existing patterns
- Existing tests continue to validate behavior

### Backward Compatibility: **FULL**
- No breaking changes to interfaces
- No changes to global game state
- No modifications to alarm/timing systems

---

## Performance Impact

**Memory:** +1 new function in EnemyBehavior.gml (negligible)
**CPU:** No additional overhead (logic already executed, just reorganized)
**Physics:** No changes to collision or movement systems

---

## Related Code References

| File | Line(s) | Purpose |
|------|---------|---------|
| oEnemyBase/Step_0.gml | 440-481 | Respawn logic (needs update) |
| oEnemyBase/Step_0.gml | 493-523 | IN_FINAL_ATTACK path initialization (current) |
| EnemyBehavior.gml | 321-332 | update_final_attack function |
| GameConstants.gml | 144 | FINAL_ATTACK_ENEMY_COUNT macro |

---

## Conclusion

BUG #GW-001 is caused by incomplete state initialization when transitioning to `IN_FINAL_ATTACK` mode. The fix is straightforward: initialize the dive path immediately upon entering this state, rather than waiting for an alarm to trigger on the next frame.

**Recommended Solution:** Extract path initialization into a `start_final_attack_dive()` helper function to eliminate code duplication and improve maintainability (Option B).

**Estimated Implementation Time:** 15-20 minutes
**Testing Time:** 10-15 minutes
**Total Time:** ~30 minutes

---

## Appendix: Code Diff

### File: `scripts/EnemyBehavior/EnemyBehavior.gml`

**Add new function after line 332:**

```gml
/// @function start_final_attack_dive
/// @description Initializes first dive in IN_FINAL_ATTACK mode
/// @param {Id.Instance} _enemy Enemy instance
/// @return {undefined}
function start_final_attack_dive(_enemy) {
	with (_enemy) {
		// Randomize spawn position
		x = SPAWN_EDGE_MARGIN + irandom(global.Game.Display.screenWidth - SPAWN_EDGE_BUFFER);
		y = SPAWN_TOP_Y;

		// Choose path based on position
		if (x > SCREEN_CENTER_X * global.Game.Display.scale) {
			if (attributes.STANDARD.DIVE_PATH2 != noone) {
				var path_id = safe_get_asset(attributes.STANDARD.DIVE_PATH2, -1);
				if (path_id != -1) path_start(path_id, moveSpeed, 0, 0);
			}
		} else {
			if (attributes.STANDARD.DIVE_ALT_PATH2 != noone) {
				var path_id = safe_get_asset(attributes.STANDARD.DIVE_ALT_PATH2, -1);
				if (path_id != -1) path_start(path_id, moveSpeed, 0, 0);
			}
		}

		// Sound and shooting setup
		global.Game.Controllers.audioManager.stopSound(GDive);
		global.Game.Controllers.audioManager.playSound(GDive);
		alarm[1] = ENEMY_SHOT_ALARM;
	}
}
```

### File: `objects/oEnemyBase/Step_0.gml`

**Replace lines 477-479:**

**Before:**
```gml
// check if we're the last two enemies left ...
if (global.Game.Enemy.count < 3) enemyState = EnemyState.IN_FINAL_ATTACK;
else enemyState = EnemyState.MOVE_INTO_FORMATION;
```

**After:**
```gml
// check if we're the last two enemies left ...
if (global.Game.Enemy.count < 3) {
	enemyState = EnemyState.IN_FINAL_ATTACK;
	start_final_attack_dive(self);
} else {
	enemyState = EnemyState.MOVE_INTO_FORMATION;
}
```

---

**Document prepared by:** Claude Code
**Next Steps:** Review and approve implementation plan before development
