// increment the credits ... max is 10
if (global.credits < 1) {	
	global.credits += 1;
	
	sound_play(GCredit);
}