global.Game.Controllers.audioManager.stopSound(GBeam);
beam_weapon.state = BEAM_STATE.FIRE_COMPLETE; 
	
/// If player is captured by this enemy's beam, render player sprite above enemy
if (oPlayer.captor == id) {
	alarm[4] = 60; 
	
	global.Game.Controllers.audioManager.stopSound(GCaptured);
	global.Game.Controllers.audioManager.playSound(GFighterCaptured);
	
	enemyState = EnemyState.RETURN_PATH;
	beam_weapon.state = BEAM_STATE.READY; 
}