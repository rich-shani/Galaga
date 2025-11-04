/// @file GameManager_STEP_FNs.gml
/// @description Helper functions for game manager operations including initial entry,
///              enemy counting, extra lives, level progression, wave spawning, and formation control

/// @function init_globals
/// @description Initializes all global game variables used throughout the application
///              This centralizes global state initialization for better maintainability
///              Should be called once in oGameManager Create event before any other initialization
/// @return {undefined}
function init_globals() {
    // === DEBUG MODE ===
    global.debug = false; // Debug mode flag (set to true for debug output)

    // === ROOM AND DISPLAY SETTINGS ===
    global.roomname = "GalagaWars"; // Current room name (can be "GalagaWars", "Galaga", "Galaga2")

    // Scale the system based on the room mode
    global.scale = 1; // Default scale
    if (global.roomname == "GalagaWars") {
        global.scale = 2; //SCALE_GALAGA_WARS; // 2x scale for Star Wars theme
    } else {
        global.scale = 1; //SCALE_GALAGA_ORIGINAL; // 1x scale for original Galaga
    }

    // Screen dimensions
    global.screen_width = view_get_wport(view_current);
    global.screen_height = view_get_hport(view_current);

    // Global variable to determine if we have applied the path scaler already
    // ie on a game restart, we don't want to re-scale again all the path data
    global.scalePath = false;

    // === HIGH SCORES ===
    // Top 5 high scores, initialized to 0
    global.galaga1 = 0; // First place
    global.galaga2 = 0; // Second place
    global.galaga3 = 0; // Third place
    global.galaga4 = 0; // Fourth place
    global.galaga5 = 0; // Fifth place

    // High score initials (3 characters each)
    global.init1 = "AA "; // First place initials
    global.init2 = "BB "; // Second place initials
    global.init3 = "CC "; // Third place initials
    global.init4 = "DD "; // Fourth place initials
    global.init5 = "EE "; // Fifth place initials

    // Displayed high score
    global.disp = 0;

    // === PLAYER STATE ===
    global.p1score = 0; // Player 1's current score
    global.p1lives = get_config_value("PLAYER", "STARTING_LIVES", 3); // Player lives
    global.credits = 0; // Number of game credits (coins entered)

    // Shot tracking
    global.shotcount = 0; // Shots fired in current wave
    global.shottotal = 0; // Total shots fired

    // === GAME STATE ===
    global.gameMode = GameMode.INITIALIZE; // Initial game mode
    global.isGameOver = false; // Game over flag
    global.isGamePaused = false; // Pause state flag
	global.isPlayerCaptured = false;
	
    // === LEVEL/WAVE PROGRESSION ===
    global.lvl = 0; // Current level
    global.wave = 0; // Current wave within level
    global.stage = 0; // Current stage
    global.pattern = 0; // Current spawn pattern
    global.spawnCounter = 0; // Tracks current spawn index

    // === CHALLENGE STAGE ===
    global.isChallengeStage = false; // Is currently in challenge stage
    global.chall = 0; // Current challenge number (1-8)
    global.challcount = 1; // Counter for challenge stage progression
    global.nLvls2ChallengeStage = get_config_value("CHALLENGE_STAGES", "INTERVAL_LEVELS", CHALLENGE_INTERVAL_LEVELS);

    // === ENEMY BEHAVIOR ===
    global.flip = 0; // Sprite/screen flip control
    global.animationIndex = 0; // Animation frame index

    // Dive and attack capacity
    global.divecap = get_config_value("ENEMIES", "MAX_DIVE_CAP", 2); // Current dive capacity
    global.divecapstart = get_config_value("ENEMIES", "DIVE_CAP_START", 2); // Starting dive capacity
    global.bosscap = get_config_value("ENEMIES", "MAX_BOSS_DIVE_CAP", 2); // Boss dive capacity

    // Enemy state flags
    global.open = 0; // Open flag for wave spawning
    global.breathing = 1; // Breathing animation state
    global.breathe = 0; // Breathing cycle position
    global.prohib = 0; // Prohibit dive flag
    global.transform = 0; // Transformation state
    global.beamcheck = 0; // Boss beam check
    global.transcount = 0; // Transformation counter
    global.escortcount = 0; // Escort enemy counter
    global.fighterstore = 0; // Stored fighter count
    global.bosscount = 1; // Boss counter

    // Rogue enemy settings
    global.rogue = 0; // Rogue level
    global.checkRoguePerWave = false; // Check rogue spawn per wave

    // Speed and timing
    global.fast = 0; // Fast mode flag
    global.fastenter = 0; // Fast entry flag
    global.entershot = 0; // Entry shot flag
    global.transnum = 0; // Transformation number
    global.hold = 15; // Hold time
    global.beamtime = 300; // Beam duration
    global.shotnumber = 2; // Number of shots
    global.lastattack = 4; // Last attack threshold

    // === DIFFICULTY SCALING ===
    global.speedMultiplier = get_config_value("DIFFICULTY", "SPEED_MULTIPLIER_BASE", 1.0);

    // === VISUAL SETTINGS ===
    global.ArcadeSprites = true; // Use arcade-style sprites
    global.ArcadeSpritesPrefix = "OG_"; // Prefix for arcade sprite names
    global.enemy_animation_speed = 0; // Enemy animation speed modifier

    // === RESULT TRACKING ===
    global.results = 0; // Results display flag

    show_debug_message("Global variables initialized successfully");
}

/// @function Enter_Initials
/// @description Handles player input for entering initials on the high score screen
///              Allows navigation through character cycle and selection of characters
///              for high score name entry
/// @return {undefined}
function Enter_Initials(){
    // === NAVIGATE LEFT THROUGH CHARACTER CYCLE ===
    if keyboard_check(vk_left) and alarm[AlarmIndex.INPUT_COOLDOWN] == -1 {
        cyc -= 1;  // Move to previous character in the 'cycle' string
        if cyc == 0 {
            cyc = string_length(cycle); // Wrap around to last character if we go before the first
        }
        alarm[AlarmIndex.INPUT_COOLDOWN] = 10; // Cooldown to prevent rapid input (10 frames)
    }

    // === NAVIGATE RIGHT THROUGH CHARACTER CYCLE ===
    if keyboard_check(vk_right) and alarm[AlarmIndex.INPUT_COOLDOWN] == -1 {
        cyc += 1; // Move to next character in the 'cycle' string
        if cyc == string_length(cycle) + 1 {
            cyc = 1; // Wrap around to first character if we go past the end
        }
        alarm[AlarmIndex.INPUT_COOLDOWN] = 10; // Cooldown to prevent rapid input
    }

    // === SELECT CURRENT CHARACTER ===
    if keyboard_check_pressed(vk_space) and loop > 0 and global.results < 5 {

        // The 'scored' variable determines which player’s initials are being entered (1 to 5)
		var _initials = "";
		var _score = 0;
		
        if scored == 1 {
            // Replace character at current position in init1
            global.init1 = string_delete(global.init1, char + 1, 1); // Remove old character
            global.init1 = string_insert(string_char_at(cycle, cyc), global.init1, char + 1); // Insert new
			_initials = global.init1;
			_score = global.galaga1;
        }

        if scored == 2 {
            global.init2 = string_delete(global.init2, char + 1, 1);
            global.init2 = string_insert(string_char_at(cycle, cyc), global.init2, char + 1);
			_initials = global.init2;
			_score = global.galaga2;
        }

        if scored == 3 {
            global.init3 = string_delete(global.init3, char + 1, 1);
            global.init3 = string_insert(string_char_at(cycle, cyc), global.init3, char + 1);
			_initials = global.init3;
			_score = global.galaga3;
        }

        if scored == 4 {
            global.init4 = string_delete(global.init4, char + 1, 1);
            global.init4 = string_insert(string_char_at(cycle, cyc), global.init4, char + 1);
			_initials = global.init4;
			_score = global.galaga4;
        }

        if scored == 5 {
            global.init5 = string_delete(global.init5, char + 1, 1);
            global.init5 = string_insert(string_char_at(cycle, cyc), global.init5, char + 1);
			_initials = global.init5;
			_score = global.galaga5;
        }

        global.results += 1; // Move to the next character position or scorer
        cyc = 1;      // Reset cycle index to first character

        // === FINALIZE NAME ENTRY ===
        if global.results == 5 {
			// save score in the GM scoreboard
			set_score(_initials, _score);
	
            // Adjust timer to move to next screen or scorer
            if loop == 1 {
                alarm[AlarmIndex.SCORE_ENTRY_ADVANCE] -= 2;
            }
            if loop == 2 {
                alarm[AlarmIndex.SCORE_ENTRY_ADVANCE] -= 1;
            }
            loop = 3; // Set to end loop state (post-entry phase)

            if scored > 1 {
                alarm[AlarmIndex.SCORE_ENTRY_ADVANCE] = 120; // Longer delay if more than one player is entering initials
            }
        }
    }

    // Track which character in the name is currently being edited
    char = global.results - 2;
}

/// @function nOfEnemies
/// @description Counts the total number of active enemies across all enemy types
///              Includes: Bee, TieFighter, TieIntercepter, ImperialShuttle, Butterfly, Boss, Fighter, Transform
/// @return {Real} Total count of active enemy instances
function nOfEnemies() {
	// return the total number of active enemies (all enemies)
	return instance_number(Bee) + instance_number(oTieFighter) + instance_number(oTieIntercepter) + instance_number(oImperialShuttle) +
			instance_number(Butterfly) + instance_number(Boss) + instance_number(Fighter) + instance_number(Transform);
}

/// @function checkForExtraLives
/// @description Awards extra lives to the player based on score thresholds
///              Default: First life at 20,000 points, then every 70,000 points after
///              Stops awarding lives after 1,000,000 points (configurable)
/// @return {undefined}
function checkForExtraLives() {
	// Award extra lives based on score thresholds
	var max_score = get_config_value("SCORE", "MAX_SCORE_FOR_EXTRA_LIVES", MAX_SCORE_FOR_EXTRA_LIVES);
	if global.p1score > firstlife and global.p1score < max_score {
	    if firstlife == 20000 {
	        firstlife = 0; // Reset first life marker
	    }
	    firstlife += additional; // Set next life threshold
	    sound_play(GLife);       // Play life gained sound
	    global.p1lives += 1;     // Add a life
	}
}

/// @function readyForNextLevel
/// @description Checks if all conditions are met to advance to the next level
///              Requires: no enemies, nextlevel==0, no open flag, player active
/// @return {Bool} True if transitioning to next level, false otherwise
function readyForNextLevel() {
	//// If no enemies are present and all game conditions are met,
	//// initiate transition to the next level.
	if (alarm[AlarmIndex.LEVEL_ADVANCE] != -1) return true;
	
	if nOfEnemies() == 0 &&
	    nextlevel == 0 &&
	    global.open == 0 &&
	    oPlayer.shipStatus == _ShipState.ACTIVE &&
		global.gameMode == GameMode.GAME_ACTIVE {
		
		
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

/// @function checkDiveCapacity
/// @description Calculates and updates the available dive capacity for enemies
///              Limits how many enemies can be diving or attacking simultaneously
///              Checks all enemy types and reduces capacity for active divers
/// @return {undefined}
function checkDiveCapacity() {

    // Reset dive cap to its starting value at the beginning of each frame
    global.divecap = global.divecapstart;

    // Decrease dive capacity based on current state of enemy units

    with Bee {
        if dive == 1  or alarm[2] > -1 {
            global.divecap -= 1; // Bees actively diving or about to dive
        }
    }

    with oTieFighter {
        if enemyState != EnemyState.IN_FORMATION or alarm[2] > -1 {
            global.divecap -= 1; // TieFighters actively diving or about to dive
        }
    }

    with oTieIntercepter {
        if enemyState != EnemyState.IN_FORMATION or alarm[2] > -1 {
            global.divecap -= 1; // TieIntercepters actively diving or about to dive
        }
    }

    with oImperialShuttle {
        if enemyState != EnemyState.IN_FORMATION or alarm[2] > -1 {
            global.divecap -= 1; // ImperialShuttles actively diving or about to dive
        }
    }
	
    with Butterfly {
        if dive == 1  or alarm[2] > -1 {
            global.divecap -= 1; // Butterflies actively diving or about to dive
        }
    }

    with Boss {
        if dive == 1 {
            global.divecap -= 1; // Bosses currently diving
        }
    }

    with Fighter {
        if dive == 1 and check == 0 {
            global.divecap -= 1; // Fighters diving that haven't been marked as checked
        }
    }

    with Transform {
        global.divecap -= 1; // Transforming entities reduce available dive capacity
    }

    // Boss dive cap handling: maximum of 2 bosses can dive
    global.bosscap = 2;
    with Boss {
        if dive == 1 {
            global.bosscap -= 1;
        }
    }
}

/// @function controlEnemyFormation
/// @description Controls the breathing animation and sound for enemy formation
///              Manages the oscillating motion of enemies in formation and syncs
///              the breathing sound effect with visual animation
/// @return {undefined}
function controlEnemyFormation() {
	// Controls breathing motion of a visual/background element and audio

    if global.breathing == 0 {
        // Not breathing yet; run animation to transition to breathing

        if exhale == 0 {
            x -= 0.5; // Inhale motion (move object left)
            if x == -48 {
                exhale = 1; // Switch to exhale
                skip = 1;   // Skip one frame on exhale start
            }
        }

        if exhale == 1 and skip == 0 {
            x += 0.5; // Exhale motion (move object right)
            if x == 80 {
                exhale = 0; // Loop back to inhale
            }
        }

        skip = 0;

        if global.open == 0 {
            if x == 16 {
                global.breathing = 1; // Begin breathing animation loop
                exhale = 0;
                sound_stop(GBreathe);
                sound_loop(GBreathe); // Loop breathing sound
            }
        }
    }

    if global.breathing == 1 {
        // Active breathing animation and audio logic

        if exhale == 0 {
            global.breathe += 0.946969697; // Simulate inhale rate
            if round(global.breathe) == 120 {
                exhale = 1;
                exit; // Exit breathing update for this frame
            }
        }

        if exhale == 1 {
            global.breathe -= 0.946969697; // Simulate exhale rate
            if round(global.breathe) == 0 {
                exhale = 0;
                sound_stop(GBreathe);
                sound_loop(GBreathe); // Restart breathing sound
                exit;
            }
        }

        // Adjust breathing sound volume based on gameplay state
        if !sound_isplaying(GDive)
        && !sound_isplaying(GBeam)
        && !sound_isplaying(GCaptured)
        && !sound_isplaying(GFighterCaptured)
        && !sound_isplaying(GRescue)
        && (instance_number(Bee) + instance_number(oTieFighter) + instance_number(oTieIntercepter) + instance_number(oImperialShuttle) + instance_number(Butterfly) + instance_number(Boss) > global.lastattack)
        {
            sound_volume(GBreathe, 1); // Play breathing sound at full volume
        } else {
            sound_volume(GBreathe, 0); // Mute if any action sounds playing
        }
    }
}

/// @function load_json_datafile
/// @description Generic JSON file loader for game data files with error handling
/// @param {String} _datafile Path to the JSON data file (relative to game directory)
/// @param {Struct} _default Default value to return if loading fails (default: undefined)
/// @return {Struct} Parsed JSON data structure, default value if file not found or parse error
function load_json_datafile(_datafile, _default = undefined) {
	// Use safe JSON loading utility
	return safe_load_json(_datafile, _default);	
}

/// @function nRogueEnemies
/// @description Returns the number of rogue enemies to spawn for current level and wave
///              Uses rogue_config data loaded from rogue_spawn.json
/// @return {Real} Number of rogue enemies to spawn
function nRogueEnemies() {
    // Get spawn count for current rogue level and wave
    var rogue_level_data = rogue_config.ROGUE_LEVELS[global.rogue];
    return rogue_level_data.SPAWN_COUNT[global.wave];
}

/// @function spawnRogueEnemy
/// @description Spawns a single rogue enemy using ROGUE_ prefixed paths
///              Handles combination spawns (paired enemies) recursively
/// @param {Real} _spawn The spawn index in the wave data
/// @return {undefined}
function spawnRogueEnemy(_spawn) {
	// Get the enemy data from a specific SPAWN instance
	var enemy_data = spawn_data.PATTERN[global.pattern].WAVE[global.wave].SPAWN[_spawn];
	
	
	// SPAWN a ROGUE Enemy, create path using the STANDARD path and prefix "ROGUE_"
	var path_name = "ROGUE_" + enemy_data.PATH;
	var enemy_id = safe_get_asset(enemy_data.ENEMY, -1);
	if (enemy_id != -1) {
		instance_create_layer(enemy_data.SPAWN_XPOS, enemy_data.SPAWN_YPOS, "GameSprites", enemy_id,
															{ ENEMY_NAME: enemy_data.ENEMY, INDEX: -1, PATH_NAME: path_name, MODE: "ROGUE" });
	} else {
		log_error("Failed to spawn rogue enemy: " + enemy_data.ENEMY, "spawnRogueEnemy", 2);
	}
	
	// is this a comination spawn, ie 2 enemies side by side?
	if (enemy_data.COMBINE) {
		// spawn another enemy in-sync with the current spawn cycle
		spawnRogueEnemy(_spawn+1);
	}
}

/// @function spawnRogueEnemies
/// @description Spawns multiple rogue enemies for the current wave
/// @param {Real} _nRogues Number of rogue enemies to spawn
/// @return {undefined}
function spawnRogueEnemies(_nRogues) {

	// loop to SPAWN _nRogues (and check for a COMBINATION SPAWN)
	for (var i=0; i < _nRogues; i++ ) {
		spawnRogueEnemy(global.spawnCounter-2);
	}
}

/// @function spawnEnemy
/// @description Spawns a standard enemy using data from wave_spawn.json
///              Automatically handles combination spawns (paired enemies)
///              Increments the global spawn counter after spawning
/// @return {undefined}
function spawnEnemy() {
	var enemy_data = spawn_data.PATTERN[global.pattern].WAVE[global.wave].SPAWN[global.spawnCounter];
				
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
	global.spawnCounter++;
	
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

	return (global.spawnCounter == array_length(spawn_data.PATTERN[global.pattern].WAVE[global.wave].SPAWN));
}

/// @function patternComplete
/// @description Checks if all waves in the current pattern have been completed
/// @return {Bool} True if all waves in pattern are done
function patternComplete() {

	return (global.wave == array_length(spawn_data.PATTERN[global.pattern].WAVE));
}

/// @function getChallengeData
/// @description Retrieves challenge stage data for the current challenge number
///              Note: global.chall is 1-indexed (1-8), array is 0-indexed
/// @return {Struct} Challenge data structure with paths and wave information
function getChallengeData() {
	// Get the challenge data for the current challenge (global.chall is 1-8)
	// Array is 0-indexed, so subtract 1
	return challenge_data.CHALLENGES[global.chall - 1];
}

/// @function getChallengeWaveData
/// @description Retrieves wave data for the current wave in the current challenge
/// @return {Struct} Wave data structure with enemy type and spawn settings
function getChallengeWaveData() {
	// Get the wave data for the current wave in the current challenge
	var chall_data = getChallengeData();
	return chall_data.WAVES[global.wave];
}

/// @function spawnChallengeEnemy
/// @description Spawns a challenge stage enemy based on current wave and challenge
///              Handles wave-specific path selection and enemy alternation
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

	// Determine which path to use based on wave and count
	var path_name = "";
	var spawn_x = 0;
	var spawn_y = 0;

	// Wave 0, 3, 4 use path1/path1flip
	if (global.wave == 0 ||
	    (global.wave == 3 && global.chall != 1 && global.chall != 6 && global.chall != 7) ||
	    (global.wave == 4 && (global.chall == 1 || global.chall == 6 || global.chall == 7))) {
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
	else if (global.wave == 1) {
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
	else if (global.wave == 2) {
		path_name = chall_data.PATH2_FLIP;
		var path_id = safe_get_asset(path_name);
		if (path_id != -1) {
			spawn_x = path_get_x(path_id, 0) ;
			spawn_y = path_get_y(path_id, 0) ;
		} else {
			log_error("Challenge path not found: " + path_name, "spawnChallengeEnemy", 2);
		}
	}
	// Wave 4 or 3 (depending on challenge) use path1flip
	else if ((global.wave == 4 && global.chall != 1 && global.chall != 6 && global.chall != 7) ||
	         (global.wave == 3 && (global.chall == 1 || global.chall == 6 || global.chall == 7))) {
		path_name = chall_data.PATH1_FLIP;
		var path_id = safe_get_asset(path_name);
		if (path_id != -1) {
			spawn_x = path_get_x(path_id, 0) ;
			spawn_y = path_get_y(path_id, 0) ;
		} else {
			log_error("Challenge path not found: " + path_name, "spawnChallengeEnemy", 2);
		}
	}

	// For wave 1, alternate between primary enemy and TieFighter based on count
	if (global.wave == 1) {
		if (count == 1 || count == 3 || count == 5 || count == 7) {
			// Use TieFighter instead of the wave's enemy for odd counts
			enemy_id = asset_get_index("oTieFighter");
		}
	}

	// Spawn the enemy
	instance_create_layer(spawn_x, spawn_y, "GameSprites", enemy_id,
	                      { ENEMY_NAME: object_get_name(enemy_id), INDEX: -1, PATH_NAME: path_name, MODE: "CHALLENGE" });
}

/// @function Game_Loop
/// @description Main game loop that handles all active gameplay logic
///              Manages enemy spawning, wave progression, challenge stages, and game state
///              Called from oGameManager Step event when in GAME_ACTIVE mode
/// @return {undefined}
function Game_Loop(){

	if (global.isGamePaused) return;
	if (readyForNextLevel()) return;
	
	// === EXTRA LIVES ===
	checkForExtraLives();
	
    // === ENEMY DIVE CAPACITY HANDLING ===
	checkDiveCapacity();

    // === BREATHING ANIMATION MECHANIC ===
	controlEnemyFormation();
	
  // === PATTERN HANDLING ===
  if global.challcount > 0 {
	  
	// SPAWN all ENEMY WAVES within the PATTERN
    if (!patternComplete()) {

		// ENEMY SPAWN (start of level)
		if (alarm[2] == -1) {
			if (!waveComplete()) {
				// SPAWN ENEMY
				spawnEnemy();
			}
			else if (!global.checkRoguePerWave) { // Wave Complete
				// check if we need to ADD any ROGUE enemies to this wave				
				var nRogue = nRogueEnemies();
				if (nRogue > 0) {
					spawnRogueEnemies(nRogue);
				}

				global.checkRoguePerWave = true;
			}
			
			// check if we've completed the wave, as we just spawned more enemies
			// note: divecap is active is the wave is still moving into formation
			if (waveComplete() && (global.divecap == global.divecapstart)) {	
			    // Advance to next wave if all wave are complete

				// reset spawn counter
				global.spawnCounter = 0;
					
				// advance to the next WAVE (if applicable)
	            global.wave += 1;
				global.checkRoguePerWave = false;
            }
			else {
				// more WAVES to complete, or current WAVE is still moving into formation ... wait
				// Frame delay before next WAVE SPAWN (using WAVE_SPAWN_DELAY constant)
				alarm[AlarmIndex.SPAWN_DELAY] = WAVE_SPAWN_DELAY; 
			}
		}
	}
	else {
		// We've completed the PATTERN
		global.open = 0;
	}
  }
    // === NON-CHALLENGE WAVE / FALLBACK SPAWNING ===
    // This logic triggers if no challenge pattern is active, handling standard enemy waves.
  
else {
	// CHALLENGE STAGE LOGIC (JSON-based)

    // Only proceed if we're within valid wave range, alarm is inactive, and not transitioning to next level
    if global.wave < CHALLENGE_TOTAL_WAVES && alarm[AlarmIndex.SPAWN_DELAY] == -1 && nextlevel == 0 {

        if count < CHALLENGE_ENEMIES_PER_WAVE {  // Only spawn if current wave hasn't reached full enemy count

            var chall_data = getChallengeData();
            var wave_data = getChallengeWaveData();

            // === PATH SHIFTING FOR CHALLENGE 4 ===
            // Adjust path if in challenge 4, wave 4
            if global.chall == 4 && global.wave == 4 {
                var path1_id = safe_get_asset(chall_data.PATH1, -1);
                if path1_id != -1 && path_get_x(path1_id, 0) == 192 {
                    var path1flip_id = safe_get_asset(chall_data.PATH1_FLIP, -1);
                    if (path1flip_id != -1) {
                        // Shift paths right by 64 pixels
                        path_shift(path1_id, 64*global.scale, 0);
                        path_shift(path1flip_id, 64*global.scale, 0);
                    } else {
                        log_error("Challenge 4 flipped path not found: " + chall_data.PATH1_FLIP, "Game_Loop", 1);
                    }
                }
            }

            // === DOUBLED WAVE CHECK ===
            if wave_data.DOUBLED {
                // This wave is a doubled wave, meaning two spawns instead of one

                if global.wave == 0 || global.wave == 3 || global.wave == 4 {
                    // Spawn two enemies on mirrored paths
                    var path1_id = safe_get_asset(chall_data.PATH1, -1);
                    var path1flip_id = safe_get_asset(chall_data.PATH1_FLIP, -1);
                    var enemy_id = safe_get_asset(wave_data.ENEMY, -1);

                    if path1_id != -1 && path1flip_id != -1 && enemy_id != -1 {
                        instance_create_layer(path_get_x(path1_id, 0), path_get_y(path1_id, 0),
                                            "GameSprites", enemy_id, { ENEMY_NAME: wave_data.ENEMY, INDEX: -1, PATH_NAME: chall_data.PATH1, MODE: "CHALLENGE" });
                        instance_create_layer(path_get_x(path1flip_id, 0), path_get_y(path1flip_id, 0),
                                            "GameSprites", enemy_id, { ENEMY_NAME: wave_data.ENEMY, INDEX: -1, PATH_NAME: chall_data.PATH1_FLIP, MODE: "CHALLENGE" });
                    } else {
                        if (enemy_id == -1) log_error("Challenge enemy not found: " + wave_data.ENEMY, "Game_Loop", 2);
                        if (path1_id == -1) log_error("Challenge path1 not found: " + chall_data.PATH1, "Game_Loop", 2);
                        if (path1flip_id == -1) log_error("Challenge path1_flip not found: " + chall_data.PATH1_FLIP, "Game_Loop", 2);
                    }
                    alarm[AlarmIndex.SPAWN_DELAY] = CHALLENGE_SPAWN_DELAY;
                }

                if global.wave == 1 {
                    // Spawn primary enemy and a TieFighter on mirrored paths
                    var path2_id = safe_get_asset(chall_data.PATH2, -1);
                    var path2flip_id = safe_get_asset(chall_data.PATH2_FLIP, -1);
                    var enemy1_id = safe_get_asset(wave_data.ENEMY, -1);
                    var enemy2_id = safe_get_asset("oTieFighter", -1);

                    if path2_id != -1 && path2flip_id != -1 && enemy1_id != -1 && enemy2_id != -1 {
                        instance_create_layer(path_get_x(path2_id, 0), path_get_y(path2_id, 0),
                                            "GameSprites", enemy1_id, { ENEMY_NAME: wave_data.ENEMY, INDEX: -1, PATH_NAME: chall_data.PATH2, MODE: "CHALLENGE" });
                        instance_create_layer(path_get_x(path2flip_id, 0), path_get_y(path2flip_id, 0),
                                            "GameSprites", enemy2_id, { ENEMY_NAME: "oTieFighter", INDEX: -1, PATH_NAME: chall_data.PATH2_FLIP, MODE: "CHALLENGE" });
                    } else {
                        if (enemy1_id == -1) log_error("Challenge wave 1 enemy not found: " + wave_data.ENEMY, "Game_Loop", 2);
                        if (enemy2_id == -1) log_error("Challenge wave 1 TieFighter not found", "Game_Loop", 2);
                        if (path2_id == -1) log_error("Challenge wave 1 path2 not found: " + chall_data.PATH2, "Game_Loop", 2);
                        if (path2flip_id == -1) log_error("Challenge wave 1 path2_flip not found: " + chall_data.PATH2_FLIP, "Game_Loop", 2);
                    }
                    alarm[AlarmIndex.SPAWN_DELAY] = CHALLENGE_SPAWN_DELAY;
                }

                if global.wave == 2 {
                    // Spawn mirrored enemies
                    var path2_id = safe_get_asset(chall_data.PATH2, -1);
                    var path2flip_id = safe_get_asset(chall_data.PATH2_FLIP, -1);
                    var enemy_id = safe_get_asset(wave_data.ENEMY, -1);

                    if path2_id != -1 && path2flip_id != -1 && enemy_id != -1 {
                        instance_create_layer(path_get_x(path2_id, 0), path_get_y(path2_id, 0),
                                            "GameSprites", enemy_id, { ENEMY_NAME: wave_data.ENEMY, INDEX: -1, PATH_NAME: chall_data.PATH2, MODE: "CHALLENGE" });
                        instance_create_layer(path_get_x(path2flip_id, 0), path_get_y(path2flip_id, 0),
                                            "GameSprites", enemy_id, { ENEMY_NAME: wave_data.ENEMY, INDEX: -1, PATH_NAME: chall_data.PATH2_FLIP, MODE: "CHALLENGE" });
                    } else {
                        if (enemy_id == -1) log_error("Challenge wave 2 enemy not found: " + wave_data.ENEMY, "Game_Loop", 2);
                        if (path2_id == -1) log_error("Challenge wave 2 path2 not found: " + chall_data.PATH2, "Game_Loop", 2);
                        if (path2flip_id == -1) log_error("Challenge wave 2 path2_flip not found: " + chall_data.PATH2_FLIP, "Game_Loop", 2);
                    }
                    alarm[AlarmIndex.SPAWN_DELAY] = CHALLENGE_SPAWN_DELAY;
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
        if count == CHALLENGE_ENEMIES_PER_WAVE {
            // If max enemies spawned and all cleared, reset for next wave
            if nOfEnemies() == 0 {
                alarm[AlarmIndex.SPAWN_DELAY] = CHALLENGE_WAVE_DELAY;  // Delay before next wave starts
                global.wave += 1;
                count = 0;
                global.shottotal += global.shotcount;
                global.shotcount = 0;
            }
        }

    }
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
			    fx_set_parameter(layer_fx, "g_HueShift", global.lvl % array_length(hue_value));
			}
		}		
		// make the nebula visible
		layer_set_visible(scrolling_nebula_bg, true);
	}
}

/// @function Show_Instructions
/// @description Displays game instructions and handles start game input
///              Supports both gamepad and keyboard input
///              Initializes all game state when player starts game
/// @return {undefined}
function Show_Instructions() {
	var startGame = false;
	// check if we have a gamepad
	if (oGameManager.useGamepad) {
			// A button on the XBOX Controller
			if (gamepad_button_check_pressed(0,gp_face1)) startGame = true;
	}
	else  if (keyboard_check_pressed(vk_space)) startGame = true;
	
	// if player presses space, start the actual game
    if (startGame) {
		// 'use' credit to enter game mode
		global.credits--;
		
		if (audio_is_playing(Galaga_Theme_Remix_Short)) {
			audio_stop_sound(Galaga_Theme_Remix_Short);
		}
		
        // === INITIALIZE GAME STATE ===
        global.lvl           = 0;
		
        global.chall         = 0;
		// start the counter at 1, as the 1st challenge stage is Stage 3, then +4 after that, ie 7, 11, 15, ...
        global.challcount    = 2;
		global.isChallengeStage = false;
		
        global.divecapstart  = 2;
        global.lastattack    = 4;
        global.beamtime      = 300;
        global.shotnumber    = 2;
        global.open          = 0;
        global.fastenter     = 0;
        global.entershot     = 0;
        global.rogue         = 0;
        global.fast          = 0;
        global.transnum      = 0;
        global.divecap       = global.divecapstart;
        global.pattern       = 0;
        global.hold          = 15;
        global.bosscap       = 2;
        global.wave          = 0;
        global.flip          = 0;
        global.breathing     = 1;
        global.breathe       = 0;
        exhale               = 0;
        global.bosscount     = 1;
        global.prohib        = 0;
        global.transform     = 0;
        global.beamcheck     = 0;
        global.transcount    = 0;
        global.escortcount   = 0;
        global.fighterstore  = 0;

        // === PLAYER INITIAL VALUES ===
        global.p1score = 0;
        global.p1lives = get_config_value("PLAYER", "STARTING_LIVES", 3);

        firstlife   = get_config_value("PLAYER", "EXTRA_LIFE_FIRST", EXTRA_LIFE_FIRST_THRESHOLD);
        additional  = get_config_value("PLAYER", "EXTRA_LIFE_ADDITIONAL", EXTRA_LIFE_ADDITIONAL_THRESHOLD);

		// create the death star on the DeathStar layer (ie behind the game sprites)
		instance_create_layer(0, 0, "DeathStar", oDeathStar);
		Set_Nebula_Color();
		
		global.gameMode = GameMode.GAME_PLAYER_MESSAGE;

        sound_play(GStart);  // Play game start sound

        alarm[AlarmIndex.SPAWN_FORMATION_TIMER] = 250;  // Start spawn / formation timer
        alarm[AlarmIndex.FORMATION_COUNTDOWN]  = 14;   // Start formation countdown

        fire = 0;   // Reset fire state
        hits = 0;   // Reset hit count
    }
}

