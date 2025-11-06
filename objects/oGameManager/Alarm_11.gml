/// @description PLAYER, STAGE, READY
/// Manages game state transitions for level progression
///
/// MIGRATION NOTE:
///   Migrated to use global.Game.State.mode

switch(global.Game.State.mode) {
	case GameMode.GAME_PLAYER_MESSAGE:
	{
		nextlevel = 1;
		// trigger the initial level variables - ie Alarm[10] with nextlevl == 1
		alarm[10] = 1;

		global.Game.State.mode = GameMode.GAME_STAGE_MESSAGE;
		alarm[11] = 90;

		break;
	}
	case GameMode.GAME_STAGE_MESSAGE:
	case GameMode.CHALLENGE_STAGE_MESSAGE:
	{
		global.Game.State.mode = GameMode.GAME_READY;
		alarm[11] = 90;

		break;
	}
	case GameMode.GAME_READY:

		nextlevel = 2;
		// trigger the next step of level variables - ie Alarm[10] with nextlevl == 2
		alarm[10] = 1;

		global.Game.State.mode = GameMode.GAME_ACTIVE;

		break;
}