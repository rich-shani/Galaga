if (scrolling_nebula_bg != -1) 
{
	if (global.Game.Controllers.visualEffects.scrollingNebulaLayer != -1) 
	{
	    if (fx_get_name(global.Game.Controllers.visualEffects.scrollingNebulaLayer) == "_filter_hue")
	    {
	        fx_set_parameter(global.Game.Controllers.visualEffects.scrollingNebulaLayer, "g_HueShift",
								global.Game.Level.current % array_length(global.Game.Controllers.visualEffects.hueValues));
	    }
	}
}
		
