// increment the credits ... max is 10
if (global.credits < 10) {	
	global.credits += 1;
	
	sound_play(GCredit);
}