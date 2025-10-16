// DEBUG MODE
global.debug = false;

// room name
global.roomname = room_get_name(room);

// scale the system based on the mode ...
global.scale = 1;
if (global.roomname == "GalagaWars") {
	global.scale = 2;
}

// global variable to determine if we have applied the path scaler already
// ie on a game restart, we don't want to re-scale again all the path data
global.scalePath = false;

/// @section High Scores
// Global variables to store the top 5 high scores, initialized to 0.
// These are likely used to track and display the highest scores achieved by players.
global.galaga1 = 0; // First place high score.
global.galaga2 = 0; // Second place high score.
global.galaga3 = 0; // Third place high score.
global.galaga4 = 0; // Fourth place high score.
global.galaga5 = 0; // Fifth place high score.

/// @section Game Mechanics
// Flag to control sprite or screen flipping (0 = no flip, likely 1 = flip).
// Possibly used for visual effects or mirroring game elements (e.g., ship or enemy sprites).
global.flip = 0;
global.animationIndex = 0;

// Number of lives for Player 1, initialized to 3.
// Decremented when the player ship is destroyed; game over when it reaches 0.
global.p1lives = 0;

// Player 1's current score, initialized to 0.
// Incremented based on enemy hits or other scoring events.
global.p1score = 0;

// Displayed high score, initialized to 0.
// Likely used to show the current high score on the UI, updated if p1score exceeds it.
global.disp = 0;

// number of game credits (coins entered)
global.credits = 0;

global.shotcount = 0;
global.shottotal = 0;

/// @section High Score Initials
// Initials for the top 5 high scores, defaulting to two-letter placeholders.
// Used to display player initials alongside high scores in the high-score table.
global.init1 = "AA"; // Initials for first place.
global.init2 = "BB"; // Initials for second place.
global.init3 = "CC"; // Initials for third place.
global.init4 = "DD"; // Initials for fourth place.
global.init5 = "EE"; // Initials for fifth place;

/// @section Wave Progression
// Current wave or level of the game, initialized to 0.
// Incremented as the player progresses through enemy waves or stages.
global.wave = 0;
global.spawnCounter = 0;

/// @section Game State Flags
// Open flag, initialized to 0.
// Purpose unclear; possibly controls access to a menu, level, or mechanic.
global.open = 0;

global.ArcadeSprites = true;
global.ArcadeSpritesPrefix = "OG_";
global.enemy_animation_speed = 0;

// Current stage or level, initialized to 0.
// May track sub-levels within a wave or specific game phases.
global.stage = 0;

// Initial game mode, set to attract mode (demo mode).
// Controls whether the game is in gameplay, instructions, or demo state.
global.gameMode = GameMode.INITIALIZE;

/// @section Game Over
// Flag indicating game over state (0 = game active, 1 = game over).
// Set when the player's lives reach 0 and no regain is possible.
global.isGameOver = false;

// Initial position (off-screen to the right)
global.screen_width = view_get_wport(view_current);
global.screen_height = view_get_hport(view_current);

// is the Game Paused?
global.isGamePaused = false;

/// @description Initializes global variables, enums, and controller state for the space shooter game.
/// This script sets up the core game state, including scoring, lives, high scores, game modes, and other mechanics.
/// It is assumed to run in the Create event of a controller object that manages global game logic.

/// @section Data Structures
// Creates a data structure list to store dynamic game data.
// Likely used for tracking enemies, scores, or other temporary game elements.
list = ds_list_create();

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

/// @section Visual and Animation
// Cycle counter, initialized to 0.
// Possibly used for cycling through animations, patterns, or UI effects.
cyc = 0;

// Results flag, initialized to 0.
// Probably used to trigger the display of end-of-level or game-over results.
results = 0;

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

/// @section Extra Lives
// Score threshold for awarding the first extra life, set to 20,000 points.
// When global.p1score reaches this, an extra life is likely granted.
firstlife = 20000;

// Score threshold for additional extra lives, set to 70,000 points.
// Likely awards further lives at multiples of this value.
additional = 70000;

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

/// @section Game Mode Enum
// Enum defining the possible game modes for state management.
// Used to control whether the game is in attract mode (demo), showing instructions, or active gameplay.
enum GameMode {
	INITIALIZE = 0,
    ATTRACT_MODE,    // Demo mode, likely displaying AI-controlled gameplay or title screen.
    INSTRUCTIONS,    // Mode for showing game instructions or tutorial.
	GAME_PLAYER_MESSAGE,
	GAME_STAGE_MESSAGE,
	SPAWN_ENEMY_WAVES,
	GAME_READY,
    GAME_ACTIVE,        // Active gameplay mode where the player controls the ship.
	SHOW_RESULTS,
	ENTER_INITIALS,
	GAME_PAUSED
}

// grab a handle to the pause/unpause screen effect
// set the FX filter to a random color
layer_pause_fx = layer_get_fx("PauseEffect");
scrolling_nebula_bg = layer_get_id("ScrollingNebula");
//layer_set_visible(scrolling_nebula_bg, true);

attractMode = instance_create_layer(global.screen_width/2, global.screen_height - 48*global.scale, "GameSprites", oAttractMode);

spawn_data = load_enemy_waves("Patterns/wave_spawn.json");
				
// is the Game Paused?
//global.isGamePaused = false;

//window_set_fullscreen(false);
fullScreen = window_get_fullscreen();

// do we need to scale the path data (once ONLY)
if (!global.scalePath) {
	// for each path, rescale using the global.scale factor
	var _pathIds = asset_get_ids(asset_path);

	// Loop through the array and scale each path
	for (var i = 0; i < array_length(_pathIds); i++) {
	    path_rescale(_pathIds[i], global.scale, global.scale);
	}
	// we have scaled the path
	global.scalePath = true;
}

// pre-fetch sprite sheets (to avoid game glitches)
var _sprites_to_load = [sTieFighter, sTieIntercepter, sImperialShuttle, xwing_sprite_sheet, galagawars_logo];
sprite_prefetch_multi(_sprites_to_load);