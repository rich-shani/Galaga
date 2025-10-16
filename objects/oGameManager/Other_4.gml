

if (global.gameMode == GameMode.INITIALIZE) {
	// Stops all currently playing sounds to ensure a clean audio state at initialization.
	// Prevents audio overlap from previous game states or sessions.
	sound_stop_all();

	load_highscores();
	
	global.gameMode = GameMode.ATTRACT_MODE;
	
	audio_play_sound(Galaga_Theme_Remix_Short,1,false);
}