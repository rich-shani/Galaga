/// ================================================================
/// ENEMY STEP EVENT - Main behavior coordinator
/// ================================================================
/// This script manages all enemy behavior including:
///   • Mode-specific logic (Challenge/Rogue/Standard)
///   • Enemy shooting with shot limits
///   • Formation breathing oscillation
///   • Transformation into other enemy types
///   • Dive attack coordination
///   • State machine progression
///
/// The code uses alarms, global variables, and path following to create
/// dynamic and varied enemy actions for challenging gameplay.
/// ================================================================
	
// CHALLENGE enemy are killed if they leave the screen
if (enemyMode == EnemyMode.CHALLENGE) {
	// check if path has ended ...
	if (path_position >= 1) {
		instance_destroy();
	}
	
	return;
}
else if (enemyMode == EnemyMode.ROGUE) {
	// do we have a target to aim at ?
	if (targx == 0) {
		// not yet, check if we've completed the PATH
		if (path_position >= 1) {
			path_end(); speed = entranceSpeed;

			// set the x coordinate target to the PLAYER
			if (instance_exists(oPlayer)) {
				targx = oPlayer.x;
				targy = oPlayer.y;
			} else {
				// Player doesn't exist, target center screen
				targx = global.screen_width / 2;
				targy = global.screen_height / 2;
			}
		}
	}
	else if (y > ROGUE_TRANSITION_Y * global.Game.Display.scale) {
		// shift to straight down

		// have we left the bottom of the screen?
		if (y > SCREEN_BOTTOM_Y * global.Game.Display.scale) {
			// ROGUE enemy has left the bottom of the screen
			instance_destroy();
		}
	}
	else {
		// move towards the PLAYER
		move_towards_point(targx, targy, entranceSpeed);
	}
	
	return;
}
else if (enemyMode == EnemyMode.STANDARD) {
	
	// Enemy shooting logic: limit number of shots on screen
	if (instance_number(EnemyShot) < MAX_ENEMY_SHOTS) {
		// Fire at specific alarm[1] values
		if (alarm[1] == ENEMY_SHOT_TIMING_1) {
			instance_create_layer(x, y, "GameSprites", EnemyShot);
		}
		if (alarm[1] == ENEMY_SHOT_TIMING_2) {
			instance_create_layer(x, y, "GameSprites", EnemyShot);
		}
		if (global.Game.Enemy.shotNumber > 2 && alarm[1] == ENEMY_SHOT_TIMING_3) {
			instance_create_layer(x, y, "GameSprites", EnemyShot);
		}
	}

	/// ================================================================
	/// BREATHING ANIMATION - Formation oscillation effect
	/// ================================================================
	/// Creates a smooth wave-like motion for enemies in formation.
	/// The breathing effect occurs around the formation position and syncs
	/// with global.Game.Enemy.breathePhase variable which cycles 0-BREATHING_CYCLE_MAX.
	/// breathing provides visual feedback that enemies are "alive"
	/// ================================================================
	var manager_x_offset = instance_exists(oGameManager) ? floor(oGameManager.x) : 0;
	breathex = xstart + ((global.Game.Enemy.breathePhase / BREATHING_CYCLE_MAX) * (FORMATION_BREATHE_AMPLITUDE * ((xstart - FORMATION_CENTER_X) / FORMATION_WIDTH))) + manager_x_offset;
	breathey = ystart + ((global.Game.Enemy.breathePhase / BREATHING_CYCLE_MAX) * (FORMATION_BREATHE_AMPLITUDE * ((ystart - FORMATION_TOP_Y) / FORMATION_HEIGHT)));

	/// ================================================================
	/// TRANSFORMATION LOGIC - Enemy morphing into special types
	/// ================================================================
	/// Triggers random enemy transformations when specific conditions met.
	/// This adds variety and challenge to later waves.
	///
	/// Requirements (see canTransform() helper for details):
	///   • Transformation tokens available
	///   • Enemy is in formation and alive
	///   • Random chance (1 in 6) passes
	///   • Dive capacity available
	///   • Player is active and not invulnerable
	///   • Less than 21 enemies on screen
	///   • Player is not firing
	/// ================================================================
	if (global.Game.Enemy.transformTokens > 0 && canTransform()) {
		// Trigger transformation animation
		alarm[EnemyAlarmIndex.DIVE_ATTACK] = TRANSFORM_ALARM_DELAY;
		global.Game.Enemy.transformActive = 1;
		sound_play(GTransform);
	}

	/// ================================================================
	/// ENEMY STATE MACHINE - Coordinate enemy behavior
	/// ================================================================
	/// Each enemy progresses through states from entry to attack:
	///   1. ENTER_SCREEN       → Following entrance path
	///   2. MOVE_INTO_FORMATION → Transitioning to grid position
	///   3. IN_FORMATION       → Stationary, breathing, awaiting dive chance
	///   4. IN_DIVE_ATTACK     → Diving at player (can loop or go final)
	///   5. IN_LOOP_ATTACK     → Looping back to formation
	///   6. IN_FINAL_ATTACK    → Last two enemies - aggressive attack
	/// ================================================================

	if (enemyState == EnemyState.ENTER_SCREEN) {
		/// Enemies enter from off-screen, following a predefined path
		/// When path completes (path_position >= 1), move to formation

		if (path_position >= 1) {
			/// Path entry is complete, now move into grid formation
			/// Look up the formation grid position using enemy's INDEX (1-40)
			/// Add bounds checking to prevent crash if INDEX is invalid
			if (INDEX >= 0 && INDEX < array_length(formation.POSITION)) {
				xstart = formation.POSITION[INDEX]._x;
				ystart = formation.POSITION[INDEX]._y;

				/// Set speed for this movement phase
				speed = entranceSpeed;

				/// Transition to next state: moving into grid formation
				enemyState = EnemyState.MOVE_INTO_FORMATION;
			} else {
				// Invalid INDEX - log error and destroy enemy to prevent further issues
				log_error("Invalid formation INDEX: " + string(INDEX), "oEnemyBase ENTER_SCREEN", 3);
				instance_destroy();
			}
		}
	}
	else if (enemyState == EnemyState.RETURN_PATH) {
		// check if path has ended ...
		if (path_position >= 1) {
			/// Set speed for this movement phase
			speed = entranceSpeed;

			/// Transition to next state: moving into grid formation
			enemyState = EnemyState.MOVE_INTO_FORMATION;		
		}		
	}
	else if (enemyState == EnemyState.MOVE_INTO_FORMATION) {
		// Have we reached the formation position?
		// enemy can come in from bottom or top of screen, so use ABS()
		if (abs (y - breathey) < FORMATION_POSITION_THRESHOLD) {
			x = breathex;
			y = breathey;

			sound_stop(GFighterCaptured);
			enemyState = EnemyState.IN_FORMATION;
					
			// set alarm : to give time for the Draw function to ROTATE the ship to down direction
			alarm[0]=60;
		}
		else { 
			// continue to move towards the formation position
			move_towards_point(breathex, breathey, entranceSpeed); 
		}
	}
	else if (enemyState == EnemyState.IN_FORMATION) {
		/// ================================================================
		/// IN_FORMATION STATE - Enemy is in grid, awaiting attack command
		/// ================================================================
		/// This is the "calm" state where enemies breathe and look for
		/// opportunities to dive at the player. It's the majority state.
		///
		/// Activities:
		///   1. Rotate sprite to face downward (270°)
		///   2. Apply breathing oscillation for visual effect
		///   3. Monitor for dive attack conditions
		///   4. Prevent collisions with other formation enemies
		/// ================================================================

		/// === SPRITE ROTATION ===
		/// Smoothly rotate sprite to face down (270 degrees)
		/// Rotation is skipped while alarm[0] is active (post-entry animation)
		/// This aligns enemy direction with their dive path
		///
		/// GameMaker rotation angles:
		///   0°   = facing right
		///   90°  = facing up
		///   180° = facing left
		///   270° = facing down (dive direction)

		if ((alarm[0] == -1) && direction != TARGET_DIRECTION_DOWN) {
			// Rotation alarm expired, set direction to down
			direction = TARGET_DIRECTION_DOWN;
		}
		else if (abs(direction - TARGET_DIRECTION_DOWN) > DIRECTION_ROTATION_THRESHOLD) {
			// Smoothly rotate toward down direction
			direction += FORMATION_ROTATION_ANGLE_STEP;
		}

		/// === BREATHING OSCILLATION ===
		/// Update position with breathing effect
		/// This creates the wave-like motion of the formation
		x = breathex;
		y = breathey;

		/// === DIVE ATTACK TRIGGER ===
		/// Monitor conditions to initiate dive attack when safe
		///
		/// Global conditions (prevent inopportune attacks):
		///   • global.Game.Enemy.diveCapacity > 0 : Dive slots available
		///   • global.Game.State.spawnOpen == 0 : Not spawning new enemies
		///   • oPlayer.alarm[4] == -1 : Player is not invulnerable (cooldown)
		///
		/// Dive trigger probability: ~10% per frame (irandom(10) == 0)

		if (instance_exists(oPlayer) && global.Game.Enemy.diveCapacity > 0 and global.Game.State.spawnOpen == 0 and oPlayer.alarm[4] == -1) {
			if (
				irandom(10) == 0 && global.Game.State.prohibitDive == 0 &&
				alarm[2] == -1 && oPlayer.shipStatus == _ShipState.ACTIVE && oPlayer.regain == 0
			) {
				/// All conditions met - initiate dive attack

				// Set global flags to prevent concurrent dives
				global.Game.State.prohibitDive = 1;
				if (instance_exists(oGameManager)) {
					oGameManager.alarm[0] = PROHIBIT_RESET_DELAY;
				}

				// Set shooting timer (shots during dive)
				alarm[1] = ENEMY_SHOT_ALARM;

				// Play dive sound effect
				sound_stop(GDive);
				sound_play(GDive);

				/// === DIVE PATH SELECTION ===
				/// Choose appropriate dive path based on starting formation position
				/// This creates asymmetric dives that depend on initial position

				if (xstart > SCREEN_CENTER_X * global.Game.Display.scale) {
					// Enemy on right side of formation → use right dive path
					if (attributes.STANDARD.DIVE_PATH1 != noone) {
						var path_id = safe_get_asset(attributes.STANDARD.DIVE_PATH1, -1);
						if (path_id != -1) path_start(path_id, moveSpeed, 0, 0);
					}
				} else {
					// Enemy on left side of formation → use left dive path
					if (attributes.STANDARD.DIVE_ALT_PATH1 != noone) {
						var path_id = safe_get_asset(attributes.STANDARD.DIVE_ALT_PATH1, -1);
						if (path_id != -1) path_start(path_id, moveSpeed, 0, 0);
					}
				}

				// Transition to dive attack state
				enemyState = EnemyState.IN_DIVE_ATTACK;
			}
		}

	}
	else if (enemyState == EnemyState.IN_DIVE_ATTACK) {

		/// ================================================================
		/// BEAM WEAPON LOGIC - Special charge and firing system
		/// ================================================================
		/// Allows beam-capable enemies (like TIE Intercepters) to activate
		/// a special beam weapon during the dive attack phase.
		///
		/// Beam activation occurs when:
		/// • beam flag is enabled for this enemy
		/// • Enemy reaches activation position (y > 368 * global.Game.Display.scale)
		/// • Player is vulnerable (not invulnerable, not in dual mode)
		///
		/// Beam phases:
		/// • loop = 0: Normal charging phase, moving to beam position
		/// • loop = -1: Beam is active, charging animation playing
		/// • loop = -2: Beam charging complete, beginning dive away
		/// ================================================================
		if (beam_weapon.available && instance_exists(oPlayer) && (oPlayer.shotMode == _ShotMode.SINGLE)) {
			
			if ((y > 368 * global.Game.Display.scale) && beam_weapon.state != BEAM_STATE.FAILED) {
				
				if (beam_weapon.state == BEAM_STATE.READY) {
					// BEAM ACTIVATION POSITION REACHED 
					// Check if PLAYER is in single mode && use a random one-in-three chance to activate
					if (!global.Game.Enemy.capturedPlayer && (irandom(0) == 0)) beam_weapon.state = BEAM_STATE.CHARGING;
					else beam_weapon.state = BEAM_STATE.FAILED;
				}
				else { 
					// BEAM will be CHARGING, then FIRE, then FIRE_COMPLETE

					if (beam_weapon.state == BEAM_STATE.CHARGING) {
						path_end();
									
						/// First frame at beam position: Stop movement and start charge sequence
						speed = 0;
						direction = TARGET_DIRECTION_DOWN;

						/// Set beam duration timer (alarm[3] controls beam animation timing)
						alarm[3] = global.Game.Enemy.beamDuration;

						/// Mark loop state as firing
						beam_weapon.state = BEAM_STATE.FIRE;

						/// Stop dive sound and play beam sound effect
						sound_stop(GBeam);
						sound_loop(GBeam);
					}
					/// === PLAYER CAPTURE ZONE ===
					/// During beam FIRE phase, check if player is in capture zone
					///
					/// DESIGN NOTE: Using rectangular bounds check instead of circular distance
					/// Rectangular check: 2 comparisons (fast)
					/// Circular check: sqrt(dx² + dy²) = expensive, ~10x slower
					///
					/// Capture zone: 64 pixels wide (x-32 to x+32), centered on beam
					/// Visual beam width matches this hitbox for accurate feel
					else if (beam_weapon.state == BEAM_STATE.FIRE && instance_exists(oPlayer)) {
						// Original circular implementation (kept for reference):
						// var distance_to_player = distance_to_point(oPlayer.x, oPlayer.y);
						// var capture_radius = 48 * global.Game.Display.scale;

						// Optimized: Check if player X is within tracker beam's horizontal bounds
						var withinBem = (oPlayer.x > x-BEAM_CAPTURE_WIDTH && oPlayer.x < x+BEAM_CAPTURE_WIDTH);

						/// Check if player is within capture zone and is vulnerable
						if (withinBem && oPlayer.shipStatus == _ShipState.ACTIVE) {

							// check if we're within the BEAM period
							if (alarm[3] < ((2 * global.Game.Enemy.beamDuration) / 3) && alarm[3] > global.Game.Enemy.beamDuration / 3) {
								beam_weapon.state = BEAM_STATE.CAPTURE_PLAYER;

								/// Player is captured by beam!
								oPlayer.shipStatus = _ShipState.CAPTURED;
								oPlayer.alarm[5] = 240;

								// grab the player x location
								beam_weapon.player_x = oPlayer.x;
								beam_weapon.player_y = 1024;

								/// Store the capturing enemy reference
								oPlayer.captor = id;

								global.Game.Enemy.capturedPlayer = true;

								sound_stop(GBeam);			// Stop beam sound
						        sound_loop(GCaptured);		// Play captured sound

								// delay the RESPAWN of the PLAYER
								oPlayer.alarm[0] = 420;

								// extend the beam to cover the period to CAPTURE the player
						        alarm[3] = ((global.Game.Enemy.beamDuration / 3) / (90 / alarm[3])) + 20;
							}
						}
					}
					else if (beam_weapon.state == BEAM_STATE.CAPTURE_PLAYER) {
						// animation to draw the player to the Enemy ...
						
						// player is at 1024, Enemy is at 736
						// 90 seconds to move 288 pixels					
						// Move ship vertically towards boss
						beam_weapon.player_y = 736 + floor((alarm[3] * 288) / global.Game.Enemy.beamDuration);
						// align the PLAYER x with the centre of the Enemy 
						if (beam_weapon.player_x < x) { beam_weapon.player_x += 3; }
						else if (beam_weapon.player_x > x) { beam_weapon.player_x -= 3; }
					}
					else if (alarm[3] == -1) {
						speed = entranceSpeed;

						beam_weapon.state = BEAM_STATE.FIRE_COMPLETE;
					}
				}
			}
		}

		// follow DIVE path until a certain Y location ...
		if (y <= DIVE_Y_THRESHOLD * global.Game.Display.scale) {
			// do nothing ... execute DIVE PATH
		}
		else if ((y > DIVE_Y_THRESHOLD * global.Game.Display.scale)) {
		
			if (attributes.CAN_LOOP) {
	
				path_end();
			
				if (x > SCREEN_CENTER_X * global.Game.Display.scale) {				
					if (attributes.LOOP_PATH != noone) {
						var path_id = asset_get_index(attributes.LOOP_PATH);
						if (path_id != -1) path_start(path_id, moveSpeed, 0, 0);
					}
				}
				else {
					if (attributes.LOOP_ALT_PATH != noone) {
						var path_id = asset_get_index(attributes.LOOP_ALT_PATH);
						if (path_id != -1) path_start(path_id, moveSpeed, 0, 0);
					}
				}
					
				enemyState = EnemyState.IN_LOOP_ATTACK;				
			}
			else if (y < SCREEN_BOTTOM_Y * global.Game.Display.scale) {
				// Adjust direction towards down
				if (direction < TARGET_DIRECTION_DOWN) {
					direction += 1;
				}
				if (direction > TARGET_DIRECTION_DOWN) {
					direction -= 1;
				}		
			}
			else {
				// reset to the top of screen and move into formation
				path_end();
				speed = entranceSpeed;
		
				x = breathex;
				y = SPAWN_TOP_Y;

				// reset beam state
				if (beam_weapon.available) { beam_weapon.state = BEAM_STATE.READY; }
				
				// BUG: weird issue when we get down to last 2 enemies, ...
				// the enemy has a one-time crazy path then resets ...
				
				// check if we're the last two enemies left ...
				if (global.Game.Enemy.count < 3) enemyState = EnemyState.IN_FINAL_ATTACK;
				else enemyState = EnemyState.MOVE_INTO_FORMATION;
			}
		}
	}
	else if (enemyState == EnemyState.IN_LOOP_ATTACK) {

		// check if path has ended ... return to formation
		if (path_position >= 1) {
			// return to FORMATION
			speed = entranceSpeed;

			enemyState = EnemyState.MOVE_INTO_FORMATION;		
		}
	}
	else if (enemyState == EnemyState.IN_FINAL_ATTACK) {
		if (y > SCREEN_BOTTOM_Y * global.Game.Display.scale) {
			// reset to the top of screen and move into formation
			path_end();

			// randomize the x location of where the enemy will drop in ...
			// don't spawn near the edges of the screen
			x = SPAWN_EDGE_MARGIN + irandom(global.screen_width-SPAWN_EDGE_BUFFER);
			y = SPAWN_TOP_Y;

			// spawn enemy bullets ...
			alarm[1] = ENEMY_SHOT_ALARM;
		
			// dive sound ...
			sound_stop(GDive);
			sound_play(GDive);

			// Choose path based on starting position
			if (x > SCREEN_CENTER_X * global.Game.Display.scale) {
				if (attributes.STANDARD.DIVE_PATH2 != noone) {
					var path_id = asset_get_index(attributes.STANDARD.DIVE_PATH2);
					if (path_id != -1) path_start(path_id, moveSpeed, 0, 0);
				}
			} else {
				if (attributes.STANDARD.DIVE_ALT_PATH2 != noone) {
					var path_id = asset_get_index(attributes.STANDARD.DIVE_ALT_PATH2);
					if (path_id != -1) path_start(path_id, moveSpeed, 0, 0);
				}				
			}
		}
	}
}
