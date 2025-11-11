/// @file GameManager_STEP_FNs.gml
/// @description Helper functions for game manager operations including initial entry,
///              enemy counting, extra lives, level progression, wave spawning, && formation control

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

/// @function shift_scores_for_new_high_score
/// @description Shifts existing high scores down when a new score qualifies
///              Updates both scores && initials arrays
/// @param {number} position - Where new score ranks (1-5)
/// @param {number} new_score - The new score value
/// @return {undefined}
function shift_scores_for_new_high_score(position, new_score) {
    var idx = position - 1;  // Convert 1-based to 0-based

    // === SHIFT SCORES DOWN ===
    // Move positions (idx+1) through 4 down by one
    for (var i = 4; i > idx; i--) {
        global.Game.HighScores.scores[i] = global.Game.HighScores.scores[i - 1];
        global.Game.HighScores.initials[i] = global.Game.HighScores.initials[i - 1];
    }

    // === INSERT NEW SCORE ===
    global.Game.HighScores.scores[idx] = new_score;
    global.Game.HighScores.initials[idx] = "   ";  // Blank for entry

    // === SYNC DISPLAY ===
    global.Game.HighScores.display = global.Game.HighScores.scores[0];
}

/// @function Enter_Initials
/// @description Handles player input for entering initials on the high score screen
///              Allows navigation through character cycle && selection of characters
///              for high score name entry (3 characters per initial slot)
/// @return {undefined}
function Enter_Initials() {

    // === NAVIGATE LEFT THROUGH CHARACTER CYCLE ===
    if keyboard_check(vk_left) && alarm[AlarmIndex.INPUT_COOLDOWN] == -1 {
        cyc -= 1;  // Move to previous character
        if cyc <= 0 {
            cyc = string_length(cycle); // Wrap to last character
        }
        alarm[AlarmIndex.INPUT_COOLDOWN] = 10; // Input cooldown
    }

    // === NAVIGATE RIGHT THROUGH CHARACTER CYCLE ===
    if keyboard_check(vk_right) && alarm[AlarmIndex.INPUT_COOLDOWN] == -1 {
        cyc += 1; // Move to next character
        if cyc > string_length(cycle) {
            cyc = 1; // Wrap to first character
        }
        alarm[AlarmIndex.INPUT_COOLDOWN] = 10; // Input cooldown
    }

    // === SELECT CHARACTER (SPACE KEY) ===
    if (keyboard_check_pressed(vk_space) && loop > 0 && global.Game.State.results < 5) {

        // Get new character from cycle string
        var _new_char = string_char_at(cycle, cyc);

        // Get the array index (scored is 1-based position, convert to 0-based)
        var pos_idx = scored - 1;

        // Get current initials string for this position
        var current_initials = global.Game.HighScores.initials[pos_idx];

        // Update character at current position (global.Game.HighScores.initials_idx tracks which of 3 characters we're editing)
        global.Game.HighScores.initials_idx = global.Game.State.results - 2;  // 0-based index (0, 1, || 2)
        current_initials = string_delete(current_initials, global.Game.HighScores.initials_idx + 1, 1);
        current_initials = string_insert(_new_char, current_initials, global.Game.HighScores.initials_idx + 1);

        // === UPDATE STRUCT ARRAY ===
        global.Game.HighScores.initials[pos_idx] = current_initials;

        // === MOVE TO NEXT CHARACTER OR FINALIZE ===
        global.Game.State.results += 1;
        cyc = 1;  // Reset character cycle

        if global.Game.State.results == 5 {
            // === ALL 3 CHARACTERS ENTERED ===

            // Get finalized initials && score for this position
            var final_initials = global.Game.HighScores.initials[pos_idx];
            var final_score = global.Game.HighScores.scores[pos_idx];

            // === SAVE TO GMSCOREBOARD ===
            // This persists the score to GMScoreboard backend
            set_score(final_initials, final_score);

            // === ADJUST TIMING ===
            // Speed up transitions if multiple players entered scores
            if loop == 1 {
                alarm[AlarmIndex.SCORE_ENTRY_ADVANCE] -= 2;
            }
            if loop == 2 {
                alarm[AlarmIndex.SCORE_ENTRY_ADVANCE] -= 1;
            }

            loop = 3; // Mark as post-entry phase

            // Longer delay before returning if multiple scorers
            if scored > 1 {
                alarm[AlarmIndex.SCORE_ENTRY_ADVANCE] = 120;
            }
        }
    }
}

/// @function nOfEnemies
/// @description Counts the total number of active enemies using parent object
///              Uses oEnemyBase to automatically include all enemy types
///              This approach scales automatically when new enemy types are added
/// @return {Real} Total count of active enemy instances
function nOfEnemies() {
	// Count all instances of oEnemyBase (includes all enemy types that inherit from it)
	return instance_number(oEnemyBase);
}

/// @function checkForExtraLives
/// @description Awards extra lives to the player based on score thresholds
///              Default: First life at 20,000 points, then every 70,000 points after
///              Stops awarding lives after 1,000,000 points (configurable)
/// @return {undefined}
function checkForExtraLives() {
	// Award extra lives based on score thresholds
	var max_score = get_config_value("SCORE", "MAX_SCORE_FOR_EXTRA_LIVES", MAX_SCORE_FOR_EXTRA_LIVES);
	if global.Game.Player.score > global.Game.Player.firstlife && global.Game.Player.score < max_score {
	    if global.Game.Player.firstlife == EXTRA_LIFE_FIRST_THRESHOLD {
	        global.Game.Player.firstlife = 0; // Reset first life marker
	    }
	    global.Game.Player.firstlife += global.Game.Player.additional; // Set next life threshold
	    sound_play(GLife);       // Play life gained sound
	    global.Game.Player.lives += 1;     // Add a life
	}
}

/// @function readyForNextLevel
/// @description Checks if all conditions are met to advance to the next level
///              Requires: no enemies, nextlevel==0, no open flag, player active
/// @return {Bool} True if transitioning to next level, false otherwise
function readyForNextLevel() {
	//// If no enemies are present && all game conditions are met,
	//// initiate transition to the next level.
	if (alarm[AlarmIndex.LEVEL_ADVANCE] != -1) return true;

	if global.Game.Enemy.count == 0 &&
	    nextlevel == 0 &&
	    global.Game.State.spawnOpen == 0 &&
	    instance_exists(oPlayer) &&
	    oPlayer.shipStatus == ShipState.ACTIVE &&
		global.Game.State.mode == GameMode.GAME_ACTIVE {
		
		
		// trigger oGameManager.alarm[LEVEL_ADVANCE] with nextlevel == 1
		// this is to skip the 'PLAYER 1' message above STAGE 1
		nextlevel = 1;
		// trigger the initial level variables - ie Alarm[LEVEL_ADVANCE] with nextlevel == 1
		alarm[AlarmIndex.LEVEL_ADVANCE] = 1;

		alarm[AlarmIndex.SPAWN_FORMATION_TIMER] = 90; 
				
		return true;
	}
	
	return false;
}

/// @function canTransform
/// @description Checks if an enemy can undergo transformation
///              Breaks down complex transformation conditions into logical groups
///              Must be called from enemy instance context (use with statement)
///
/// TRANSFORMATION CONDITIONS:
///   1. Enemy State: Must be in formation
///   2. Game State: Dive capacity available, no prohibitions, spawning complete
///   3. Player State: Active && vulnerable (!invulnerable || firing)
///   4. Enemy Count: Less than 21 enemies on screen
///   5. Random Chance: 1 in 6 probability
///
/// @return {Bool} True if enemy can transform, false otherwise
function canTransform() {
	// === BASIC STATE CHECKS ===
	// Enemy must be in formation to transform
	var inValidState = (enemyState == EnemyState.IN_FORMATION);

	// === GAME STATE CHECKS ===
	// Game must allow transformations (capacity && no active prohibitions)
	var gameReady = (global.Game.Enemy.diveCapacity > 0) &&
	                (global.Game.State.prohibitDive == 0) &&
	                (global.Game.State.spawnOpen == 0);

	// === PLAYER STATE CHECKS ===
	// Player must be active && vulnerable for transformation to make sense
	var playerVulnerable = instance_exists(oPlayer) &&
	                       (oPlayer.shipStatus == ShipState.ACTIVE) &&
	                       (oPlayer.regain == 0) &&
	                       (oPlayer.alarm[4] == -1);

	// === ENEMY COUNT CHECK ===
	// Don't transform if too many enemies already on screen (performance/balance)
	var notTooManyEnemies = global.Game.Enemy.count < 21;

	// === RANDOM CHANCE ===
	// 1 in 6 chance (approximately 16.7% probability)
	var randomChance = (irandom(5) == 0);

	// All conditions must be met for transformation to occur
	return inValidState && gameReady && playerVulnerable && notTooManyEnemies && randomChance;
}

/// @function checkDiveCapacity
/// @description Calculates && updates the available dive capacity for enemies
///              Limits how many enemies can be diving || attacking simultaneously
///              Checks all enemy types && reduces capacity for active divers
///
/// OPTIMIZATION: Uses loop-based approach to check all enemy types
///               Makes it easy to add new enemy types without code duplication
///
/// @return {undefined}
function checkDiveCapacity() {

    // Reset dive cap to its starting value at the beginning of each frame
    global.Game.Enemy.diveCapacity = global.Game.Enemy.diveCapacityStart;

    // === DIVE CAPACITY CALCULATION ===
    // Check all enemy types in one pass using array iteration
    // An enemy consumes dive capacity if:
    //   1. Not in formation (actively diving/attacking)
    //   2. About to dive (alarm[2] is active)

    var enemy_types = [oTieFighter, oTieIntercepter, oImperialShuttle];

    for (var i = 0; i < array_length(enemy_types); i++) {
        with (enemy_types[i]) {
            if (enemyState != EnemyState.IN_FORMATION || alarm[EnemyAlarmIndex.DIVE_ATTACK] > -1) {
                global.Game.Enemy.diveCapacity -= 1;
            }
        }
    }

    // Boss dive cap handling: maximum of 2 bosses can dive
    global.Game.Enemy.bossCap = 2;
}

/// @function controlEnemyFormation
/// @description Controls the breathing animation && sound for enemy formation
///              Manages the oscillating motion of enemies in formation && syncs
///              the breathing sound effect with visual animation
/// @return {undefined}
function controlEnemyFormation() {
	// Controls breathing motion of a visual/background element && audio

    if global.Game.State.breathing == 0 {
        // Not breathing yet; run animation to transition to breathing

        if exhale == 0 {
            x -= 0.5; // Inhale motion (move object left)
            if x == -48 {
                exhale = 1; // Switch to exhale
                skip = 1;   // Skip one frame on exhale start
            }
        }

        if exhale == 1 && skip == 0 {
            x += 0.5; // Exhale motion (move object right)
            if x == 80 {
                exhale = 0; // Loop back to inhale
            }
        }

        skip = 0;

        if global.Game.State.spawnOpen == 0 {
            if x == 16 {
                global.Game.State.breathing = 1; // Begin breathing animation loop
                exhale = 0;
                sound_stop(GBreathe);
                sound_loop(GBreathe); // Loop breathing sound
            }
        }
    }

    if global.Game.State.breathing == 1 {
        // Active breathing animation && audio logic

        if exhale == 0 {
            global.Game.Enemy.breathePhase += BREATHING_RATE; // Simulate inhale rate
            if round(global.Game.Enemy.breathePhase) >= BREATHING_CYCLE_MAX {
                exhale = 1;
                exit; // Exit breathing update for this frame
            }
        }

        if exhale == 1 {
            global.Game.Enemy.breathePhase -= BREATHING_RATE; // Simulate exhale rate
            if round(global.Game.Enemy.breathePhase) <= 0 {
                exhale = 0;
                sound_stop(GBreathe);
                sound_loop(GBreathe); // Restart breathing sound
                exit;
            }
        }

        // === BREATHING SOUND VOLUME CONTROL ===
        // OPTIMIZATION: Only check sound state && enemy count periodically (every 10 frames)
        // This reduces expensive function calls from 8 per frame to ~0.8 per frame
        // (5 sound checks + 3 instance_number calls are costly)
        if (global.Game.Level.current % 10 == 0) {
            // Check only critical action sounds (dive && beam) at full volume
            var actionSoundPlaying = sound_isplaying(GDive) || sound_isplaying(GBeam);

            // Use cached enemy count instead of 3 instance_number calls
            var enemyCountHigh = global.Game.Enemy.count > global.Game.State.lastAttack;

            if (!actionSoundPlaying && enemyCountHigh) {
                sound_volume(GBreathe, 1); // Play breathing sound at full volume
            } else {
                sound_volume(GBreathe, 0); // Mute if any action sounds playing
            }
        }
    }
}

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
    if (global.Game.Rogue.level < 0 || global.Game.Rogue.level >= array_length(rogue_config.ROGUE_LEVELS)) {
        log_error("Invalid rogue level index: " + string(global.Game.Rogue.level), "nRogueEnemies", 2);
        return 0;
    }

    var rogue_level_data = rogue_config.ROGUE_LEVELS[global.Game.Rogue.level];

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
/// @param {Real} _spawn The spawn index in the wave data
/// @param {Real} _depth Current recursion depth (optional, default 0)
/// @return {undefined}
function spawnRogueEnemy(_spawn, _depth = 0) {
	// === RECURSION DEPTH LIMIT ===
	// Prevent stack overflow from malformed JSON with infinite COMBINE chains
	// Max depth of 16 allows for reasonable paired spawning while preventing crashes
	var MAX_ROGUE_SPAWN_DEPTH = 16;
	if (_depth > MAX_ROGUE_SPAWN_DEPTH) {
		log_error("spawnRogueEnemy exceeded max recursion depth (" + string(MAX_ROGUE_SPAWN_DEPTH) + ")", "spawnRogueEnemy", 2);
		return;
	}

	// === BOUNDS CHECKING ===
	// Verify spawn index is within valid range
	var spawn_array = spawn_data.PATTERN[global.Game.Level.pattern].WAVE[global.Game.Level.wave].SPAWN;
	if (_spawn < 0 || _spawn >= array_length(spawn_array)) {
		log_error("spawnRogueEnemy spawn index out of bounds: " + string(_spawn), "spawnRogueEnemy", 2);
		return;
	}

	// Get the enemy data from a specific SPAWN instance
	var enemy_data = spawn_array[_spawn];

	// SPAWN a ROGUE Enemy, create path using the STANDARD path && prefix "ROGUE_"
	var path_name = "ROGUE_" + enemy_data.PATH;
	var enemy_id = safe_get_asset(enemy_data.ENEMY, -1);
	if (enemy_id != -1) {
		instance_create_layer(enemy_data.SPAWN_XPOS, enemy_data.SPAWN_YPOS, "GameSprites", enemy_id,
															{ ENEMY_NAME: enemy_data.ENEMY, INDEX: -1, PATH_NAME: path_name, MODE: "ROGUE" });
	} else {
		log_error("Failed to spawn rogue enemy: " + enemy_data.ENEMY, "spawnRogueEnemy", 2);
	}

	// is this a combination spawn, ie 2 enemies side by side?
	if (enemy_data.COMBINE) {
		// spawn another enemy in-sync with the current spawn cycle
		// Pass increased depth to track recursion level
		spawnRogueEnemy(_spawn + 1, _depth + 1);
	}
}

/// @function spawnRogueEnemies
/// @description Spawns multiple rogue enemies for the current wave
/// @param {Real} _nRogues Number of rogue enemies to spawn
/// @return {undefined}
function spawnRogueEnemies(_nRogues) {

	// loop to SPAWN _nRogues (and check for a COMBINATION SPAWN)
	for (var i=0; i < _nRogues; i++ ) {
		spawnRogueEnemy(global.Game.Spawn.counter-2);
	}
}

/// @function spawnEnemy
/// @description Spawns a standard enemy using data from wave_spawn.json
///              Automatically handles combination spawns (paired enemies)
///              Increments the global spawn counter after spawning
/// @return {undefined}
function spawnEnemy() {
	var enemy_data = spawn_data.PATTERN[global.Game.Level.pattern].WAVE[global.Game.Level.wave].SPAWN[global.Game.Spawn.counter];
				
	// enemy_data: eg
	// ENEMY		"oTieFighter"
	// PATH			"Ent1e1"
	// SPAWN_XPOS	512
	// SPAWN YPOS	-16
	// INDEX		1
	// COMBINE		true/false
	
	// SPAWN a STANDARD Enemy with error checking
	var enemy_id = safe_get_asset(enemy_data.ENEMY, -1);
	if (enemy_id != -1) {
		instance_create_layer(enemy_data.SPAWN_XPOS, enemy_data.SPAWN_YPOS, "GameSprites", enemy_id,
															{ ENEMY_NAME: enemy_data.ENEMY, INDEX: enemy_data.INDEX, PATH_NAME: enemy_data.PATH, MODE: "STANDARD" });
	} else {
		log_error("Failed to spawn standard enemy: " + enemy_data.ENEMY, "spawnEnemy", 2);
	}
	
	// advance the enemy spawn counter
	global.Game.Spawn.counter++;
	
	// is this a comination spawn, ie 2 enemies side by side?
	if (enemy_data.COMBINE) {
		// spawn another enemy in-sync with the current spawn cycle
		spawnEnemy();
	}
}

/// @function waveComplete
/// @description Checks if all enemies in the current wave have been spawned
/// @return {Bool} True if all spawn indices have been processed
function waveComplete() {

	return (global.Game.Spawn.counter == array_length(spawn_data.PATTERN[global.Game.Level.pattern].WAVE[global.Game.Level.wave].SPAWN));
}

/// @function patternComplete
/// @description Checks if all waves in the current pattern have been completed
/// @return {Bool} True if all waves in pattern are done
function patternComplete() {

	return (global.Game.Level.wave == array_length(spawn_data.PATTERN[global.Game.Level.pattern].WAVE));
}

/// @function getChallengeData
/// @description Retrieves challenge stage data for the current challenge number
///              Note: global.Game.Challenge.current is 1-indexed (1-8), array is 0-indexed
/// @return {Struct} Challenge data structure with paths && wave information
function getChallengeData() {
	// Get the challenge data for the current challenge (global.Game.Challenge.current is 1-8)
	// Array is 0-indexed, so subtract 1
	return challenge_data.CHALLENGES[global.Game.Challenge.current - 1];
}

/// @function getChallengeWaveData
/// @description Retrieves wave data for the current wave in the current challenge
/// @return {Struct} Wave data structure with enemy type && spawn settings
function getChallengeWaveData() {
	// Get the wave data for the current wave in the current challenge
	var chall_data = getChallengeData();
	return chall_data.WAVES[global.Game.Level.wave];
}

/// @function spawnChallengeEnemy
/// @description Spawns a challenge stage enemy based on current wave && challenge
///              Handles wave-specific path selection && enemy alternation
///              Used for challenge stage-specific spawning logic
/// @return {undefined}
function spawnChallengeEnemy() {
	var chall_data = getChallengeData();
	var wave_data = getChallengeWaveData();
	var enemy_name = wave_data.ENEMY;
	var enemy_id = asset_get_index(enemy_name);

	if (enemy_id == -1) {
		log_error("Could not find enemy: " + enemy_name, "spawnChallengeEnemy", 2);
		return;
	}

	// Determine which path to use based on wave && count
	var path_name = "";
	var spawn_x = 0;
	var spawn_y = 0;

	// Wave 0, 3, 4 use path1/path1flip
	if (global.Game.Level.wave == 0 ||
	    (global.Game.Level.wave == 3 && global.Game.Challenge.current != 1 && global.Game.Challenge.current != 6 && global.Game.Challenge.current != 7) ||
	    (global.Game.Level.wave == 4 && (global.Game.Challenge.current == 1 || global.Game.Challenge.current == 6 || global.Game.Challenge.current == 7))) {
		path_name = chall_data.PATH1;
		var path_id = safe_get_asset(path_name);
		if (path_id != -1) {
			spawn_x = path_get_x(path_id, 0) ;
			spawn_y = path_get_y(path_id, 0) ;
		} else {
			log_error("Challenge path not found: " + path_name, "spawnChallengeEnemy", 2);
		}
	}
	// Wave 1 uses path2 (alternating enemy types handled below)
	else if (global.Game.Level.wave == 1) {
		path_name = chall_data.PATH2;
		var path_id = safe_get_asset(path_name);
		if (path_id != -1) {
			spawn_x = path_get_x(path_id, 0) ;
			spawn_y = path_get_y(path_id, 0) ;
		} else {
			log_error("Challenge path not found: " + path_name, "spawnChallengeEnemy", 2);
		}
	}
	// Wave 2 uses path2flip
	else if (global.Game.Level.wave == 2) {
		path_name = chall_data.PATH2_FLIP;
		var path_id = safe_get_asset(path_name);
		if (path_id != -1) {
			spawn_x = path_get_x(path_id, 0) ;
			spawn_y = path_get_y(path_id, 0) ;
		} else {
			log_error("Challenge path not found: " + path_name, "spawnChallengeEnemy", 2);
		}
	}
	// Wave 4 || 3 (depending on challenge) use path1flip
	else if ((global.Game.Level.wave == 4 && global.Game.Challenge.current != 1 && global.Game.Challenge.current != 6 && global.Game.Challenge.current != 7) ||
	         (global.Game.Level.wave == 3 && (global.Game.Challenge.current == 1 || global.Game.Challenge.current == 6 || global.Game.Challenge.current == 7))) {
		path_name = chall_data.PATH1_FLIP;
		var path_id = safe_get_asset(path_name);
		if (path_id != -1) {
			spawn_x = path_get_x(path_id, 0) ;
			spawn_y = path_get_y(path_id, 0) ;
		} else {
			log_error("Challenge path not found: " + path_name, "spawnChallengeEnemy", 2);
		}
	}

	// For wave 1, alternate between primary enemy && TieFighter based on count
	if (global.Game.Level.wave == 1) {
		if (count == 1 || count == 3 || count == 5 || count == 7) {
			// Use TieFighter instead of the wave's enemy for odd counts
			enemy_id = asset_get_index("oTieFighter");
		}
	}

	// Spawn the enemy
	instance_create_layer(spawn_x, spawn_y, "GameSprites", enemy_id,
	                      { ENEMY_NAME: object_get_name(enemy_id), INDEX: -1, PATH_NAME: path_name, MODE: "CHALLENGE" });
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
		// alarm[2] controls delay between spawns (WAVE_SPAWN_DELAY = 9 frames)
		// When alarm[2] == -1, spawn timer is inactive && we can spawn
		if (alarm[2] == -1) {

			// === PHASE 1: SPAWN STANDARD ENEMIES ===
			if (!waveComplete()) {
				// Wave still has enemies to spawn
				// spawnEnemy() reads next spawn from wave_spawn.json
				// Automatically handles COMBINE flag for paired spawns
				spawnEnemy();
			}
			// === PHASE 2: ADD ROGUE ENEMIES ===
			else if (!global.Game.Rogue.checkPerWave) {
				// Wave spawning complete, now check for rogue enemies
				// Rogues are special enemies that don't join formation
				// They target the player directly after entrance path

				var nRogue = nRogueEnemies(); // Get rogue count from rogue_spawn.json
				if (nRogue > 0) {
					spawnRogueEnemies(nRogue);
				}

				global.Game.Rogue.checkPerWave = true; // Mark rogues as spawned for this wave
			}

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

				// Reset spawn counter for next wave
				global.Game.Spawn.counter = 0;

				// Advance to the next WAVE within this pattern
	            global.Game.Level.wave += 1;
				global.Game.Rogue.checkPerWave = false; // Reset rogue flag for next wave
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

/// @function spawnChallengeWave_0_3_4
/// @description Spawns doubled enemies for challenge waves 0, 3, && 4 using PATH1/PATH1_FLIP
/// @param {Struct} chall_data Challenge pattern data with path names
/// @param {Struct} wave_data Current wave data with enemy type
/// @return {undefined}
function spawnChallengeWave_0_3_4(chall_data, wave_data) {
	// Spawn two enemies on mirrored paths
	var path1_id = safe_get_asset(chall_data.PATH1, -1);
	var path1flip_id = safe_get_asset(chall_data.PATH1_FLIP, -1);
	var enemy_id = safe_get_asset(wave_data.ENEMY, -1);

	if (path1_id != -1 && path1flip_id != -1 && enemy_id != -1) {
		instance_create_layer(path_get_x(path1_id, 0), path_get_y(path1_id, 0),
							"GameSprites", enemy_id, { ENEMY_NAME: wave_data.ENEMY, INDEX: -1, PATH_NAME: chall_data.PATH1, MODE: "CHALLENGE" });
		instance_create_layer(path_get_x(path1flip_id, 0), path_get_y(path1flip_id, 0),
							"GameSprites", enemy_id, { ENEMY_NAME: wave_data.ENEMY, INDEX: -1, PATH_NAME: chall_data.PATH1_FLIP, MODE: "CHALLENGE" });
	} else {
		if (enemy_id == -1) log_error("Challenge enemy not found: " + wave_data.ENEMY, "spawnChallengeWave_0_3_4", 2);
		if (path1_id == -1) log_error("Challenge path1 not found: " + chall_data.PATH1, "spawnChallengeWave_0_3_4", 2);
		if (path1flip_id == -1) log_error("Challenge path1_flip not found: " + chall_data.PATH1_FLIP, "spawnChallengeWave_0_3_4", 2);
	}
	alarm[AlarmIndex.SPAWN_DELAY] = CHALLENGE_SPAWN_DELAY;
}

/// @function spawnChallengeWave_1
/// @description Spawns doubled enemies for challenge wave 1 using PATH2/PATH2_FLIP
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

	if (path2_id != -1 && path2flip_id != -1 && enemy1_id != -1 && enemy2_id != -1) {
		instance_create_layer(path_get_x(path2_id, 0), path_get_y(path2_id, 0),
							"GameSprites", enemy1_id, { ENEMY_NAME: wave_data.ENEMY, INDEX: -1, PATH_NAME: chall_data.PATH2, MODE: "CHALLENGE" });
		instance_create_layer(path_get_x(path2flip_id, 0), path_get_y(path2flip_id, 0),
							"GameSprites", enemy2_id, { ENEMY_NAME: "oTieFighter", INDEX: -1, PATH_NAME: chall_data.PATH2_FLIP, MODE: "CHALLENGE" });
	} else {
		if (enemy1_id == -1) log_error("Challenge wave 1 enemy not found: " + wave_data.ENEMY, "spawnChallengeWave_1", 2);
		if (enemy2_id == -1) log_error("Challenge wave 1 TieFighter not found", "spawnChallengeWave_1", 2);
		if (path2_id == -1) log_error("Challenge wave 1 path2 not found: " + chall_data.PATH2, "spawnChallengeWave_1", 2);
		if (path2flip_id == -1) log_error("Challenge wave 1 path2_flip not found: " + chall_data.PATH2_FLIP, "spawnChallengeWave_1", 2);
	}
	alarm[AlarmIndex.SPAWN_DELAY] = CHALLENGE_SPAWN_DELAY;
}

/// @function spawnChallengeWave_2
/// @description Spawns doubled enemies for challenge wave 2 using PATH2/PATH2_FLIP
/// @param {Struct} chall_data Challenge pattern data with path names
/// @param {Struct} wave_data Current wave data with enemy type
/// @return {undefined}
function spawnChallengeWave_2(chall_data, wave_data) {
	// Spawn mirrored enemies
	var path2_id = safe_get_asset(chall_data.PATH2, -1);
	var path2flip_id = safe_get_asset(chall_data.PATH2_FLIP, -1);
	var enemy_id = safe_get_asset(wave_data.ENEMY, -1);

	if (path2_id != -1 && path2flip_id != -1 && enemy_id != -1) {
		instance_create_layer(path_get_x(path2_id, 0), path_get_y(path2_id, 0),
							"GameSprites", enemy_id, { ENEMY_NAME: wave_data.ENEMY, INDEX: -1, PATH_NAME: chall_data.PATH2, MODE: "CHALLENGE" });
		instance_create_layer(path_get_x(path2flip_id, 0), path_get_y(path2flip_id, 0),
							"GameSprites", enemy_id, { ENEMY_NAME: wave_data.ENEMY, INDEX: -1, PATH_NAME: chall_data.PATH2_FLIP, MODE: "CHALLENGE" });
	} else {
		if (enemy_id == -1) log_error("Challenge wave 2 enemy not found: " + wave_data.ENEMY, "spawnChallengeWave_2", 2);
		if (path2_id == -1) log_error("Challenge wave 2 path2 not found: " + chall_data.PATH2, "spawnChallengeWave_2", 2);
		if (path2flip_id == -1) log_error("Challenge wave 2 path2_flip not found: " + chall_data.PATH2_FLIP, "spawnChallengeWave_2", 2);
	}
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
	// Challenge stages occur every 4 levels (when global.Game.Challenge.count reaches 0)
	// Different spawning logic: 8 enemies per wave, 5 waves total = 40 enemies
	// Enemies follow looping paths && don't form into grid

	// Only proceed if we're within valid wave range, alarm is inactive, && !transitioning to next level
    if (global.Game.Level.wave < CHALLENGE_TOTAL_WAVES && alarm[AlarmIndex.SPAWN_DELAY] == -1 && nextlevel == 0) {

        if (count < CHALLENGE_ENEMIES_PER_WAVE) {  // Only spawn if current wave hasn't reached full enemy count

            var chall_data = getChallengeData();
            var wave_data = getChallengeWaveData();

            // === PATH SHIFTING FOR CHALLENGE 4 ===
            // Special case: Challenge 4, Wave 4 shifts paths right for visual variety
            if (global.Game.Challenge.current == 4 && global.Game.Level.wave == 4) {
                var path1_id = safe_get_asset(chall_data.PATH1, -1);
                if (path1_id != -1 && path_get_x(path1_id, 0) == 192) {
                    var path1flip_id = safe_get_asset(chall_data.PATH1_FLIP, -1);
                    if (path1flip_id != -1) {
                        // Shift paths right by 64 pixels
                        path_shift(path1_id, 64*global.Game.Display.scale, 0);
                        path_shift(path1flip_id, 64*global.Game.Display.scale, 0);
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
}

/// @function Game_Loop
/// @description Main game loop orchestrator - routes to appropriate game mode
///              Handles common logic then delegates to mode-specific functions
///
/// ARCHITECTURE:
/// This function handles TWO distinct game modes:
///   1. STANDARD MODE (global.Game.Challenge.count > 0): Regular wave-based gameplay
///      - Spawns 40 enemies per wave from wave_spawn.json
///      - Enemies form into 5x8 grid formation
///      - Includes rogue enemy spawning between waves
///
///   2. CHALLENGE MODE (global.Game.Challenge.count == 0): Bonus stages every 4 levels
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
	if (global.Game.State.isPaused || oPlayer.shipStatus != ShipState.ACTIVE) return;
	if (readyForNextLevel()) return;

	// === EXTRA LIVES ===
	// Award extra lives at score milestones (20k, then every 70k)
	checkForExtraLives();

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
	// global.Game.Challenge.count tracks progress toward challenge stages
	// When > 0: Normal gameplay with formations
	// When == 0: Challenge stage (every 4th level)

	if (global.Game.Challenge.count > 0) {
		Game_Loop_Standard();
	} else {
		Game_Loop_Challenge();
	}
}

/// @function Set_Nebula_Color
/// @description Updates the scrolling nebula background color based on current level
///              Cycles through predefined hue values to create visual variety
/// @return {undefined}
function Set_Nebula_Color() {
	// change the hue mix for the nebula
	if (scrolling_nebula_bg != -1) 
	{
		var layer_fx = layer_get_fx(scrolling_nebula_bg);
   
		if (layer_fx != -1)
		{
			if (fx_get_name(layer_fx) == "_filter_hue")
			{
				// background color based on Level, wrap around array length of pre-set colors
			    fx_set_parameter(layer_fx, "g_HueShift", global.Game.Level.current % array_length(hue_value));
			}
		}		
		// make the nebula visible
		layer_set_visible(scrolling_nebula_bg, true);
	}
}

/// @function Show_Instructions
/// @description Displays game instructions && handles start game input
///              Supports both gamepad && keyboard input
///              Initializes all game state when player starts game
/// @return {undefined}
function Show_Instructions() {

}

