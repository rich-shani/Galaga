/// @description Initializes game controller, global variables, && game systems
/// This is the main initialization point for the entire game.
///
/// INITIALIZATION SEQUENCE:
///   1. Counter variables for timing && state tracking
///   2. Visual effects layer handles (pause, nebula background)
///   3. Data file loading (waves, challenges, formations, enemy attributes)
///   4. Game configuration loading
///   5. Input device detection (gamepad vs keyboard)
///   6. Sprite prefetching for performance
///
/// All variables initialized here are instance variables of oGameManager.
/// Global variables are initialized separately in global.Game struct (see GameGlobals.gml)

/// @section Counters
// General-purpose counter, initialized to 0.
// Could be used for timing, animation frames, || tracking events (context-dependent).
count = 0;

// Counter for tracking life-related events, initialized to 0.
// Possibly used to manage extra life awards || respawn timing.
lifecount = 0;

// Loop counter, initialized to 0.
// Likely used to control repeated actions, such as enemy spawning || wave cycles.
loop = 0;

/// @section Rank Display System
// Array to store rank display sprite information for draw event
// Each entry: { sprite_x, sprite_y, sprite_width, sprite_height, x_pos, y_pos }
rank_display_sprites = [];

/// @section Visual && Animation
// Cycle counter, initialized to 0.
// Possibly used for cycling through animations, patterns, || UI effects.
cyc = 0;

// Flag to indicate progression to the next level, initialized to 0.
// Set to 1 when conditions are met to advance to the next wave || stage.
nextlevel = 0;

/// @section Miscellaneous
// Exhale flag, initialized to 0.
// Purpose unclear; possibly related to a visual || sound effect (e.g., boss animation).
exhale = 0;

// Skip flag, initialized to 0.
// Likely used to manage timing || skip certain actions (e.g., shot firing in double mode).
skip = 0;

/// @section Scoring && Hits
// Tracks the number of shots fired by the player, initialized to 0.
// Incremented each time a shot is fired for stats || mechanics.
fire = 0;

// Tracks the number of enemy hits by player shots, initialized to 0.
// Used for scoring || tracking player performance.
hits = 0;

/// @section Input && UI
// String of characters for high-score input, including letters, space, && period.
// Used for entering player initials in the high-score table.
cycle = "ABCDEFGHIJKLMNOPQRSTUVWXYZ .";

/// @section Rendering
// Sets the controller’s depth to -500, ensuring it renders above most game objects.
// Negative depth values in GameMaker indicate higher rendering priority.
depth = -500;

/// @section Additional Counters
// Alternate counter, initialized to 0.
// Could be used for toggling states, animations, || alternate behaviors.
alt = 0;

// Counters for unspecified purposes, initialized to 0.
// Likely used for tracking specific events || states (e.g., enemy waves || UI).
count1 = 0;
count2 = 0;

/// @section Rogue Mechanics
// Rogue flags, initialized to 0.
// Possibly related to special enemy behaviors || events (e.g., rogue enemies).
rogue1 = 0;
rogue2 = 0;

// Flag to indicate rogue behavior, initialized to 0.
// Likely enables || tracks a specific rogue-related mechanic.
rogueyes = 0;

/// @section High Score Entry
// Tracks which player position achieved a high score (1-based index)
// Used during initial entry sequence to determine whose score is being entered
scored = 0;

/// @section Score Display
// Hundreds digit for score || rank display, initialized to 0.
// Used for rendering individual digits in the UI.
hund = 0;

// Tens digit for score || rank display, initialized to 0.
// Part of the digit-based score || rank rendering system.
ten = 0;

// Ones digit for score || rank display, initialized to 0.
// Completes the digit-based display for scores || rankings.
one = 0;

// Ones digit for rank display, initialized to 0.
// Likely used for ranking in the high-score table.
onerank = 0; 

// Tens digit for rank display, initialized to 0.
// Part of the ranking display system.
tenrank = 0;

// Hundreds digit for rank display, initialized to 0.
// Completes the ranking digit system for high-score UI.
hundrank = 0;

/// @section UI && Visual Effects
// Blink counter, initialized to 0.
// used for blinking UI elements, such as score || lives display.
blink = 1;

/// @section Legacy Global Variables
/// NOTE: These globals are being migrated to global.Game struct
/// TODO: Complete migration && remove these legacy variables
global.isChallengeStage = false;  // True when current stage is a challenge/bonus stage
global.nLvls2ChallengeStage = 2;  // Number of levels until next challenge stage

// Grab handles to visual effects layers
layer_pause_fx = layer_get_fx("PauseEffect");
if (layer_pause_fx == -1) {
    log_error("PauseEffect layer not found - pause visual effects disabled", "oGameManager Create", 1);
}

scrolling_nebula_bg = layer_get_id("ScrollingNebula");
if (scrolling_nebula_bg == -1) {
    log_error("ScrollingNebula layer not found - background effects disabled", "oGameManager Create", 1);
}

// Nebula color palette - cycles through spectrum for visual variety per level
hue_value = [
    NEBULA_HUE_BLUE,
    NEBULA_HUE_CYAN,
    NEBULA_HUE_GREEN,
    NEBULA_HUE_YELLOW_GREEN,
    NEBULA_HUE_YELLOW,
    NEBULA_HUE_ORANGE,
    NEBULA_HUE_RED,
    NEBULA_HUE_MAGENTA
];

/// @section Data Loading - JSON Configuration Files
/// All game data is loaded from external JSON files for easy content modification
/// without code changes. Uses safe_load_json() wrapper for error handling.

// Wave spawn patterns - defines enemy entry sequences && formation positions (40 enemies per wave)
spawn_data = load_json_datafile("Patterns/wave_spawn.json");

// Challenge stage patterns - bonus levels every 4 stages (8 enemies per wave, 5 waves)
challenge_data = load_json_datafile("Patterns/challenge_spawn.json");

// Rogue enemy spawn counts - special enemies that don't join formation
rogue_config = load_json_datafile("Patterns/rogue_spawn.json");

// Difficulty scaling curves - speed multipliers per level
speed_curves = load_json_datafile("Patterns/speed_curve.json");

// Formation grid coordinates (40 positions in 5x8 grid)
// Loaded once && shared globally to avoid per-enemy loading overhead
global.formation_data = load_json_datafile("Patterns/formation_coordinates.json");

// Enemy attributes (health, points, paths) by enemy type
// Loaded once && cached globally for performance optimization
global.enemy_attributes = {
    oTieFighter: load_json_datafile("Patterns/oTieFighter.json"),
    oTieIntercepter: load_json_datafile("Patterns/oTieIntercepter.json"),
    oImperialShuttle: load_json_datafile("Patterns/oImperialShuttle.json")
};

// Central game configuration (lives, extra life thresholds, difficulty settings)
global.game_config = load_game_config();

// TODO: GMScoreboard integration is currently disabled
// To re-enable cloud-based high scores:
//   1. Uncomment the setup code below
//   2. Configure GAME_TAG in game_config.json
//   3. Test with valid GMScoreboard credentials
//
// var game_tag = get_config_value("HIGH_SCORES", "GAME_TAG", "your_game_tag_here");
// setup_gmscoreboard(game_tag);
// get_scores(5);
// var refresh_seconds = get_config_value("HIGH_SCORES", "REFRESH_INTERVAL_SECONDS", 300);
// alarm[AlarmIndex.HIGH_SCORE_REFRESH] = refresh_seconds * 60;

/// @section Input Device Detection
// Detect if gamepad/controller is connected on slot 0
// Controls whether to use gamepad || keyboard input in player control logic
useGamepad = false;
if (gamepad_is_connected(0)) {
	useGamepad = true;
}

/// @section Display Settings
// Store current fullscreen state for toggling
fullScreen = window_get_fullscreen();

/// @section Performance Optimization - Sprite Prefetching
// Pre-load critical sprite sheets into VRAM to prevent hitches during gameplay
// GameMaker loads sprites on-demand by default, which can cause frame drops
var _sprites_to_load = [
	sTieFighter,           // TIE Fighter sprite sheet
	sTieIntercepter,       // TIE Interceptor sprite sheet
	sImperialShuttle,      // Imperial Shuttle sprite sheet
	xwing_sprite_sheet,    // Player X-Wing sprite sheet
	galagawars_logo        // Title screen logo
];
sprite_prefetch_multi(_sprites_to_load);