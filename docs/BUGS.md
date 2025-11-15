# Known Bugs

This document tracks all known bugs in Galaga Wars. Each bug is assigned a unique ID (GW-XXX) and documented with reproduction steps, severity, and status.

## Bug Tracking System

**Severity Levels:**
- **CRITICAL**: Game-breaking, crashes, data loss
- **HIGH**: Major gameplay impact, frequent occurrence
- **MEDIUM**: Noticeable issues, workarounds available
- **LOW**: Minor visual glitches, rare edge cases

**Priority Levels:**
- **P0**: Drop everything, fix immediately
- **P1**: Fix in current sprint
- **P2**: Fix in next release
- **P3**: Fix when time permits
- **P4**: Low priority, may not fix

**Status:**
- **OPEN**: Bug identified, not yet fixed
- **IN_PROGRESS**: Currently being worked on
- **FIXED**: Bug resolved, awaiting verification
- **VERIFIED**: Fix confirmed working
- **CLOSED**: Issue resolved and deployed
- **WONTFIX**: Decided not to fix (with reason)

---

## Active Bugs

### BUG #GW-001: Erratic Path Behavior with Final Enemies

**Severity:** LOW
**Priority:** P3
**Status:** OPEN
**Reported:** 2025-01-12
**Location:** `objects/oEnemyBase/Step_0.gml:430`

**Description:**
When 2 enemies remain, one enemy occasionally exhibits erratic path behavior on its first dive attack before normalizing. Subsequent dives behave normally.

**Reproduction Steps:**
1. Clear all enemies except 2
2. Wait for one enemy to initiate dive attack
3. Observe: Enemy may follow unexpected path briefly
4. Enemy's subsequent dives work normally

**Expected Behavior:**
Final 2 enemies should follow standard dive patterns consistently, even on first dive after reaching final attack mode.

**Actual Behavior:**
One enemy shows erratic path on first dive, then normalizes.

**Root Cause Hypothesis:**
Possible state transition issue when entering `EnemyState.IN_FINAL_ATTACK` mode. Path may not be properly initialized before the first dive attack is triggered.

**Potential Fix:**
- Ensure path is explicitly set when transitioning to IN_FINAL_ATTACK
- Add path validation before dive attack initiation
- Check if path_position or path_index needs reset on state change

**Impact:**
Minimal - rare edge case that only affects visual behavior, does not impact gameplay fairness or game stability.

**Notes:**
This is a low-priority cosmetic issue. Players rarely notice since they're focused on the final 2 enemies' attacks, not their exact paths.

---

## Bug Statistics

- **Total Bugs:** 1
- **Open:** 1
- **In Progress:** 0
- **Fixed:** 0
- **Verified:** 0
- **Closed:** 0

### By Severity
- **Critical:** 0
- **High:** 0
- **Medium:** 0
- **Low:** 1

### By Priority
- **P0:** 0
- **P1:** 0
- **P2:** 0
- **P3:** 1
- **P4:** 0

---

## Recently Fixed Bugs

_(No bugs fixed yet)_

---

## Won't Fix

_(No bugs marked as won't fix)_

---

## Bug Reporting Guidelines

When reporting a new bug, please include:

1. **Clear Title:** Brief description (e.g., "Enemy spawns outside screen bounds")
2. **Reproduction Steps:** Numbered list of exact steps to reproduce
3. **Expected vs Actual:** What should happen vs what actually happens
4. **Frequency:** Always, Sometimes, Rarely
5. **Environment:** GameMaker version, OS, room/level where it occurs
6. **Screenshots/Video:** If applicable
7. **Code Location:** File and line number if known
8. **Save File:** Attach if bug requires specific game state

---

## Bug Fix Workflow

1. **Identify & Document:** Create bug entry in this file with unique ID
2. **Triage:** Assign severity and priority
3. **Investigate:** Reproduce bug, identify root cause
4. **Fix:** Implement solution, update status to IN_PROGRESS
5. **Test:** Verify fix works, doesn't introduce regressions
6. **Review:** Code review for quality
7. **Deploy:** Merge to main branch
8. **Verify:** Confirm fix in deployed build
9. **Close:** Update status to CLOSED with fix details

---

_Last Updated: 2025-01-12_
