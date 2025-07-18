if (gameMode == GameMode.GAME_ACTIVE || gameMode == GameMode.GAME_PAUSED) {
	// toggle the Game Pause setting
	isGamePaused = !isGamePaused;
	
	gameMode = (isGamePaused) ? GameMode.GAME_PAUSED :  GameMode.GAME_ACTIVE;
	
	// pause or un-pause any sounds ...
	if (isGamePaused) {
		
		// PAUSE game, suspend the sounds and set screen effect to black and white
		audio_pause_all();
		
			
		if (layer_pause_fx != -1) 
		{
			if (fx_get_name(layer_pause_fx) == "_filter_colourise")
			{            
				fx_set_parameter(layer_pause_fx, "g_Intensity", 1.0);
			}		
		}
	}
	else {
			
		// UNPAUSE game, resume the sounds and set screen effect to color
		audio_resume_all();
			
		if (layer_pause_fx != -1) 
		{
			if (fx_get_name(layer_pause_fx) == "_filter_colourise")
			{            
				fx_set_parameter(layer_pause_fx, "g_Intensity", 0.0);
			}		
		}
	}
}