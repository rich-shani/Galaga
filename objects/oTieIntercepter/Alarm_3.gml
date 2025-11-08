sound_stop(GBeam);
beam_weapon.state = BEAM_STATE.FIRE_COMPLETE; 
	
/// If player is captured by this enemy's beam, render player sprite above enemy
if (oPlayer.captor == id) {
	alarm[4] = 60; 
	
	sound_stop(GCaptured); 
	sound_play(GFighterCaptured);
	
	enemyState = EnemyState.RETURN_PATH;
	beam_weapon.state = BEAM_STATE.READY; 
}