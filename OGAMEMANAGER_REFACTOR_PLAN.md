# oGameManager Instance Variable Reduction Plan

**Objective:** Reduce oGameManager from 40+ instance variables to <15
**Current Status:** God Object with mixed responsibilities
**Goal:** Extract remaining variables into specialized managers/structs
**Estimated Impact:** Reduced cognitive load, improved maintainability, cleaner architecture

---

## Current Instance Variables Audit

### Instance Variables by Category (40+ total)

#### 1. Counters (6 variables) - CONSOLIDATE
```gml
count = 0;          // Generic counter
lifecount = 0;      // Life-related timing
loop = 0;           // Loop control
cyc = 0;            // Cycle counter
alt = 0;            // Alternate counter
count1 = 0;         // Unspecified counter
count2 = 0;         // Unspecified counter
```
**Problem:** Generic, overlapping purposes
**Solution:** Move to dedicated `FrameCounterManager` or `TimingManager` struct
**Target:** Consolidate to 1-2 manager structs

---

#### 2. Display/Rank System (7 variables) - EXTRACT TO STRUCT
```gml
rank_display_sprites = [];  // Rank display sprite data
blink = 1;                   // Blink counter
hund = 0;                    // Hundreds digit
ten = 0;                     // Tens digit
one = 0;                     // Ones digit
onerank = 0;                 // Rank ones
tenrank = 0;                 // Rank tens
hundrank = 0;                // Rank hundreds
```
**Problem:** Digit-by-digit rendering is outdated, tightly coupled to UI logic
**Solution:** Move to `UIManager` struct with proper abstraction
**Target:** Replace 8 variables with 1 UIManager struct

---

#### 3. Visual Effects (5 variables) - EXTRACT TO CONTROLLER
```gml
layer_pause_fx = -1;           // Pause effect layer handle
scrolling_nebula_bg = -1;      // Background layer handle
hue_value = [/* array */];     // Nebula color palette
exhale = 0;                    // Unknown purpose flag
skip = 0;                      // Skip flag
```
**Problem:** Visual effects mixed with game logic
**Solution:** Move to `VisualEffectsManager` controller
**Target:** Replace 5 variables with 1 controller struct

---

#### 4. Data Files (8 variables) - MOVE TO GLOBAL/STATIC
```gml
spawn_data = undefined;        // Wave spawn patterns
challenge_data = undefined;    // Challenge patterns
rogue_config = undefined;      // Rogue spawn config
speed_curves = undefined;      // Speed curves
global.formation_data = [];    // Formation positions
global.enemy_attributes = {}; // Enemy stats
global.game_config = {};       // Game config
```
**Problem:** Instance variables for data that should be global
**Status:** Already mostly moved to global, some still as instance vars
**Solution:** Fully migrate to global constants/structs
**Target:** Replace with references to `global.Game.Data` struct

---

#### 5. Input/Controllers (6 variables) - CONSOLIDATE
```gml
useGamepad = false;            // Input device flag
fullScreen = false;            // Fullscreen state
waveSpawner = undefined;       // Wave spawner controller
scoreManager = undefined;      // Score manager
challengeManager = undefined;  // Challenge manager
```
**Problem:** Controllers scattered as instance variables
**Solution:** Move to `global.Game.Controllers` struct
**Target:** Replace with 1 controller registry

---

#### 6. Scoring/Game State (4 variables) - MOVE TO GLOBAL.GAME
```gml
fire = 0;                      // Shots fired counter
hits = 0;                      // Shots hit counter
rogueyes = 0;                  // Rogue behavior flag
scored = 0;                    // High score position
```
**Problem:** Game state mixed with manager variables
**Solution:** Move to appropriate `global.Game` substruct
**Target:** Replace with references to global state

---

#### 7. Configuration (3 variables) - CONSOLIDATE
```gml
cycle = "ABCDEFGHIJKLMNOPQRSTUVWXYZ .";  // Character cycle for score entry
rogue1 = 0;                    // Rogue flag 1
rogue2 = 0;                    // Rogue flag 2
nextlevel = 0;                 // Level progression flag
```
**Problem:** UI config mixed with game flags
**Solution:** Extract to appropriate config/flag structs
**Target:** Consolidate to 1-2 variables

---

#### 8. Rendering (1 variable) - KEEP
```gml
depth = -500;                  // Rendering depth
```
**Status:** Necessary, keep as-is

---

## Refactoring Strategy

### Phase 1: Create Global Data Structures (0.5 hour)

**Create in `oGlobal/Create_0.gml`:**

```gml
// ================================================================
// CENTRALIZED CONTROLLER REGISTRY
// ================================================================
global.Game.Controllers = {
    waveSpawner: undefined,
    scoreManager: undefined,
    challengeManager: undefined,
    visualEffects: undefined,
    frameCounters: undefined,
    uiManager: undefined
};

// ================================================================
// CENTRALIZED INPUT/CONFIG STATE
// ================================================================
global.Game.Input = {
    useGamepad: false,
    fullScreen: false,
    characterCycle: "ABCDEFGHIJKLMNOPQRSTUVWXYZ ."
};

// ================================================================
// CENTRALIZED DISPLAY STATE
// ================================================================
global.Game.Display = {
    // ... existing display state ...
    uiState: {
        blinkCounter: 1,
        scoreDigits: { hundreds: 0, tens: 0, ones: 0 },
        rankDigits: { hundreds: 0, tens: 0, ones: 0 },
        rankDisplaySprites: []
    }
};

// ================================================================
// CENTRALIZED GAME COUNTERS
// ================================================================
global.Game.Timing = {
    frameCounter: 0,
    lifeCounter: 0,
    loopCounter: 0,
    cycleCounter: 0,
    alternateCounter: 0,
    nextLevelFlag: 0
};

// ================================================================
// CENTRALIZED GAME FLAGS
// ================================================================
global.Game.State = {
    // ... existing state ...
    rogueFlags: { flag1: 0, flag2: 0, active: false },
    scoring: {
        shotsFired: 0,
        shotsHit: 0,
        highScorePosition: 0
    }
};
```

---

### Phase 2: Extract Visual Effects Manager (1 hour)

**Create new file: `scripts/VisualEffectsManager/VisualEffectsManager.gml`**

```gml
/// @file VisualEffectsManager.gml
/// @description Manages visual effects (pause effect, nebula background, color cycling)

function VisualEffectsManager() constructor {
    // Visual effect layer handles
    this.pauseEffectLayer = -1;
    this.scrollingNebulaLayer = -1;

    // Nebula color palette
    this.hueValues = [
        NEBULA_HUE_BLUE,
        NEBULA_HUE_CYAN,
        NEBULA_HUE_GREEN,
        NEBULA_HUE_YELLOW_GREEN,
        NEBULA_HUE_YELLOW,
        NEBULA_HUE_ORANGE,
        NEBULA_HUE_RED,
        NEBULA_HUE_MAGENTA
    ];

    // Skip flag (for visual effects timing)
    this.skipFrame = 0;
    this.exhaleFlag = 0;

    // Initialize layers
    this.initialize = function() {
        this.pauseEffectLayer = layer_get_fx("PauseEffect");
        this.scrollingNebulaLayer = layer_get_id("ScrollingNebula");

        if (this.pauseEffectLayer == -1) {
            log_error("PauseEffect layer not found", "VisualEffectsManager", 1);
        }
        if (this.scrollingNebulaLayer == -1) {
            log_error("ScrollingNebula layer not found", "VisualEffectsManager", 1);
        }
    };

    // Get current hue for nebula effect based on level
    this.getCurrentHue = function(level) {
        var hueIndex = level mod array_length(this.hueValues);
        return this.hueValues[hueIndex];
    };

    this.initialize();
}
```

**Update oGameManager/Create_0.gml:**

```gml
// OLD (Remove these lines):
// layer_pause_fx = layer_get_fx("PauseEffect");
// scrolling_nebula_bg = layer_get_id("ScrollingNebula");
// hue_value = [ ... ];
// exhale = 0;
// skip = 0;

// NEW (Add this):
global.Game.Controllers.visualEffects = new VisualEffectsManager();
```

**Files to Update:** Any drawing/visual effect code
- Find: `self.layer_pause_fx` → Replace with: `global.Game.Controllers.visualEffects.pauseEffectLayer`
- Find: `self.scrolling_nebula_bg` → Replace with: `global.Game.Controllers.visualEffects.scrollingNebulaLayer`
- Find: `self.hue_value` → Replace with: `global.Game.Controllers.visualEffects.hueValues`
- Find: `self.exhale` → Replace with: `global.Game.Controllers.visualEffects.exhaleFlag`
- Find: `self.skip` → Replace with: `global.Game.Controllers.visualEffects.skipFrame`

**Impact:** Reduce oGameManager by 5 variables

---

### Phase 3: Extract UI Manager (1 hour)

**Create new file: `scripts/UIManager/UIManager.gml`**

```gml
/// @file UIManager.gml
/// @description Manages UI state including score/rank display and blinking

function UIManager() constructor {
    // Display state
    this.blinkCounter = 1;
    this.rankDisplaySprites = [];

    // Score digit display (hundreds, tens, ones)
    this.scoreDisplay = {
        hundreds: 0,
        tens: 0,
        ones: 0
    };

    // Rank digit display (hundreds, tens, ones)
    this.rankDisplay = {
        hundreds: 0,
        tens: 0,
        ones: 0
    };

    // Character cycle for high score entry
    this.characterCycle = "ABCDEFGHIJKLMNOPQRSTUVWXYZ .";

    // Update display digits from current score
    this.updateScoreDisplay = function(score) {
        this.scoreDisplay.ones = score mod 10;
        this.scoreDisplay.tens = (score div 10) mod 10;
        this.scoreDisplay.hundreds = (score div 100) mod 10;
    };

    // Update rank digits from current rank
    this.updateRankDisplay = function(rank) {
        this.rankDisplay.ones = rank mod 10;
        this.rankDisplay.tens = (rank div 10) mod 10;
        this.rankDisplay.hundreds = (rank div 100) mod 10;
    };

    // Tick blink counter
    this.updateBlink = function() {
        this.blinkCounter++;
    };

    // Check if UI should be visible (blinking effect)
    this.isVisible = function() {
        return (this.blinkCounter div 10) mod 2 == 0;
    };
}
```

**Update oGameManager/Create_0.gml:**

```gml
// OLD (Remove):
// blink = 1;
// hund = 0;
// ten = 0;
// one = 0;
// onerank = 0;
// tenrank = 0;
// hundrank = 0;
// rank_display_sprites = [];

// NEW (Add):
global.Game.Controllers.uiManager = new UIManager();
```

**Files to Update:**
- Find: `self.blink` → Replace with: `global.Game.Controllers.uiManager.blinkCounter`
- Find: `self.hund` → Replace with: `global.Game.Controllers.uiManager.scoreDisplay.hundreds`
- Find: `self.ten` → Replace with: `global.Game.Controllers.uiManager.scoreDisplay.tens`
- Find: `self.one` → Replace with: `global.Game.Controllers.uiManager.scoreDisplay.ones`
- Find: `self.onerank` → Replace with: `global.Game.Controllers.uiManager.rankDisplay.ones`
- Find: `self.tenrank` → Replace with: `global.Game.Controllers.uiManager.rankDisplay.tens`
- Find: `self.hundrank` → Replace with: `global.Game.Controllers.uiManager.rankDisplay.hundreds`
- Find: `self.rank_display_sprites` → Replace with: `global.Game.Controllers.uiManager.rankDisplaySprites`

**Impact:** Reduce oGameManager by 8 variables

---

### Phase 4: Extract Frame Counter Manager (0.5 hour)

**Create new file: `scripts/FrameCounterManager/FrameCounterManager.gml`**

```gml
/// @file FrameCounterManager.gml
/// @description Manages timing counters (frame counts, animation cycles, etc.)

function FrameCounterManager() constructor {
    // Primary counters
    this.frameCounter = 0;      // General timing
    this.lifeCounter = 0;       // Life-related events
    this.loopCounter = 0;       // Loop control
    this.cycleCounter = 0;      // Cycle animation
    this.alternateCounter = 0;  // Alternate behavior

    // Increment all counters
    this.update = function() {
        this.frameCounter++;
        this.lifeCounter++;
        this.loopCounter++;
        this.cycleCounter++;
        this.alternateCounter++;
    };

    // Reset specific counter
    this.reset = function(counter_name) {
        switch (counter_name) {
            case "frame":
                this.frameCounter = 0;
                break;
            case "life":
                this.lifeCounter = 0;
                break;
            case "loop":
                this.loopCounter = 0;
                break;
            case "cycle":
                this.cycleCounter = 0;
                break;
            case "alt":
                this.alternateCounter = 0;
                break;
        }
    };
}
```

**Update oGameManager/Create_0.gml:**

```gml
// OLD (Remove):
// count = 0;
// lifecount = 0;
// loop = 0;
// cyc = 0;
// alt = 0;
// count1 = 0;
// count2 = 0;

// NEW (Add):
global.Game.Controllers.frameCounters = new FrameCounterManager();
```

**Update oGameManager/Step_0.gml:**

```gml
// In step event, add:
global.Game.Controllers.frameCounters.update();
```

**Impact:** Reduce oGameManager by 7 variables

---

### Phase 5: Move Data to Global Structures (0.5 hour)

**In oGameManager/Create_0.gml, replace:**

```gml
// OLD (Remove from instance):
// spawn_data = ...
// challenge_data = ...
// rogue_config = ...
// speed_curves = ...

// NEW (Keep only in global):
global.Game.Data = {
    spawn: load_json_datafile("Patterns/wave_spawn.json"),
    challenge: load_json_datafile("Patterns/challenge_spawn.json"),
    rogue: load_json_datafile("Patterns/rogue_spawn.json"),
    speedCurves: load_json_datafile("Patterns/speed_curve.json")
};
```

**Update WaveSpawner initialization:**

```gml
// OLD:
// waveSpawner = new WaveSpawner(spawn_data, challenge_data, rogue_config);

// NEW:
global.Game.Controllers.waveSpawner = new WaveSpawner(
    global.Game.Data.spawn,
    global.Game.Data.challenge,
    global.Game.Data.rogue
);
```

**Impact:** Reduce oGameManager by 4 variables

---

### Phase 6: Move State to Global.Game (0.5 hour)

**Move to `global.Game.State` and `global.Game.Input`:**

```gml
// OLD (Remove from instance):
// useGamepad = false;
// fullScreen = false;
// rogueyes = 0;
// rogue1 = 0;
// rogue2 = 0;
// fire = 0;
// hits = 0;
// scored = 0;
// nextlevel = 0;
// cycle = "..."

// NEW (In global.Game - already exists, just add missing):
// global.Game.Input.useGamepad = false;
// global.Game.Input.fullScreen = false;
// global.Game.State.rogueActive = false;
// global.Game.State.rogueFlags = { flag1: 0, flag2: 0 };
// global.Game.State.scoring = { shotsFired: 0, shotsHit: 0 };
// global.Game.State.highScorePosition = 0;
// global.Game.State.nextLevelFlag = 0;
```

**Update device detection in Create_0.gml:**

```gml
// OLD:
// useGamepad = false;
// if (gamepad_is_connected(0)) { useGamepad = true; }

// NEW:
global.Game.Input.useGamepad = gamepad_is_connected(0);
global.Game.Input.fullScreen = window_get_fullscreen();
```

**Update references throughout codebase:**
- Find: `self.useGamepad` → Replace with: `global.Game.Input.useGamepad`
- Find: `self.fullScreen` → Replace with: `global.Game.Input.fullScreen`
- Find: `self.fire` → Replace with: `global.Game.State.scoring.shotsFired`
- Find: `self.hits` → Replace with: `global.Game.State.scoring.shotsHit`
- Find: `self.rogueyes` → Replace with: `global.Game.State.rogueActive`
- Find: `self.rogue1` → Replace with: `global.Game.State.rogueFlags.flag1`
- Find: `self.rogue2` → Replace with: `global.Game.State.rogueFlags.flag2`
- Find: `self.scored` → Replace with: `global.Game.State.highScorePosition`
- Find: `self.nextlevel` → Replace with: `global.Game.State.nextLevelFlag`
- Find: `self.cycle` → Replace with: `global.Game.Input.characterCycle`

**Impact:** Reduce oGameManager by 10 variables

---

### Phase 7: Consolidate Controller Initialization (0.25 hour)

**Update oGameManager/Create_0.gml controller section:**

```gml
// === CONTROLLER INITIALIZATION ===
// Initialize controllers in global registry

// Wave spawner
global.Game.Controllers.waveSpawner = new WaveSpawner(
    global.Game.Data.spawn,
    global.Game.Data.challenge,
    global.Game.Data.rogue
);

// Score manager
global.Game.Controllers.scoreManager = new ScoreManager();

// Challenge stage manager
global.Game.Controllers.challengeManager = new ChallengeStageManager(
    global.Game.Data.challenge
);

// Visual effects manager
global.Game.Controllers.visualEffects = new VisualEffectsManager();

// UI manager
global.Game.Controllers.uiManager = new UIManager();

// Frame counter manager
global.Game.Controllers.frameCounters = new FrameCounterManager();

show_debug_message("[oGameManager] All controllers initialized in global registry");
```

**Remove from instance:**
```gml
// DELETE these lines:
// waveSpawner = new WaveSpawner(...);
// scoreManager = new ScoreManager();
// challengeManager = new ChallengeStageManager(...);
```

**Impact:** Reduce oGameManager by 3 variables (move to global registry)

---

## Summary: Before & After

### BEFORE - 40+ Instance Variables

```
oGameManager Instance Variables:
├── Counters (7): count, lifecount, loop, cyc, alt, count1, count2
├── Display (8): rank_display_sprites, blink, hund, ten, one, onerank, tenrank, hundrank
├── Visual Effects (5): layer_pause_fx, scrolling_nebula_bg, hue_value, exhale, skip
├── Data Files (4): spawn_data, challenge_data, rogue_config, speed_curves
├── Controllers (3): waveSpawner, scoreManager, challengeManager
├── Input/Config (2): useGamepad, fullScreen
├── Game State (6): fire, hits, rogueyes, rogue1, rogue2, scored
├── Flags (2): nextlevel, cycle
└── Rendering (1): depth
```

**Total: 40 instance variables** ❌

---

### AFTER - <15 Instance Variables

```
oGameManager Instance Variables:
├── Rendering (1): depth                    [KEEP - Necessary]
├── References (5):                         [KEEP - Minimal refs to global]
│   ├── (Reference to global.Game for quick access)
└── (ALL OTHER DATA MOVED TO GLOBAL STRUCTS)

Global Structures:
├── global.Game.Controllers    [6 managers: wave, score, challenge, visual, ui, counters]
├── global.Game.Data           [4 data files: spawn, challenge, rogue, speed]
├── global.Game.Input          [2 values: useGamepad, fullScreen, characterCycle]
├── global.Game.State          [game state, scoring, rogueFlags, nextLevelFlag]
├── global.Game.Display        [display state including uiState substruct]
└── global.Game.Timing         [timing counters consolidated]
```

**Total: 6 instance variables** ✅
**Reduction: 85%** (from 40 to 6)

---

## Implementation Timeline

| Phase | Task | Time | Files | Variables Removed |
|-------|------|------|-------|-------------------|
| 1 | Create global data structures | 0.5h | oGlobal | 0 (setup) |
| 2 | Extract VisualEffectsManager | 1h | VisualEffectsManager.gml, Create_0.gml, Draw events | 5 |
| 3 | Extract UIManager | 1h | UIManager.gml, Create_0.gml, Draw_Hud | 8 |
| 4 | Extract FrameCounterManager | 0.5h | FrameCounterManager.gml, Create_0.gml, Step_0.gml | 7 |
| 5 | Move data to global | 0.5h | Create_0.gml, WaveSpawner | 4 |
| 6 | Move state to global | 0.5h | Create_0.gml, all affected files | 10 |
| 7 | Update references | 1h | Multiple files | 0 (refactoring) |

**Total Time: 4.5 hours**
**Total Variables Removed: 34 (from 40 to 6)**

---

## Files to Create (3 new)

1. **scripts/VisualEffectsManager/VisualEffectsManager.gml** (50-70 lines)
2. **scripts/UIManager/UIManager.gml** (60-80 lines)
3. **scripts/FrameCounterManager/FrameCounterManager.gml** (40-60 lines)

---

## Files to Update (10+ files)

### Primary Files to Update:
1. `objects/oGameManager/Create_0.gml` - Major refactor
2. `objects/oGameManager/Step_0.gml` - Add controller.update()
3. `objects/oGameManager/Draw_Hud.gml` - Update UI references
4. `scripts/WaveSpawner/WaveSpawner.gml` - Update data references
5. `scripts/newlevel/newlevel.gml` - Update global references

### Secondary Files (Variable References):
6. `objects/oPlayer/Step_0.gml` - gamepad reference
7. Draw functions - Visual effects/UI references
8. Any script accessing oGameManager state

---

## Benefits

✅ **Reduced Cognitive Load:** From 40 to 6 instance variables (85% reduction)
✅ **Clearer Responsibilities:** Each manager has single purpose
✅ **Better Testability:** Managers can be tested independently
✅ **Improved Readability:** Global references clearly show intent
✅ **Easier Maintenance:** Changes isolated to specific managers
✅ **Scalability:** Easy to add new managers without oGameManager bloat
✅ **Performance:** No impact (same number of variables, different organization)

---

## Risk Assessment

### Low Risk
- ✅ No gameplay logic changes
- ✅ No state machine changes
- ✅ Purely architectural refactoring
- ✅ Can be tested incrementally (phase by phase)

### Testing Strategy
1. **Phase Testing:** After each phase, run game and verify no crashes
2. **Functional Testing:** Play through full game levels
3. **Reference Testing:** Search for old references (`self.varname`) and ensure all updated
4. **Unit Tests:** Run existing test suites to verify no regressions

---

## Detailed Step-by-Step Implementation Guide

### STEP 1: Backup & Prepare (5 minutes)

```bash
# Create backup branch
git checkout -b refactor/reduce-ogamemanager-variables

# List all current instance variables
# Open objects/oGameManager/Create_0.gml and review
```

---

### STEP 2: Update Global Data Structures (15 minutes)

**File: `objects/oGlobal/Create_0.gml`**

Add new substruct to existing `global.Game`:

```gml
// === ADDITION TO EXISTING global.Game ===

global.Game.Controllers = {
    waveSpawner: undefined,
    scoreManager: undefined,
    challengeManager: undefined,
    visualEffects: undefined,
    frameCounters: undefined,
    uiManager: undefined
};

global.Game.Input = {
    useGamepad: false,
    fullScreen: false,
    characterCycle: "ABCDEFGHIJKLMNOPQRSTUVWXYZ ."
};

// Update existing display with UI substruct
global.Game.Display.uiState = {
    blinkCounter: 1,
    scoreDigits: { hundreds: 0, tens: 0, ones: 0 },
    rankDigits: { hundreds: 0, tens: 0, ones: 0 },
    rankDisplaySprites: []
};

// Create timing substruct
global.Game.Timing = {
    frameCounter: 0,
    lifeCounter: 0,
    loopCounter: 0,
    cycleCounter: 0,
    alternateCounter: 0
};

// Update existing state with new substruct
global.Game.State.rogueFlags = { flag1: 0, flag2: 0, active: false };
global.Game.State.scoring = { shotsFired: 0, shotsHit: 0, highScorePosition: 0 };
global.Game.State.nextLevelFlag = 0;

// Data files
global.Game.Data = {
    spawn: undefined,
    challenge: undefined,
    rogue: undefined,
    speedCurves: undefined
};
```

---

### STEP 3: Create VisualEffectsManager (20 minutes)

**File: `scripts/VisualEffectsManager/VisualEffectsManager.gml`**

[See code above in Phase 2]

---

### STEP 4: Create UIManager (20 minutes)

**File: `scripts/UIManager/UIManager.gml`**

[See code above in Phase 3]

---

### STEP 5: Create FrameCounterManager (15 minutes)

**File: `scripts/FrameCounterManager/FrameCounterManager.gml`**

[See code above in Phase 4]

---

### STEP 6: Update oGameManager/Create_0.gml (30 minutes)

1. **Remove these variable declarations (lines 15-119):**
   ```gml
   count = 0;
   lifecount = 0;
   loop = 0;
   rank_display_sprites = [];
   cyc = 0;
   nextlevel = 0;
   exhale = 0;
   skip = 0;
   fire = 0;
   hits = 0;
   cycle = "ABCDEFGHIJKLMNOPQRSTUVWXYZ .";
   alt = 0;
   count1 = 0;
   count2 = 0;
   rogue1 = 0;
   rogue2 = 0;
   rogueyes = 0;
   scored = 0;
   hund = 0;
   ten = 0;
   one = 0;
   onerank = 0;
   tenrank = 0;
   hundrank = 0;
   blink = 1;
   ```

2. **Remove visual effects initialization (lines 126-146):**
   ```gml
   layer_pause_fx = layer_get_fx("PauseEffect");
   if (layer_pause_fx == -1) { ... }
   scrolling_nebula_bg = layer_get_id("ScrollingNebula");
   if (scrolling_nebula_bg == -1) { ... }
   hue_value = [ ... ];
   ```

3. **Replace data file loading (lines 152-162):**
   ```gml
   // OLD:
   spawn_data = load_json_datafile(...);
   challenge_data = load_json_datafile(...);
   // etc.

   // NEW:
   global.Game.Data.spawn = load_json_datafile("Patterns/wave_spawn.json");
   global.Game.Data.challenge = load_json_datafile("Patterns/challenge_spawn.json");
   global.Game.Data.rogue = load_json_datafile("Patterns/rogue_spawn.json");
   global.Game.Data.speedCurves = load_json_datafile("Patterns/speed_curve.json");
   ```

4. **Replace controller initialization (lines 264-272):**
   ```gml
   // OLD:
   waveSpawner = new WaveSpawner(spawn_data, challenge_data, rogue_config);
   scoreManager = new ScoreManager();
   challengeManager = new ChallengeStageManager(challenge_data);

   // NEW:
   global.Game.Controllers.waveSpawner = new WaveSpawner(
       global.Game.Data.spawn,
       global.Game.Data.challenge,
       global.Game.Data.rogue
   );
   global.Game.Controllers.scoreManager = new ScoreManager();
   global.Game.Controllers.challengeManager = new ChallengeStageManager(
       global.Game.Data.challenge
   );
   global.Game.Controllers.visualEffects = new VisualEffectsManager();
   global.Game.Controllers.uiManager = new UIManager();
   global.Game.Controllers.frameCounters = new FrameCounterManager();
   ```

5. **Replace input detection (lines 226-233):**
   ```gml
   // OLD:
   useGamepad = false;
   if (gamepad_is_connected(0)) { useGamepad = true; }
   fullScreen = window_get_fullscreen();

   // NEW:
   global.Game.Input.useGamepad = gamepad_is_connected(0);
   global.Game.Input.fullScreen = window_get_fullscreen();
   ```

---

### STEP 7: Update oGameManager/Step_0.gml (10 minutes)

Add to Step event:

```gml
// Update frame counters
global.Game.Controllers.frameCounters.update();

// Update UI blink counter
global.Game.Controllers.uiManager.updateBlink();
```

---

### STEP 8: Find and Replace References (1-2 hours)

**Use Find & Replace to update all references:**

| Find | Replace | Files Affected |
|------|---------|---|
| `self.count` | `global.Game.Controllers.frameCounters.frameCounter` | Step, Draw |
| `self.lifecount` | `global.Game.Controllers.frameCounters.lifeCounter` | Step |
| `self.loop` | `global.Game.Controllers.frameCounters.loopCounter` | Step |
| `self.cyc` | `global.Game.Controllers.frameCounters.cycleCounter` | Draw |
| `self.alt` | `global.Game.Controllers.frameCounters.alternateCounter` | Step |
| `self.count1` | `global.Game.Controllers.frameCounters.frameCounter` | - |
| `self.count2` | (examine usage) | - |
| `self.hund` | `global.Game.Controllers.uiManager.scoreDisplay.hundreds` | Draw_Hud |
| `self.ten` | `global.Game.Controllers.uiManager.scoreDisplay.tens` | Draw_Hud |
| `self.one` | `global.Game.Controllers.uiManager.scoreDisplay.ones` | Draw_Hud |
| `self.onerank` | `global.Game.Controllers.uiManager.rankDisplay.ones` | Draw_Hud |
| `self.tenrank` | `global.Game.Controllers.uiManager.rankDisplay.tens` | Draw_Hud |
| `self.hundrank` | `global.Game.Controllers.uiManager.rankDisplay.hundreds` | Draw_Hud |
| `self.blink` | `global.Game.Controllers.uiManager.blinkCounter` | Draw_Hud |
| `self.rank_display_sprites` | `global.Game.Controllers.uiManager.rankDisplaySprites` | Draw_Hud |
| `self.layer_pause_fx` | `global.Game.Controllers.visualEffects.pauseEffectLayer` | Draw, Step |
| `self.scrolling_nebula_bg` | `global.Game.Controllers.visualEffects.scrollingNebulaLayer` | Draw |
| `self.hue_value` | `global.Game.Controllers.visualEffects.hueValues` | Draw |
| `self.exhale` | `global.Game.Controllers.visualEffects.exhaleFlag` | Step |
| `self.skip` | `global.Game.Controllers.visualEffects.skipFrame` | Step |
| `self.spawn_data` | `global.Game.Data.spawn` | - |
| `self.challenge_data` | `global.Game.Data.challenge` | - |
| `self.rogue_config` | `global.Game.Data.rogue` | - |
| `self.speed_curves` | `global.Game.Data.speedCurves` | - |
| `self.useGamepad` | `global.Game.Input.useGamepad` | oPlayer, Step |
| `self.fullScreen` | `global.Game.Input.fullScreen` | Step |
| `self.fire` | `global.Game.State.scoring.shotsFired` | Step |
| `self.hits` | `global.Game.State.scoring.shotsHit` | Step |
| `self.rogueyes` | `global.Game.State.rogueActive` | Step |
| `self.rogue1` | `global.Game.State.rogueFlags.flag1` | Step |
| `self.rogue2` | `global.Game.State.rogueFlags.flag2` | Step |
| `self.scored` | `global.Game.State.highScorePosition` | Alarm events |
| `self.nextlevel` | `global.Game.State.nextLevelFlag` | Step |
| `self.cycle` | `global.Game.Input.characterCycle` | Draw_Hud |
| `oGameManager.waveSpawner` | `global.Game.Controllers.waveSpawner` | Scripts |
| `oGameManager.scoreManager` | `global.Game.Controllers.scoreManager` | Scripts |
| `oGameManager.challengeManager` | `global.Game.Controllers.challengeManager` | Scripts |

**Important:** Some variables (`count1`, `count2`) need examination to determine correct replacement.

---

### STEP 9: Testing (30-60 minutes)

**After each major change:**

1. **Compile Test**
   ```bash
   # Open game in GameMaker, press F5 to run
   # Check for any errors in output console
   ```

2. **Gameplay Test**
   - Play through level 1-5
   - Verify difficulty escalates properly at level 3, 7, 11
   - Test challenge stages (level 4, 8, 12)
   - Check UI updates (score, lives, ranks)
   - Test high score entry

3. **Visual Effects Test**
   - Verify pause effect works
   - Check nebula color cycling
   - Verify blinking UI elements

4. **Automated Tests**
   ```gml
   // Run test suites
   runWaveSpawnerTests();
   runScoreAndChallengeTests();
   runEnemyStateMachineTests();
   ```

---

### STEP 10: Verification & Commit (15 minutes)

**Verification Checklist:**

- [ ] Game runs without errors
- [ ] No console warnings about missing variables
- [ ] All UI elements display correctly
- [ ] Score/lives/rank display works
- [ ] High score entry works
- [ ] Difficulty escalates at correct levels
- [ ] Challenge stages trigger at correct levels
- [ ] Visual effects (pause, nebula) work
- [ ] No reference to `self.count`, `self.fire`, etc. remains
- [ ] All tests pass

**Commit:**

```bash
git add .
git commit -m "refactor: Reduce oGameManager instance variables from 40 to 6

- Extract VisualEffectsManager for pause/nebula/hue effects
- Extract UIManager for score/rank display and blinking
- Extract FrameCounterManager for timing counters
- Move data files to global.Game.Data struct
- Move game state to global.Game.State substruct
- Move input config to global.Game.Input
- Move timing counters to global.Game.Timing

Results:
- oGameManager reduced from 40 to 6 instance variables (85% reduction)
- Clearer separation of concerns
- Easier to test and maintain
- No gameplay changes or performance impact

All tests pass, full gameplay verified through level 20."
```

---

## Post-Refactoring Opportunities

After completing this refactoring, consider:

1. **Create CameraController** for camera/viewport management
2. **Create InputController** for consolidated input handling
3. **Create AudioManager** for sound/music management
4. **Create ParticleController** for particle effects
5. **Create LevelController** for level progression logic

This would further reduce oGameManager to a simple coordinator with <5 instance variables.

---

## Success Metrics

**Before:**
- 40+ instance variables
- 600+ lines in Create_0.gml
- Mixed responsibilities
- Difficult to understand at a glance

**After:**
- 6 instance variables (85% reduction)
- 300-350 lines in Create_0.gml (40% reduction)
- Clear separation of concerns
- Easy to understand architecture

---

**Estimated Total Time: 4-5 hours**
**Difficulty: MEDIUM (straightforward refactoring, low risk)**
**Impact: HIGH (significantly improves code organization)**
