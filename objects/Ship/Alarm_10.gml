//if global.isGameOver = 1{global.isGameOver = 2; alarm[10] = 150; exit};

if global.isGameOver {

    with Bee{instance_destroy()}

	with oTieFighter { instance_destroy(); }
	with oImperialShuttle { instance_destroy(); }	
	
    with Butterfly{instance_destroy()}

    with Boss{instance_destroy()}; sound_stop(GBeam);

    with Transform{instance_destroy()}

    with Fighter{instance_destroy()}

    with oGameManager{global.gameMode = GameMode.SHOW_RESULTS; results = 1; alarm[9] = 450};

	// reset the game over flag
	global.isGameOver = false;

    instance_destroy()

}




