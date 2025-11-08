/// @description Game Over Cleanup
///
/// MIGRATION NOTE:
///   Migrated to use global.Game.State for isGameOver and mode

if (global.Game.State.isGameOver) {

	// clean up all enemies that are still alive ...
	with oTieFighter{instance_destroy();}
	with oTieIntercepter{instance_destroy();}
	with oImperialShuttle{instance_destroy();}

	// set the GAME MANAGER to show the results screen
    with oGameManager{
		global.Game.State.mode = GameMode.SHOW_RESULTS;
		global.Game.State.results = 1;
		// trigger GAME MANAGER alarm[9] ... ie enter Initials (if score is top 5)
		alarm[9] = 450;
	}

	// reset the game over flag
	global.Game.State.isGameOver = false;

    //instance_destroy();
}