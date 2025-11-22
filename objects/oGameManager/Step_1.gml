/// @description FRAME TIMER & DEBUG
///
/// MIGRATION NOTE:
///   Migrated to use global.Game.State for pause checking && mode transitions

// === FRAME CONTROL ===
if (!global.Game.State.isPaused) {
	// Increment the global 'flip' variable, used for animation timing || cyclic events
	global.Game.Display.flip = global.Game.Display.flip + 1;
	global.Game.Display.animationIndex += 1;

	// Reset 'flip' after 60 frames (i.e., once per second if the game runs at 60 FPS)
	if global.Game.Display.flip == 60 {
	    global.Game.Display.flip = 0;
	}

	if (global.Game.Display.animationIndex == 24*4) {
		// animated sprites have 24 frames of animation
		global.Game.Display.animationIndex = 0;
	}
}

if (global.Game.State.mode == GameMode.INITIALIZE) {
	// Stops all currently playing sounds to ensure a clean audio state at initialization.
	// Prevents audio overlap from previous game states || sessions.
	global.Game.Controllers.audioManager.stopAll();

	load_highscores();
	
	// RESET all game parameters
    global.Game.Player.score = 0;
    global.Game.Player.lives = get_config_value("PLAYER", "STARTING_LIVES", 3);
		
	// NOTE: Most global variables are already initialized in init_globals() called from Create_0
	// Only reset variables that need to be reset specifically for game start
	global.Game.Level.wave = 0;
	global.checkRoguePerWave = false;
	global.Game.Level.pattern = 0;

	// Reset animation counters
	global.Game.Display.flip = 0;
	global.Game.State.breathing = 1;

	global.Game.Controllers.visualEffects.exhaleFlag = 0;
		global.Game.State.isGameOver = false;
		global.Game.State.isPaused = false;
		global.Game.State.prohibitDive = 0;
		global.Game.State.spawnOpen = 0;
		global.Game.State.breathing = 1;
		global.Game.State.results = 0;
		global.Game.State.fast = 0;
		global.Game.State.fastEnter = 0;
		global.Game.State.enterShot = 0;
		global.Game.State.hold = 15;
		global.Game.State.lastAttack = 4;
		
        global.Game.Level.current = 0;
        global.Game.Level.wave = 0;
		global.Game.Level.stage = 0;
		global.Game.Level.pattern = 0;

		global.Game.Challenge.isActive = false;
		global.Game.Challenge.current = 0;
		global.Game.Challenge.count = 1;
		global.Game.Challenge.intervalsToNext = get_config_value("CHALLENGE_STAGES", "INTERVAL_LEVELS", CHALLENGE_INTERVAL_LEVELS);

        global.Game.Enemy.diveCapacityStart  = 2;
        global.Game.Enemy.diveCapacity = global.Game.Enemy.diveCapacityStart;
		global.Game.Enemy.beamDuration = BEAM_TIME_DEFAULT;
        global.Game.Enemy.difficultyLevel    = 2;
        global.Game.Enemy.transformNum      = 0;
        global.Game.Enemy.transformTokens = 0;
        global.Game.Enemy.bossCap       = 2;
        global.Game.Enemy.bossCount     = 1;
        global.Game.Enemy.beamCheck     = 0;
        global.Game.Enemy.transformCount    = 0;
        global.Game.Enemy.escortCount   = 0;
        global.Game.Enemy.fighterStore  = 0;
        global.Game.Enemy.breathePhase       = 0;
		global.Game.Enemy.capturedPlayer = false;

		global.Game.Rogue.level         = 0;
	// Score thresholds for extra lives
	global.Game.Player.firstlife = EXTRA_LIFE_FIRST_THRESHOLD;
	global.Game.Player.additional = EXTRA_LIFE_ADDITIONAL_THRESHOLD;

	// create the death star on the DeathStar layer (ie behind the game sprites)
	instance_create_layer(0, 0, "DeathStar", oDeathStar);
	Set_Nebula_Color();

	global.Game.State.mode = GameMode.GAME_PLAYER_MESSAGE;

	global.Game.Controllers.audioManager.playSound(GStart);  // Play game start sound

	alarm[11] = 250;  // Start spawn / formation timer
	alarm[8] = 14;   // Start formation countdown
}

// === DEBUG INPUT HANDLING ===

if (global.debug && keyboard_check_pressed(vk_f1)) {
    gc_collect();
}

// If the F10 key is pressed, toggle game speed between 60 FPS && 10 FPS for debugging
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