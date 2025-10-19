if (scrolling_nebula_bg != -1) 
{
	var layer_fx = layer_get_fx(scrolling_nebula_bg);
   
    if (layer_fx != -1)
    {
        if (fx_get_name(layer_fx) == "_filter_hue")
        {
				hue_value = random(1);
				
            fx_set_parameter(layer_fx, "g_HueShift", random(hue_value));
        }
    }		
}
		
