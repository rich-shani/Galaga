// increment the credits ... max is 10
if (global.Game.Player.credits < 10) {	
	global.Game.Player.credits += 1;
	
	sound_play(GCredit);
}