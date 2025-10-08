if (global.gameover) {

	// clean up all enemies that are still alive ...
	
    with Bee{instance_destroy()}
	with oTieFighter{instance_destroy();}
	with oImperialShuttle{instance_destroy();}
    with Butterfly{instance_destroy()}
    with Boss{instance_destroy()}; sound_stop(GBeam);
    with Transform{instance_destroy()}
    with Fighter{instance_destroy()}

	// set the GAME MANAGER to show the results screen
    with oGameManager{
		global.gameMode = GameMode.SHOW_RESULTS; 
		results = 1; 
		// trigger GAME MANAGER alarm[9] ... ie enter Initials (if score is top 5)
		alarm[9] = 450;
	}

	// reset the game over flag
	global.gameover = false;

    //instance_destroy();
}