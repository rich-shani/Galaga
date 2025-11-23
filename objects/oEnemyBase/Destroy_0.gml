/// @description Destroy event for oEnemyBase (and all enemy types)
/// ================================================================
/// ENEMY DESTRUCTION AND SCORING SYSTEM
/// ================================================================
/// Handles all effects when an enemy is destroyed, including:
/// • Awarding player score (based on enemy state && mode)
/// • Managing transformation counters
/// • Playing appropriate sound effects
/// • Tracking special achievement conditions
///
/// Only applies scoring && effects if the enemy dies within the
/// visible play area, preventing score exploitation from off-screen kills.
/// ================================================================

// ensure no looping sounds are still playing ...
global.Game.Controllers.audioManager.stopSound(GBeam);
global.Game.Controllers.audioManager.stopSound(GCaptured);

if (!global.Game.State.isGameOver) {
	/// === BOUNDARY CHECK ===
	/// Only award points && play effects for on-screen kills
	/// This prevents exploiting off-screen enemy kills for free points
	/// Boundaries: Y between -64 && 592, X between -64 && 464 (scaled)
	if (y > SPAWN_TOP_Y * global.Game.Display.scale && y < SCREEN_BOTTOM_Y * global.Game.Display.scale && x > SCREEN_LEFT_X && x < SCREEN_RIGHT_X * global.Game.Display.scale) {

		/// ================================================================
		/// SCORING SYSTEM - Award points based on enemy state
		/// ================================================================
		/// Different point values reward different gameplay strategies:
		/// • IN_DIVE_ATTACK: DIVE_POINT_VALUE (dangerous enemies worth more)
		/// • Otherwise: POINT_VALUE (standard formation enemies)
		///
		/// Challenge mode multipliers apply different point values:
		/// • In challenge: Uses DIVE_POINT_VALUE even for non-diving
		/// • Normal waves: Uses CHALLENGE_POINT_VALUE
		/// ================================================================
		if (enemyState == EnemyState.IN_DIVE_ATTACK) {
			/// Enemy is currently diving/attacking - grant invulnerability window
			oPlayer.alarm[PlayerAlarmIndex.TiMER] = global.Game.State.hold + irandom(global.Game.State.hold);

			/// If not a transformed enemy, award points for the kill
			if (trans == 0) {
				/// Award higher points for diving enemies (more dangerous)
				if (global.Game.Challenge.countdown > 0 || global.Game.Challenge.current == 1) {
					global.Game.Player.score += attributes.DIVE_POINT_VALUE;
				} else {
					global.Game.Player.score += attributes.CHALLENGE_POINT_VALUE;
				}
			}
		} else {
			/// Enemy is in formation || other non-dive state - standard points
			global.Game.Player.score += attributes.POINT_VALUE;
		}

		/// ================================================================
		/// TRANSFORMATION TRACKING AND COMBO SYSTEM
		/// ================================================================
		/// The transformation system tracks enemy combinations for bonuses.
		/// When 3 specific enemies are destroyed in sequence, a special
		/// combined enemy appears (Boss, Butterfly, etc.) worth bonus points.
		///
		/// Transformation combo mechanics:
		/// • Tracks number of consecutive kills (shotcount for normal, transcount for transformed)
		/// • After 8 kills: spawns TransPoints bonus (normal mode)
		/// • After 3 transformations: spawns TransPoints bonus (transformation mode)
		/// ================================================================

		/// === NORMAL MODE COMBO TRACKING ===
		/// Track regular enemy kills for TransPoints bonus
		if global.Game.Challenge.countdown == 0 {
			global.Game.Player.shotCount += 1;

			/// Every ENEMIES_PER_BONUS consecutive kills in normal mode creates a bonus
			if global.Game.Player.shotCount == ENEMIES_PER_BONUS {
				instance_create_layer(round(x), round(y), "GameSprites", TransPoints);
			}
		}

		/// === TRANSFORMATION MODE COMBO TRACKING ===
		if trans == 1 {
			/// Increment transformation counter && award transformation bonus
			global.Game.Enemy.transformCount += 1;
			global.Game.Player.score += TRANSFORMATION_BONUS;  // Fixed bonus per transformed enemy

			/// After 3 transformation kills, spawn TransPoints bonus
			if global.Game.Enemy.transformCount == 3 {
				instance_create_layer(round(x), round(y), "GameSprites", TransPoints);
			}

			/// ================================================================
			/// TRANSFORMATION SOUND EFFECTS
			/// ================================================================
			/// Sound cues indicate which transformation stage was defeated:
			/// • transnum = 1: Boss2 sound (first transformation)
			/// • transnum = 2: Butterfly sound (second transformation)
			/// • transnum = 3: Boss1 sound (third transformation)
			/// ================================================================
			if global.Game.Enemy.transformNum == 1 {
				global.Game.Controllers.audioManager.stopSound(GBoss2);
				global.Game.Controllers.audioManager.playSound(GBoss2);
			}
			if global.Game.Enemy.transformNum == 2 {
				global.Game.Controllers.audioManager.stopSound(GButterfly);
				global.Game.Controllers.audioManager.playSound(GButterfly);
			}
			if global.Game.Enemy.transformNum == 3 {
				global.Game.Controllers.audioManager.stopSound(GBoss1);
				global.Game.Controllers.audioManager.playSound(GBoss1);
			}
		} else {
			/// ================================================================
			/// STANDARD SOUND EFFECTS
			/// ================================================================
			/// Sound cues vary by challenge stage type to provide audio feedback
			/// Challenge stages 1-8 use different sound themes:
			/// • Challenge 1: Bee sound
			/// • Challenges 2,3,5,6,8: Butterfly sound
			/// • Challenge 4: Boss2 sound
			/// • Challenge 7: Boss1 sound
			/// ================================================================
			if global.Game.Challenge.countdown > 0 || global.Game.Challenge.current == 1 {
				global.Game.Controllers.audioManager.stopSound(GBee);
				global.Game.Controllers.audioManager.playSound(GBee);
			}

			if global.Game.Challenge.countdown == 0 {
				if global.Game.Challenge.current == 2 || global.Game.Challenge.current == 3 || global.Game.Challenge.current == 5 || global.Game.Challenge.current == 6 || global.Game.Challenge.current == 8 {
					global.Game.Controllers.audioManager.stopSound(GButterfly);
					global.Game.Controllers.audioManager.playSound(GButterfly);
				}
				if global.Game.Challenge.current == 4 {
					global.Game.Controllers.audioManager.stopSound(GBoss2);
					global.Game.Controllers.audioManager.playSound(GBoss2);
				}
				if global.Game.Challenge.current == 7 {
					global.Game.Controllers.audioManager.stopSound(GBoss1);
					global.Game.Controllers.audioManager.playSound(GBoss1);
				}
			}
		}
		
		// score has been updated, check for extra life condition
		checkForExtraLives();
	}
	
	// check if this enemy had a CAPTURED PLAYER
	if (oPlayer.captor == id) {
		
		// Player was captured - initiate rescue sequence!
		oPlayer.shipStatus = ShipState.RELEASING;
		oPlayer.rescued_fighter_x = beam_weapon.player_x;
		oPlayer.rescued_fighter_y = beam_weapon.player_y;

		// Play rescue sound effect
		global.Game.Controllers.audioManager.loopSound(GRescue); 
		
		// instruct all enemies to return to FORMATION
		with (oEnemyBase) {
			if (enemyState != EnemyState.IN_FORMATION) {
				// end current path && return to FORMATION
				path_end();
				enemyState = EnemyState.MOVE_INTO_FORMATION;
			}
		}	
		
		// remove any enemy missiles in flight
		with (oEnemyShot) {
			instance_destroy();
		}
	}
}
