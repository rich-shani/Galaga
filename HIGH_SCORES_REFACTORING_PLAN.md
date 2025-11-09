# High Score System Refactoring Guide

## Overview
This guide provides a step-by-step implementation plan to modernize the high score system from legacy global variables (`global.galaga1..5` and `global.init1..5`) to the new struct-based approach using `global.Game.HighScores` and `global.gmscoreboard_scores` ds_list.

## Current System Analysis

### Legacy Implementation
```
High Scores:
  global.galaga1, global.galaga2, global.galaga3, global.galaga4, global.galaga5 (scores)
  global.init1, global.init2, global.init3, global.init4, global.init5 (player initials)
  global.disp (displayed high score)

Data Source:
  - Initially: INI file (deprecated)
  - Currently: ds_list `global.gmscoreboard_scores` (GameMaker scoreboard)
  - Problem: Dual-system causing confusion and maintenance overhead
```

### New Target Implementation
```
High Scores:
  global.Game.HighScores = {
    scores: [score1, score2, score3, score4, score5],
    initials: [init1, init2, init3, init4, init5],
    display: score (currently displayed high score)
  }

Data Source:
  - Primary: global.gmscoreboard_scores (GMScoreboard ds_list)
  - Secondary: global.Game.HighScores struct (in-memory cache)
  - Single source of truth approach
```

## Implementation Steps

### PHASE 1: Struct Extension (Foundation)

#### Step 1.1: Extend global.Game.HighScores Struct
**File**: `scripts/GameManager_STEP_FNs/GameManager_STEP_FNs.gml` (in `init_globals()` function)

**Current (lines 137-143)**:
```gml
HighScores: {
    first: global.galaga1,
    second: global.galaga2,
    third: global.galaga3,
    fourth: global.galaga4,
    fifth: global.galaga5
}
```

**New Structure** - Change to:
```gml
HighScores: {
    scores: [0, 0, 0, 0, 0],        // Array [score1, score2, score3, score4, score5]
    initials: ["AA", "BB", "CC", "DD", "EE"],  // Array [init1, init2, init3, init4, init5]
    display: 0,                      // Currently displayed high score
    position: -1                     // Which position player just scored in (1-5 or -1 if none)
}
```

**Rationale**:
- Arrays simplify indexed access (eliminate 5 separate variables)
- Logical grouping of related data (scores and initials together)
- `position` tracks where the player's new score ranks (useful for Enter_Initials logic)
- `display` centralizes the displayed score (was previously `global.disp`)

---

### PHASE 2: Load and Sync Functions (Data Flow)

#### Step 2.1: Rewrite `load_highscores()` Function
**File**: `scripts/highscores/highscores.gml`

**Current Implementation Analysis** (lines 1-76):
- Reads from `global.gmscoreboard_scores` ds_list (correct data source) ✓
- Updates legacy globals (`global.galaga1-5`, `global.init1-5`)
- Also updates `global.Game.HighScores.first` (incomplete migration)
- Sets `global.disp` for display

**New Implementation** - Complete rewrite:

```gml
/// @function load_highscores
/// @description Loads high scores from GMScoreboard ds_list into global.Game.HighScores struct
///              This is the primary entry point for high score data synchronization
/// @return {undefined}
function load_highscores() {

    // === INITIALIZE DEFAULT SCORES IF LIST IS EMPTY ===
    if ds_list_empty(global.gmscoreboard_scores) {
        // Set default high scores
        global.Game.HighScores.scores = [20000, 20000, 20000, 20000, 20000];
        global.Game.HighScores.initials = ["N.N", "A.A", "M.M", "C.C", "O.O"];
        global.Game.HighScores.display = 20000;
        return;
    }

    // === LOAD FROM GMSCOREBOARD DS_LIST ===
    var num_scores = ds_list_size(global.gmscoreboard_scores);
    var scores_to_load = min(num_scores, 5);  // Load max 5 scores

    // Clear arrays
    global.Game.HighScores.scores = [];
    global.Game.HighScores.initials = [];

    // === ITERATE THROUGH DS_LIST AND POPULATE STRUCT ARRAYS ===
    for (var i = 0; i < scores_to_load; i++) {
        var item = ds_list_find_value(global.gmscoreboard_scores, i);

        if (item != undefined) {
            var player_name = item[? "player"];
            var player_score = item[? "score"];

            // Add to arrays (auto-extends array)
            global.Game.HighScores.scores[i] = player_score;
            global.Game.HighScores.initials[i] = player_name;
        }
    }

    // === SET DISPLAY SCORE (TOP SCORE) ===
    global.Game.HighScores.display = global.Game.HighScores.scores[0];

    // === LEGACY SYNC (TEMPORARY FOR BACKWARD COMPATIBILITY) ===
    // Remove after all code migrated to use global.Game.HighScores
    sync_legacy_highscores();
}

/// @function sync_legacy_highscores
/// @description TEMPORARY: Syncs global.Game.HighScores to legacy global.galaga1-5 variables
///              This enables gradual migration - remove once all code uses new struct
/// @return {undefined}
function sync_legacy_highscores() {
    // ONE-WAY SYNC: struct → legacy globals (for compatibility only)
    global.galaga1 = global.Game.HighScores.scores[0];
    global.galaga2 = global.Game.HighScores.scores[1];
    global.galaga3 = global.Game.HighScores.scores[2];
    global.galaga4 = global.Game.HighScores.scores[3];
    global.galaga5 = global.Game.HighScores.scores[4];

    global.init1 = global.Game.HighScores.initials[0];
    global.init2 = global.Game.HighScores.initials[1];
    global.init3 = global.Game.HighScores.initials[2];
    global.init4 = global.Game.HighScores.initials[3];
    global.init5 = global.Game.HighScores.initials[4];

    global.disp = global.Game.HighScores.display;
}

/// @function save_highscores
/// @description Saves high scores to persistent storage
///              Currently GMScoreboard handles persistence
///              This function is a placeholder for future expansion
/// @return {undefined}
function save_highscores() {
    // GMScoreboard handles persistence automatically via set_score()
    // This function reserved for future needs (local backup, analytics, etc.)
}
```

**Key Changes**:
1. Array-based storage (index 0-4 maps to scores 1-5)
2. Single loop to populate both arrays simultaneously
3. Proper bounds checking (`min(num_scores, 5)`)
4. Legacy sync function for gradual migration
5. Clear documentation for eventual legacy removal

---

#### Step 2.2: Create High Score Query Function
**File**: `scripts/highscores/highscores.gml` (add new function)

```gml
/// @function get_high_score_at_position
/// @description Retrieves a specific high score by position
/// @param {number} position - Position 1-5 (1 = highest score)
/// @return {number} Score value at position, or 0 if invalid position
function get_high_score_at_position(position) {
    if (position < 1 || position > 5) return 0;
    return global.Game.HighScores.scores[position - 1];  // Convert 1-based to 0-based
}

/// @function get_high_score_initials_at_position
/// @description Retrieves initials for a specific high score position
/// @param {number} position - Position 1-5 (1 = highest score)
/// @return {string} Initials at position, or "???" if invalid
function get_high_score_initials_at_position(position) {
    if (position < 1 || position > 5) return "???";
    return global.Game.HighScores.initials[position - 1];  // Convert 1-based to 0-based
}

/// @function is_new_high_score
/// @description Checks if current player score qualifies for high score table
/// @param {number} player_score - Score to check
/// @return {object} { is_high_score: bool, position: 1-5 or -1 }
function is_new_high_score(player_score) {
    var result = {
        is_high_score: false,
        position: -1
    };

    // Check against each position (from lowest to highest for efficiency)
    for (var i = 4; i >= 0; i--) {  // i: 4,3,2,1,0 (positions 5,4,3,2,1)
        if (player_score > global.Game.HighScores.scores[i]) {
            result.is_high_score = true;
            result.position = i + 1;  // Convert 0-based to 1-based (1-5)
            break;
        }
    }

    return result;
}
```

**Purpose**:
- Provides clean API for high score queries
- Eliminates need to access arrays directly elsewhere
- Centralizes 1-based ↔ 0-based conversion logic

---

### PHASE 3: Alarm System Updates (Score Entry Logic)

#### Step 3.1: Update Alarm[9] Logic (Score Entry Detection)
**File**: `objects/oGameManager/Alarm_9.gml` (Complete rewrite)

**Current Implementation** (lines 1-94):
- Uses nested if statements to check scores
- Shifts scores manually using individual globals
- Places new score in appropriate position

**New Implementation** - Using struct and helper function:

```gml
/// @description High Score Entry Initialization
///
/// Triggered when level ends. Checks if player's score qualifies for high score table.
/// If so, initiates Enter_Initials mode and shifts scores as needed.

// Get high score status
var high_score_result = is_new_high_score(global.Game.Player.score);

if (high_score_result.is_high_score) {
    // === PLAYER ACHIEVED A HIGH SCORE ===

    // Set game mode to enter initials
    global.Game.State.mode = GameMode.ENTER_INITIALS;
    global.Game.State.results = 2;  // Start at character position 2 (0-indexed is 1)

    // Stop all sounds and prepare audio
    sound_stop_all();

    cyc = 1;  // Reset character cycle
    loop = 0; // Reset loop counter
    scored = high_score_result.position;  // Store which position they scored in (1-5)

    // === SHIFT SCORES DOWN THE TABLE ===
    // Shift all scores below the new score down by one position
    shift_scores_for_new_high_score(high_score_result.position, global.Game.Player.score);

    // === START AUDIO SEQUENCE ===
    if (high_score_result.position == 1) {
        // New #1 score - special fanfare
        sound_play(G1st15);
    } else {
        // Top 5 but not #1
        sound_loop(G2nd);
    }

    alarm[AlarmIndex.SCORE_ENTRY_ADVANCE] = 15;  // Timer for next phase

} else {
    // === NO HIGH SCORE ===
    // Return to title/attract mode
    global.Game.State.mode = GameMode.INITIALIZE;
    room_goto(TitleScreen);
}
```

**New Helper Function** - Add to `GameManager_STEP_FNs.gml`:

```gml
/// @function shift_scores_for_new_high_score
/// @description Shifts existing high scores down when a new score qualifies
///              Updates both scores and initials arrays
/// @param {number} position - Where new score ranks (1-5)
/// @param {number} new_score - The new score value
/// @return {undefined}
function shift_scores_for_new_high_score(position, new_score) {
    var idx = position - 1;  // Convert 1-based to 0-based

    // === SHIFT SCORES DOWN ===
    // Move positions (idx+1) through 4 down by one
    for (var i = 4; i > idx; i--) {
        global.Game.HighScores.scores[i] = global.Game.HighScores.scores[i - 1];
        global.Game.HighScores.initials[i] = global.Game.HighScores.initials[i - 1];
    }

    // === INSERT NEW SCORE ===
    global.Game.HighScores.scores[idx] = new_score;
    global.Game.HighScores.initials[idx] = "   ";  // Blank for entry

    // === SYNC DISPLAY ===
    global.Game.HighScores.display = global.Game.HighScores.scores[0];

    // === TEMPORARY LEGACY SYNC ===
    sync_legacy_highscores();
}
```

**Key Changes**:
1. Uses `is_new_high_score()` helper instead of manual comparison
2. Single `shift_scores_for_new_high_score()` call instead of nested if statements
3. Array-based operations (cleaner, less code duplication)
4. Stores position in `scored` variable for Enter_Initials reference
5. Proper sound selection based on position

---

### PHASE 4: Enter_Initials Refactoring (UI Input)

#### Step 4.1: Refactor Enter_Initials Function
**File**: `scripts/GameManager_STEP_FNs/GameManager_STEP_FNs.gml` (lines 161-245)

**Current Implementation**:
- Uses switch statement to update individual globals
- Accesses arrays `initials_array` and `scores_array` locally (good approach)
- Problem: Still writes to legacy `global.init1-5` variables

**New Implementation**:

```gml
/// @function Enter_Initials
/// @description Handles player input for entering initials on the high score screen
///              Allows navigation through character cycle and selection of characters
///              for high score name entry (3 characters per initial slot)
/// @return {undefined}
function Enter_Initials() {

    // === NAVIGATE LEFT THROUGH CHARACTER CYCLE ===
    if keyboard_check(vk_left) and alarm[AlarmIndex.INPUT_COOLDOWN] == -1 {
        cyc -= 1;  // Move to previous character
        if cyc <= 0 {
            cyc = string_length(cycle); // Wrap to last character
        }
        alarm[AlarmIndex.INPUT_COOLDOWN] = 10; // Input cooldown
    }

    // === NAVIGATE RIGHT THROUGH CHARACTER CYCLE ===
    if keyboard_check(vk_right) and alarm[AlarmIndex.INPUT_COOLDOWN] == -1 {
        cyc += 1; // Move to next character
        if cyc > string_length(cycle) {
            cyc = 1; // Wrap to first character
        }
        alarm[AlarmIndex.INPUT_COOLDOWN] = 10; // Input cooldown
    }

    // === SELECT CHARACTER (SPACE KEY) ===
    if keyboard_check_pressed(vk_space) and loop > 0 and global.Game.State.results < 5 {

        // Get new character from cycle string
        var _new_char = string_char_at(cycle, cyc);

        // Get the array index (scored is 1-based position, convert to 0-based)
        var pos_idx = scored - 1;

        // Get current initials string for this position
        var current_initials = global.Game.HighScores.initials[pos_idx];

        // Update character at current position (char tracks which of 3 characters we're editing)
        char = global.Game.State.results - 2;  // 0-based index (0, 1, or 2)
        current_initials = string_delete(current_initials, char + 1, 1);
        current_initials = string_insert(_new_char, current_initials, char + 1);

        // === UPDATE STRUCT ARRAY ===
        global.Game.HighScores.initials[pos_idx] = current_initials;

        // === MOVE TO NEXT CHARACTER OR FINALIZE ===
        global.Game.State.results += 1;
        cyc = 1;  // Reset character cycle

        if global.Game.State.results == 5 {
            // === ALL 3 CHARACTERS ENTERED ===

            // Get finalized initials and score for this position
            var final_initials = global.Game.HighScores.initials[pos_idx];
            var final_score = global.Game.HighScores.scores[pos_idx];

            // === SAVE TO GMSCOREBOARD ===
            // This persists the score to GMScoreboard backend
            set_score(final_initials, final_score);

            // === ADJUST TIMING ===
            // Speed up transitions if multiple players entered scores
            if loop == 1 {
                alarm[AlarmIndex.SCORE_ENTRY_ADVANCE] -= 2;
            }
            if loop == 2 {
                alarm[AlarmIndex.SCORE_ENTRY_ADVANCE] -= 1;
            }

            loop = 3; // Mark as post-entry phase

            // Longer delay before returning if multiple scorers
            if scored > 1 {
                alarm[AlarmIndex.SCORE_ENTRY_ADVANCE] = 120;
            }
        }

        // === TEMPORARY LEGACY SYNC ===
        sync_legacy_highscores();
    }
}
```

**Key Changes**:
1. Reads/writes directly to `global.Game.HighScores.initials[pos_idx]` (array-based)
2. No switch statement - cleaner, more maintainable
3. Uses `pos_idx` for clearer index management
4. Calls `sync_legacy_highscores()` after modification (temporary)
5. Better variable naming for clarity

---

### PHASE 5: Drawing and Display Updates

#### Step 5.1: Update Draw Functions to Use Struct
**File**: `scripts/Controller_draw_fns/Controller_draw_fns.gml`

**Function: Draw_Scores()** (lines 26-68) - Minimal change:

```gml
// NO CHANGES NEEDED - Already uses global.Game.Player.score for player score
// Just update comment to reference global.Game.HighScores.display instead of global.disp

// OLD (line 59):
// global.disp is updated from global.galaga1 (top score)

// NEW:
// global.Game.HighScores.display is synced to top score
```

**Function: Draw_Enter_Initials()** (lines 142-150+) - Needs significant update:

First, check what this function currently does by reading more lines:

```gml
// Get the current initials for display
function Draw_Enter_Initials() {
    draw_set_color(c_red);
    draw_text(64*global.Game.Display.scale, 96*global.Game.Display.scale,
              string_hash_to_newline("ENTER YOUR INITIALS "));
    draw_sprite_ext(spr_exc, 0, 384*global.Game.Display.scale, 96*global.Game.Display.scale,
                   1, 1, 0, c_red, 1);

    draw_set_color(c_aqua);

    // === DISPLAY INITIALS ===
    // Get the position being edited (scored = 1-5)
    var pos_idx = scored - 1;
    var current_initials = global.Game.HighScores.initials[pos_idx];

    // Calculate positions for 3 characters
    var base_x = 192 * global.Game.Display.scale;
    var base_y = 160 * global.Game.Display.scale;
    var char_spacing = 32 * global.Game.Display.scale;

    // Display each character
    for (var i = 0; i < 3; i++) {
        var char_to_draw = string_char_at(current_initials, i + 1);
        draw_text(base_x + (i * char_spacing), base_y,
                 string_hash_to_newline(char_to_draw));

        // Highlight the character being edited
        if (i == global.Game.State.results - 2) {
            draw_set_color(c_yellow);
            draw_text(base_x + (i * char_spacing) + 8, base_y - 8, "↑");
            draw_set_color(c_aqua);
        }
    }

    // Display score being entered
    draw_set_color(c_white);
    draw_text(64*global.Game.Display.scale, 256*global.Game.Display.scale,
             string_hash_to_newline("YOUR SCORE: " + string(global.Game.HighScores.scores[pos_idx])));
}
```

**Key Changes**:
1. Direct access to `global.Game.HighScores.initials[pos_idx]`
2. Use `global.Game.HighScores.scores[pos_idx]` for score display
3. Array-based character iteration
4. Better calculation for cursor position

---

### PHASE 6: High Score Table Display (Attract Mode)

#### Step 6.1: Update Attract Mode Display
**File**: `objects/oAttractMode/Draw_0.gml`

**Review and update** to use:
```gml
// Instead of:
// global.galaga1, global.init1, global.galaga2, global.init2, etc.

// Use:
for (var i = 0; i < 5; i++) {
    var score = global.Game.HighScores.scores[i];
    var initial = global.Game.HighScores.initials[i];
    var position = i + 1;

    // Draw high score table row
    draw_text(x, y + (i * row_height),
             string(position) + ". " + initial + " " + string(score));
}
```

---

### PHASE 7: HUD/UI Updates

#### Step 7.1: Update Hud.gml if Needed
**File**: `scripts/Hud/Hud.gml`

Search for any references to `global.galaga1-5` or `global.init1-5` and replace with struct access:

```gml
// Before: global.galaga1
// After: global.Game.HighScores.scores[0]

// Before: global.init1
// After: global.Game.HighScores.initials[0]

// Before: global.disp
// After: global.Game.HighScores.display
```

---

## Implementation Checklist

### Pre-Implementation
- [ ] Create backup of current codebase (git commit)
- [ ] Document current high score flow in code comments
- [ ] Run full game test suite

### Phase 1: Struct Extension
- [ ] Extend `global.Game.HighScores` struct in `init_globals()`
  - [ ] Add `scores` array
  - [ ] Add `initials` array
  - [ ] Add `display` property
  - [ ] Add `position` property
- [ ] Update struct initialization with default values

### Phase 2: Load and Sync Functions
- [ ] Rewrite `load_highscores()` with array-based logic
- [ ] Add `sync_legacy_highscores()` helper
- [ ] Add `get_high_score_at_position()` query function
- [ ] Add `get_high_score_initials_at_position()` query function
- [ ] Add `is_new_high_score()` validation function
- [ ] Test `load_highscores()` loads data correctly

### Phase 3: Alarm System
- [ ] Rewrite Alarm[9] in `oGameManager`
- [ ] Add `shift_scores_for_new_high_score()` helper
- [ ] Test score entry detection and shifting
- [ ] Verify audio cues play correctly

### Phase 4: Enter_Initials
- [ ] Refactor `Enter_Initials()` function
- [ ] Update character array access
- [ ] Test character input and cycling
- [ ] Verify initial entry works correctly
- [ ] Test `set_score()` persists to GMScoreboard

### Phase 5: Drawing Updates
- [ ] Update `Draw_Enter_Initials()` function
- [ ] Update `Draw_Scores()` function (review only)
- [ ] Test visual display of initials screen
- [ ] Test high score display in attract mode

### Phase 6: Attract Mode
- [ ] Update high score table display in `oAttractMode/Draw_0.gml`
- [ ] Test high score table formatting
- [ ] Verify scores display correctly

### Phase 7: HUD Updates
- [ ] Search and replace in `Hud.gml`
- [ ] Test all HUD elements display correctly

### Post-Implementation
- [ ] Run full game test:
  - [ ] Attract mode displays high scores correctly
  - [ ] Entering game and scoring works
  - [ ] High score detection works
  - [ ] Enter initials screen works
  - [ ] Scrolling through characters works
  - [ ] Completing initials saves to GMScoreboard
  - [ ] New game loads updated high scores
  - [ ] Multiple player entries work
- [ ] Remove legacy variable comments
- [ ] Remove sync calls (Phase 2 when complete)
- [ ] Final git commit

---

## Migration Timeline (Recommended)

1. **Week 1: Foundation** - Complete Phase 1 (struct extension)
2. **Week 1: Loading** - Complete Phase 2 (load/sync functions)
3. **Week 2: Logic** - Complete Phase 3-4 (Alarm and Enter_Initials)
4. **Week 2: Display** - Complete Phase 5-7 (UI updates)
5. **Week 3: Testing** - Comprehensive testing and bug fixes
6. **Week 3: Cleanup** - Remove legacy code and sync functions

---

## Testing Strategy

### Unit Tests (Per Function)
```gml
// Test is_new_high_score()
var result = is_new_high_score(100000);
assert(result.is_high_score == true);
assert(result.position >= 1 && result.position <= 5);

// Test get_high_score_at_position()
var score = get_high_score_at_position(1);
assert(score == global.Game.HighScores.scores[0]);

// Test shift_scores_for_new_high_score()
shift_scores_for_new_high_score(3, 50000);
assert(global.Game.HighScores.scores[2] == 50000);
assert(global.Game.HighScores.initials[2] == "   ");
```

### Integration Tests (Full Flow)
1. Start game in attract mode
2. Verify high score table displays correctly
3. Play until high score achieved
4. Verify Enter_Initials screen appears
5. Enter complete initials
6. Verify GMScoreboard persistence
7. Restart game and verify new scores loaded
8. Check high score table updated in attract mode

### Edge Cases
- Empty high score list
- All positions filled with same score
- Player score at boundary (exactly equal to 5th place)
- Single character initial
- Special characters (., space, etc.)

---

## Rollback Plan

If major issues arise during implementation:

1. **Stop all changes** at current phase
2. **Git revert** to last stable commit
3. **Analyze failure** against this guide
4. **Adjust approach** and retry specific phase
5. **Document lessons learned**

All changes are backwards compatible during migration period due to `sync_legacy_highscores()`.

---

## Future Enhancements

Once migration is complete:

1. **Remove legacy variables** (global.galaga1-5, global.init1-5)
2. **Remove sync_legacy_highscores()** function
3. **Add high score categories** (difficulty levels, game modes)
4. **Add achievement tracking** alongside scores
5. **Add detailed score statistics** (average, distribution, trends)
6. **Implement local persistence** backup system
7. **Add score validation** (checksum, tamper detection)

---

## Quick Reference: Variable Mapping

| Legacy | New Path | Type | Notes |
|--------|----------|------|-------|
| global.galaga1 | global.Game.HighScores.scores[0] | number | 1st place score |
| global.galaga2 | global.Game.HighScores.scores[1] | number | 2nd place score |
| global.galaga3 | global.Game.HighScores.scores[2] | number | 3rd place score |
| global.galaga4 | global.Game.HighScores.scores[3] | number | 4th place score |
| global.galaga5 | global.Game.HighScores.scores[4] | number | 5th place score |
| global.init1 | global.Game.HighScores.initials[0] | string | 1st place initials |
| global.init2 | global.Game.HighScores.initials[1] | string | 2nd place initials |
| global.init3 | global.Game.HighScores.initials[2] | string | 3rd place initials |
| global.init4 | global.Game.HighScores.initials[3] | string | 4th place initials |
| global.init5 | global.Game.HighScores.initials[4] | string | 5th place initials |
| global.disp | global.Game.HighScores.display | number | Displayed high score |
| scored (local var) | global.Game.HighScores.position | number | Current entry position |

---

## Key Design Principles

1. **Single Source of Truth**: GMScoreboard is the authoritative source
2. **Array-Based Access**: Eliminates code duplication (5 separate variables → 1 array)
3. **Gradual Migration**: Legacy sync allows phase-by-phase conversion
4. **Clear Ownership**: `global.Game.HighScores` owns high score data
5. **Defensive Access**: Helper functions validate array bounds
6. **Consistent Naming**: Clear distinction between 0-based arrays and 1-based positions

---

## Notes for Implementation

- All array indices are 0-based internally (0-4)
- All position references in Enter_Initials are 1-based (1-5)
- Conversion: `array_index = position - 1`, `position = array_index + 1`
- GMScoreboard ds_list is the source of truth for persistent storage
- struct array assignment creates new array, doesn't reference old one
- Performance: Single load_highscores() call per game start

---

**Document Version**: 1.0
**Last Updated**: 2025-11-09
**Status**: Ready for Implementation
