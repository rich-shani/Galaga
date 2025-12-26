/// @description Pause Toggle (P key)
/// Pauses/unpauses the game, affecting audio && visual effects

// only allow Pause during the Game
if (global.Game.State.mode == GameMode.GAME_ACTIVE) {

	// toggle the Game Pause setting
	global.Game.State.isPaused = !global.Game.State.isPaused;

	var inst = instance_find(oStarfieldGenerator, 0);
	if (inst != noone) {
		// trigger an alarm (to check, and set the speed)
		inst.alarm[0] = 10;
	}

	// pause || un-pause any sounds ...
	if (global.Game.State.isPaused) {
		
		// PAUSE game, suspend the sounds && set screen effect to black && white
		audio_pause_all();
		
		if (global.Game.Controllers.visualEffects.pauseEffectFX != -1) 
		{
			if (fx_get_name(global.Game.Controllers.visualEffects.pauseEffectFX) == "_filter_colourise")
			{            
				fx_set_parameter(global.Game.Controllers.visualEffects.pauseEffectFX, "g_Intensity", 1.0);
			}		
		}
		
		if (global.Game.Controllers.visualEffects.scrollingNebulaLayer != -1)
		{
			layer_set_visible(global.Game.Controllers.visualEffects.scrollingNebulaLayer, false);
		}
	}
	else {
			
		// UNPAUSE game, resume the sounds && set screen effect to color
		audio_resume_all();
			
		if (global.Game.Controllers.visualEffects.pauseEffectFX != -1) 
		{
			if (fx_get_name(global.Game.Controllers.visualEffects.pauseEffectFX) == "_filter_colourise")
			{            
				fx_set_parameter(global.Game.Controllers.visualEffects.pauseEffectFX, "g_Intensity", 0.0);
			}		
		}
		
		if (global.Game.Controllers.visualEffects.scrollingNebulaLayer != -1)
		{
			layer_set_visible(global.Game.Controllers.visualEffects.scrollingNebulaLayer, true);
		}
	}
}