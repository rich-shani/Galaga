/// @description FRAME TIMER & DEBUG

// === FRAME CONTROL ===
if (!global.isGamePaused) {
	// Increment the global 'flip' variable, used for animation timing or cyclic events
	global.flip = global.flip + 1;
	global.animationIndex += 1;

	// Reset 'flip' after 60 frames (i.e., once per second if the game runs at 60 FPS)
	if global.flip == 60 {
	    global.flip = 0;
	}
	
	if (global.animationIndex == 24*4) {
		// animated sprites have 24 frames of animation
		global.animationIndex = 0;
	}
}

if (global.gameMode == GameMode.INITIALIZE) {
	// Stops all currently playing sounds to ensure a clean audio state at initialization.
	// Prevents audio overlap from previous game states or sessions.
	sound_stop_all();

	load_highscores();

	// NOTE: Most global variables are already initialized in init_globals() called from Create_0
	// Only reset variables that need to be reset specifically for game start
	global.wave = 0;
	global.checkRoguePerWave = false;
	global.pattern = 0;
	global.open = 0;

	// Reset animation counters
	global.flip = 0;
	global.breathing = 1;
	global.breathe = 0;
	exhale = 0;

	// Score thresholds for extra lives
	firstlife = 20000;  // Score threshold for first extra life
	additional = 70000;  // Score threshold for each subsequent extra life

	// create the death star on the DeathStar layer (ie behind the game sprites)
	instance_create_layer(0, 0, "DeathStar", oDeathStar);
	Set_Nebula_Color();

	global.gameMode = GameMode.GAME_PLAYER_MESSAGE;

	sound_play(GStart);  // Play game start sound

	alarm[11] = 250;  // Start spawn / formation timer
	alarm[8] = 14;   // Start formation countdown

	fire = 0;   // Reset fire state
	hits = 0;   // Reset hit count
}

// === DEBUG INPUT HANDLING ===

// If the F10 key is pressed, toggle game speed between 60 FPS and 10 FPS for debugging
if keyboard_check_pressed(vk_f10) == true {
    if game_get_speed(gamespeed_fps) == 60 {
        // Switch to slow motion
        game_set_speed(10, gamespeed_fps);
    } else {
        // Switch back to normal speed
        game_set_speed(60, gamespeed_fps);
    }
}

// If the F12 key is pressed, restart the game (useful for quick resetting during testing)
if keyboard_check_pressed(vk_f12) == true {
    game_restart();
}