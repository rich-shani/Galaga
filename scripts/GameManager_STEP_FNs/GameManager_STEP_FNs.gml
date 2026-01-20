/// @file GameManager_STEP_FNs.gml
/// @description Helper functions for game manager operations including wave spawning,
///              challenge stages, && game loop orchestration
///
/// RELATED FILES:
///   - scripts/HighScoreSystem.gml - High score management functions
///   - scripts/EnemyManagement.gml - Enemy counting && formation control
///   - scripts/LevelProgression.gml - Level advancement && extra life logic

/// @function init_globals
/// @description Initializes all global game variables used throughout the application
///              This centralizes global state initialization for better maintainability
///              Should be called once in oGameManager Create event before any other initialization
///
/// MIGRATION NOTE:
///   This function now performs DUAL INITIALIZATION:
///   1. Initializes legacy global variables (for backward compatibility)
///   2. Initializes new global.Game struct system (for better organization)
///   3. Syncs values between old && new systems
///
///   During migration, code can use EITHER old globals OR new structs.
///   Eventually, all code will migrate to struct-based access.
///

/// @function load_json_datafile
/// @description Generic JSON file loader for game data files with error handling
/// @param {String} _datafile Path to the JSON data file (relative to game directory)
/// @param {Struct} _default Default value to return if loading fails (default: undefined)
/// @return {Struct} Parsed JSON data structure, default value if file not found || parse error
function load_json_datafile(_datafile, _default = undefined) {
	// Use safe JSON loading utility
	return safe_load_json(_datafile, _default);
}

/// @function nRogueEnemies
/// @description Returns the number of rogue enemies to spawn for current level && wave
///              Uses rogue_config data loaded from rogue_spawn.json
/// @return {Real} Number of rogue enemies to spawn
function nRogueEnemies() {
    // Get spawn count for current rogue level && wave
    // Add bounds checking to prevent crashes from invalid indices
    if (global.Game.Rogue.level < 0 || global.Game.Rogue.level >= array_length(global.Game.Data.rogue.ROGUE_LEVELS)) {
        log_error("Invalid rogue level index: " + string(global.Game.Rogue.level), "nRogueEnemies", 2);
        return 0;
    }

    var rogue_level_data = global.Game.Data.rogue.ROGUE_LEVELS[global.Game.Rogue.level];

    if (global.Game.Level.wave < 0 || global.Game.Level.wave >= array_length(rogue_level_data.SPAWN_COUNT)) {
        log_error("Invalid wave index: " + string(global.Game.Level.wave), "nRogueEnemies", 2);
        return 0;
    }

    return rogue_level_data.SPAWN_COUNT[global.Game.Level.wave];
}

/// @function spawnRogueEnemy
/// @description Spawns a single rogue enemy using ROGUE_ prefixed paths
///              Handles combination spawns (paired enemies) recursively
///              SAFETY: Includes depth limit to prevent stack overflow from malformed data
///              UPDATED: Now uses asset caching for performance
/// @param {Real} _spawn The spawn index in the wave data
/// @param {Real} _depth Current recursion depth (optional, default 0)
/// @return {undefined}
function spawnRogueEnemy(_spawn, _depth = 0) {
	// === RECURSION DEPTH LIMIT ===
	// Prevent stack overflow from malformed JSON with infinite COMBINE chains
	var MAX_ROGUE_SPAWN_DEPTH = 16;
	if (_depth > MAX_ROGUE_SPAWN_DEPTH) {
		log_error("spawnRogueEnemy exceeded max recursion depth (" + string(MAX_ROGUE_SPAWN_DEPTH) + ")", "spawnRogueEnemy", 2);
		return;
	}

	// === BOUNDS CHECKING ===
	var spawn_array = global.Game.Data.spawn.PATTERN[global.Game.Level.pattern].WAVE[global.Game.Level.wave].SPAWN;
	if (_spawn < 0 || _spawn >= array_length(spawn_array)) {
		log_error("spawnRogueEnemy spawn index out of bounds: " + string(_spawn), "spawnRogueEnemy", 2);
		return;
	}

	var enemy_data = spawn_array[_spawn];

	// SPAWN a ROGUE Enemy with cached asset lookup
	var path_name = "ROGUE_" + enemy_data.PATH;
	var enemy_id = safe_get_asset(enemy_data.ENEMY, -1);
	if (enemy_id != -1) {
		instance_create_layer(enemy_data.SPAWN_XPOS, enemy_data.SPAWN_YPOS, "GameSprites", enemy_id,
			{ ENEMY_NAME: enemy_data.ENEMY, INDEX: -1, PATH_NAME: path_name, MODE: EnemyMode.ROGUE });
	} else {
		log_error("Failed to spawn rogue enemy: " + enemy_data.ENEMY, "spawnRogueEnemy", 2);
	}

	// Handle combination spawn
	if (enemy_data.COMBINE) {
		spawnRogueEnemy(_spawn + 1, _depth + 1);
	}
}

/// @function spawnRogueEnemies
/// @description Spawns multiple rogue enemies for the current wave
/// @param {Real} _nRogues Number of rogue enemies to spawn
/// @return {undefined}
function spawnRogueEnemies(_nRogues) {

	if (global.Game.Controllers.waveSpawner != undefined) {
		// loop to SPAWN _nRogues (and check for a COMBINATION SPAWN)
		for (var i=0; i < _nRogues; i++ ) {
			spawnRogueEnemy(global.Game.Controllers.waveSpawner.getSpawnCounter()-2);
		}
	} else {
		log_error("waveSpawner controller not initialized", "spawnRogueEnemies", 3);
	}
}

/// @function spawnEnemy
/// @description Spawns a standard enemy using WaveSpawner controller
///              Delegates to waveSpawner.spawnStandardEnemy()
/// @return {undefined}
function spawnEnemy() {
	// Delegate to WaveSpawner controller
	// Controller handles: data reading, error checking, COMBINE flags, counter increment
	if (global.Game.Controllers.waveSpawner != undefined) {
		global.Game.Controllers.waveSpawner.spawnEnemyGroup();
	} else {
		log_error("waveSpawner controller not initialized", "spawnEnemyGroup", 3);
	}
}

/// @function waveComplete
/// @description Checks if all enemies in the current wave have been spawned
/// @return {Bool} True if all spawn indices have been processed
function waveComplete() {
	if (global.Game.Controllers.waveSpawner != undefined) {
		return (global.Game.Controllers.waveSpawner.isWaveComplete());
//		return (global.Game.Controllers.waveSpawner.getSpawnCounter() == array_length(global.Game.Data.spawn.PATTERN[global.Game.Level.pattern].WAVE[global.Game.Level.wave].SPAWN));
	} else {
		log_error("waveSpawner controller not initialized", "waveComplete", 3);
		return false;
	}
}

/// @function patternComplete
/// @description Checks if all waves in the current pattern have been completed
/// @return {Bool} True if all waves in pattern are done
function patternComplete() {

	return (global.Game.Level.wave == array_length(global.Game.Data.spawn.PATTERN[global.Game.Level.pattern].WAVE));
}

/// @function getChallengeData
/// @description Retrieves challenge stage data for the current challenge number
///              DEPRECATED: Use global.Game.Controllers.challengeManager.getChallengeData() instead
///              Note: global.Game.Challenge.current is 1-indexed (1-8), array is 0-indexed
/// @return {Struct} Challenge data structure with paths && wave information
/// @deprecated Use challengeManager.getChallengeData() instead
//function getChallengeData() {
//	if (global.Game.Controllers.challengeManager != undefined) {
//		return global.Game.Controllers.challengeManager.getChallengeData();
//	} else {
//		log_error("challengeManager controller not initialized", "getChallengeData", 3);
//		// Fallback to direct access for backward compatibility
//		return global.Game.Data.challenge.CHALLENGES[global.Game.Challenge.current - 1];
//	}
//}

/// @function getChallengeWaveData
/// @description Retrieves wave data for the current wave in the current challenge
///              DEPRECATED: Use global.Game.Controllers.challengeManager.getChallengeWaveData() instead
/// @return {Struct} Wave data structure with enemy type && spawn settings
/// @deprecated Use challengeManager.getChallengeWaveData() instead
//function getChallengeWaveData() {
//	if (global.Game.Controllers.challengeManager != undefined) {
//		return global.Game.Controllers.challengeManager.getChallengeWaveData();
//	} else {
//		log_error("challengeManager controller not initialized", "getChallengeWaveData", 3);
//		// Fallback to direct access for backward compatibility
//		var chall_data = getChallengeData();
//		if (chall_data != undefined) {
//			return chall_data.WAVES[global.Game.Level.wave];
//		}
//		return undefined;
//	}
//}

/// @function spawnChallengeEnemy
/// @description Spawns a challenge stage enemy using WaveSpawner controller
///              Delegates to waveSpawner.spawnChallengeEnemy()
/// @return {undefined}
function spawnChallengeEnemy() {
	// Delegate to WaveSpawner controller
	// Controller handles: path selection, enemy alternation, error checking
	if (global.Game.Controllers.waveSpawner != undefined) {
		global.Game.Controllers.waveSpawner.spawnChallengeEnemy();
	} else {
		log_error("waveSpawner controller not initialized", "spawnChallengeEnemy", 3);
	}
}

/// @function Game_Loop_Standard
/// @description Handles standard wave-based gameplay spawning logic
///              Spawns enemies from wave_spawn.json into 5x8 formation grid
///              Includes rogue enemy spawning between waves
/// @return {undefined}
function Game_Loop_Standard() {
	// ====================================================================
	// STANDARD MODE: Wave Spawning Logic
	// ====================================================================
	// Spawns enemies from wave_spawn.json pattern
	// Each pattern has multiple waves, each wave has 40 enemies total
	// Enemies spawn in groups with delays between each group

	// SPAWN all ENEMY WAVES within the PATTERN
    if (!patternComplete()) {

		// === ENEMY SPAWNING TIMER ===
		// alarm[AlarmIndex.SPAWN_DELAY] controls delay between spawns (WAVE_SPAWN_DELAY = 9 frames)
		// When alarm[AlarmIndex.SPAWN_DELAY] == -1, spawn timer is inactive && we can spawn
		if (alarm[AlarmIndex.SPAWN_DELAY] == -1) {

			// === PHASE 1: SPAWN STANDARD ENEMIES ===
			if (!waveComplete()) {
				// Wave still has enemies to spawn
				// spawnEnemy() reads next spawn from wave_spawn.json
				// Automatically handles COMBINE flag for paired spawns
				spawnEnemy();
			}
			//// === PHASE 2: ADD ROGUE ENEMIES ===
			//else if (!global.Game.Rogue.checkPerWave) {
			//	// Wave spawning complete, now check for rogue enemies
			//	// Rogues are special enemies that don't join formation
			//	// They target the player directly after entrance path

			//	var nRogue = nRogueEnemies(); // Get rogue count from rogue_spawn.json
			//	if (nRogue > 0) {
			//		spawnRogueEnemies(nRogue);
			//	}

			//	global.Game.Rogue.checkPerWave = true; // Mark rogues as spawned for this wave
			//}

			// === PHASE 3: WAVE TRANSITION CHECK ===
			// Only advance to next wave when:
			//   1. All enemies spawned (waveComplete)
			//   2. All enemies in formation (divecap == divecapstart)
			//
			// The divecap check ensures enemies aren't still entering
			// when we start the next wave
			if (waveComplete() && (global.Game.Enemy.diveCapacity == global.Game.Enemy.diveCapacityStart)) {
			    // Wave fully spawned AND enemies in formation
				// Advance to next wave

				if (global.Game.Controllers.waveSpawner != undefined) {
					global.Game.Controllers.waveSpawner.resetSpawnCounter();
				} else {
					log_error("waveSpawner controller not initialized", "Game_Loop_Standard", 3);
				}

				// Advance to the next WAVE within this pattern
	            global.Game.Level.wave += 1;
				// Reset rogue flag for next wave
				global.Game.Rogue.checkPerWave = false;
            }
			else {
				// Still spawning OR enemies still moving into formation
				// Wait WAVE_SPAWN_DELAY frames before next spawn
				alarm[AlarmIndex.SPAWN_DELAY] = WAVE_SPAWN_DELAY; // 9 frames
			}
		}
	}
	else {
		// === PATTERN COMPLETE ===
		// All waves in current pattern have been spawned
		// Stop spawning until next level
		//global.open = 0;
		global.Game.State.spawnOpen = 0;
	}
}

/// @function _spawn_paired_challenge_enemies
/// @description Generic spawner for paired enemies on mirrored paths
///              Handles both same-enemy and mixed-enemy spawning
/// @param {Struct} chall_data Challenge pattern data with path names
/// @param {Real} path_id ID of first path asset
/// @param {Real} path_flip_id ID of flipped path asset
/// @param {Real} enemy1_id ID of first enemy type
/// @param {String} enemy1_name Name of first enemy type
/// @param {Real} enemy2_id ID of second enemy type (optional, -1 to use enemy1_id)
/// @param {String} enemy2_name Name of second enemy type (optional, default enemy1_name)
/// @return {Bool} True if both enemies spawned successfully
function _spawn_paired_challenge_enemies(chall_data, path_id, path_flip_id, enemy1_id, enemy1_name, enemy2_id = -1, enemy2_name = "") {
	// Use second enemy as first if not specified
	if (enemy2_id == -1) enemy2_id = enemy1_id;
	if (enemy2_name == "") enemy2_name = enemy1_name;

	// Spawn first enemy on primary path
	if (path_id != -1 && enemy1_id != -1) {
		instance_create_layer(path_get_x(path_id, 0), path_get_y(path_id, 0),
							"GameSprites", enemy1_id,
							{ ENEMY_NAME: enemy1_name, INDEX: -1, PATH_NAME: chall_data.PATH1, MODE: EnemyMode.CHALLENGE });
	} else {
		if (enemy1_id == -1) log_error("Challenge enemy not found: " + enemy1_name, "spawnChallengeWave", 2);
		if (path_id == -1) log_error("Challenge path not found", "spawnChallengeWave", 2);
		return false;
	}

	// Spawn second enemy on flipped path
	if (path_flip_id != -1 && enemy2_id != -1) {
		instance_create_layer(path_get_x(path_flip_id, 0), path_get_y(path_flip_id, 0),
							"GameSprites", enemy2_id,
							{ ENEMY_NAME: enemy2_name, INDEX: -1, PATH_NAME: chall_data.PATH1_FLIP, MODE: EnemyMode.CHALLENGE });
	} else {
		if (enemy2_id == -1) log_error("Challenge enemy not found: " + enemy2_name, "spawnChallengeWave", 2);
		if (path_flip_id == -1) log_error("Challenge flipped path not found", "spawnChallengeWave", 2);
		return false;
	}

	return true;
}

/// @function spawnChallengeWave_0_3_4
/// @description Spawns doubled enemies for challenge waves 0, 3, && 4 using PATH1/PATH1_FLIP
///              Both enemies are the same type
/// @param {Struct} chall_data Challenge pattern data with path names
/// @param {Struct} wave_data Current wave data with enemy type
/// @return {undefined}
function spawnChallengeWave_0_3_4(chall_data, wave_data) {
	// Spawn two enemies of the same type on mirrored paths
	var path1_id = safe_get_asset(chall_data.PATH1, -1);
	var path1flip_id = safe_get_asset(chall_data.PATH1_FLIP, -1);
	var enemy_id = safe_get_asset(wave_data.ENEMY, -1);

	_spawn_paired_challenge_enemies(chall_data, path1_id, path1flip_id, enemy_id, wave_data.ENEMY);
	alarm[AlarmIndex.SPAWN_DELAY] = CHALLENGE_SPAWN_DELAY;
}

/// @function spawnChallengeWave_1
/// @description Spawns mixed enemies for challenge wave 1 using PATH2/PATH2_FLIP
///              Spawns primary enemy + TieFighter on mirrored paths
/// @param {Struct} chall_data Challenge pattern data with path names
/// @param {Struct} wave_data Current wave data with enemy type
/// @return {undefined}
function spawnChallengeWave_1(chall_data, wave_data) {
	// Spawn primary enemy && a TieFighter on mirrored paths
	var path2_id = safe_get_asset(chall_data.PATH2, -1);
	var path2flip_id = safe_get_asset(chall_data.PATH2_FLIP, -1);
	var enemy1_id = safe_get_asset(wave_data.ENEMY, -1);
	var enemy2_id = safe_get_asset("oTieFighter", -1);

	// Temporarily swap path names for mixed spawn
	var orig_path1 = chall_data.PATH1;
	var orig_path1_flip = chall_data.PATH1_FLIP;
	chall_data.PATH1 = chall_data.PATH2;
	chall_data.PATH1_FLIP = chall_data.PATH2_FLIP;

	_spawn_paired_challenge_enemies(chall_data, path2_id, path2flip_id, enemy1_id, wave_data.ENEMY, enemy2_id, "oTieFighter");

	// Restore original paths
	chall_data.PATH1 = orig_path1;
	chall_data.PATH1_FLIP = orig_path1_flip;
	alarm[AlarmIndex.SPAWN_DELAY] = CHALLENGE_SPAWN_DELAY;
}

/// @function spawnChallengeWave_2
/// @description Spawns doubled enemies for challenge wave 2 using PATH2/PATH2_FLIP
///              Both enemies are the same type
/// @param {Struct} chall_data Challenge pattern data with path names
/// @param {Struct} wave_data Current wave data with enemy type
/// @return {undefined}
function spawnChallengeWave_2(chall_data, wave_data) {
	// Spawn two enemies of the same type on mirrored paths (PATH2)
	var path2_id = safe_get_asset(chall_data.PATH2, -1);
	var path2flip_id = safe_get_asset(chall_data.PATH2_FLIP, -1);
	var enemy_id = safe_get_asset(wave_data.ENEMY, -1);

	// Temporarily swap path names for PATH2 use
	var orig_path1 = chall_data.PATH1;
	var orig_path1_flip = chall_data.PATH1_FLIP;
	chall_data.PATH1 = chall_data.PATH2;
	chall_data.PATH1_FLIP = chall_data.PATH2_FLIP;

	_spawn_paired_challenge_enemies(chall_data, path2_id, path2flip_id, enemy_id, wave_data.ENEMY);

	// Restore original paths
	chall_data.PATH1 = orig_path1;
	chall_data.PATH1_FLIP = orig_path1_flip;
	alarm[AlarmIndex.SPAWN_DELAY] = CHALLENGE_SPAWN_DELAY;
}

/// @function Game_Loop_Challenge
/// @description Handles challenge stage spawning logic
///              Challenge stages occur every 4 levels
///              Spawns 8 enemies per wave (5 waves = 40 total)
///              Enemies follow looping paths with no formation
/// @return {undefined}
function Game_Loop_Challenge() {
	// ====================================================================
	// CHALLENGE MODE: Challenge Stage Spawning Logic
	// ====================================================================
	// Challenge stages occur every 4 levels (when global.Game.Challenge.countdown reaches 0)
	// Different spawning logic: 8 enemies per wave, 5 waves total = 40 enemies
	// Enemies follow looping paths && don't form into grid

	// Only proceed if we're within valid wave range, alarm is inactive, && !transitioning to next level
    if (global.Game.Level.wave < CHALLENGE_TOTAL_WAVES && alarm[AlarmIndex.SPAWN_DELAY] == -1 && nextlevel == 0) {

        if (count < CHALLENGE_ENEMIES_PER_WAVE) {  // Only spawn if current wave hasn't reached full enemy count

            // Use challengeManager to get challenge and wave data
            if (global.Game.Controllers.challengeManager != undefined) {
                var chall_data = global.Game.Controllers.challengeManager.getChallengeData();
                var wave_data = global.Game.Controllers.challengeManager.getChallengeWaveData();
            } else {
                log_error("challengeManager controller not initialized", "Game_Loop_Challenge", 3);
                return;
            }

            // === PATH SHIFTING FOR CHALLENGE 4 ===
            // Special case: Challenge 4, Wave 4 shifts paths right for visual variety
            if (global.Game.Challenge.current == 4 && global.Game.Level.wave == 4) {
                var path1_id = safe_get_asset(chall_data.PATH1, -1);
                if (path1_id != -1 && path_get_x(path1_id, 0) == FORMATION_CENTER_X) {
                    var path1flip_id = safe_get_asset(chall_data.PATH1_FLIP, -1);
                    if (path1flip_id != -1) {
                        // Shift paths right for visual variety
                        path_shift(path1_id, CHALLENGE_4_WAVE_4_PATH_SHIFT_X * global.Game.Display.scale, 0);
                        path_shift(path1flip_id, CHALLENGE_4_WAVE_4_PATH_SHIFT_X * global.Game.Display.scale, 0);
                    } else {
                        log_error("Challenge 4 flipped path not found: " + chall_data.PATH1_FLIP, "Game_Loop_Challenge", 1);
                    }
                }
            }

            // === DOUBLED WAVE CHECK ===
            if (wave_data.DOUBLED) {
                // This wave spawns mirrored pairs of enemies

                if (global.Game.Level.wave == 0 || global.Game.Level.wave == 3 || global.Game.Level.wave == 4) {
					spawnChallengeWave_0_3_4(chall_data, wave_data);
               } else if (global.Game.Level.wave == 1) {
					spawnChallengeWave_1(chall_data, wave_data);
                } else if (global.Game.Level.wave == 2) {
					spawnChallengeWave_2(chall_data, wave_data);
                }

				// advance count by 2, as this was a DOUBLE spawn
				count += 2;
            } else {
                // === NON-DOUBLED WAVE ===
                spawnChallengeEnemy();
                alarm[AlarmIndex.SPAWN_DELAY] = CHALLENGE_SPAWN_DELAY;

				count++;
            }
        } // End of count check for spawning

        // === ADVANCE WAVE ===
        if (count == CHALLENGE_ENEMIES_PER_WAVE) {
            // If max enemies spawned && all cleared, reset for next wave
            if (global.Game.Enemy.count == 0) {
                alarm[AlarmIndex.SPAWN_DELAY] = CHALLENGE_WAVE_DELAY;  // Delay before next wave starts
                global.Game.Level.wave += 1;
                count = 0;
                global.Game.Player.shotTotal += global.Game.Player.shotCount;
                global.Game.Player.shotCount = 0;
            }
        }
    }
	else if (global.Game.Level.wave == CHALLENGE_TOTAL_WAVES) {
		if (alarm[2] == -1) {
			// trigger the RESULTS ...
			alarm[2] = 60;
		}
	}
}

/// @function Game_Loop
/// @description Main game loop orchestrator - routes to appropriate game mode
///              Handles common logic then delegates to mode-specific functions
///
/// ARCHITECTURE:
/// This function handles TWO distinct game modes:
///   1. STANDARD MODE (global.Game.Challenge.countdown > 0): Regular wave-based gameplay
///      - Spawns 40 enemies per wave from wave_spawn.json
///      - Enemies form into 5x8 grid formation
///      - Includes rogue enemy spawning between waves
///
///   2. CHALLENGE MODE (global.Game.Challenge.countdown == 0): Bonus stages every 4 levels
///      - Spawns 8 enemies per wave (5 waves = 40 total)
///      - Enemies follow looping paths (no formation)
///      - Uses challenge_spawn.json for patterns
///
/// FLOW:
///   1. Check for extra lives (score thresholds)
///   2. Update dive capacity (limits simultaneous attacks)
///   3. Control formation breathing animation
///   4. Route to Game_Loop_Standard() || Game_Loop_Challenge()
///
/// @return {undefined}
function Game_Loop(){

	// === EARLY EXITS ===
	// Skip processing if game is paused || transitioning to next level
	// do not spawn a wave if the Ship isn't active (eg its RESPAWNING)
	if (global.Game.State.isPaused || oPlayer.shipState != ShipState.ACTIVE) return;
	else if (!global.Game.Rogue.checkPerWave) {

		// pre-compute the wave to SPAWN, include any rogue enemies (and randomize their position in the SPANN)
		global.Game.Controllers.waveSpawner.computeEnemiesForWave();
			
		// flag is reset, at the end of each WAVE (within Game_Loop_Standard)
		global.Game.Rogue.checkPerWave = true;	
	}
	
	// === CHECK LEVEL ADVANCE CONDITIONS ===
	// Pass current state to readyForNextLevel() for context-independent validation
	var levelAdvanceResult = readyForNextLevel(alarm[AlarmIndex.LEVEL_ADVANCE], nextlevel);
	if (levelAdvanceResult != undefined && levelAdvanceResult.shouldAdvance) {
		// Apply the state changes returned by the function
		nextlevel = levelAdvanceResult.nextlevel;
		alarm[AlarmIndex.LEVEL_ADVANCE] = levelAdvanceResult.alarmLevelAdvance;
		if (levelAdvanceResult.alarmSpawnTimer != -1) {
			alarm[AlarmIndex.SPAWN_FORMATION_TIMER] = levelAdvanceResult.alarmSpawnTimer;
		}
		return;
	}

     // Cache enemy shot count once per frame (used by 40 enemies)
     // Use pool's active count if available, otherwise fall back to instance_number
     global.Game.Enemy.shotCount = (global.shot_pool != undefined) ? global.shot_pool.stats.current_active : instance_number(oEnemyShot);
	 
	// calculate the Enemy breathing global.Game.Input.characterCycle - once per frame (used by 40 enemies)
     if (global.Game.Enemy.breathePhase != undefined) {
         global.Game.Enemy.breathePhase_normalized =
             global.Game.Enemy.breathePhase / BREATHING_CYCLE_MAX;
     }
	 
	// === EXTRA LIVES ===
	// Award extra lives at score milestones (20k, then every 70k)
	// Delegate to ScoreManager controller
	if (global.Game.Controllers.scoreManager != undefined) {
		global.Game.Controllers.scoreManager.checkForExtraLife();
	}

    // === ENEMY DIVE CAPACITY HANDLING ===
	// Calculate how many enemies can dive simultaneously
	// Prevents overwhelming the player with too many attacks at once
	checkDiveCapacity();

    // === BREATHING ANIMATION MECHANIC ===
	// Update the oscillating "breathing" motion of the formation
	// Creates the iconic Galaga wave effect && syncs audio
	controlEnemyFormation();

	// ====================================================================
	// GAME MODE ROUTING: Standard Wave Gameplay vs Challenge Stage
	// ====================================================================
	// global.Game.Challenge.countdown tracks progress toward challenge stages
	// When > 0: Normal gameplay with formations
	// When == 0: Challenge stage (every 4th level)
	if (global.Game.Challenge.isActive) {
		Game_Loop_Challenge();
	}
	else {
		Game_Loop_Standard();
	}
}

/// @function Set_Nebula_Color
/// @description Updates the scrolling nebula background color based on current level
///              Cycles through predefined hue values to create visual variety
/// @return {undefined}
function Set_Nebula_Color(_level) {
	// set the hue mix for the nebula, based on the level
	
	if (global.Game.Controllers.visualEffects.scrollingNebulaFX != -1) 
	{
		if (fx_get_name(global.Game.Controllers.visualEffects.scrollingNebulaFX) == "_filter_hue")
		{
		    fx_set_parameter(global.Game.Controllers.visualEffects.scrollingNebulaFX, "g_HueShift",
								global.Game.Controllers.visualEffects.getCurrentHue(_level));
		}

		// make the nebula visible
		layer_set_visible(global.Game.Controllers.visualEffects.scrollingNebulaLayer, true);
	}
}

/// @function Show_Instructions
/// @description Displays game instructions && handles start game input
///              Supports both gamepad && keyboard input
///              Initializes all game state when player starts game
/// @return {undefined}
function Show_Instructions() {

}
