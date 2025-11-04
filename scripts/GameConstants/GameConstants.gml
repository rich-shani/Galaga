/// @file GameConstants.gml
/// @description Defines game-wide constants, enums, and configuration macros
/// @author Galaga Wars Team

// ====================================================================================
// ENUMS
// ====================================================================================

/// @enum GameMode
/// @description Defines the possible game states/modes
/// Game mode states are already defined elsewhere, keeping reference here for documentation
 enum GameMode {
     INITIALIZE = 0,
     ATTRACT_MODE,
     INSTRUCTIONS,
     GAME_PLAYER_MESSAGE,
     GAME_STAGE_MESSAGE,
     SPAWN_ENEMY_WAVES,
     GAME_READY,
     GAME_ACTIVE,
     SHOW_RESULTS,
     ENTER_INITIALS,
     CHALLENGE_STAGE_MESSAGE,
     GAME_PAUSED
 }

/// @enum EnemyState
/// @description Enemy behavior states
/// Already defined in oEnemyBase/Create_0.gml - reference only
 enum EnemyState {
     ENTER_SCREEN,
     MOVE_INTO_FORMATION,
     IN_FORMATION,
	 RETURN_PATH,
     IN_DIVE_ATTACK,
     IN_LOOP_ATTACK,
     IN_FINAL_ATTACK
 }

/// @enum EnemyMode
/// @description Enemy spawn mode types
/// Already defined in oEnemyBase/Create_0.gml - reference only
 enum EnemyMode {
     STANDARD,
     CHALLENGE,
     ROGUE
 }

/// @enum ShipState
/// @description Player ship states
/// Already defined in oPlayer/Create_0.gml as _ShipState - reference only
 enum _ShipState {
     ACTIVE,
     CAPTURED,
     RELEASING,
     DEAD,
     RESPAWN
 }

/// @enum AlarmIndex
/// @description Named indices for alarm events in oGameManager
/// Makes alarm usage more readable and maintainable
enum AlarmIndex {
    PROHIBIT_RESET = 0,         // Resets global.prohib flag after dive attacks
    RANK_UPDATE = 1,            // Controls rank digit display timing
    SPAWN_DELAY = 2,            // Delays between enemy spawns
    HIGH_SCORE_REFRESH = 3,     // Periodic high score table refresh (5 minutes)
    // UNUSED_4 = 4,            // Available
    // UNUSED_5 = 5,            // Available
    INPUT_COOLDOWN = 6,         // Cooldown for initial entry navigation
    SCORE_ENTRY_ADVANCE = 7,    // Advances to next scorer in initial entry
    FORMATION_COUNTDOWN = 8,    // Formation setup countdown
    // UNUSED_9 = 9,            // Available
    LEVEL_ADVANCE = 10,         // Level progression and cleanup
    SPAWN_FORMATION_TIMER = 11  // Initial spawn/formation setup timer
}

/// @enum EnemyAlarmIndex
/// @description Named indices for alarm events in enemy objects
enum EnemyAlarmIndex {
    FORMATION_ROTATION = 0,     // Rotates enemy sprite to face down in formation
    SHOT_TIMER = 1,             // Controls enemy shooting timing
    DIVE_ATTACK = 2,            // Initiates dive attack behavior
    // UNUSED_3 = 3,            // Available
    // UNUSED_4 = 4,            // Available
    DIVE_SETUP = 5              // Sets up initial dive timing
}

/// @enum PlayerAlarmIndex
/// @description Named indices for alarm events in player ship
enum PlayerAlarmIndex {
    DEATH_SHAKE = 0,            // Screen shake effect duration
    RESPAWN = 1,                // Respawn timer after death
    // UNUSED_2 TO 9 = 2-9,     // Available
    GAME_OVER_CLEANUP = 10,     // Cleanup when game ends
    // UNUSED_11 = 11           // Available
}

// ====================================================================================
// MACROS - ENEMY CONSTANTS
// ====================================================================================

///// @macro ENEMY_BASE_SPEED
///// @description Base movement speed for enemies in pixels per step
#macro ENEMY_BASE_SPEED 6

///// @macro ENEMY_ENTRANCE_SPEED_MULTIPLIER
///// @description Multiplier applied to base speed during entrance
#macro ENEMY_ENTRANCE_SPEED_MULTIPLIER 2

///// @macro FORMATION_ROTATION_ANGLE_STEP
///// @description Degrees to rotate per step when turning to face down
#macro FORMATION_ROTATION_ANGLE_STEP 6

/// @macro BREATHING_CYCLE_MAX
/// @description Maximum value for breathing animation cycle
#macro BREATHING_CYCLE_MAX 120

/// @macro BREATHING_RATE
/// @description Rate of breathing animation increment per frame
///              Value calculated as: 120 cycles / 127 frames ≈ 0.9469697
///              This specific value ensures breathing cycle aligns with audio loop timing
#macro BREATHING_RATE 0.946969697

///// @macro TARGET_DIRECTION_DOWN
///// @description Direction value for facing downward (in degrees)
#macro TARGET_DIRECTION_DOWN 270

///// @macro DIVE_Y_THRESHOLD
///// @description Y-coordinate threshold for transitioning from dive to loop/return
#macro DIVE_Y_THRESHOLD 480

///// @macro OFFSCREEN_Y_THRESHOLD
///// @description Y-coordinate where enemies are considered off-screen
#macro OFFSCREEN_Y_THRESHOLD 592

///// @macro MAX_ENEMY_SHOTS
///// @description Maximum number of enemy shots allowed on screen
#macro MAX_ENEMY_SHOTS 8

///// @macro FINAL_ATTACK_ENEMY_COUNT
///// @description Number of enemies remaining to trigger final attack mode
#macro FINAL_ATTACK_ENEMY_COUNT 3

//// ====================================================================================
//// MACROS - TIMING CONSTANTS
//// ====================================================================================

///// @macro ENEMY_SHOT_TIMING_1
///// @description First shot timing during dive (frames)
#macro ENEMY_SHOT_TIMING_1 60

/// @macro ENEMY_SHOT_TIMING_2
/// @description Second shot timing during dive (frames)
#macro ENEMY_SHOT_TIMING_2 40

/// @macro ENEMY_SHOT_TIMING_3
/// @description Third shot timing during dive (frames, if enabled)
#macro ENEMY_SHOT_TIMING_3 20

/// @macro DIVE_ALARM_STANDARD
/// @description Standard dive alarm delay for waves 1-2
#macro DIVE_ALARM_STANDARD 75

/// @macro DIVE_ALARM_FAST
/// @description Fast dive alarm delay when fastenter is enabled
#macro DIVE_ALARM_FAST 63

/// @macro DIVE_ALARM_INITIAL
/// @description Initial dive alarm delay for wave 0
#macro DIVE_ALARM_INITIAL 10

/// @macro WAVE_SPAWN_DELAY
/// @description Frames to wait between standard wave spawns
#macro WAVE_SPAWN_DELAY 9

/// @macro CHALLENGE_SPAWN_DELAY
/// @description Frames to wait between challenge stage spawns
#macro CHALLENGE_SPAWN_DELAY 6

/// @macro CHALLENGE_WAVE_DELAY
/// @description Frames to wait between challenge waves
#macro CHALLENGE_WAVE_DELAY 45

/// @macro FORMATION_ALARM_DELAY
/// @description Frames to wait for formation rotation alignment
#macro FORMATION_ALARM_DELAY 60

/// @macro PROHIBIT_RESET_DELAY
/// @description Frames to wait before resetting dive prohibit flag
#macro PROHIBIT_RESET_DELAY 15

/// @macro TRANSFORM_ALARM_DELAY
/// @description Frames to wait before enemy transformation
#macro TRANSFORM_ALARM_DELAY 50

/// @macro ENEMY_SHOT_ALARM
/// @description Default enemy shot alarm duration
#macro ENEMY_SHOT_ALARM 90

// ====================================================================================
// MACROS - PLAYER CONSTANTS
// ====================================================================================

/// @macro PLAYER_MISSILE_COOLDOWN
/// @description Frames between missile shots
#macro PLAYER_MISSILE_COOLDOWN 6

/// @macro PLAYER_MAX_MISSILES
/// @description Maximum missiles player can have on screen
#macro PLAYER_MAX_MISSILES 2

/// @macro PLAYER_RESPAWN_DELAY
/// @description Frames to wait before respawning player
#macro PLAYER_RESPAWN_DELAY 90

/// @macro PLAYER_DEATH_DELAY
/// @description Frames to wait after death before processing game over
#macro PLAYER_DEATH_DELAY 120

// ====================================================================================
// MACROS - CHALLENGE STAGE CONSTANTS
// ====================================================================================

/// @macro CHALLENGE_ENEMIES_PER_WAVE
/// @description Number of enemies spawned per challenge wave
#macro CHALLENGE_ENEMIES_PER_WAVE 8

/// @macro CHALLENGE_TOTAL_WAVES
/// @description Total number of waves in a challenge stage
#macro CHALLENGE_TOTAL_WAVES 5

/// @macro CHALLENGE_INTERVAL_LEVELS
/// @description Number of levels between challenge stages
#macro CHALLENGE_INTERVAL_LEVELS 4

// ====================================================================================
// MACROS - SCORE CONSTANTS
// ====================================================================================

/// @macro EXTRA_LIFE_FIRST_THRESHOLD
/// @description Score required for first extra life
#macro EXTRA_LIFE_FIRST_THRESHOLD 20000

/// @macro EXTRA_LIFE_ADDITIONAL_THRESHOLD
/// @description Score increment for each additional extra life
#macro EXTRA_LIFE_ADDITIONAL_THRESHOLD 70000

/// @macro MAX_SCORE_FOR_EXTRA_LIVES
/// @description Maximum score at which extra lives are awarded
#macro MAX_SCORE_FOR_EXTRA_LIVES 1000000

// ====================================================================================
// MACROS - DISPLAY CONSTANTS
// ====================================================================================

/// @macro SCALE_GALAGA_ORIGINAL
/// @description Display scale for original Galaga mode
#macro SCALE_GALAGA_ORIGINAL 1

/// @macro SCALE_GALAGA_WARS
/// @description Display scale for Galaga Wars mode
#macro SCALE_GALAGA_WARS 2

// ====================================================================================
// CONFIGURATION LOADING
// ====================================================================================

/// Global variable to store loaded game configuration
global.game_config = undefined;

/// @function load_game_config
/// @description Loads the game configuration from JSON file
/// @return {Struct} Configuration data structure or undefined on failure
function load_game_config() {
    var config_file = "Patterns/game_config.json";

    if (!file_exists(config_file)) {
        show_debug_message("WARNING: Game config file not found: " + config_file);
        show_debug_message("Using default hardcoded values");
        return undefined;
    }

    try {
        var config_data = load_json_datafile(config_file);

        if (config_data == undefined) {
            show_debug_message("ERROR: Failed to parse game config JSON");
            return undefined;
        }

        show_debug_message("Game configuration loaded successfully");
        return config_data;

    } catch(e) {
        show_debug_message("ERROR loading game config: " + string(e));
        return undefined;
    }
}

/// @function get_config_value
/// @description Retrieves a configuration value with fallback to default
/// @param {String} section The configuration section (e.g., "PLAYER", "ENEMIES")
/// @param {String} key The configuration key within the section
/// @param {Any} default_value The value to return if config is not available
/// @return {Any} The configuration value or default
function get_config_value(section, key, default_value) {
    if (global.game_config == undefined) {
        return default_value;
    }

    if (!variable_struct_exists(global.game_config, section)) {
        return default_value;
    }

    var section_data = global.game_config[$ section];

    if (!variable_struct_exists(section_data, key)) {
        return default_value;
    }

    return section_data[$ key];
}
