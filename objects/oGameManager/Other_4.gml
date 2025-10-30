

if (global.gameMode == GameMode.INITIALIZE) {
	// Stops all currently playing sounds to ensure a clean audio state at initialization.
	// Prevents audio overlap from previous game states or sessions.
	sound_stop_all();

	load_highscores();
	
        // === INITIALIZE GAME STATE ===
        global.lvl           = 4;
		
        global.chall         = 0;
		// start the counter at 1, as the 1st challenge stage is Stage 3, then +4 after that, ie 7, 11, 15, ...
        global.challcount    = 1;
		global.isChallengeStage = false;
		
        global.divecapstart  = 2;
        global.lastattack    = 4;
        global.beamtime      = 300;
        global.shotnumber    = 2;
        global.open          = 0;
        global.fastenter     = 0;
        global.entershot     = 0;
        global.rogue         = 0;
        global.fast          = 0;
        global.transnum      = 0;
        global.divecap       = global.divecapstart;
        global.pattern       = 0;
        global.hold          = 15;
        global.bosscap       = 2;
		
        global.wave          = 0;
		global.checkRoguePerWave = false;
						
        global.flip          = 0;
        global.breathing     = 1;
        global.breathe       = 0;
        exhale               = 0;
        global.bosscount     = 1;
        global.prohib        = 0;
        global.transform     = 0;
        global.beamcheck     = 0;
        global.transcount    = 0;
        global.escortcount   = 0;
        global.fighterstore  = 0;

        // === PLAYER INITIAL VALUES ===
        global.p1score = 0;
        global.p1lives = 3;

        firstlife   = 20000;  // Score threshold for first extra life
        additional  = 70000;  // Score threshold for each subsequent extra life

		// create the death star on the DeathStar layer (ie behind the game sprites)
		instance_create_layer(0, 0, "DeathStar", oDeathStar);
		Set_Nebula_Color();
		
		global.gameMode = GameMode.GAME_PLAYER_MESSAGE;

        sound_play(GStart);  // Play game start sound

        alarm[11] = 250;  // Start spawn / formation timer
        alarm[8]  = 14;   // Start formation countdown

        fire = 0;   // Reset fire state
        hits = 0;   // Reset hit count
}