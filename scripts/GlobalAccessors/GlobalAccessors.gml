/// @file GlobalAccessors.gml
/// @description Centralized accessor functions for global game state
///              Provides single points of access to game configuration, caches, and data
///              Enables safe refactoring of global.Game struct without updating all call sites
///
/// USAGE:
///   Instead of: global.game_config.PLAYER.STARTING_LIVES
///   Use:        get_config_value("PLAYER", "STARTING_LIVES")
///
///   Instead of: global.Game.Data.enemyAttributes.oTieFighter
///   Use:        get_enemy_attributes("oTieFighter")

// ============================================================================
// ASSET CACHE ACCESSORS
// ============================================================================

/// @function get_asset_cache()
/// @description Get the asset cache data structure
/// @return {Id.DsMap} Asset cache ds_map
function get_asset_cache() {
	return global.Game.Cache.assetCache;
}

/// @function get_asset_cache_stats()
/// @description Get asset cache statistics
/// @return {Struct} Cache statistics (hits, misses, total_lookups, unique_assets)
function get_asset_cache_stats() {
	return global.Game.Cache.assetStats;
}

// ============================================================================
// DATA FILE ACCESSORS
// ============================================================================

/// @function get_formation_data()
/// @description Get formation grid coordinates (40 positions in 5x8 grid)
/// @return {Struct} Formation coordinate data from formation_coordinates.json
function get_formation_data() {
	return global.Game.Data.formation;
}

/// @function get_enemy_attributes(_enemy_name)
/// @description Get configuration attributes for a specific enemy type
/// @param {String} _enemy_name Enemy object name (e.g., "oTieFighter")
/// @return {Struct} Enemy attributes (health, points, paths, etc.)
function get_enemy_attributes(_enemy_name) {
	if (!is_string(_enemy_name) || string_length(_enemy_name) == 0) {
		log_error("Invalid enemy name: " + _enemy_name, "get_enemy_attributes", 1);
		return undefined;
	}

	return global.Game.Data.enemyAttributes[$ _enemy_name];
}

/// @function get_game_config_data()
/// @description Get entire game configuration struct
/// @return {Struct} Game configuration from game_config.json
function get_game_config_data() {
	return global.game_config;
}

/// @function get_wave_spawn_data()
/// @description Get wave spawning patterns
/// @return {Struct} Wave spawn data from wave_spawn.json
function get_wave_spawn_data() {
	return global.Game.Data.spawn;
}

/// @function get_challenge_spawn_data()
/// @description Get challenge stage patterns
/// @return {Struct} Challenge spawn data from challenge_spawn.json
function get_challenge_spawn_data() {
	return global.Game.Data.challenge;
}

/// @function get_rogue_spawn_data()
/// @description Get rogue enemy patterns
/// @return {Struct} Rogue spawn data from rogue_spawn.json
function get_rogue_spawn_data() {
	return global.Game.Data.rogue;
}

/// @function get_speed_curves()
/// @description Get difficulty scaling curves
/// @return {Struct} Speed multipliers per level from speed_curve.json
function get_speed_curves() {
	return global.Game.Data.speedCurves;
}

// ============================================================================
// CONFIGURATION VALUE ACCESSORS
// ============================================================================

/// @function get_config_value(_section, _key, _default)
/// @description Safely retrieve a configuration value with fallback default
/// @param {String} _section Configuration section name (e.g., "PLAYER", "ENEMIES")
/// @param {String} _key Configuration key within section (e.g., "STARTING_LIVES")
/// @param {*} _default Default value if section or key not found
/// @return {*} Configuration value or default value
function get_config_value(_section, _key, _default = undefined) {
	var config = get_game_config_data();

	if (config == undefined) {
		log_error("Game config not loaded", "get_config_value", 2);
		return _default;
	}

	if (!struct_exists(config, _section)) {
		log_error("Config section not found: " + _section, "get_config_value", 1);
		return _default;
	}

	var section = config[$ _section];
	if (!is_struct(section)) {
		log_error("Config section is not a struct: " + _section, "get_config_value", 1);
		return _default;
	}

	if (!struct_exists(section, _key)) {
		log_error("Config key not found: " + _section + "." + _key, "get_config_value", 1);
		return _default;
	}

	return section[$ _key];
}

// ============================================================================
// CONTROLLER ACCESSORS
// ============================================================================

/// @function get_wave_spawner()
/// @description Get the wave spawner controller
/// @return {Struct} WaveSpawner instance or undefined
function get_wave_spawner() {
	return global.Game.Controllers.waveSpawner;
}

/// @function get_score_manager()
/// @description Get the score manager controller
/// @return {Struct} ScoreManager instance or undefined
function get_score_manager() {
	return global.Game.Controllers.scoreManager;
}

/// @function get_challenge_manager()
/// @description Get the challenge stage manager controller
/// @return {Struct} ChallengeStageManager instance or undefined
function get_challenge_manager() {
	return global.Game.Controllers.challengeManager;
}

/// @function get_visual_effects_manager()
/// @description Get the visual effects manager controller
/// @return {Struct} VisualEffectsManager instance or undefined
function get_visual_effects_manager() {
	return global.Game.Controllers.visualEffects;
}

/// @function get_ui_manager()
/// @description Get the UI manager controller
/// @return {Struct} UIManager instance or undefined
function get_ui_manager() {
	return global.Game.Controllers.uiManager;
}

/// @function get_audio_manager()
/// @description Get the audio manager controller
/// @return {Struct} AudioManager instance or undefined
function get_audio_manager() {
	return global.Game.Controllers.audioManager;
}

// ============================================================================
// POOL ACCESSORS
// ============================================================================

/// @function get_enemy_shot_pool()
/// @description Get the enemy shot object pool
/// @return {Struct} ObjectPool instance or undefined
function get_enemy_shot_pool() {
	return global.shot_pool;
}

/// @function get_missile_pool()
/// @description Get the player missile object pool
/// @return {Struct} ObjectPool instance or undefined
function get_missile_pool() {
	return global.missile_pool;
}

/// @function get_explosion_pool()
/// @description Get the explosion object pool
/// @return {Struct} ObjectPool instance or undefined
function get_explosion_pool() {
	return global.explosion_pool;
}

/// @function get_explosion_pool_2()
/// @description Get the secondary explosion object pool
/// @return {Struct} ObjectPool instance or undefined
function get_explosion_pool_2() {
	return global.explosion2_pool;
}

// ============================================================================
// DEBUG UTILITY ACCESSORS
// ============================================================================

/// @function is_debug_mode()
/// @description Check if debug mode is enabled
/// @return {Bool} True if debug mode active
function is_debug_mode() {
	return global.debug;
}

/// @function set_debug_mode(_enabled)
/// @description Enable or disable debug mode
/// @param {Bool} _enabled Debug mode state
/// @return {undefined}
function set_debug_mode(_enabled) {
	global.debug = _enabled;
	if (_enabled) {
		show_debug_message("[DEBUG] Debug mode ENABLED");
	} else {
		show_debug_message("[DEBUG] Debug mode DISABLED");
	}
}


// ========================================================================
// HELPER FUNCTIONS
// ========================================================================

/// @function score_to_sprite_frame
/// @description Maps score values to spriteFrame indices for oPointsDisplay
/// @param {Real} _score The score value to map
/// @return {Real} The spriteFrame index (0-7) corresponding to the score value
/// 
/// Score to Frame Mapping:
///   - 50 points   → frame 0
///   - 100 points  → frame 1
///   - 150 points  → frame 2
///   - 200 points  → frame 3
///   - 300 points  → frame 4
///   - 400 points  → frame 5
///   - 500 points  → frame 6
///   - 800 points  → frame 7
///   - Default: frame 0 for unknown values
function score_to_sprite_frame(_score) {
	switch (_score) {
		case 150: return 0;
		case 400: return 1;
		case 800: return 2;
		case 1000: return 3;
		case 1500: return 4;
		case 1600: return 5;
		case 2000: return 6;
		case 3000: return 7;
		default: return 0;  // Default to frame 0 for unknown values
	}
}

/// @description Creates an instance of a given object at a given position.
/// @param x The x position the object will be created at.
/// @param y The y position the object will be created at.
/// @param obj The object to create an instance of.
function instance_create(argument0, argument1, argument2) {
	//var myDepth = object_get_depth( argument2 );
	return instance_create_depth( argument0, argument1, 0, argument2 );
}
