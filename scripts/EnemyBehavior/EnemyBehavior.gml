/// @file EnemyBehavior.gml
/// @description Extracted enemy behavior functions from oEnemyBase/Step_0.gml
///              Reduces 400+ line Step event to <100 lines by extracting logic
///
/// BENEFITS:
///   - Improved readability (each function has single responsibility)
///   - Easier to test individual behaviors
///   - Reduced cyclomatic complexity
///   - Better maintainability
///
/// USAGE:
///   // In oEnemyBase/Step_0.gml:
///   switch(enemyState) {
///       case EnemyState.ENTER_SCREEN: update_enter_screen(self); break;
///       case EnemyState.IN_FORMATION: update_in_formation(self); break;
///       // ...
///   }

/// @function update_enter_screen
/// @description Handles ENTER_SCREEN state logic
/// @param {Id.Instance} _enemy Enemy instance
/// @return {undefined}
function update_enter_screen(_enemy) {
	with (_enemy) {
		// Follow entrance path
		if (PATH_NAME != noone && PATH_NAME != "" && is_string(PATH_NAME)) {
			var path_id = get_cached_asset(PATH_NAME);

			if (path_id != -1 && !path_exists(path_id)) {
				path_start(path_id, ENEMY_BASE_SPEED * global.Game.Difficulty.speedMultiplier, path_action_stop, false);
			}
		}

		// Check if reached end of path
		if (path_position >= 1 || path_position == -1) {
			path_end();
			enemyState = EnemyState.MOVE_INTO_FORMATION;
		}
	}
}

/// @function update_move_into_formation
/// @description Handles MOVE_INTO_FORMATION state logic
/// @param {Id.Instance} _enemy Enemy instance
/// @return {undefined}
function update_move_into_formation(_enemy) {
	with (_enemy) {
		// Get formation position
		if (INDEX >= 0 && INDEX < 40) {
			var target_x = formation.POSITION[INDEX]._x * global.Game.Display.scale;
			var target_y = formation.POSITION[INDEX]._y * global.Game.Display.scale;

			// Move towards formation position
			var dist_x = target_x - x;
			var dist_y = target_y - y;
			var dist = point_distance(x, y, target_x, target_y);

			if (dist > FORMATION_POSITION_THRESHOLD) {
				// Move towards formation
				var move_speed = ENEMY_BASE_SPEED * global.Game.Difficulty.speedMultiplier;
				x += sign(dist_x) * min(abs(dist_x), move_speed);
				y += sign(dist_y) * min(abs(dist_y), move_speed);
			} else {
				// Reached formation position
				x = target_x;
				y = target_y;
				xstart = x;
				ystart = y;
				enemyState = EnemyState.IN_FORMATION;

				// Start rotation to face down
				alarm[EnemyAlarmIndex.FORMATION_ROTATION] = FORMATION_ALARM_DELAY;
			}
		}
	}
}

/// @function update_in_formation
/// @description Handles IN_FORMATION state logic (breathing animation + dive setup)
/// @param {Id.Instance} _enemy Enemy instance
/// @return {undefined}
function update_in_formation(_enemy) {
	with (_enemy) {
		// === BREATHING ANIMATION ===
		apply_breathing_animation(self);

		// === DIVE ATTACK TRIGGERING ===
		if (should_initiate_dive(self)) {
			setup_dive_attack(self);
		}

		// === TRANSFORMATION LOGIC ===
		if (should_transform(self)) {
			setup_transformation(self);
		}
	}
}

/// @function apply_breathing_animation
/// @description Applies formation breathing oscillation
/// @param {Id.Instance} _enemy Enemy instance
/// @return {undefined}
function apply_breathing_animation(_enemy) {
	with (_enemy) {
		if (INDEX >= 0 && INDEX < 40) {
			var formation_center_x = FORMATION_CENTER_X * global.Game.Display.scale;
			var formation_width = FORMATION_WIDTH * global.Game.Display.scale;
			var amplitude = FORMATION_BREATHE_AMPLITUDE * global.Game.Display.scale;

			// Calculate horizontal offset based on position in formation
			var offset = ((xstart - formation_center_x) / formation_width) * amplitude;

			// Apply breathing oscillation
			var breathe_value = (global.Game.Enemy.breathePhase / BREATHING_CYCLE_MAX);
			breathex = xstart + (breathe_value * offset);

			// Update position
			x = breathex;
			y = ystart;
		}
	}
}

/// @function should_initiate_dive
/// @description Checks if enemy should start dive attack
/// @param {Id.Instance} _enemy Enemy instance
/// @return {Bool} True if should dive
function should_initiate_dive(_enemy) {
	with (_enemy) {
		// Check dive capacity available
		if (global.Game.Enemy.diveCapacity <= 0) return false;

		// Check prohibit flag
		if (global.Game.State.prohibitDive > 0) return false;

		// Random chance to dive
		if (irandom(DIVE_TRIGGER_RANDOM_RANGE) != 0) return false;

		// Don't dive if alarm already set
		if (alarm[EnemyAlarmIndex.DIVE_ATTACK] != -1) return false;

		return true;
	}
}

/// @function setup_dive_attack
/// @description Sets up dive attack alarm and decrements capacity
/// @param {Id.Instance} _enemy Enemy instance
/// @return {undefined}
function setup_dive_attack(_enemy) {
	with (_enemy) {
		// Consume dive capacity
		global.Game.Enemy.diveCapacity--;

		// Set dive alarm based on wave
		var alarm_delay = DIVE_ALARM_STANDARD;
		if (global.Game.Level.wave == 0) {
			alarm_delay = DIVE_ALARM_INITIAL;
		} else if (global.Game.State.fastEnter) {
			alarm_delay = DIVE_ALARM_FAST;
		}

		alarm[EnemyAlarmIndex.DIVE_ATTACK] = alarm_delay;
	}
}

/// @function should_transform
/// @description Checks if enemy should transform (combine with escort)
/// @param {Id.Instance} _enemy Enemy instance
/// @return {Bool} True if should transform
function should_transform(_enemy) {
	with (_enemy) {
		// Check if transformation is enabled for this enemy
		if (!attributes.CAN_TRANSFORM) return false;

		// Check transformation tokens available
		if (global.Game.Enemy.transformTokens <= 0) return false;

		// Check enemy count not too high
		if (global.Game.Enemy.count > MAX_TRANSFORM_ENEMY_COUNT) return false;

		// Check dive capacity available
		if (global.Game.Enemy.diveCapacity <= 0) return false;

		// Random chance
		if (irandom(TRANSFORM_RANDOM_RANGE) != 0) return false;

		return true;
	}
}

/// @function setup_transformation
/// @description Sets up transformation alarm
/// @param {Id.Instance} _enemy Enemy instance
/// @return {undefined}
function setup_transformation(_enemy) {
	with (_enemy) {
		global.Game.Enemy.transformTokens--;
		alarm[EnemyAlarmIndex.DIVE_ATTACK] = TRANSFORM_ALARM_DELAY;
	}
}

/// @function update_dive_attack
/// @description Handles IN_DIVE_ATTACK state logic
/// @param {Id.Instance} _enemy Enemy instance
/// @return {undefined}
function update_dive_attack(_enemy) {
	with (_enemy) {
		// Follow dive path
		if (path_index != -1) {
			// Check if reached end of dive path
			if (path_position >= 1) {
				path_end();

				// Transition to loop or final attack
				if (attributes.CAN_LOOP) {
					enemyState = EnemyState.IN_LOOP_ATTACK;
					start_loop_path(self);
				} else {
					enemyState = EnemyState.IN_FINAL_ATTACK;
				}
			}
		}

		// === BEAM WEAPON LOGIC (TIE Interceptor only) ===
		if (beam_weapon.available) {
			update_beam_weapon(self);
		}

		// Check if went offscreen
		if (y > OFFSCREEN_Y_THRESHOLD * global.Game.Display.scale) {
			handle_dive_completion(self);
		}
	}
}

/// @function update_beam_weapon
/// @description Handles beam weapon activation during dive
/// @param {Id.Instance} _enemy Enemy instance
/// @return {undefined}
function update_beam_weapon(_enemy) {
	with (_enemy) {
		// Check if at activation position
		if (y > BEAM_ACTIVATION_Y * global.Game.Display.scale &&
		    beam_weapon.state != BEAM_STATE.FAILED) {

			if (beam_weapon.state == BEAM_STATE.READY) {
				// Check activation conditions
				if (!global.Game.Enemy.capturedPlayer &&
				    instance_exists(oPlayer) &&
				    oPlayer.shotMode == ShotMode.SINGLE) {

					// Random 1-in-3 chance to activate
					if (irandom(2) == 0) {
						beam_weapon.state = BEAM_STATE.CHARGING;
					} else {
						beam_weapon.state = BEAM_STATE.FAILED;
					}
				} else {
					beam_weapon.state = BEAM_STATE.FAILED;
				}
			}
		}
	}
}

/// @function start_loop_path
/// @description Starts loop-back path to return to formation
/// @param {Id.Instance} _enemy Enemy instance
/// @return {undefined}
function start_loop_path(_enemy) {
	with (_enemy) {
		var loop_path_name = (x > SCREEN_CENTER_X * global.Game.Display.scale) ?
			attributes.LOOP_PATH : attributes.LOOP_ALT_PATH;

		var path_id = get_cached_asset(loop_path_name);
		if (path_id != -1) {
			path_start(path_id, ENEMY_BASE_SPEED * global.Game.Difficulty.speedMultiplier, path_action_stop, false);
		}
	}
}

/// @function handle_dive_completion
/// @description Handles enemy returning to formation after dive
/// @param {Id.Instance} _enemy Enemy instance
/// @return {undefined}
function handle_dive_completion(_enemy) {
	with (_enemy) {
		// Reset position to formation
		x = breathex;
		y = SPAWN_TOP_Y * global.Game.Display.scale;

		// Reset beam state
		if (beam_weapon.available) {
			beam_weapon.state = BEAM_STATE.READY;
		}

		// Transition to appropriate state
		if (global.Game.Enemy.count < FINAL_ATTACK_ENEMY_COUNT) {
			enemyState = EnemyState.IN_FINAL_ATTACK;
		} else {
			enemyState = EnemyState.MOVE_INTO_FORMATION;
		}
	}
}

/// @function update_loop_attack
/// @description Handles IN_LOOP_ATTACK state logic
/// @param {Id.Instance} _enemy Enemy instance
/// @return {undefined}
function update_loop_attack(_enemy) {
	with (_enemy) {
		// Check if loop path complete
		if (path_position >= 1 || path_position == -1) {
			path_end();
			enemyState = EnemyState.MOVE_INTO_FORMATION;
		}
	}
}

/// @function update_final_attack
/// @description Handles IN_FINAL_ATTACK state (aggressive diving when few enemies remain)
/// @param {Id.Instance} _enemy Enemy instance
/// @return {undefined}
function update_final_attack(_enemy) {
	with (_enemy) {
		// More aggressive dive timing
		if (alarm[EnemyAlarmIndex.DIVE_ATTACK] == -1 && irandom(5) == 0) {
			alarm[EnemyAlarmIndex.DIVE_ATTACK] = 30; // Faster dive timing
		}
	}
}

/// @function start_final_attack_dive
/// @description Initializes first dive in IN_FINAL_ATTACK mode
/// @param {Id.Instance} _enemy Enemy instance
/// @return {undefined}
function start_final_attack_dive(_enemy) {
	with (_enemy) {
		// Randomize spawn position
		x = 400 + irandom(96); //SPAWN_EDGE_MARGIN + irandom(global.Game.Display.screenWidth - SPAWN_EDGE_BUFFER);
		y = SPAWN_TOP_Y;

		// Choose path based on position
		if (x > SCREEN_CENTER_X * global.Game.Display.scale) {
			if (attributes.STANDARD.DIVE_PATH2 != noone) {
				var path_id = safe_get_asset(attributes.STANDARD.DIVE_PATH2, -1);
				if (path_id != -1) path_start(path_id, moveSpeed, 0, 0);
			}
		} else {
			if (attributes.STANDARD.DIVE_ALT_PATH2 != noone) {
				var path_id = safe_get_asset(attributes.STANDARD.DIVE_ALT_PATH2, -1);
				if (path_id != -1) path_start(path_id, moveSpeed, 0, 0);
			}
		}

		// Sound and shooting
		global.Game.Controllers.audioManager.stopSound(GDive);
		global.Game.Controllers.audioManager.playSound(GDive);
		alarm[1] = ENEMY_SHOT_ALARM;
	}
}