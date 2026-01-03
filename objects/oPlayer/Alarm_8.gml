/// @description Handles shield pickup
global.Game.Controllers.audioManager.playSound(GCredit);

// adds 0.5 to shield capacity (on 0-5 scale)
shieldTimer += 0.5;
// Clamp to maximum of 5
if (shieldTimer > 5) {
	shieldTimer = 5;
}