// destroy Enemy missile
instance_destroy(other);

// check if the PLAYER is ACTIVE
if (oPlayer.shipStatus == _ShipState.ACTIVE) {
	// Notify the PLAYER that it was HIT
	if (alarm[11] < 0) {
	    alarm[11] = 1; 
	}
}