/// @description Handle Enemy Shot Collision
///
/// MIGRATION NOTE:
///   Migrated to use global.Game.State.mode

// Return enemy shot to pool or destroy it
if (global.shot_pool != undefined) {
	global.shot_pool.release(other);
} else {
	instance_destroy(other);
}

// check if the Game && Player are ACTIVE
if (global.Game.State.mode == GameMode.GAME_ACTIVE && oPlayer.shipStatus == ShipState.ACTIVE) {

	// Notify the PLAYER that it was HIT
	if (alarm[11] < 0) {
		alarm[11] = 1;
	}
}