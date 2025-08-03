// Stops all currently playing sounds to ensure a clean audio state at initialization.
// Prevents audio overlap from previous game states or sessions.
sound_stop_all();

if (global.gameMode == GameMode.INITIALIZE) {
	global.gameMode = GameMode.ATTRACT_MODE;
	audio_play_sound(Galaga_Theme_Remix,1,false);
}