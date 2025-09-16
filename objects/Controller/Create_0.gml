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

/// @section Game State Flags
// Open flag, initialized to 0.
// Purpose unclear; possibly controls access to a menu, level, or mechanic.
global.open = 0;

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