if (global.Game.Controllers.visualEffects.scrollingNebulaFX != -1) 
{
	if (fx_get_name(global.Game.Controllers.visualEffects.scrollingNebulaFX) == "_filter_hue")
	{
	    fx_set_parameter(global.Game.Controllers.visualEffects.scrollingNebulaFX, "g_HueShift",
							global.Game.Controllers.visualEffects.getCurrentHue(global.Game.Level.current));
	}
}

