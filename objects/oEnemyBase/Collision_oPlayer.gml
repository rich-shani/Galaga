/// @description Enemy-Player Collision
///
/// MIGRATION NOTE:
///   Migrated to use global.Game.State.mode

// check PLAYER STATUS - as the player may be RESPAWNING ...
if (global.Game.State.mode == GameMode.GAME_ACTIVE && oPlayer.shipStatus == ShipState.ACTIVE) {
	// check if we're out of HEALTH
	hitCount--;

	if (hitCount == 0) {

		if (irandom(1)) {
			instance_create(round(x), round(y), oExplosion);
		}
		else {
			instance_create(round(x), round(y), oExplosion2);	
		}
					
		// destroy Enemy
		instance_destroy(self);
	}

	// Notify the PLAYER that it was HIT
	if (oPlayer.alarm[11] < 0) {
		oPlayer.alarm[11] = 1;
	}
}