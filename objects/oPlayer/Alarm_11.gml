/// @description PLAYER HIT

// PLAYER explosion sound
sound_stop(GDie); sound_play(GDie); 

if (shotMode == _ShotMode.DOUBLE) {
	// Lose dual fighter, revert to single
	shotMode = _ShotMode.SINGLE;

	// need to remove the fighter that was HIT, ie the left or right ...
	/// not just the one on the right 
	
	// Create explosion for lost fighter
	instance_create(x + 72, y, oExplosion);

	// Don't deduct life - just lose the dual fighter bonus
}
else {
	// PLAYER explosion animation
	instance_create(round(x), round(y), oExplosion3);
		
		
	// screem shake ON when PLAYER is DEAD, and we need to RESPAWN
	layer_set_visible("ScreenShake", true);

	// Update ship status to DEAD
	shipStatus = _ShipState.DEAD;	

	// set timer (to pause before respawn, or game over)
	alarm[0] = 120;
}