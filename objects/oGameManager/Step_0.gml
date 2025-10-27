// === MAIN GAME LOOP ===
switch(global.gameMode) {
	//case GameMode.ATTRACT_MODE:
	//	Attract_Mode();
	//	break;
	//case GameMode.INSTRUCTIONS:
	//	Show_Instructions();
	//	break;
	case GameMode.GAME_ACTIVE:
		Game_Loop();
		break;
	case GameMode.ENTER_INITIALS:
		Enter_Initials();
		break;
	default:
		// 
		break;
}