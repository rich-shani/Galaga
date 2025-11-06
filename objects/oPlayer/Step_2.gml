/// @description High Score Display Update
///
/// MIGRATION NOTE:
///   Migrated to use global.Game.State.mode

if (global.Game.State.mode == GameMode.GAME_ACTIVE) {
	/// @section Highscore
	// Update highscore if current score is higher
	if (global.Game.Player.score > global.disp) {
		global.disp = global.Game.Player.score;
	}
}