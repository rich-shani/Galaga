/// @file ChallengeStageManager.gml
/// @description Specialized controller for challenge stage management
///              Extracted from oGameManager to reduce god object complexity
///              Eliminates 60+ lines of duplicate path selection code
///
/// RESPONSIBILITIES:
///   - Challenge stage detection and triggering
///   - Wave path selection (eliminates duplication)
///   - Challenge results and bonuses
///   - Challenge stage state management
///
/// RELATED FILES:
///   - datafiles/Patterns/challenge_spawn.json - Challenge patterns
///   - scripts/GameConstants.gml - CHALLENGE_INTERVAL_LEVELS

/// Path selection lookup table - eliminates duplicate code
/// Maps wave number (0-4) to path type (PATH1 or PATH2)
global.challenge_wave_path_map = {
	wave_0: { path_type: "PATH1", alt_type: "PATH1_FLIP" },
	wave_1: { path_type: "PATH2", alt_type: "PATH2_FLIP" },
	wave_2: { path_type: "PATH2", alt_type: "PATH2_FLIP" },
	wave_3: { path_type: "PATH1", alt_type: "PATH1_FLIP" },
	wave_4: { path_type: "PATH1", alt_type: "PATH1_FLIP" }
};

/// @function ChallengeStageManager
/// @description Constructor for ChallengeStageManager controller
/// @param {Struct} _challenge_data Challenge spawn data from challenge_spawn.json
/// @return {Struct} ChallengeStageManager instance
function ChallengeStageManager(_challenge_data) constructor {
	// Store data reference
	challenge_data = _challenge_data;

	// Challenge state
	current_challenge_id = 0;
	current_wave = 0;
	enemies_destroyed = 0;
	is_active = false;

	/// @function shouldTriggerChallenge
	/// @description Checks if conditions are met to trigger a challenge stage
	/// @return {Bool} True if challenge should start
	static shouldTriggerChallenge = function() {
		// Challenge triggers every 4 levels
		var interval = get_config_value("CHALLENGE_STAGES", "INTERVAL_LEVELS", CHALLENGE_INTERVAL_LEVELS);
		return (global.Game.Challenge.countdown >= interval);
	};

	/// @function startChallenge
	/// @description Initiates a new challenge stage
	/// @return {undefined}
	static startChallenge = function() {
		// Set challenge state
		is_active = true;
		global.Game.Challenge.isActive = true;

		// Select challenge pattern (global.Game.Input.characterCycle through 0-7)
		current_challenge_id = global.Game.Challenge.current mod 8;
		global.Game.Challenge.current = current_challenge_id;

		// Reset wave and tracking
		current_wave = 0;
		global.Game.Level.wave = 0;
		enemies_destroyed = 0;

		// Reset challenge counter
		global.Game.Challenge.countdown = 0;

		show_debug_message("[ChallengeStageManager] Challenge " + string(current_challenge_id) + " started");
	};

	/// @function endChallenge
	/// @description Ends the current challenge stage
	/// @return {Real} Bonus points earned
	static endChallenge = function() {
		// Calculate bonus
		var bonus = calculateBonus();

		// Update state
		is_active = false;
		global.Game.Challenge.isActive = false;

		// Increment challenge counter for next time
		global.Game.Challenge.current++;

		show_debug_message("[ChallengeStageManager] Challenge ended - " +
			string(enemies_destroyed) + "/40 enemies, " +
			string(bonus) + " points bonus");

		return bonus;
	};

	/// @function getChallengeData
	/// @description Retrieves challenge stage data for the current challenge number
	///              Uses global.Game.Challenge.current (1-indexed) and converts to 0-indexed array access
	/// @return {Struct} Challenge data structure with paths && wave information, undefined if invalid
	static getChallengeData = function() {
		// Get the challenge ID (global.Game.Challenge.current is 1-indexed, array is 0-indexed)
		var challenge_id = global.Game.Challenge.current - 1;
		
		// Bounds checking
		if (challenge_id < 0 || challenge_id >= array_length(challenge_data.CHALLENGES)) {
			log_error("Challenge ID out of bounds: " + string(global.Game.Challenge.current) + " (0-indexed: " + string(challenge_id) + ")",
				"ChallengeStageManager.getChallengeData", 2);
			return undefined;
		}
		
		return challenge_data.CHALLENGES[challenge_id];
	};

	/// @function getChallengeWaveData
	/// @description Retrieves wave data for the current wave in the current challenge
	/// @return {Struct} Wave data structure with enemy type && spawn settings, undefined if invalid
	static getChallengeWaveData = function() {
		var chall_data = getChallengeData();
		if (chall_data == undefined) {
			return undefined;
		}
		
		var wave = global.Game.Level.wave;
		
		// Bounds checking
		if (wave < 0 || wave >= array_length(chall_data.WAVES)) {
			log_error("Challenge wave index out of bounds: " + string(wave),
				"ChallengeStageManager.getChallengeWaveData", 2);
			return undefined;
		}
		
		return chall_data.WAVES[wave];
	};

	/// @function getPathForWave
	/// @description Gets appropriate path name for current wave using lookup table
	///              ELIMINATES 60+ lines of duplicate if/else code
	/// @param {Real} _wave Wave number (0-4)
	/// @param {Bool} _use_alt Whether to use alternate (flipped) path
	/// @return {String} Path name
	static getPathForWave = function(_wave, _use_alt) {
		var challenge = getChallengeData();
		if (challenge == undefined) {
			return "";
		}

		// Use lookup table instead of massive if/else tree
		var path_key = "wave_" + string(_wave);
		var path_config = global.challenge_wave_path_map[$ path_key];

		if (path_config == undefined) {
			log_error("Invalid wave number for path lookup: " + string(_wave),
				"ChallengeStageManager.getPathForWave", 2);
			return challenge.PATH1; // Fallback
		}

		// Get path type from lookup
		var path_type = _use_alt ? path_config.alt_type : path_config.path_type;

		// Return actual path name from challenge data
		return challenge[$ path_type];
	};

	/// @function advanceWave
	/// @description Advances to next wave in challenge
	/// @return {Bool} True if there are more waves, false if challenge complete
	static advanceWave = function() {
		current_wave++;
		global.Game.Level.wave = current_wave;

		// Challenge stages have 5 waves (0-4)
		if (current_wave >= CHALLENGE_TOTAL_WAVES) {
			return false; // Challenge complete
		}

		return true; // More waves remaining
	};

	/// @function recordEnemyDestroyed
	/// @description Records that a challenge enemy was destroyed
	/// @return {undefined}
	static recordEnemyDestroyed = function() {
		enemies_destroyed++;
	};

	/// @function calculateBonus
	/// @description Calculates bonus points for challenge completion
	/// @return {Real} Bonus points
	static calculateBonus = function() {
		// Perfect clear (40/40): 10000 points
		// Otherwise: 100 points per enemy
		if (enemies_destroyed == 40) {
			return 10000; // Special bonus
		} else {
			return enemies_destroyed * 100;
		}
	};

	/// @function getProgress
	/// @description Gets current challenge progress
	/// @return {Struct} Progress data {wave, enemies_destroyed, total_enemies}
	static getProgress = function() {
		return {
			wave: current_wave,
			enemies_destroyed: enemies_destroyed,
			total_enemies: 40,
			completion_percent: (enemies_destroyed / 40) * 100
		};
	};

	/// @function isComplete
	/// @description Checks if all challenge waves are complete
	/// @return {Bool} True if complete
	static isComplete = function() {
		return (current_wave >= CHALLENGE_TOTAL_WAVES - 1) &&
		       (global.Game.Enemy.count == 0);
	};

	/// @function reset
	/// @description Resets challenge manager for new game
	/// @return {undefined}
	static reset = function() {
		current_challenge_id = 0;
		current_wave = 0;
		enemies_destroyed = 0;
		is_active = false;

		global.Game.Challenge.isActive = false;
		global.Game.Challenge.current = 0;
		global.Game.Challenge.countdown = 1; // Start at 1 so first challenge is at level 4
	};

	/// @function incrementChallengeCounter
	/// @description Increments the challenge counter (called after each standard level)
	/// @return {undefined}
	static incrementChallengeCounter = function() {
		global.Game.Challenge.countdown++;
	};
}

/// @function getChallengePath_Legacy
/// @description LEGACY FUNCTION - Preserved for reference
///              This is the OLD way with 60+ lines of duplicate code
///              Now replaced by ChallengeStageManager.getPathForWave() with lookup table
/// @deprecated Use ChallengeStageManager.getPathForWave() instead
function getChallengePath_Legacy(_challenge, _wave, _use_alt) {
	// BEFORE (60+ lines of duplication):
	/*
	if (_wave == 0 || _wave == 3 || _wave == 4) {
		if (_use_alt) return _challenge.PATH1_FLIP;
		else return _challenge.PATH1;
	}
	else if (_wave == 1) {
		if (_use_alt) return _challenge.PATH2_FLIP;
		else return _challenge.PATH2;
	}
	else if (_wave == 2) {
		if (_use_alt) return _challenge.PATH2_FLIP;
		else return _challenge.PATH2;
	}
	*/

	// AFTER (single lookup):
	// var path_config = global.challenge_wave_path_map[$ "wave_" + string(_wave)];
	// return _challenge[$ (use_alt ? path_config.alt_type : path_config.path_type)];
}

/// @function challenging
/// @description Initialize challenge stage data && paths
///
/// Challenge stages are special bonus rounds that occur every 4 levels (when global.Game.Challenge.countdown reaches 4).
/// Unlike normal stages, enemies don't form up - they follow looping paths across the screen.
/// This function loads the challenge pattern data from JSON && sets up path references for spawning.
///
/// Challenge Stage Features:
///   • 8 different challenge patterns (CHALLENGE_ID 1-8)
///   • 5 waves per challenge (40 total enemies)
///   • Enemies can spawn single || in mirrored pairs (DOUBLED flag)
///   • No formation positions (INDEX = -1 for all challenge enemies)
///   • Perfect clear = 10,000 bonus points
///
/// Data Structure (from datafiles/Patterns/challenge_spawn.json):
///   • PATH1, PATH2: Primary paths for enemy entry
///   • PATH1_FLIP, PATH2_FLIP: Mirrored versions for opposite side
///   • DOUBLED: Boolean indicating if enemies spawn in pairs
///   • ENEMY: Enemy type to spawn (e.g., "oTieFighter", "oImperialShuttle")
///
/// Legacy Compatibility:
///   This function maintains backward compatibility by creating path1, path2, path1flip,
///   path2flip variables && a ds_list (list) that the spawning code expects.
///
/// @global {number} chall - Current challenge pattern (1-8)
/// @global {struct} challenge_data - Challenge pattern data loaded from JSON
/// @variable {ds_list} list - List of spawn patterns (1=single, 2=doubled/mirrored)
///
/// @related GameManager_STEP_FNs.gml:Game_Loop - Where challenge spawning occurs
/// @related datafiles/Patterns/challenge_spawn.json - Challenge pattern definitions

function challenging() {
	// === INITIALIZE DATA STRUCTURE ===
	// Create a ds_list to store spawn patterns for each wave
	// This list indicates whether enemies spawn single (1) || doubled/mirrored (2)
	oGameManager.list = ds_list_create();

	// === LOAD CHALLENGE DATA ===
	// Get challenge data for current challenge pattern
	// global.Game.Challenge.current ranges from 1-8, corresponding to 8 different challenge patterns
	// Array is 0-indexed, so subtract 1 to get correct pattern
	var chall_data = global.Game.Data.challenge.CHALLENGES[global.Game.Challenge.current - 1];

	// === SET PATH VARIABLES ===
	// Convert path names (strings) to path asset IDs (numbers)
	// These paths define how challenge enemies enter && move across screen
	//
	// PATH1 / PATH2: Primary paths for left/right sides
	// PATH1_FLIP / PATH2_FLIP: Mirrored versions for opposite entrance
	path1 = asset_get_index(chall_data.PATH1);
	path2 = asset_get_index(chall_data.PATH2);
	path1flip = asset_get_index(chall_data.PATH1_FLIP);
	path2flip = asset_get_index(chall_data.PATH2_FLIP);

	// === BUILD SPAWN PATTERN LIST ===
	// Iterate through all waves in this challenge (5 waves total)
	// For each wave, add entry to list indicating spawn pattern:
	//   • 2 = DOUBLED (spawn enemies in mirrored pairs, 8 enemies per wave)
	//   • 1 = SINGLE (spawn enemies individually, 8 enemies per wave)
	//
	// This list is consumed by the spawning code in Game_Loop() function
	for (var i = 0; i < array_length(chall_data.WAVES); i++) {
		var wave = chall_data.WAVES[i];
		if (wave.DOUBLED) {
			// Doubled mode: enemies spawn in mirrored pairs
			ds_list_add(oGameManager.list, 2);
		} else {
			// Single mode: enemies spawn individually
			ds_list_add(oGameManager.list, 1);
		}
	}
}