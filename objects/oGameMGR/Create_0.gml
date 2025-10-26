enum GameState {
	TITLE_SCREEN,
	INTRO_GAME,
	PLAY_GAME,
	GAME_OVER
}

state = GameState.TITLE_SCREEN;

// setup the GM Scoreboard using the unique game tag
setup_gmscoreboard("fd0828983a329a0be9e26c34d892769b");

// get the current set of high-scores
get_scores(5);

// setup an alarm to refresh the high score table every 5 minutes
alarm[0]=5*60*60;

// check if we have a gamepad connected
useGamepad = false;

if (gamepad_is_connected(0)) {
	useGamepad = true;
}