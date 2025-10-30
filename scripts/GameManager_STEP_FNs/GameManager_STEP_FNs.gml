// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Enter_Initials(){
    // === NAVIGATE LEFT THROUGH CHARACTER CYCLE ===
    if keyboard_check(vk_left) and alarm[6] == -1 {
        cyc -= 1;  // Move to previous character in the 'cycle' string
        if cyc == 0 {
            cyc = string_length(cycle); // Wrap around to last character if we go before the first
        }
        alarm[6] = 10; // Cooldown to prevent rapid input (10 frames)
    }

    // === NAVIGATE RIGHT THROUGH CHARACTER CYCLE ===
    if keyboard_check(vk_right) and alarm[6] == -1 {
        cyc += 1; // Move to next character in the 'cycle' string
        if cyc == string_length(cycle) + 1 {
            cyc = 1; // Wrap around to first character if we go past the end
        }
        alarm[6] = 10; // Cooldown to prevent rapid input
    }

    // === SELECT CURRENT CHARACTER ===
    if keyboard_check_pressed(vk_space) and loop > 0 {

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
                alarm[7] -= 2;
            }
            if loop == 2 {
                alarm[7] -= 1;
            }
            loop = 3; // Set to end loop state (post-entry phase)

            if scored > 1 {
                alarm[7] = 120; // Longer delay if more than one player is entering initials
            }
        }
    }

    // Track which character in the name is currently being edited
    char = global.results - 2;
}

function nOfEnemies() {
	// return the total number of active enemies (all enemies)
	return instance_number(Bee) + instance_number(oTieFighter) + instance_number(oTieIntercepter) + instance_number(oImperialShuttle) +
			instance_number(Butterfly) + instance_number(Boss) + instance_number(Fighter) + instance_number(Transform);
}

function checkForExtraLives() {
	// Award extra lives based on score thresholds
	if global.p1score > firstlife and global.p1score < 1000000 {
	    if firstlife == 20000 {
	        firstlife = 0; // Reset first life marker
	    }
	    firstlife += additional; // Set next life threshold
	    sound_play(GLife);       // Play life gained sound
	    global.p1lives += 1;     // Add a life
	}
}

function readyForNextLevel() {	
	//// If no enemies are present and all game conditions are met,
	//// initiate transition to the next level.
	if (alarm[10] != -1) return true;
	
	if nOfEnemies() == 0 &&
	    nextlevel == 0 &&
	    global.open == 0 &&
	    oPlayer.shipStatus == _ShipState.ACTIVE &&
		global.gameMode == GameMode.GAME_ACTIVE {
		
		
		// trigger oGameManager.alarm[10] with nextlevel == 1
		// this is to skip the 'PLAYER 1' message above STAGE 1
		nextlevel = 1; 
		// trigger the initial level variables - ie Alarm[10] with nextlevel == 1
		alarm[10] = 1; 
		
		alarm[11] = 90; 
				
		return true;
	}
	
	return false;
}

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
            global.divecap -= 1; // Bees actively diving or about to dive
        }
    }

    with oTieIntercepter {
        if enemyState != EnemyState.IN_FORMATION or alarm[2] > -1 {
            global.divecap -= 1; // Bees actively diving or about to dive
        }
    }
	
    with oImperialShuttle {
        if enemyState != EnemyState.IN_FORMATION or alarm[2] > -1 {
            global.divecap -= 1; // Bees actively diving or about to dive
        }
    }

    with oTieIntercepter {
        if enemyState != EnemyState.IN_FORMATION or alarm[2] > -1 {
            global.divecap -= 1; // Bees actively diving or about to dive
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

function load_enemy_waves(_datafile) {
	var _data = "";

	// Check if the file exists to avoid errors
	if (file_exists(_datafile)) {
	    // Open the file for reading
	    var _fileid = file_text_open_read(_datafile);
    
	    // Read the entire file line by line
	    while (!file_text_eof(_fileid)) {
	        _data += file_text_readln(_fileid);
	    }
    
	    // Close the file
	    file_text_close(_fileid);
	
		return json_parse(_data);
	}	
}

function load_json_datafile(_datafile) {
	var _data = "";

	// Check if the file exists to avoid errors
	if (file_exists(_datafile)) {
	    // Open the file for reading
	    var _fileid = file_text_open_read(_datafile);
    
	    // Read the entire file line by line
	    while (!file_text_eof(_fileid)) {
	        _data += file_text_readln(_fileid);
	    }
    
	    // Close the file
	    file_text_close(_fileid);
	
		return json_parse(_data);
	}	
}

function nRogueEnemies() {
    // Get spawn count for current rogue level and wave
    var rogue_level_data = rogue_config.ROGUE_LEVELS[global.rogue];
    return rogue_level_data.SPAWN_COUNT[global.wave];
}

function spawnRogueEnemy(_spawn) {
	// Get the enemy data from a specific SPAWN instance
	var enemy_data = spawn_data.PATTERN[global.pattern].WAVE[global.wave].SPAWN[_spawn];
	
	
	// SPAWN a ROGUE Enemy, create path using the STANDARD path and prefix "ROGUE_"
	var path_name = "ROGUE_" + enemy_data.PATH;
	var enemy_id = asset_get_index(enemy_data.ENEMY);
	if (enemy_id != -1) {
		instance_create_layer(enemy_data.SPAWN_XPOS, enemy_data.SPAWN_YPOS, "GameSprites", enemy_id,
															{ ENEMY_NAME: enemy_data.ENEMY, INDEX: -1, PATH_NAME: path_name, MODE: "ROGUE" });
	}
	
	// is this a comination spawn, ie 2 enemies side by side?
	if (enemy_data.COMBINE) {
		// spawn another enemy in-sync with the current spawn cycle
		spawnRogueEnemy(_spawn+1);
	}
}

function spawnRogueEnemies(_nRogues) {
	
	// loop to SPAWN _nRogues (and check for a COMBINATION SPAWN)
	for (var i=0; i < _nRogues; i++ ) {
		spawnRogueEnemy(global.spawnCounter-2);
	}
}

function spawnEnemy() {
	var enemy_data = spawn_data.PATTERN[global.pattern].WAVE[global.wave].SPAWN[global.spawnCounter];
				
	// enemy_data: eg
	// ENEMY		"oTieFighter"
	// PATH			"Ent1e1"
	// SPAWN_XPOS	512
	// SPAWN YPOS	-16
	// INDEX		1
	// COMBINE		true/false
	
	// SPAWN a STANDARD Enemy
	var enemy_id = asset_get_index(enemy_data.ENEMY);
	if (enemy_id != -1) {
		instance_create_layer(enemy_data.SPAWN_XPOS, enemy_data.SPAWN_YPOS, "GameSprites", enemy_id,
															{ ENEMY_NAME: enemy_data.ENEMY, INDEX: enemy_data.INDEX, PATH_NAME: enemy_data.PATH, MODE: "STANDARD" });
	}
	
	// advance the enemy spawn counter
	global.spawnCounter++;
	
	// is this a comination spawn, ie 2 enemies side by side?
	if (enemy_data.COMBINE) {
		// spawn another enemy in-sync with the current spawn cycle
		spawnEnemy();
	}
}

function waveComplete() {

	return (global.spawnCounter == array_length(spawn_data.PATTERN[global.pattern].WAVE[global.wave].SPAWN));
}

function patternComplete() {

	return (global.wave == array_length(spawn_data.PATTERN[global.pattern].WAVE));
}

function getChallengeData() {
	// Get the challenge data for the current challenge (global.chall is 1-8)
	// Array is 0-indexed, so subtract 1
	return challenge_data.CHALLENGES[global.chall - 1];
}

function getChallengeWaveData() {
	// Get the wave data for the current wave in the current challenge
	var chall_data = getChallengeData();
	return chall_data.WAVES[global.wave];
}

function spawnChallengeEnemy() {
	var chall_data = getChallengeData();
	var wave_data = getChallengeWaveData();
	var enemy_name = wave_data.ENEMY;
	var enemy_id = asset_get_index(enemy_name);

	if (enemy_id == -1) {
		show_debug_message("Error: Could not find enemy: " + enemy_name);
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
		var path_id = asset_get_index(path_name);
		if (path_id != -1) {
			spawn_x = path_get_x(path_id, 0) ;
			spawn_y = path_get_y(path_id, 0) ;
		}
	}
	// Wave 1 uses path2 (alternating enemy types handled below)
	else if (global.wave == 1) {
		path_name = chall_data.PATH2;
		var path_id = asset_get_index(path_name);
		if (path_id != -1) {
			spawn_x = path_get_x(path_id, 0) ;
			spawn_y = path_get_y(path_id, 0) ;
		}
	}
	// Wave 2 uses path2flip
	else if (global.wave == 2) {
		path_name = chall_data.PATH2_FLIP;
		var path_id = asset_get_index(path_name);
		if (path_id != -1) {
			spawn_x = path_get_x(path_id, 0) ;
			spawn_y = path_get_y(path_id, 0) ;
		}
	}
	// Wave 4 or 3 (depending on challenge) use path1flip
	else if ((global.wave == 4 && global.chall != 1 && global.chall != 6 && global.chall != 7) ||
	         (global.wave == 3 && (global.chall == 1 || global.chall == 6 || global.chall == 7))) {
		path_name = chall_data.PATH1_FLIP;
		var path_id = asset_get_index(path_name);
		if (path_id != -1) {
			spawn_x = path_get_x(path_id, 0) ;
			spawn_y = path_get_y(path_id, 0) ;
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
			else if (!global.checkRoguePerWave) { // WaveComplete
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
				// 12 frame delay before next WAVE SPAWN
				alarm[2] = 9; 
			}
		}
	}
	else {
		// We've completed the PATTERN
		global.open = 0;
	}
                //if (count1 > 0 || count2 > 0 || rogue1 > 0 || rogue2 > 0) && alarm[2] == -1 {

	            //    // Random chance to spawn a rogue Bee
	            //    if count1 > 0 || rogue1 > 0 {
	            //        if random(1) < (rogue1 / (rogue1 + count1)) {
	            //        rogueyes = 1;
	            //        }
	            //    }
	            //    if (global.roomname == "GalagaWars") {
				//		instance_create(256*global.scale, -16*global.scale, oTieFighter); // Spawn from top
				//	}
				//	else {
				//		instance_create(256*global.scale, -16*global.scale, Bee); // Spawn Bee from top
				//	}
					
	            //    // Random chance to spawn a rogue Butterfly
	            //    if count2 > 0 || rogue2 > 0 {
	            //        if random(1) < (rogue2 / (rogue2 + count2)) {
	            //        rogueyes = 1;
	            //        }
	            //    }
	            //    if (global.roomname == "GalagaWars") {
				//		instance_create((448 - 256)*global.scale, -16*global.scale, oImperialShuttle); // Spawn from top
				//	}
				//	else {
				//		instance_create((448 - 256)*global.scale, -16*global.scale, Butterfly); // Spawn Butterfly from top
				//	}
					
	            //    alarm[2] = 6; // Delay before next possible spawn
                //}

                //// Advance to next wave if all counts are zero
                //if oPlayer.shipStatus == _ShipState.ACTIVE &&
                //    count1 == 0 && count2 == 0 &&
                //    rogue1 == 0 && rogue2 == 0 &&
                //    global.divecap == global.divecapstart {
	            //    global.wave = 1;
	            //    script_execute(waverogue); // Recalculate rogue spawn logic
                //}
	    //        }

	    //        // ---- WAVE 1 ----
	    //        if global.wave == 1 {
	    //            if (count1 > 0 || count2 > 0 || rogue1 > 0 || rogue2 > 0) && alarm[2] == -1 {
	    //            alt += 1;
	    //            if alt == 2 { alt = 0; } // Alternate between Bee and Butterfly spawn

	    //            if alt == 1 {
	    //                // Chance for rogue Boss
	    //                if count1 > 0 || rogue1 > 0 {
	    //                if random(1) < (rogue1 / (rogue1 + count1)) {
	    //                    rogueyes = 1;
	    //                }
	    //                }
	    //                instance_create(-16*global.scale, 496*global.scale, Boss); // Spawn Boss from bottom
	    //                alarm[2] = 6;
	    //            }

	    //            if alt == 0 {
	    //                // Chance for rogue Butterfly
	    //                if count2 > 0 || rogue2 > 0 {
	    //                if random(1) < (rogue2 / (rogue2 + count2)) {
	    //                    rogueyes = 1;
	    //                }
	    //                }
		//				if (global.roomname == "GalagaWars") {
		//					instance_create(-16*global.scale, 496*global.scale, oImperialShuttle); // Spawn from bottom
		//				}
		//				else {
		//					instance_create(-16*global.scale, 496*global.scale, Butterfly); // Spawn Butterfly from bottom
		//				}

	    //                alarm[2] = 6;
	    //            }
	    //            }

	    //            // Advance to next wave
	    //            if oPlayer.shipStatus == _ShipState.ACTIVE &&
	    //                count1 == 0 && count2 == 0 && rogue1 == 0 && rogue2 == 0 &&
	    //                global.divecap == global.divecapstart {
	    //            global.wave = 2;
	    //            script_execute(waverogue);
	    //            }
	    //        }

	    //        // ---- WAVE 2 to 4 ----

	    //        // ---- WAVE 2 ----
	    //        if global.wave == 2 {
	    //            if (count1 > 0 || count2 > 0 || rogue1 > 0 || rogue2 > 0) && alarm[2] == -1 {

	    //                // Alternate logic to randomly pick a rogue
	    //                if alt == 0 {
	    //                if count1 > 0 || rogue1 > 0 {
	    //                    if random(1) < (rogue1 / (rogue1 + count1)) {
	    //                    rogueyes = 1;
	    //                    }
	    //                }
	    //                } else {
	    //                if count2 > 0 || rogue2 > 0 {
	    //                    if random(1) < (rogue2 / (rogue2 + count2)) {
	    //                    rogueyes = 1;
	    //                    }
	    //                }
	    //                }
		//				if (global.roomname == "GalagaWars") {
		//					instance_create(464*global.scale, 496*global.scale, oImperialShuttle); // Spawn from bottom-right
		//				}
		//				else {
		//					instance_create(464*global.scale, 496*global.scale, Butterfly); // Spawn Butterfly from bottom-right
		//				}

	    //                alt += 1;
	    //                if alt == 2 { alt = 0; } // Toggle alt
	    //                alarm[2] = 6; // Spawn delay
	    //            }

	    //            // Transition to next wave
	    //            if oPlayer.shipStatus == _ShipState.ACTIVE &&
	    //                count1 == 0 && count2 == 0 && rogue1 == 0 && rogue2 == 0 &&
	    //                global.divecap == global.divecapstart {
	    //                global.wave = 3;
	    //                script_execute(waverogue);
	    //            }
	    //        }

	    //        // ---- WAVE 3 ----
	    //        if global.wave == 3 {
	    //            if (count1 > 0 || count2 > 0 || rogue1 > 0 || rogue2 > 0) && alarm[2] == -1 {

	    //                if alt == 0 {
	    //                if count1 > 0 || rogue1 > 0 {
	    //                    if random(1) < (rogue1 / (rogue1 + count1)) {
	    //                    rogueyes = 1;
	    //                    }
	    //                }
	    //                } else {
	    //                if count2 > 0 || rogue2 > 0 {
	    //                    if random(1) < (rogue2 / (rogue2 + count2)) {
	    //                    rogueyes = 1;
	    //                    }
	    //                }
	    //                }

		//                if (global.roomname == "GalagaWars") {
		//					instance_create(256*global.scale, -16*global.scale, oTieFighter); // Spawn from top
		//				}
		//				else {
		//					instance_create(256*global.scale, -16*global.scale, Bee); // Spawn Bee from top
		//				}

	    //                alt += 1;
	    //                if alt == 2 { alt = 0; }
	    //                alarm[2] = 6;
	    //            }

	    //            if oPlayer.shipStatus == _ShipState.ACTIVE &&
	    //                count1 == 0 && count2 == 0 && rogue1 == 0 && rogue2 == 0 &&
	    //                global.divecap == global.divecapstart {
	    //                global.wave = 4;
	    //                script_execute(waverogue);
	    //            }
	    //        }

	    //        // ---- WAVE 4 ----
	    //        if global.wave == 4 {
	    //            if (count1 > 0 || count2 > 0 || rogue1 > 0 || rogue2 > 0) && alarm[2] == -1 {

	    //                if alt == 0 {
	    //                if count1 > 0 || rogue1 > 0 {
	    //                    if random(1) < (rogue1 / (rogue1 + count1)) {
	    //                    rogueyes = 1;
	    //                    }
	    //                }
	    //                } else {
	    //                if count2 > 0 || rogue2 > 0 {
	    //                    if random(1) < (rogue2 / (rogue2 + count2)) {
	    //                    rogueyes = 1;
	    //                    }
	    //                }
	    //                }
					
		//                if (global.roomname == "GalagaWars") {
		//					instance_create(256*global.scale, -16*global.scale, oTieFighter); // Spawn from top
		//				}
		//				else {
		//					instance_create(256*global.scale, -16*global.scale, Bee); // Spawn Bee from top
		//				}

	    //                alt += 1;
	    //                if alt == 2 { alt = 0; }
	    //                alarm[2] = 6;
	    //            }

	    //            // === Fighter spawning logic ===
	    //            if global.fighterstore == 0 && instance_number(Fighter) == 0 {
	    //                if count1 == 0 && count2 == 0 && rogue1 == 0 && rogue2 == 0 &&
	    //                global.divecap == global.divecapstart {
	    //                global.open = 0;
	    //                }
	    //            } else {
	    //                if count1 == 0 && count2 == 0 && rogue1 == 0 && rogue2 == 0 &&
	    //                alarm[2] == -1 {
	    //                instance_create(192*global.scale, -16*global.scale, Fighter); // Spawn fighter unit
	    //                }
	    //            }

	    //            // === Close level if all enemies are cleared and fighter finished dive
	    //            if count1 == -1 && count2 == 0 && rogue1 == 0 && rogue2 == 0 &&
	    //                global.divecap == global.divecapstart && Fighter.dive == 0 {
	    //                global.open = 0;
	    //            }
	    //        }
	    //    } // End of challenge pattern 0
    

	    //    // === PATTERN 1 ===
	    //    // A different arrangement of waves and spawn directions (e.g., mirrored or center-based logic)

	    //    if global.pattern == 1 {

	    //        // ---- WAVE 0 ----
	    //        if global.wave == 0 {
	    //            if (count1 > 0 || count2 > 0 || rogue1 > 0 || rogue2 > 0) && alarm[2] == -1 {

	    //            // Random chance for rogue Bee
	    //            if count1 > 0 || rogue1 > 0 {
	    //                if random(1) < (rogue1 / (rogue1 + count1)) {
	    //                rogueyes = 1;
	    //                }
	    //            }
	    //            instance_create((448 - 288)*global.scale, -16*global.scale, Bee); // Bee from offset top-left

	    //            // Random chance for rogue Butterfly
	    //            if count2 > 0 || rogue2 > 0 {
	    //                if random(1) < (rogue2 / (rogue2 + count2)) {
	    //                rogueyes = 1;
	    //                }
	    //            }
	    //            instance_create(288*global.scale, -16*global.scale, Butterfly); // Butterfly from offset top-right

	    //            alarm[2] = 6;
	    //            }

	    //            // Advance wave if all enemies cleared and ship is alive
	    //            if oPLayer.shipStatus == _ShipState.ACTIVE && count1 == 0 && count2 == 0 &&
	    //            rogue1 == 0 && rogue2 == 0 && global.divecap == global.divecapstart {
	    //            global.wave = 1;
	    //            script_execute(waverogue);
	    //            }
	    //        }

	    //        // ---- WAVE 1 ----
	    //        if global.wave == 1 {
	    //            if (count1 > 0 || count2 > 0 || rogue1 > 0 || rogue2 > 0) && alarm[2] == -1 {

	    //            // Rogue Boss spawn
	    //            if count1 > 0 || rogue1 > 0 {
	    //                if random(1) < (rogue1 / (rogue1 + count1)) {
	    //                rogueyes = 1;
	    //                }
	    //            }
	    //            instance_create(-16*global.scale, 496*global.scale, Boss); // Boss from lower left

	    //            // Rogue Butterfly spawn
	    //            if count2 > 0 || rogue2 > 0 {
	    //                if random(1) < (rogue2 / (rogue2 + count2)) {
	    //                rogueyes = 1;
	    //                }
	    //            }
	    //            instance_create(-16*global.scale, (496 - 32)*global.scale, Butterfly); // Slightly offset Butterfly

	    //            alarm[2] = 6;
	    //            }

	    //            if oPlayer.shipStatus == _ShipState.ACTIVE &&
	    //            count1 == 0 && count2 == 0 && rogue1 == 0 && rogue2 == 0 &&
	    //            global.divecap == global.divecapstart {
	    //            global.wave = 2;
	    //            script_execute(waverogue);
	    //            }
	    //        }

	    //        // ---- WAVE 2 ----
	    //        if global.wave == 2 {
	    //            if (count1 > 0 || count2 > 0 || rogue1 > 0 || rogue2 > 0) && alarm[2] == -1 {

	    //            // Rogue Bee or Butterfly decision
	    //            if count1 > 0 || rogue1 > 0 {
	    //                if random(1) < (rogue1 / (rogue1 + count1)) {
	    //                rogueyes = 1;
	    //                }
	    //            }
	    //            alt = 0;
	    //            instance_create(464*global.scale, 496*global.scale, Butterfly); // From far right

	    //            if count2 > 0 || rogue2 > 0 {
	    //                if random(1) < (rogue2 / (rogue2 + count2)) {
	    //                rogueyes = 1;
	    //                }
	    //            }
	    //            alt = 1;
	    //            instance_create(464*global.scale, (496 - 32)*global.scale, Butterfly); // Another butterfly

	    //            alarm[2] = 6;
	    //            }

	    //            if oPlayer.shipStatus == _ShipState.ACTIVE &&
	    //            count1 == 0 && count2 == 0 && rogue1 == 0 && rogue2 == 0 &&
	    //            global.divecap == global.divecapstart {
	    //            global.wave = 3;
	    //            script_execute(waverogue);
	    //            }
	    //        }

	    //        // ---- WAVE 3 ----
	    //        if global.wave == 3 {
	    //            if (count1 > 0 || count2 > 0 || rogue1 > 0 || rogue2 > 0) && alarm[2] == -1 {

	    //                // Attempt to spawn rogue Bee from top positions
	    //                alt = 0;
	    //                if count1 > 0 || rogue1 > 0 {
	    //                if random(1) < (rogue1 / (rogue1 + count1)) {
	    //                    rogueyes = 1;
	    //                }
	    //                }
	    //                instance_create((256 + 32)*global.scale, -16*global.scale, Bee);  // Slightly offset Bee

	    //                alt = 1;
	    //                if count2 > 0 || rogue2 > 0 {
	    //                if random(1) < (rogue2 / (rogue2 + count2)) {
	    //                    rogueyes = 1;
	    //                }
	    //                }
	    //                instance_create((228 + 32)*global.scale, -16*global.scale, Bee);  // Another Bee from nearby offset

	    //                alarm[2] = 6;
	    //            }

	    //            // Advance wave once enemies are cleared
	    //            if oPlayer.shipStatus == _ShipState.ACTIVE &&
	    //                count1 == 0 && count2 == 0 && rogue1 == 0 && rogue2 == 0 &&
	    //                global.divecap == global.divecapstart {
	    //                global.wave = 4;
	    //                script_execute(waverogue);
	    //            }
	    //        }

	    //        // ---- WAVE 4 ----
	    //        if global.wave == 4 {
	    //            if (count1 > 0 || count2 > 0 || rogue1 > 0 || rogue2 > 0) && alarm[2] == -1 {

	    //                // Patterned Bee spawns from mirrored offset
	    //                if count1 > 0 || rogue1 > 0 {
	    //                if random(1) < (rogue1 / (rogue1 + count1)) {
	    //                    rogueyes = 1;
	    //                }
	    //                }
	    //                alt = 0;
	    //                instance_create((448 - 256 - 32)*global.scale, -16*global.scale, Bee); // Left Bee

	    //                if count2 > 0 || rogue2 > 0 {
	    //                if random(1) < (rogue2 / (rogue2 + count2)) {
	    //                    rogueyes = 1;
	    //                }
	    //                }
	    //                alt = 1;
	    //                instance_create((448 - 228 - 32)*global.scale, -16*global.scale, Bee); // Right Bee

	    //                alarm[2] = 6;
	    //            }
           
		//            // === Final cleanup or Fighter spawn ===
		//            // === Fighter spawning and pattern closing ===

		//            // If no Fighters remain to deploy and no enemies are left, close the pattern
		//            if global.fighterstore == 0 && instance_number(Fighter) == 0 {
		//                if count1 == 0 && count2 == 0 && rogue1 == 0 && rogue2 == 0 &&
		//                global.divecap == global.divecapstart {
		//                global.open = 0;
		//                }
		//            } else {
		//                // Otherwise deploy a fighter if enemies are clear and alarm is ready
		//                if count1 == 0 && count2 == 0 && rogue1 == 0 && rogue2 == 0 &&
		//                alarm[2] == -1 {
		//                instance_create(160*global.scale, -16*global.scale, Fighter); // Spawn Fighter unit from mid-top
		//                }
		//            }
			
		//            // End pattern if Fighter dive is complete and no enemies remain
		//            if count1 == -1 && count2 == 0 && rogue1 == 0 && rogue2 == 0 &&
		//                global.divecap == global.divecapstart && Fighter.dive == 0 {
		//                global.open = 0;
		//            }
		//		}
	    //    }

	    //    // === PATTERN 2 ===
	    //    // A third pattern variation with different positioning for enemies.

	    //    if global.pattern == 2 {

	    //        // ---- WAVE 0 ----
	    //        if global.wave == 0 {
	    //            if (count1 > 0 || count2 > 0 || rogue1 > 0 || rogue2 > 0) && alarm[2] == -1 {

	    //            // Spawn Bee with rogue chance
	    //            if count1 > 0 || rogue1 > 0 {
	    //                if random(1) < (rogue1 / (rogue1 + count1)) {
	    //                rogueyes = 1;
	    //                }
	    //            }
	    //            instance_create(256*global.scale, -16*global.scale, Bee);  // From top center

	    //            // Spawn Butterfly with rogue chance
	    //            if count2 > 0 || rogue2 > 0 {
	    //                if random(1) < (rogue2 / (rogue2 + count2)) {
	    //                rogueyes = 1;
	    //                }
	    //            }
	    //            instance_create((448 - 256)*global.scale, -16*global.scale, Butterfly);  // From top offset right
	    //            alarm[2] = 6;
	    //            }

	    //            if oPlayer.shipStatus == _ShipState.ACTIVE && count1 == 0 && count2 == 0 &&
	    //            rogue1 == 0 && rogue2 == 0 && global.divecap == global.divecapstart {
	    //            global.wave = 1;
	    //            script_execute(waverogue);
	    //            }
	    //        }

	    //        // ---- WAVE 1 ----
	    //        if global.wave == 1 {
	    //            if (count1 > 0 || count2 > 0 || rogue1 > 0 || rogue2 > 0) && alarm[2] == -1 {

	    //            // Rogue Boss spawn
	    //            if count1 > 0 || rogue1 > 0 {
	    //                if random(1) < (rogue1 / (rogue1 + count1)) {
	    //                rogueyes = 1;
	    //                }
	    //            }
	    //            instance_create(-16*global.scale, 496*global.scale, Boss); // From lower left

	    //            // Rogue Butterfly spawn
	    //            if count2 > 0 || rogue2 > 0 {
	    //                if random(1) < (rogue2 / (rogue2 + count2)) {
	    //                rogueyes = 1;
	    //                }
	    //            }
	    //            instance_create(464*global.scale, 496*global.scale, Butterfly); // From lower right

	    //            alarm[2] = 6;
	    //            }

	    //            if oPlayer.shipStatus == _ShipState.ACTIVE && count1 == 0 && count2 == 0 &&
	    //            rogue1 == 0 && rogue2 == 0 && global.divecap == global.divecapstart {
	    //            global.wave = 2;
	    //            script_execute(waverogue);
	    //            }
	    //        }

	    //        // ---- WAVE 2 ----
	    //        if global.wave == 2 {
	    //            if (count1 > 0 || count2 > 0 || rogue1 > 0 || rogue2 > 0) && alarm[2] == -1 {

	    //            // Left butterfly
	    //            if count1 > 0 || rogue1 > 0 {
	    //                if random(1) < (rogue1 / (rogue1 + count1)) {
	    //                rogueyes = 1;
	    //                }
	    //            }
	    //            alt = 0;
	    //            instance_create(-16, 496, Butterfly);

	    //            // Right butterfly
	    //            if count2 > 0 || rogue2 > 0 {
	    //                if random(1) < (rogue2 / (rogue2 + count2)) {
	    //                rogueyes = 1;
	    //                }
	    //            }
	    //            alt = 1;
	    //            instance_create(464, 496, Butterfly);

	    //            alarm[2] = 6;
	    //            }

	    //            if oPlayer.shipStatus == _ShipState.ACTIVE && count1 == 0 && count2 == 0 &&
	    //            rogue1 == 0 && rogue2 == 0 && global.divecap == global.divecapstart {
	    //            global.wave = 3;
	    //            script_execute(waverogue);
	    //            }
	    //        }

	    //        // ---- WAVE 3 ----
	    //        if global.wave == 3 {
	    //            if (count1 > 0 || count2 > 0 || rogue1 > 0 || rogue2 > 0) && alarm[2] == -1 {

	    //            // Bee 1
	    //            if count1 > 0 || rogue1 > 0 {
	    //                if random(1) < (rogue1 / (rogue1 + count1)) {
	    //                rogueyes = 1;
	    //                }
	    //            }
	    //            alt = 0;
	    //            instance_create(256, -16, Bee);

	    //            // Bee 2
	    //            if count2 > 0 || rogue2 > 0 {
	    //                if random(1) < (rogue2 / (rogue2 + count2)) {
	    //                rogueyes = 1;
	    //                }
	    //            }
	    //            alt = 1;
	    //            instance_create(448 - 256, -16, Bee);

	    //            alarm[2] = 6;
	    //            }

	    //            if oPlayer.shipStatus == _ShipState.ACTIVE && count1 == 0 && count2 == 0 &&
	    //            rogue1 == 0 && rogue2 == 0 && global.divecap == global.divecapstart {
	    //            global.wave = 4;
	    //            script_execute(waverogue);
	    //            }
	    //        }

	    //        // ---- WAVE 4 ----
	    //        if global.wave == 4 {
	    //            if (count1 > 0 || count2 > 0 || rogue1 > 0 || rogue2 > 0) && alarm[2] == -1 {

	    //            // Bee 1
	    //            if count1 > 0 || rogue1 > 0 {
	    //                if random(1) < (rogue1 / (rogue1 + count1)) {
	    //                rogueyes = 1;
	    //                }
	    //            }
	    //            alt = 0;
	    //            instance_create(256, -16, Bee);

	    //            // Bee 2
	    //            if count2 > 0 || rogue2 > 0 {
	    //                if random(1) < (rogue2 / (rogue2 + count2)) {
	    //                rogueyes = 1;
	    //                }
	    //            }
	    //            alt = 1;
	    //            instance_create(448 - 256, -16, Bee);

	    //            alarm[2] = 6;
	    //            }
	    //        }

	    //        // === Final cleanup or Fighter spawn ===
	    //        if global.fighterstore == 0 && instance_number(Fighter) == 0 {
	    //        if count1 == 0 && count2 == 0 && rogue1 == 0 && rogue2 == 0 &&
	    //            global.divecap == global.divecapstart {
	    //            global.open = 0;
	    //        }
	    //        } else {
	    //        if count1 == 0 && count2 == 0 && rogue1 == 0 && rogue2 == 0 &&
	    //            alarm[2] == -1 {
	    //            instance_create(192, -16, Fighter);
	    //        }
	    //        }

	    //        if count1 == -1 && count2 == 0 && rogue1 == 0 && rogue2 == 0 &&
	    //        global.divecap == global.divecapstart && Fighter.dive == 0 {
	    //            lobal.open = 0;
	    //        }

	    //    } // End of pattern 2
	    //} // End of challenge pattern handling
  }
    // === NON-CHALLENGE WAVE / FALLBACK SPAWNING ===
    // This logic triggers if no challenge pattern is active, handling standard enemy waves.
  
else {
	// CHALLENGE STAGE LOGIC (JSON-based)

    // Only proceed if we're within valid wave range, alarm is inactive, and not transitioning to next level
    if global.wave < 5 && alarm[2] == -1 && nextlevel == 0 {

        if count < 8 {  // Only spawn if current wave hasn't reached full enemy count (e.g., 8 max)

            var chall_data = getChallengeData();
            var wave_data = getChallengeWaveData();

            // === PATH SHIFTING FOR CHALLENGE 4 ===
            // Adjust path if in challenge 4, wave 4
            if global.chall == 4 && global.wave == 4 {
                var path1_id = asset_get_index(chall_data.PATH1);
                if path1_id != -1 && path_get_x(path1_id, 0) == 192 {
                    var path1flip_id = asset_get_index(chall_data.PATH1_FLIP);
                    // Shift paths right by 64 pixels
                    path_shift(path1_id, 64*global.scale, 0);
                    path_shift(path1flip_id, 64*global.scale, 0);
                }
            }

            // === DOUBLED WAVE CHECK ===
            if wave_data.DOUBLED {
                // This wave is a doubled wave, meaning two spawns instead of one

                if global.wave == 0 || global.wave == 3 || global.wave == 4 {
                    // Spawn two enemies on mirrored paths
                    var path1_id = asset_get_index(chall_data.PATH1);
                    var path1flip_id = asset_get_index(chall_data.PATH1_FLIP);
                    var enemy_id = asset_get_index(wave_data.ENEMY);

                    if path1_id != -1 && path1flip_id != -1 && enemy_id != -1 {
                        instance_create_layer(path_get_x(path1_id, 0), path_get_y(path1_id, 0),
                                            "GameSprites", enemy_id, { ENEMY_NAME: wave_data.ENEMY, INDEX: -1, PATH_NAME: chall_data.PATH1, MODE: "CHALLENGE" });
                        instance_create_layer(path_get_x(path1flip_id, 0), path_get_y(path1flip_id, 0),
                                            "GameSprites", enemy_id, { ENEMY_NAME: wave_data.ENEMY, INDEX: -1, PATH_NAME: chall_data.PATH1_FLIP, MODE: "CHALLENGE" });
                    }
                    alarm[2] = 6;
                }

                if global.wave == 1 {
                    // Spawn primary enemy and a TieFighter on mirrored paths
                    var path2_id = asset_get_index(chall_data.PATH2);
                    var path2flip_id = asset_get_index(chall_data.PATH2_FLIP);
                    var enemy1_id = asset_get_index(wave_data.ENEMY);
                    var enemy2_id = asset_get_index("oTieFighter");

                    if path2_id != -1 && path2flip_id != -1 && enemy1_id != -1 && enemy2_id != -1 {
                        instance_create_layer(path_get_x(path2_id, 0), path_get_y(path2_id, 0),
                                            "GameSprites", enemy1_id, { ENEMY_NAME: wave_data.ENEMY, INDEX: -1, PATH_NAME: chall_data.PATH2, MODE: "CHALLENGE" });
                        instance_create_layer(path_get_x(path2flip_id, 0), path_get_y(path2flip_id, 0),
                                            "GameSprites", enemy2_id, { ENEMY_NAME: "oTieFighter", INDEX: -1, PATH_NAME: chall_data.PATH2_FLIP, MODE: "CHALLENGE" });
                    }
                    alarm[2] = 6;
                }

                if global.wave == 2 {
                    // Spawn mirrored enemies
                    var path2_id = asset_get_index(chall_data.PATH2);
                    var path2flip_id = asset_get_index(chall_data.PATH2_FLIP);
                    var enemy_id = asset_get_index(wave_data.ENEMY);

                    if path2_id != -1 && path2flip_id != -1 && enemy_id != -1 {
                        instance_create_layer(path_get_x(path2_id, 0), path_get_y(path2_id, 0),
                                            "GameSprites", enemy_id, { ENEMY_NAME: wave_data.ENEMY, INDEX: -1, PATH_NAME: chall_data.PATH2, MODE: "CHALLENGE" });
                        instance_create_layer(path_get_x(path2flip_id, 0), path_get_y(path2flip_id, 0),
                                            "GameSprites", enemy_id, { ENEMY_NAME: wave_data.ENEMY, INDEX: -1, PATH_NAME: chall_data.PATH2_FLIP, MODE: "CHALLENGE" });
                    }
                    alarm[2] = 6;
                }

				// advance count by 2, as this was a DOUBLE spawn
				count += 2;
            } else {
                // === NON-DOUBLED WAVE ===
                spawnChallengeEnemy();
                alarm[2] = 6;
				
				count++;
            }
        } // End of count check for spawning

        // === ADVANCE WAVE ===
        if count == 8 {
            // If max enemies spawned and all cleared, reset for next wave
            if nOfEnemies() == 0 {
                alarm[2] = 45;  // Delay before next wave starts
                global.wave += 1;
                count = 0;
                global.shottotal += global.shotcount;
                global.shotcount = 0;
            }
        }

    }
	}
}

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
        global.p1lives = 3;

        firstlife   = 20000;  // Score threshold for first extra life
        additional  = 70000;  // Score threshold for each subsequent extra life

		// create the death star on the DeathStar layer (ie behind the game sprites)
		instance_create_layer(0, 0, "DeathStar", oDeathStar);
		Set_Nebula_Color();
		
		global.gameMode = GameMode.GAME_PLAYER_MESSAGE;

        sound_play(GStart);  // Play game start sound

        alarm[11] = 250;  // Start spawn / formation timer
        alarm[8]  = 14;   // Start formation countdown

        fire = 0;   // Reset fire state
        hits = 0;   // Reset hit count
    }
}

