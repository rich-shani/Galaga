// only allow Pause during the Game
//if (global.gameMode == GameMode.GAME_ACTIVE || global.gameMode == GameMode.GAME_PAUSED) {
	// toggle the Game Pause setting
	global.isGamePaused = !global.isGamePaused;
	
	//global.gameMode = (global.isGamePaused) ? GameMode.GAME_PAUSED :  GameMode.GAME_ACTIVE;
	
	var inst = instance_find(oStarfieldGenerator, 0);
	if (inst != noone) {
		// trigger an alarm (to check and set the speed)
		inst.alarm[0] = 10;
	}
	
	// pause or un-pause any sounds ...
	if (global.isGamePaused) {
		
		// PAUSE game, suspend the sounds and set screen effect to black and white
		audio_pause_all();
		
		// pause the starfield

		
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
//}