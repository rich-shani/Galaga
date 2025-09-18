//if global.gameover = 1{global.gameover = 2; alarm[10] = 150; exit};

if global.gameover {

    with Bee{instance_destroy()}

    with Butterfly{instance_destroy()}

    with Boss{instance_destroy()}; sound_stop(GBeam);

    with Transform{instance_destroy()}

    with Fighter{instance_destroy()}

    with oGameManager{global.gameMode = GameMode.SHOW_RESULTS; results = 1; alarm[9] = 450};

	// reset the game over flag
	global.gameover = false;

    instance_destroy()

}




