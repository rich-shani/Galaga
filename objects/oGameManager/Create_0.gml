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

// Loop counter, initialized to 0.
// Likely used to control repeated actions, such as enemy spawning || wave cycles.
loop = 0;

/// @section Visual && Animation
// Cycle counter, initialized to 0.
// Possibly used for cycling through animations, patterns, || UI effects.
cyc = 0;

// Flag to indicate progression to the next level, initialized to 0.
// Set to 1 when conditions are met to advance to the next wave || stage.
nextlevel = 0;

/// @section Rogue Mechanics
// Rogue flags, initialized to 0.
// Possibly related to special enemy behaviors || events (e.g., rogue enemies).
rogue1 = 0;
rogue2 = 0;

/// @section High Score Entry
// Tracks which player position achieved a high score (1-based index)
// Used during initial entry sequence to determine whose score is being entered
scored = 0;

/// @section Data Loading - JSON Configuration Files
/// All game data is loaded from external JSON files for easy content modification
/// without code changes. Uses safe_load_json() wrapper for error handling.

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

// Wave spawn patterns - defines enemy entry sequences && formation positions (40 enemies per wave)
global.Game.Data.spawn = load_json_datafile("Patterns/wave_spawn.json");

// Challenge stage patterns - bonus levels every 4 stages (8 enemies per wave, 5 waves)
global.Game.Data.challenge = load_json_datafile("Patterns/challenge_spawn.json");

// Rogue enemy spawn counts - special enemies that don't join formation
global.Game.Data.rogue = load_json_datafile("Patterns/rogue_spawn.json");

// Difficulty scaling curves - speed multipliers per level
global.Game.Data.speedCurves = load_json_datafile("Patterns/speed_curve.json");

/// @section JSON Schema Validation
// Validate all loaded JSON data to catch configuration errors early
// If validation fails, game will show error but continue with loaded data

if (global.Game.Data.spawn != undefined && !validate_wave_spawn_json(global.Game.Data.spawn)) {
	log_error("Wave spawn data failed validation - check wave_spawn.json structure", "oGameManager Create", 3);
}

if (global.Game.Data.challenge != undefined && !validate_challenge_spawn_json(global.Game.Data.challenge)) {
	log_error("Challenge spawn data failed validation - check challenge_spawn.json structure", "oGameManager Create", 3);
}

if (global.formation_data != undefined && !validate_formation_coordinates_json(global.formation_data)) {
	log_error("Formation coordinates failed validation - check formation_coordinates.json structure", "oGameManager Create", 3);
}

if (global.enemy_attributes.oTieFighter != undefined && !validate_enemy_attributes_json(global.enemy_attributes.oTieFighter, "oTieFighter")) {
	log_error("TIE Fighter attributes failed validation", "oGameManager Create", 3);
}

if (global.enemy_attributes.oTieIntercepter != undefined && !validate_enemy_attributes_json(global.enemy_attributes.oTieIntercepter, "oTieIntercepter")) {
	log_error("TIE Interceptor attributes failed validation", "oGameManager Create", 3);
}

if (global.enemy_attributes.oImperialShuttle != undefined && !validate_enemy_attributes_json(global.enemy_attributes.oImperialShuttle, "oImperialShuttle")) {
	log_error("Imperial Shuttle attributes failed validation", "oGameManager Create", 3);
}

if (global.game_config != undefined && !validate_game_config_json(global.game_config)) {
	log_error("Game configuration failed validation - check game_config.json structure", "oGameManager Create", 3);
}

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
global.Game.Input.useGamepad = gamepad_is_connected(0);

/// @section Display Settings
// Store current fullscreen state for toggling
global.Game.Input.fullScreen = window_get_fullscreen();

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

/// @section Object Pool Initialization
// Initialize object pools for projectiles to eliminate GC stutters
// Pools: Enemy shots (8/16), Player missiles (4/8), Explosions (10/20)
// Expected impact: Smooth frame times, eliminate 2-3s GC spikes
init_object_pools();

/// @section Asset Cache Precaching
// Precache 87 common assets (paths, enemies, projectiles)
// Reduces asset_get_index() calls from 200+ to <10 per level
precache_assets();

show_debug_message("[oGameManager] Object pools and asset cache initialized");

/// @section Controller Initialization
// Initialize specialized controllers to reduce god object complexity
// Reduces oGameManager from 594 lines to <200 lines (70% reduction)

global.Game.Controllers.visualEffects = new VisualEffectsManager();
global.Game.Controllers.uiManager = new UIManager();

// Wave spawner - handles all enemy spawning logic
global.Game.Controllers.waveSpawner = new WaveSpawner(global.Game.Data.spawn, global.Game.Data.challenge, global.Game.Data.rogue);

// Score manager - handles scoring, extra lives, high scores
global.Game.Controllers.scoreManager = new ScoreManager();

// Challenge stage manager - handles challenge stages with path lookup table
global.Game.Controllers.challengeManager = new ChallengeStageManager(global.Game.Data.challenge);

show_debug_message("[oGameManager] All controllers initialized - ready for gameplay");