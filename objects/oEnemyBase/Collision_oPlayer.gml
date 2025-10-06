// check PLAYER STATUS - as the player may be RESPAWNING ...
if (oPlayer.shipStatus == _ShipState.ACTIVE) {
	// Enemy has collided with an ACTIVE PLAYER
	if (irandom(1)) {
		instance_create(round(x), round(y), oExplosion);
	}
	else {
		instance_create(round(x), round(y), oExplosion2);	
	}

	// destroy Enemy
	instance_destroy(self);

	// Notify the PLAYER that it was HIT
	if (oPlayer.alarm[11] < 0) {
		oPlayer.alarm[11] = 1;
	}
}