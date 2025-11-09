// Initialize global.Game struct first (must happen before accessing any struct fields)
init_globals();

// room name
global.roomname = "GalagaWars"; //room_get_name(room);

// scale the system based on the mode ...
global.Game.Display.scale = 1;
if (global.roomname == "GalagaWars") {
	global.Game.Display.scale = 2;
}

/// @section Game Mode Enum
// Enum defining the possible game modes for state management.
// Used to control whether the game is in attract mode (demo), showing instructions, or active gameplay.
//enum GameMode {
//	INITIALIZE = 0,
//    ATTRACT_MODE,    // Demo mode, likely displaying AI-controlled gameplay or title screen.
//    INSTRUCTIONS,    // Mode for showing game instructions or tutorial.
//	GAME_PLAYER_MESSAGE,
//	GAME_STAGE_MESSAGE,
//	SPAWN_ENEMY_WAVES,
//	GAME_READY,
//    GAME_ACTIVE,        // Active gameplay mode where the player controls the ship.
//	SHOW_RESULTS,
//	ENTER_INITIALS,
//	CHALLENGE_STAGE_MESSAGE,
//	GAME_PAUSED
//}

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
global.Game.Player.lives = 3;

// Player 1's current score, initialized to 0.
// Incremented based on enemy hits or other scoring events.
global.Game.Player.score = 0;

// Displayed high score, initialized to 0.
// Likely used to show the current high score on the UI, updated if p1score exceeds it.
global.disp = 0;

// number of game credits (coins entered)
global.credits = 0;

global.Game.Player.shotCount = 0;
global.Game.Player.shotTotal = 0;

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
global.Game.Level.wave = 0;
global.spawnCounter = 0;

/// @section Game State Flags
// Open flag, initialized to 0.
// Purpose unclear; possibly controls access to a menu, level, or mechanic.
//global.open = 0;
global.Game.State.spawnOpen = 0;

global.enemy_animation_speed = 0;

// Current stage or level, initialized to 0.
// May track sub-levels within a wave or specific game phases.
global.Game.Level.stage = 0;

// Initial game mode, set to attract mode (demo mode).
// Controls whether the game is in gameplay, instructions, or demo state.
global.Game.State.mode = GameMode.INITIALIZE;

global.Game.Difficulty.speedMultiplier = 1.0;  // Base multiplier

/// @section Game Over
// Flag indicating game over state (0 = game active, 1 = game over).
// Set when the player's lives reach 0 and no regain is possible.
global.isGameOver = false;

// Initial position (off-screen to the right)
global.screen_width = view_get_wport(view_current);
global.screen_height = view_get_hport(view_current);

// is the Game Paused?
global.Game.State.isPaused = false;