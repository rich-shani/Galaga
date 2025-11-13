/// @description ENTRANCE SHOOTING TIMER
/// Handles periodic enemy shooting during entrance phase (ENTER_SCREEN && MOVE_INTO_FORMATION states).
///
/// This alarm is initially set in Create_0.gml and repeats until enemy reaches IN_FORMATION state.
/// Once in formation, shooting is handled by alarm[1] in Step_0.gml instead.
///
/// Shooting frequency is controlled by global.Game.Enemy.shotNumber:
///   • shotNumber 2: Up to 4 concurrent shots
///   • shotNumber 3: Up to 6 concurrent shots
///   • shotNumber 4: Up to 8 concurrent shots
///
/// Shooting is disabled on levels 1, 10, && 18 (easy intro levels).
///
/// @related oEnemyBase/Create_0.gml:172-177 - Where alarm[5] is initially set
/// @related oEnemyBase/Step_0.gml:62-86 - Formation shooting logic (different system)

// check PLAYER STATUS - as the player may be RESPAWNING ...
if (global.Game.State.mode == GameMode.GAME_ACTIVE && instance_exists(oPlayer) && oPlayer.shipStatus == ShipState.ACTIVE) {

	// Only allow shooting if not on levels 1, 10, || 18
	if (global.Game.Level.current == 1 || global.Game.Level.current == 10 || global.Game.Level.current == 18) {
	    // No shooting on these levels
	} else {
	    // Shot logic based on shotnumber

	    // If shotnumber is 2, allow up to 4 EnemyShot instances
	    if (global.Game.Enemy.shotNumber == 2) {
	        if (global.Game.Enemy.shotCount < 4) {
				if (global.shot_pool != undefined) {
					global.shot_pool.acquire(x, y);
				} else {
					instance_create_layer(x, y, "GameSprites", oEnemyShot);
				}
	        }
	    }

	    // If shotnumber is 3, allow up to 6 EnemyShot instances
	    if (global.Game.Enemy.shotNumber == 3) {
	        if (global.Game.Enemy.shotCount < 6) {
				if (global.shot_pool != undefined) {
					global.shot_pool.acquire(x, y);
				} else {
					instance_create_layer(x, y, "GameSprites", oEnemyShot);
				}
	        }
	    }

	    // If shotnumber is 4, allow up to 8 EnemyShot instances
	    if (global.Game.Enemy.shotNumber == 4) {
	        if (global.Game.Enemy.shotCount < 8) {
				if (global.shot_pool != undefined) {
					global.shot_pool.acquire(x, y);
				} else {
					instance_create_layer(x, y, "GameSprites", oEnemyShot);
				}
	        }
	    }
	}
}

// === ALARM RESET FOR CONTINUOUS ENTRANCE SHOOTING ===
// Only reset alarm if enemy is still in entrance phase
// Once in formation, shooting is handled by alarm[1] in Step event instead
if (enemyState == EnemyState.ENTER_SCREEN || enemyState == EnemyState.MOVE_INTO_FORMATION) {
	// Reset alarm for next shot during entrance
	// Use same timing as initial setup
	if (global.Game.Level.wave == 1 || global.Game.Level.wave == 2) {
		alarm[EnemyAlarmIndex.DIVE_SETUP] = DIVE_ALARM_STANDARD;
		if (global.Game.State.fastEnter == 1) {
			alarm[EnemyAlarmIndex.DIVE_SETUP] = DIVE_ALARM_FAST;
		}
	} else {
		alarm[EnemyAlarmIndex.DIVE_SETUP] = DIVE_ALARM_INITIAL;
	}
}