// We should only be able to use the Shield during an active LEVEL
if (global.Game.State.isPaused || 
	global.Game.State.mode != GameMode.GAME_ACTIVE ||
	oPlayer.shipStatus != ShipState.ACTIVE) {
		// not in an ACTIVE state to use the Shield
		return;
	}
	
// ====================================================================
// GAME MODE ROUTING: Standard Wave Gameplay vs Challenge Stage
// ====================================================================
// global.Game.Challenge.countdown tracks progress toward challenge stages
// When > 0: Normal gameplay with formations
// When == 0: Challenge stage (every 4th level)

if (!global.Game.Challenge.isActive) {
//if (global.Game.Challenge.countdown > 0) {
		
	// activate the SHIELD if we have some energy available
	if (shieldTimer > 0) {
		isShieldActive = true;
	}
}