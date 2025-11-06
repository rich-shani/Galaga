/// @description Pause Toggle (P key)
/// Pauses/unpauses the game, affecting audio and visual effects

// only allow Pause during the Game
if (global.Game.State.mode == GameMode.GAME_ACTIVE) {

	// toggle the Game Pause setting
	global.Game.State.isPaused = !global.Game.State.isPaused;

	var inst = instance_find(oStarfieldGenerator, 0);
	if (inst != noone) {
		// trigger an alarm (to check and set the speed)
		inst.alarm[0] = 10;
	}

	// pause or un-pause any sounds ...
	if (global.Game.State.isPaused) {
		
		// PAUSE game, suspend the sounds and set screen effect to black and white
		audio_pause_all();
		
		if (layer_pause_fx != -1) 
		{
			if (fx_get_name(layer_pause_fx) == "_filter_colourise")
			{            
				fx_set_parameter(layer_pause_fx, "g_Intensity", 1.0);
			}		
		}
		
		if (scrolling_nebula_bg != -1)
		{
			layer_set_visible(scrolling_nebula_bg, false);
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
		
		if (scrolling_nebula_bg != -1)
		{
			layer_set_visible(scrolling_nebula_bg, true);
		}
	}
}