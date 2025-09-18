/// @description PLAYER, STAGE, READY
switch(global.gameMode) {
	case GameMode.GAME_PLAYER_MESSAGE: 
	{
		alarm[11] = 90; 
		alarm[10] = 1; 
		nextlevel = 1; 
		
		global.gameMode = GameMode.GAME_STAGE_MESSAGE; 
		break;
	}
	case GameMode.GAME_STAGE_MESSAGE:
	{
		alarm[11] = 90;
		
		global.gameMode = GameMode.GAME_READY; 
		break;
	}
	case GameMode.GAME_READY:
		alarm[10] = 1; 
		nextlevel = 2;
		
		global.gameMode = GameMode.GAME_ACTIVE;
		break;
}