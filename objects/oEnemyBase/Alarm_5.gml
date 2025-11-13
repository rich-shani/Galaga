/// @description enemy shooting logic
// Handles enemy shooting logic based on level && shot number
// check PLAYER STATUS - as the player may be RESPAWNING ...
if (global.Game.State.mode == GameMode.GAME_ACTIVE && instance_exists(oPlayer) && oPlayer.shipStatus == ShipState.ACTIVE) {
	
	// Only allow shooting if !on levels 1, 10, || 18
	if (global.Game.Level.current == 1 || global.Game.Level.current == 10 || global.Game.Level.current == 18) {
	    // No shooting on these levels
	} else {
	    // Shot logic based on shotnumber

	    // If shotnumber is 2, allow up to 4 EnemyShot instances
	    if (global.Game.Enemy.shotNumber == 2) {
	        if instance_number(oEnemyShot) < 4 {
				if (global.shot_pool != undefined) {
					global.shot_pool.acquire(x, y);
				} else {
					instance_create_layer(x, y, "GameSprites", oEnemyShot);
				}
	        }
	    }

	    // If shotnumber is 3, allow up to 6 EnemyShot instances
	    if (global.Game.Enemy.shotNumber == 3) {
	        if instance_number(oEnemyShot) < 6 {
				if (global.shot_pool != undefined) {
					global.shot_pool.acquire(x, y);
				} else {
					instance_create_layer(x, y, "GameSprites", oEnemyShot);
				}
	        }
	    }

	    // If shotnumber is 4, allow up to 8 EnemyShot instances
	    if (global.Game.Enemy.shotNumber == 4) {
	        if instance_number(oEnemyShot) < 8 {
				if (global.shot_pool != undefined) {
					global.shot_pool.acquire(x, y);
				} else {
					instance_create_layer(x, y, "GameSprites", oEnemyShot);
				}
	        }
	    }
	}
}