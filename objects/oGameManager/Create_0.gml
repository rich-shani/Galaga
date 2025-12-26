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

// load the visual effects now (not in oGlobals) as we now have the PauseEffect, and ScrollingNebula LAYERs
global.Game.Controllers.visualEffects = new VisualEffectsManager();

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

//// In oGameManager Create event or room initialization
//bloom_layer = layer_create(-50, "BloomEffect");
//layer_shader(bloom_layer, shd_bloom);

//// Set shader uniforms (do this in Create or when shader is applied)
//shader_set(shd_bloom);
//shader_set_uniform_f(shader_get_uniform(shd_bloom, "intensity"), 0.9);
//shader_set_uniform_f(shader_get_uniform(shd_bloom, "threshold"), 0.9);
//shader_set_uniform_f_array(shader_get_uniform(shd_bloom, "texel_size"), 
//    [1.0/view_wport[0], 1.0/view_hport[0]]);
//shader_reset();