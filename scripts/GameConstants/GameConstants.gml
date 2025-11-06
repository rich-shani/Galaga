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
// MACROS - FORMATION CONSTANTS
// ====================================================================================

/// @macro FORMATION_CENTER_X
/// @description X-coordinate of formation center point (base resolution)
#macro FORMATION_CENTER_X 448

/// @macro FORMATION_WIDTH
/// @description Total width of enemy formation grid (base resolution)
#macro FORMATION_WIDTH 368

/// @macro FORMATION_TOP_Y
/// @description Y-coordinate of top of formation (base resolution)
#macro FORMATION_TOP_Y 128

/// @macro FORMATION_HEIGHT
/// @description Total height of enemy formation grid (base resolution)
#macro FORMATION_HEIGHT 288

/// @macro FORMATION_BREATHE_AMPLITUDE
/// @description Pixel amplitude of breathing animation oscillation
#macro FORMATION_BREATHE_AMPLITUDE 48

// ====================================================================================
// MACROS - SCREEN BOUNDARY CONSTANTS
// ====================================================================================

/// @macro SCREEN_CENTER_X
/// @description X-coordinate of screen center (base resolution)
#macro SCREEN_CENTER_X 224

/// @macro SCREEN_BOTTOM_Y
/// @description Y-coordinate of screen bottom boundary (base resolution)
///              Note: Same as OFFSCREEN_Y_THRESHOLD
#macro SCREEN_BOTTOM_Y 592

/// @macro BEAM_ACTIVATION_Y
/// @description Y-coordinate where beam weapon can activate (base resolution)
#macro BEAM_ACTIVATION_Y 368

/// @macro ROGUE_TRANSITION_Y
/// @description Y-coordinate where rogue enemies transition behavior (base resolution)
#macro ROGUE_TRANSITION_Y 462

/// @macro SPAWN_TOP_Y
/// @description Y-coordinate for spawning enemies at top of screen (base resolution)
#macro SPAWN_TOP_Y -16

/// @macro SPAWN_EDGE_MARGIN
/// @description Minimum margin from screen edge for random spawning (pixels)
#macro SPAWN_EDGE_MARGIN 64

/// @macro SPAWN_EDGE_BUFFER
/// @description Extra buffer from edges to prevent clipping (pixels)
#macro SPAWN_EDGE_BUFFER 128

/// @macro FORMATION_POSITION_THRESHOLD
/// @description Pixel threshold for determining if enemy has reached formation position
///              Used with abs() to check vertical alignment
#macro FORMATION_POSITION_THRESHOLD 6

/// @macro DIRECTION_ROTATION_THRESHOLD
/// @description Degree threshold for direction alignment checking
///              Used to determine if enemy is facing target direction
#macro DIRECTION_ROTATION_THRESHOLD 6

// ====================================================================================
// MACROS - PLAYER SHIP CONSTANTS
// ====================================================================================

/// @macro PLAYER_SHIP_MIN_X_GALAGA
/// @description Minimum X boundary for player ship in original Galaga mode (base resolution)
#macro PLAYER_SHIP_MIN_X_GALAGA 16

/// @macro PLAYER_SHIP_MIN_X_WARS
/// @description Minimum X boundary for player ship in Galaga Wars mode (scaled resolution)
#macro PLAYER_SHIP_MIN_X_WARS 32

/// @macro PLAYER_SHIP_MAX_X_GALAGA
/// @description Maximum X boundary for player ship in original Galaga mode (base resolution)
#macro PLAYER_SHIP_MAX_X_GALAGA 432

/// @macro PLAYER_SHIP_MAX_X_WARS
/// @description Maximum X boundary for player ship in Galaga Wars mode (scaled resolution)
#macro PLAYER_SHIP_MAX_X_WARS 832

/// @macro PLAYER_SHOT_OFFSCREEN
/// @description Y coordinate where player shots are considered off-screen
#macro PLAYER_SHOT_OFFSCREEN -32

/// @macro PLAYER_SHOT_SPEED_GALAGA
/// @description Player missile speed in pixels per frame (Galaga mode)
#macro PLAYER_SHOT_SPEED_GALAGA 12

/// @macro PLAYER_SHOT_SPEED_WARS
/// @description Player missile speed in pixels per frame (Galaga Wars mode)
#macro PLAYER_SHOT_SPEED_WARS 24

/// @macro PLAYER_SHIP_SPACE_GALAGA
/// @description Horizontal offset between dual fighters (Galaga mode, pixels)
#macro PLAYER_SHIP_SPACE_GALAGA 28

/// @macro PLAYER_SHIP_SPACE_WARS
/// @description Horizontal offset between dual fighters (Galaga Wars mode, pixels)
#macro PLAYER_SHIP_SPACE_WARS 64

/// @macro PLAYER_SHIP_MOVE_INCREMENT_GALAGA
/// @description Player movement increment per frame (Galaga mode, pixels)
#macro PLAYER_SHIP_MOVE_INCREMENT_GALAGA 3

/// @macro PLAYER_SHIP_MOVE_INCREMENT_WARS
/// @description Player movement increment per frame (Galaga Wars mode, pixels)
#macro PLAYER_SHIP_MOVE_INCREMENT_WARS 6

/// @macro PLAYER_BASE_MOVE_SPEED
/// @description Base movement speed for player ship physics calculations
#macro PLAYER_BASE_MOVE_SPEED 5

// ====================================================================================
// MACROS - PLAYER SHIP CONSTANTS (continued from above)
// ====================================================================================

/// @macro PLAYER_SPAWN_Y
/// @description Y-coordinate where player spawns after death (base resolution)
#macro PLAYER_SPAWN_Y 528

/// @macro PLAYER_MISSILE_SPAWN_OFFSET_Y
/// @description Vertical offset from player center to missile spawn point (pixels)
#macro PLAYER_MISSILE_SPAWN_OFFSET_Y 48

/// @macro DUAL_FIGHTER_OFFSET_X
/// @description Horizontal spacing between dual fighters (pixels)
#macro DUAL_FIGHTER_OFFSET_X 72

/// @macro RESCUED_FIGHTER_DOCK_OFFSET_Y
/// @description Vertical offset for rescued fighter docking position (pixels)
#macro RESCUED_FIGHTER_DOCK_OFFSET_Y 64

/// @macro RESCUED_FIGHTER_DESCENT_SPEED
/// @description Descent speed of rescued fighter during docking sequence (pixels/frame)
#macro RESCUED_FIGHTER_DESCENT_SPEED 4

/// @macro RESCUED_FIGHTER_HORIZONTAL_SPEED
/// @description Horizontal movement speed of rescued fighter during docking (pixels/frame)
#macro RESCUED_FIGHTER_HORIZONTAL_SPEED 2

/// @macro SHIP_SPRITE_LEFT
/// @description Sprite index for left-tilted ship
#macro SHIP_SPRITE_LEFT 1

/// @macro SHIP_SPRITE_CENTER
/// @description Sprite index for centered ship
#macro SHIP_SPRITE_CENTER 2

/// @macro SHIP_SPRITE_RIGHT
/// @description Sprite index for right-tilted ship
#macro SHIP_SPRITE_RIGHT 3

/// @macro GAMEPAD_DEADZONE
/// @description Analog stick deadzone threshold (0.0-1.0)
#macro GAMEPAD_DEADZONE 0.1

// ====================================================================================
// MACROS - TIMING CONSTANTS (EXTENDED)
// ====================================================================================

/// @macro PLAYER_RESPAWN_DELAY_FRAMES
/// @description Frames to wait before respawning player after death
///              Note: This is the actual value used in code (different from PLAYER_RESPAWN_DELAY)
#macro PLAYER_RESPAWN_DELAY_FRAMES 180

/// @macro CAPTURE_SEQUENCE_DURATION
/// @description Duration of player capture animation sequence (frames)
#macro CAPTURE_SEQUENCE_DURATION 240

/// @macro CAPTURE_RESPAWN_DELAY
/// @description Delay before respawning captured player (frames)
#macro CAPTURE_RESPAWN_DELAY 420

/// @macro GAME_OVER_CLEANUP_DELAY
/// @description Delay before cleanup after game over (frames)
#macro GAME_OVER_CLEANUP_DELAY 120

// ====================================================================================
// MACROS - BEAM WEAPON CONSTANTS
// ====================================================================================

/// @macro BEAM_TIME_DEFAULT
/// @description Default duration of tractor beam animation (frames)
#macro BEAM_TIME_DEFAULT 90

/// @macro BEAM_CAPTURE_WIDTH
/// @description Horizontal width of beam capture zone (pixels, half-width from center)
#macro BEAM_CAPTURE_WIDTH 32

/// @macro BEAM_CAPTURE_WINDOW_START_RATIO
/// @description Fraction of beam duration when capture window opens (0.0-1.0)
///              Capture window = (1/3 to 2/3) of beam duration
#macro BEAM_CAPTURE_WINDOW_START_RATIO 0.333333

/// @macro BEAM_CAPTURE_WINDOW_END_RATIO
/// @description Fraction of beam duration when capture window closes (0.0-1.0)
///              Capture window = (1/3 to 2/3) of beam duration
#macro BEAM_CAPTURE_WINDOW_END_RATIO 0.666667

/// @macro BEAM_PLAYER_START_Y
/// @description Starting Y position for player during beam capture (base resolution)
#macro BEAM_PLAYER_START_Y 1024

/// @macro BEAM_PLAYER_END_Y
/// @description Ending Y position for player during beam capture (base resolution)
#macro BEAM_PLAYER_END_Y 736

/// @macro BEAM_PLAYER_TRAVEL_DISTANCE
/// @description Total vertical distance player travels during beam capture (pixels)
///              Calculated as: BEAM_PLAYER_START_Y - BEAM_PLAYER_END_Y = 288
#macro BEAM_PLAYER_TRAVEL_DISTANCE 288

/// @macro BEAM_PLAYER_ALIGN_SPEED
/// @description Speed at which player aligns horizontally with captor (pixels/frame)
#macro BEAM_PLAYER_ALIGN_SPEED 3

// ====================================================================================
// MACROS - GAMEPLAY BALANCE CONSTANTS
// ====================================================================================

/// @macro MAX_TRANSFORM_ENEMY_COUNT
/// @description Maximum number of enemies on screen to allow transformations
#macro MAX_TRANSFORM_ENEMY_COUNT 21

/// @macro DIVE_TRIGGER_RANDOM_RANGE
/// @description Random range for dive trigger probability (1 in N chance)
///              Used with irandom(10) == 0 for ~9% dive chance per frame
#macro DIVE_TRIGGER_RANDOM_RANGE 10

/// @macro TRANSFORM_RANDOM_RANGE
/// @description Random range for transformation probability (1 in N chance)
///              Used with irandom(5) == 0 for ~16.7% transform chance per frame
#macro TRANSFORM_RANDOM_RANGE 5

/// @macro DUAL_FIGHTER_MAX_MISSILES
/// @description Maximum missiles when in dual fighter mode
#macro DUAL_FIGHTER_MAX_MISSILES 4

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
// MACROS - ATTRACT MODE CONSTANTS
// ====================================================================================

/// @macro ATTRACT_SHOT_TIMING_PRIMARY
/// @description Primary shot timing during attract mode sequence (frames)
///              Used during sequences 8-12
#macro ATTRACT_SHOT_TIMING_PRIMARY 30

/// @macro ATTRACT_SHOT_TIMING_ALTERNATE
/// @description Alternate shot timing during attract mode (frames)
///              Fired regardless of sequence value
#macro ATTRACT_SHOT_TIMING_ALTERNATE 10

/// @macro ATTRACT_SHOT_TIMING_BOSS_FIRST
/// @description First shot timing for boss sequence in attract mode (frames)
///              Used in sequence 16
#macro ATTRACT_SHOT_TIMING_BOSS_FIRST 27

/// @macro ATTRACT_SHOT_TIMING_BOSS_SECOND
/// @description Second shot timing for boss sequence in attract mode (frames)
///              Used in sequence 16
#macro ATTRACT_SHOT_TIMING_BOSS_SECOND 12

/// @macro ATTRACT_TARGET_Y
/// @description Y-coordinate target for attract mode shots (base resolution)
///              Shots are removed when reaching this position
#macro ATTRACT_TARGET_Y 336

/// @macro ATTRACT_SHOT_MOVE_INCREMENT
/// @description Vertical movement increment for attract mode shots (pixels per frame)
#macro ATTRACT_SHOT_MOVE_INCREMENT 16

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
