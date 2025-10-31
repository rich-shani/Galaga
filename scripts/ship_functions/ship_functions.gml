
/// @function handle_shot_collision(shot_index, enemy_x, enemy_y, enemy_instance)
/// @description Handles collision between a shot and an enemy, applying hit effects
/// @param {real} shot_index Which shot and ship variant (0=shot1 first ship, 1=shot2 first ship, 2=shot1 second ship, 3=shot2 second ship)
/// @param {real} enemy_x Enemy X-coordinate
/// @param {real} enemy_y Enemy Y-coordinate
/// @param {instance} enemy_instance The enemy instance to check collision with
/// ================================================================
/// LEGACY COLLISION HANDLER - Shot vs Enemy
/// ================================================================
/// Handles collision detection and response for player shots hitting enemies.
/// This is a legacy function that includes offset support for dual-ship scenarios.
///
/// Shot indices:
/// • 0: shot1 from first ship (no offset)
/// • 1: shot2 from first ship (no offset)
/// • 2: shot1 from second ship (28-pixel offset)
/// • 3: shot2 from second ship (28-pixel offset)
///
/// Offset mechanics:
/// • Second ship positions are offset by 28 pixels horizontally
/// • Accounts for two ships flying in parallel
///
/// Collision requirements:
/// • Both X and Y must be within space radius
/// • For shots 0-1: Always check (first ship always active)
/// • For shots 2-3: Only check if dub1/dub2 flag is set (second ship active)
/// ================================================================
function handle_shot_collision(shot_index, enemy_x, enemy_y, enemy_instance) {
    /// Select which shot coordinates to use based on shot_index
    var shot_x = (shot_index == 0 || shot_index == 2) ? shot1x : shot2x;
    var shot_y = (shot_index == 0 || shot_index == 2) ? shot1y : shot2y;

    /// Check if second ship (dub mode) is active for this shot
    var dub_check = (shot_index == 0 || shot_index == 2) ? dub1 : dub2;

    /// Apply offset for second ship's shots (28-pixel spacing)
    var offset = (shot_index == 2 || shot_index == 3) ? 28 : 0;

    /// Collision detection with offset and mode checking
    if (abs(enemy_x - shot_x - offset) < space && abs(enemy_y - shot_y) < space && (dub_check == 1 || shot_index < 2)) {
        /// Execute hit visual/audio effects
        script_execute(shot1for2, shot_index);

        /// Deactivate the shot (move to -32,-32 marker position)
        if (shot_index == 0 || shot_index == 2) {
            shot1x = -32;
            shot1y = -32;
        } else {
            shot2x = -32;
            shot2y = -32;
        }

        /// Update hit statistics
        oGameManager.hits += 1;

        /// Handle enemy-specific destruction logic
        with (enemy_instance) {
            if (object_index == obj_Boss) {
                /// === BOSS TWO-HIT SYSTEM ===
                if (hit == 0) {
                    /// First hit: Mark boss as damaged
                    hit = 1;
                    sound_stop(GBoss1);
                    sound_play(GBoss1);
                } else if (hit == 1 && carrying == 1 && dive == 1) {
                    /// Second hit with captured fighter: Trigger rescue
                    sound_loop(GRescue);
                    Ship.regain = 1;
                    Ship.alarm[3] = 90;
                    Ship.newshipy = Fighter.y;
                    Ship.newshipx = Fighter.x;
                    with (Fighter) { instance_destroy(); }
                    instance_destroy();
                }
            } else if (object_index == obj_Fighter) {
                /// Fighter rescue target: Clear tracking on hit
                global.fighterstore = 0;
                instance_destroy();
            } else {
                /// Normal enemy: Destroy on hit
                instance_destroy();
            }
        }
    }
}

/// @function handle_player_hit(enemy_x, enemy_y, enemy_instance, is_double, is_right)
/// @description Handles collision between player ship and enemies
/// @param {real} enemy_x X-coordinate of the enemy
/// @param {real} enemy_y Y-coordinate of the enemy
/// @param {instance} enemy_instance The enemy instance
/// @param {bool} is_double Whether in dual-ship mode
/// @param {bool} is_right Which ship to check in dual mode (true=right, false=left)
/// ================================================================
/// PLAYER COLLISION WITH ENEMIES
/// ================================================================
/// Handles when the player ship collides with an enemy or enemy projectile.
/// Collision effects depend on current game mode and ship state.
///
/// Single-ship mode:
/// • Collision sets shipStatus = 1 (dead)
/// • Sets 120-frame death animation timer (alarm[0] = 120)
/// • Ship explodes and respawns after animation completes
///
/// Dual-ship mode:
/// • Collision destroys only one ship (left or right based on is_right)
/// • Other ship continues flying
/// • Reverts to single-shot mode (shotMode = ShotMode.SINGLE)
/// • Sets skip flag to prevent double-destruction
/// • Repositions surviving ship for center-screen flying
///
/// Both modes:
/// • Play death sound effect (GDie)
/// • Enemy hit detection applies (boss two-hit, fighter rescue, etc.)
/// ================================================================
function handle_player_hit(enemy_x, enemy_y, enemy_instance, is_double, is_right) {
    /// === SELECT SHIP POSITION ===
    /// In dual-ship mode, check the appropriate ship position
    /// In single-ship mode, just check main ship position
    var check_x = is_right ? (Ship.x + Ship.SHIP_SPACE) : Ship.x;

    /// === COLLISION DETECTION ===
    /// Check if enemy is within collision radius of the ship
    /// Additional condition: Must be in ACTIVE state or in dual mode with no skip flag
    if (abs(enemy_x - check_x) < space2 && abs(enemy_y - Ship.y) < space2 && (oPlayer.shipStatus == _ShipState.ACTIVE || (is_double && skip == 0))) {
        /// Play death sound effect
        sound_stop(GDie);
        sound_play(GDie);

        /// === COLLISION RESPONSE ===
        if (is_double) {
            /// DUAL-SHIP MODE: One ship is destroyed
            skip = 1; // Prevent double-destruction of same ship

            /// Record destroyed ship position
            secondx = is_right ? (oPlayer.x + oPlayer.SHIP_SPACE) : Ship.x;

            /// If left ship hit, move right ship to center
            if (!is_right) oPlayer.x += oPlayer.SHIP_SPACE;

            /// Revert to single-shot firing pattern
            shotMode = ShotMode.SINGLE;
        } else {
            /// SINGLE-SHIP MODE: Ship enters death state
            shipStatus = 1; // Mark ship as dead

            /// Set death animation duration (120 frames ≈ 2 seconds at 60 FPS)
            alarm[0] = 120;
        }

        /// === ENEMY RESPONSE TO COLLISION ===
        /// Enemy may survive collision (boss) or be destroyed
        with (enemy_instance) {
            if (object_index == obj_Boss) {
                /// === BOSS COLLISION LOGIC ===
                if (hit == 0) {
                    /// First collision: Boss becomes vulnerable
                    hit = 1;
                    sound_stop(GBoss1);
                    sound_play(GBoss1);
                } else if (hit == 1 && carrying == 1 && dive == 1) {
                    /// Second collision with kidnapped fighter: Boss dies and fighter rescued
                    sound_loop(GRescue);
                    Ship.regain = 1;
                    Ship.alarm[3] = 90;
                    Ship.newshipy = Fighter.y;
                    Ship.newshipx = Fighter.x;
                    with (Fighter) { instance_destroy(); }
                    instance_destroy();
                }
            } else if (object_index == obj_Fighter) {
                /// Fighter rescue target: Clear rescue tracking
                global.fighterstore = 0;
                instance_destroy();
            } else {
                /// Normal enemy: Destroyed on collision
                instance_destroy();
            }
        }
    }
}

/// @function scr_handle_shot_collision_enemy(id)
/// @description Dispatcher for handling normal enemy shot collisions
/// @param {instance} id The enemy instance to check for shot collisions
/// ================================================================
/// NORMAL ENEMY SHOT COLLISION DISPATCHER
/// ================================================================
/// Calls all necessary collision detection functions for a normal enemy.
/// Checks both single-shot mode and dual-ship special collision modes.
/// ================================================================
function scr_handle_shot_collision_enemy(id) {
	/// Check primary shots (shot1 and shot2) - normal collision detection
	scr_handle_shot_collision(id, 0, false, 0);  // shot1
	scr_handle_shot_collision(id, 1, false, 0);  // shot2

	/// Check dual-ship mode collisions
	/// Handles shots from second ship with offset positioning
	scr_handle_enemy_collisions(id);
}

/// @function scr_handle_shot_collision_boss(id)
/// @description Dispatcher for handling boss shot collisions
/// @param {instance} id The boss instance to check for shot collisions
/// ================================================================
/// BOSS SHOT COLLISION DISPATCHER
/// ================================================================
/// Calls all necessary collision detection functions for a boss enemy.
/// Passes boss hit state to enable two-hit system.
/// Checks both single-shot mode and dual-ship special collision modes.
/// ================================================================
function scr_handle_shot_collision_boss(id) {
	/// Check primary shots (shot1 and shot2) with boss two-hit system
	scr_handle_shot_collision(id, 0, true, hit);  // shot1 - pass hit state
	scr_handle_shot_collision(id, 1, true, hit);  // shot2 - pass hit state

	/// Check dual-ship mode collisions with boss-specific logic
	scr_handle_boss_collisions(object_index);
}
	
/// @function scr_handle_shot_collision(obj, shot_index, is_boss, boss_hit_state)
/// @description Core collision detection for player shots hitting enemies
/// @param {instance} obj The enemy object instance to check
/// @param {real} shot_index Which shot to check (0=shot1, 1=shot2)
/// @param {bool} is_boss Whether this is a boss enemy (affects hit logic)
/// @param {real} boss_hit_state Current boss hit count (0=first hit, 1=second hit)
/// @return {bool} True if collision occurred and was processed, false otherwise
/// ================================================================
/// CORE SHOT-ENEMY COLLISION SYSTEM
/// ================================================================
/// This is the primary collision detection function for player shots.
/// It handles both normal enemies (1-hit kills) and boss enemies (2-hit kills).
///
/// Collision detection:
/// • Circular hitbox with radius Ship.space
/// • Checks only active shots (within bounds)
/// • Most enemies skip collision if y <= -17 (off-screen top)
/// • Transform always checks collision regardless of screen position
///
/// Boss two-hit mechanic:
/// • First hit (boss_hit_state=0): Marks boss as hit, plays sound, survives
/// • Second hit (boss_hit_state=1): Destroys boss, may trigger rescue
///
/// Fighter rescue system:
/// • If boss carrying=1 and dive=1, it's kidnapped a fighter
/// • On second hit: Enable rescue mode and restore fighter to ship
/// • Grant 90-frame invulnerability period
///
/// Shot management:
/// • Deactivates shot (moves to -32,-32) after hit
/// • Only one shot can hit per function call
/// • Returns true if hit occurred, false if no collision
/// ================================================================
function scr_handle_shot_collision(obj, shot_index, is_boss, boss_hit_state) {
	with (obj) {
		/// === BOUNDARY CHECK ===
		/// Skip collision for off-screen enemies (except Transform which always checks)
		if (object_index != Transform && y <= -17) return false;

		/// === SELECT SHOT POSITION ===
		/// Determine which of the two possible shots to check against
		var shot_x = (shot_index == 0) ? Ship.shot1x : Ship.shot2x;
		var shot_y = (shot_index == 0) ? Ship.shot1y : Ship.shot2y;

		/// === COLLISION CHECK ===
		/// Use distance-based circular collision detection
		/// Hit occurs if both X and Y distances are within Ship.space radius
		if (abs(x - shot_x) < Ship.space && abs(y - shot_y) < Ship.space) {
			/// Execute hit visual/audio effects
			script_execute(shot1for2, shot_index);

			/// === DEACTIVATE SHOT ===
			/// Move shot off-screen so it can't hit multiple enemies
			if (shot_index == 0) {
				Ship.shot1x = Ship.SHOT_OFFSCREEN; // -32 marks inactive
				Ship.shot1y = Ship.SHOT_OFFSCREEN;
			} else {
				Ship.shot2x = Ship.SHOT_OFFSCREEN; // -32 marks inactive
				Ship.shot2y = Ship.SHOT_OFFSCREEN;
			}

			/// Update game statistics
			oGameManager.hits += 1;

			/// === DAMAGE AND DESTRUCTION LOGIC ===
			if (is_boss) {
				/// === BOSS TWO-HIT SYSTEM ===
				if (boss_hit_state == 0) {
					/// FIRST HIT: Boss survives but is marked as hit
					hit = 1;

					/// Play boss hit sound effect
					sound_stop(GBoss1);
					sound_play(GBoss1);

					/// Return true but don't destroy the boss
					return true;
				} else if (boss_hit_state == 1) {
					/// SECOND HIT: Boss is destroyed

					/// === FIGHTER RESCUE MECHANIC ===
					/// Check if boss was carrying a kidnapped fighter
					if (carrying == 1 && dive == 1) {
						/// Play rescue music instead of boss death sound
						sound_loop(GRescue);

						/// Enable ship rescue/recovery mode
						Ship.regain = 1;

						/// Grant 90-frame invulnerability period (~1.5 seconds at 60 FPS)
						Ship.alarm[3] = 90;

						/// Restore ship position to fighter's last location
						Ship.newshipx = Fighter.x;
						Ship.newshipy = Fighter.y;

						/// Clean up the captured fighter sprite
						with (Fighter) instance_destroy();
					}

					/// Destroy the boss instance
					instance_destroy();
				}
			} else {
				/// === NORMAL ENEMY (1-HIT KILL) ===
				/// Non-boss enemies are destroyed immediately on hit

				/// Special handling for Fighter objects (part of rescue mechanic)
				if (object_index == Fighter) {
					global.fighterstore = 0; // Clear rescue tracking
				}

				/// Destroy the enemy instance
				instance_destroy();
			}

			/// Collision was processed successfully
			return true;
		}

		/// No collision detected
		return false;
	}
}

/// @function scr_move_ship_bullets()
/// @description Updates position of both player shots each frame
/// ================================================================
/// PLAYER SHOT MOVEMENT SYSTEM
/// ================================================================
/// Moves both shots in their designated directions using trigonometric
/// calculations. Shots are removed from screen when they go out of bounds.
///
/// Coordinate system:
/// • GameMaker uses standard screen coordinates (origin at top-left)
/// • shot1dir and shot2dir are in degrees (0-360)
/// • Trigonometric functions convert direction angles to X/Y velocity
///
/// Movement physics:
/// • cos(angle) provides vertical movement component
/// • sin(angle) provides horizontal movement component
/// • Both multiplied by SHOT_SPEED for consistent velocity
///
/// Boundary management:
/// • 31-pixel margin outside room bounds before deactivation
/// • Prevents visible pop-in/pop-out at screen edges
/// ================================================================
function scr_move_ship_bullets() {
	/// === SHOT 1 MOVEMENT ===
	if (Ship.shot1y > -31 && Ship.shot1x > -31 && Ship.shot1y < room_height + 31 && Ship.shot1x < room_width + 31) {
        /// Shot is on-screen or near boundaries - update position
        /// Uses trigonometric decomposition to move at angle
        Ship.shot1y -= (Ship.SHOT_SPEED * cos(degtorad(Ship.shot1dir))); // Vertical movement
        Ship.shot1x -= (Ship.SHOT_SPEED * sin(degtorad(Ship.shot1dir))); // Horizontal movement
    } else {
        /// Shot has left the play area - deactivate it
        Ship.shot1x = Ship.SHOT_OFFSCREEN; // Marker: -32 indicates inactive
        Ship.shot1y = Ship.SHOT_OFFSCREEN;
    }

    /// === SHOT 2 MOVEMENT ===
    /// For dual-shot mode (when ship is doubled with another ship)
    if (Ship.shot2y > -31 && Ship.shot2x > -31 && Ship.shot2y < room_height + 31 && Ship.shot2x < room_width + 31) {
        /// Shot is on-screen or near boundaries - update position
        Ship.shot2y -= (Ship.SHOT_SPEED * cos(degtorad(Ship.shot2dir))); // Vertical movement
        Ship.shot2x -= (Ship.SHOT_SPEED * sin(degtorad(Ship.shot2dir))); // Horizontal movement
    } else {
        /// Shot has left the play area - deactivate it
        Ship.shot2x = Ship.SHOT_OFFSCREEN; // Marker: -32 indicates inactive
        Ship.shot2y = Ship.SHOT_OFFSCREEN;
    }
}

/// @function scr_handle_enemy_collisions(id)
/// @description Handles shot collision detection for normal enemies (Bee, Butterfly, Fighter, Transform)
/// @param {real} id Object type/instance to check collisions for
/// ================================================================
/// NORMAL ENEMY COLLISION DETECTION
/// ================================================================
/// Handles hit detection for standard enemy types (non-boss).
/// These enemies are destroyed on first hit, unlike Boss which takes 2 hits.
///
/// Supported enemy types:
/// • Bee: Standard enemy, destroyed on hit
/// • Butterfly: Transformation-based enemy, destroyed on hit
/// • Fighter: Special rescue target, resets global.fighterstore on hit
/// • Transform: Special transformation enemy (checked even if off-screen)
///
/// Collision mechanics:
/// • Checks both shots (shot1 and shot2) independently
/// • Accounts for dual-ship offset (Ship.SHIP_SPACE) for second ship position
/// • Requires dub1/dub2 flag set to 1 (dual-mode active)
/// • Hit detection uses circular hitbox (distance check with Ship.space radius)
///
/// Boundary rules:
/// • Most enemies: Skip collision check if y <= -17 (off-screen top)
/// • Transform: Always checks collision (even if off-screen)
/// ================================================================
function scr_handle_enemy_collisions(id) {
    /// Skip collision checks for off-screen enemies (except Transform)
    if (id != Transform && y <= -17) return;

    /// === SHOT 1 COLLISION CHECK ===
    /// Check if shot1 from second ship (offset by SHIP_SPACE) hits this enemy
    if (abs(x - Ship.shot1x - Ship.SHIP_SPACE) < Ship.space && abs(y - Ship.shot1y) < Ship.space && Ship.dub1 == 1) {
        /// Execute hit effect script (visual/audio feedback)
        script_execute(shot1for2, 2);

        /// Deactivate shot1
        Ship.shot1x = Ship.SHOT_OFFSCREEN;
        Ship.shot1y = Ship.SHOT_OFFSCREEN;

        /// Update game statistics
        oGameManager.hits += 1;

        /// Special handling for Fighter rescue mechanic
        if (id == Fighter) {
            global.fighterstore = 0; // Clear fighter rescue state
        }

        /// Destroy the enemy instance (normal enemies die on first hit)
        instance_destroy();
    }

    /// === SHOT 2 COLLISION CHECK ===
    /// Check if shot2 from second ship (offset by SHIP_SPACE) hits this enemy
    if (abs(x - Ship.shot2x - Ship.SHIP_SPACE) < Ship.space && abs(y - Ship.shot2y) < Ship.space && Ship.dub2 == 1) {
        /// Execute hit effect script (visual/audio feedback)
        script_execute(shot1for2, 3);

        /// Deactivate shot2
        Ship.shot2x = Ship.SHOT_OFFSCREEN;
        Ship.shot2y = Ship.SHOT_OFFSCREEN;

        /// Update game statistics
        oGameManager.hits += 1;

        /// Special handling for Fighter rescue mechanic
        if (id == Fighter) {
            global.fighterstore = 0; // Clear fighter rescue state
        }

        /// Destroy the enemy instance (normal enemies die on first hit)
        instance_destroy();
    }
}	

/// @function scr_handle_boss_collisions(id)
/// @description Handles shot collision detection for Boss enemies
/// @param {real} id The Boss object instance ID
/// ================================================================
/// BOSS COLLISION AND TWO-HIT SYSTEM
/// ================================================================
/// Manages collision detection and special logic for Boss enemies.
/// Bosses are significantly more complex than regular enemies:
///
/// Two-hit mechanic:
/// • First hit (hit == 0): Boss becomes invulnerable, plays hit sound
/// • Second hit (hit == 1): Boss destroyed, may rescue captured Fighter
///
/// Rescue mechanic:
/// • If boss is carrying == 1 and dive == 1, it's kidnapped a fighter
/// • On destruction: Transfer fighter position to ship position
/// • Ship gains invulnerability period (alarm[3] = 90 frames)
/// • Rescued fighter respawns with ship
///
/// Collision offset:
/// • Uses Ship.SHIP_SPACE offset (second ship position)
/// • Requires dub1/dub2 flag set to 1 (dual-mode active)
/// • Hit detection uses circular hitbox (distance check with Ship.space radius)
///
/// Off-screen rules:
/// • Skips collision if y <= -17 (off-screen top)
/// ================================================================
function scr_handle_boss_collisions(id) {
    /// Skip collision checks for off-screen bosses
    if (y <= -17) return;

    /// === SHOT 1 COLLISION CHECK ===
    if (abs(x - Ship.shot1x - Ship.SHIP_SPACE) < Ship.space && abs(y - Ship.shot1y) < Ship.space && Ship.dub1 == 1) {
        /// Execute hit effect script (visual/audio feedback)
        script_execute(shot1for2, 2);

        /// Deactivate shot1
        Ship.shot1x = Ship.SHOT_OFFSCREEN;
        Ship.shot1y = Ship.SHOT_OFFSCREEN;

        /// Update game statistics
        oGameManager.hits += 1;

        /// === TWO-HIT SYSTEM ===
        if (hit == 0) {
            /// First hit: Mark boss as damaged but not destroyed
            hit = 1;

            /// Play boss hit sound effect
            sound_stop(GBoss1);
            sound_play(GBoss1);
        } else if (hit == 1) {
            /// Second hit: Boss is destroyed

            /// === FIGHTER RESCUE LOGIC ===
            /// Check if this boss was carrying a kidnapped fighter
            if (carrying == 1 && dive == 1) {
                /// Enable ship rescue mode
                Ship.regain = 1;

                /// Grant invulnerability period (90 frames ≈ 1.5 seconds at 60 FPS)
                Ship.alarm[3] = 90;

                /// Position ship at fighter's last known location
                Ship.newshipx = Fighter.x;
                Ship.newshipy = Fighter.y;

                /// Destroy the captured fighter sprite
                with (Fighter) instance_destroy();
            }

            /// Destroy the boss instance
            instance_destroy();
        }
    }

    /// === SHOT 2 COLLISION CHECK ===
    if (abs(x - Ship.shot2x - Ship.SHIP_SPACE) < Ship.space && abs(y - Ship.shot2y) < Ship.space && Ship.dub2 == 1) {
        /// Execute hit effect script (visual/audio feedback)
        script_execute(shot1for2, 3);

        /// Deactivate shot2
        Ship.shot2x = Ship.SHOT_OFFSCREEN;
        Ship.shot2y = Ship.SHOT_OFFSCREEN;

        /// Update game statistics
        oGameManager.hits += 1;

        /// === TWO-HIT SYSTEM ===
        if (hit == 0) {
            /// First hit: Mark boss as damaged but not destroyed
            hit = 1;

            /// Play boss hit sound effect
            sound_stop(GBoss1);
            sound_play(GBoss1);
        } else if (hit == 1) {
            /// Second hit: Boss is destroyed

            /// === FIGHTER RESCUE LOGIC ===
            /// Check if this boss was carrying a kidnapped fighter
            if (carrying == 1 && dive == 1) {
                /// Enable ship rescue mode
                Ship.regain = 1;

                /// Grant invulnerability period (90 frames ≈ 1.5 seconds at 60 FPS)
                Ship.alarm[3] = 90;

                /// Position ship at fighter's last known location
                Ship.newshipx = Fighter.x;
                Ship.newshipy = Fighter.y;

                /// Destroy the captured fighter sprite
                with (Fighter) instance_destroy();
            }

            /// Destroy the boss instance
            instance_destroy();
        }
    }
}