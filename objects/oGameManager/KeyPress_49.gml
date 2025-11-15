// increment the credits ... max is 10
if (global.Game.Player.credits < 10) {
	global.Game.Player.credits += 1;

	global.Game.Controllers.audioManager.playSound(GCredit);
}