function Draw_Hud(){
	// 1UP & HIGH SCORE (red text)

	// load retro Atari font
	if (global.roomname == "GalagaWars") {
		draw_set_font(fAtari24);	
	}
	else draw_set_font(fAtari12);

	if (global.isGameOver)
	{
		//draw_set_color(c_aqua);
		draw_set_color(c_red);
		draw_text(160*global.scale, 288*global.scale, string_hash_to_newline("GAME OVER"));
		
		return;
	}
		
	// show CREDITS if we're not in an active game
	if (global.gameMode > GameMode.ATTRACT_MODE) {
		// draw the scores (top of screen)
		Draw_Scores();		
	}
	
	if (global.gameMode < GameMode.GAME_STAGE_MESSAGE) {
		Draw_Credits();
	}
	else {
		Draw_Lives();
	}
		
	// is the Game Paused?
	if (global.isGamePaused) { 
		draw_set_font(fAtari36);
		draw_set_color(c_green);
	
		draw_text(100*global.scale,265*global.scale, "GAME PAUSED");
		
		draw_set_color(c_white);		
		draw_set_font(fAtari24);
	}
	else { 
		draw_set_color(c_aqua);
							
		// Draw screen based on Game Mode
		switch (global.gameMode) {
			case GameMode.INSTRUCTIONS:
				Draw_Instructions();
				break
			case GameMode.SHOW_RESULTS:
				Draw_Results();
				break;
			case GameMode.ENTER_INITIALS:
				Draw_Enter_Initials();
				break;
			case GameMode.GAME_PLAYER_MESSAGE: 		
				draw_text(176*global.scale, 288*global.scale, string_hash_to_newline("PLAYER 1"));
				break;
			case GameMode.GAME_STAGE_MESSAGE: 
				draw_text(160*global.scale, 288*global.scale, string_hash_to_newline("STAGE"));
				draw_text(260*global.scale, 288*global.scale, string_hash_to_newline(global.lvl));
				break;
			case GameMode.GAME_READY:
				draw_text(160*global.scale, 256*global.scale, string_hash_to_newline("PLAYER 1"));
				draw_text(160*global.scale, 288*global.scale, string_hash_to_newline("STAGE"));
				draw_text(260*global.scale, 288*global.scale, string_hash_to_newline(global.lvl));
				break;
			case GameMode.GAME_ACTIVE:
				// if the oPlayer RESPAWN is still in effect, show 'READY'
				if ((oPlayer.alarm[1] > -1) && (global.p1lives > 0)) {
					draw_text(170*global.scale, 288*global.scale, string_hash_to_newline("READY"));
		        }
				break;
		} // SWITCH STATEMENT
	}
 }