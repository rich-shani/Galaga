if (global.isGameOver) {

	// clean up all enemies that are still alive ...
	with oTieFighter{instance_destroy();}
	with oTieIntercepter{instance_destroy();}
	with oImperialShuttle{instance_destroy();}

	// set the GAME MANAGER to show the results screen
    with oGameManager{
		global.gameMode = GameMode.SHOW_RESULTS; 
		global.results = 1; 
		// trigger GAME MANAGER alarm[9] ... ie enter Initials (if score is top 5)
		oGameManager.alarm[9] = 450;
	}

	// reset the game over flag
	global.isGameOver = false;

    //instance_destroy();
}