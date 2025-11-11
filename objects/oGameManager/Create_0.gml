/// @description Initializes game controller, global variables, and game systems
/// This is the main initialization point for the entire game

/// @description Initializes global variables, enums, and controller state for the space shooter game.
/// This script sets up the core game state, including scoring, lives, high scores, game modes, and other mechanics.
/// It is assumed to run in the Create event of a controller object that manages global game logic.

//init_globals();

/// @section Counters
// General-purpose counter, initialized to 0.
// Could be used for timing, animation frames, or tracking events (context-dependent).
count = 0;

// Counter for tracking life-related events, initialized to 0.
// Possibly used to manage extra life awards or respawn timing.
lifecount = 0;

// Loop counter, initialized to 0.
// Likely used to control repeated actions, such as enemy spawning or wave cycles.
loop = 0;

/// @section Rank Display System
// Array to store rank display sprite information for draw event
// Each entry: { sprite_x, sprite_y, sprite_width, sprite_height, x_pos, y_pos }
rank_display_sprites = [];

/// @section Visual and Animation
// Cycle counter, initialized to 0.
// Possibly used for cycling through animations, patterns, or UI effects.
cyc = 0;

// Results flag, initialized to 0.
// Probably used to trigger the display of end-of-level or game-over results.
//results = 0;

// Flag to indicate progression to the next level, initialized to 0.
// Set to 1 when conditions are met to advance to the next wave or stage.
nextlevel = 0;

/// @section Miscellaneous
// Exhale flag, initialized to 0.
// Purpose unclear; possibly related to a visual or sound effect (e.g., boss animation).
exhale = 0;

// Skip flag, initialized to 0.
// Likely used to manage timing or skip certain actions (e.g., shot firing in double mode).
skip = 0;

/// @section Scoring and Hits
// Tracks the number of shots fired by the player, initialized to 0.
// Incremented each time a shot is fired for stats or mechanics.
fire = 0;

// Tracks the number of enemy hits by player shots, initialized to 0.
// Used for scoring or tracking player performance.
hits = 0;

/// @section Input and UI
// String of characters for high-score input, including letters, space, and period.
// Used for entering player initials in the high-score table.
cycle = "ABCDEFGHIJKLMNOPQRSTUVWXYZ .";

/// @section Rendering
// Sets the controller’s depth to -500, ensuring it renders above most game objects.
// Negative depth values in GameMaker indicate higher rendering priority.
depth = -500;

/// @section Additional Counters
// Alternate counter, initialized to 0.
// Could be used for toggling states, animations, or alternate behaviors.
alt = 0;

// Counters for unspecified purposes, initialized to 0.
// Likely used for tracking specific events or states (e.g., enemy waves or UI).
count1 = 0;
count2 = 0;

/// @section Rogue Mechanics
// Rogue flags, initialized to 0.
// Possibly related to special enemy behaviors or events (e.g., rogue enemies).
rogue1 = 0;
rogue2 = 0;

// Flag to indicate rogue behavior, initialized to 0.
// Likely enables or tracks a specific rogue-related mechanic.
rogueyes = 0;

scored = 0;

/// @section Score Display
// Hundreds digit for score or rank display, initialized to 0.
// Used for rendering individual digits in the UI.
hund = 0;

// Tens digit for score or rank display, initialized to 0.
// Part of the digit-based score or rank rendering system.
ten = 0;

// Ones digit for score or rank display, initialized to 0.
// Completes the digit-based display for scores or rankings.
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

/// @section UI and Visual Effects
// Blink counter, initialized to 0.
// used for blinking UI elements, such as score or lives display.
blink = 1;

global.isChallengeStage = false;
global.nLvls2ChallengeStage = 2;

// grab a handle to the pause/unpause screen effect
// set the FX filter to a random color
layer_pause_fx = layer_get_fx("PauseEffect");
scrolling_nebula_bg = layer_get_id("ScrollingNebula");
hue_value = [0.05, 0.1, 0.2, 0.3, 0.5, 0.75, 0.8, 0.97];

// Load game data files
spawn_data = load_json_datafile("Patterns/wave_spawn.json");
challenge_data = load_json_datafile("Patterns/challenge_spawn.json");
rogue_config = load_json_datafile("Patterns/rogue_spawn.json");
speed_curves = load_json_datafile("Patterns/speed_curve.json");
// Load formation coordinates once (optimization - shared by all enemies)
global.formation_data = load_json_datafile("Patterns/formation_coordinates.json");

// Load enemy attributes once (optimization - prevents loading per enemy instance)
global.enemy_attributes = {
    oTieFighter: load_json_datafile("Patterns/oTieFighter.json"),
    oTieIntercepter: load_json_datafile("Patterns/oTieIntercepter.json"),
    oImperialShuttle: load_json_datafile("Patterns/oImperialShuttle.json")
};
  
// Load game configuration
global.game_config = load_game_config();

//// Setup the GM Scoreboard using the unique game tag (loaded from config)
//var game_tag = get_config_value("HIGH_SCORES", "GAME_TAG", "fd0828983a329a0be9e26c34d892769b");
//setup_gmscoreboard(game_tag);

//// get the current set of high-scores
//get_scores(5);

//// Setup an alarm to refresh the high score table (using AlarmIndex enum)
//// Default: refresh every 5 minutes (300 seconds * 60 frames/second)
//var refresh_seconds = get_config_value("HIGH_SCORES", "REFRESH_INTERVAL_SECONDS", 300);
//alarm[AlarmIndex.HIGH_SCORE_REFRESH] = refresh_seconds * 60;

// check if we have a gamepad connected
useGamepad = false;

if (gamepad_is_connected(0)) {
	useGamepad = true;
}

//window_set_fullscreen(false);
fullScreen = window_get_fullscreen();

// pre-fetch sprite sheets (to avoid game glitches)
var _sprites_to_load = [sTieFighter, sTieIntercepter, sImperialShuttle, xwing_sprite_sheet, galagawars_logo];
sprite_prefetch_multi(_sprites_to_load);