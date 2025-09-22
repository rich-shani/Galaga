/// @description PLAYER, STAGE, READY
switch(global.gameMode) {
	case GameMode.GAME_PLAYER_MESSAGE: 
	{
		nextlevel = 1; 
		
		alarm[11] = 90; 
		// trigger the initial level variables - ie Alarm[10] with nextlevl == 1
		alarm[10] = 1; 
				
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

		nextlevel = 2;
		// trigger the next step of level variables - ie Alarm[10] with nextlevl == 2	
		alarm[10] = 1; 
			
		global.gameMode = GameMode.GAME_ACTIVE;
		break;
}