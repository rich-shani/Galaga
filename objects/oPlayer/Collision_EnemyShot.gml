// destroy Enemy missile
instance_destroy(other);

// check if the Game and Player are ACTIVE
if (global.gameMode == GameMode.GAME_ACTIVE && oPlayer.shipStatus == _ShipState.ACTIVE) {
	
	// Notify the PLAYER that it was HIT
	if (alarm[11] < 0) {
		alarm[11] = 1; 
	}
}