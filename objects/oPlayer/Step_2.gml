if (global.gameMode == GameMode.GAME_ACTIVE) {
	/// @section Highscore
	// Update highscore if current score is higher
	if (global.p1score > global.disp) {
		global.disp = global.p1score;
	}
}