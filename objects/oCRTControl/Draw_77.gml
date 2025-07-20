if global.CRT_SHADER.CRT.ShaderOn
{
	shader_set(CRTShader);

	x2=window_get_width();
	y2=window_get_height();
	
	// If using shader on GUI layer, set resolution
	global.CRT_SHADER.CRT.SetResolution(window_get_width(), window_get_height());

	shader_set_uniform_f_array(UCRTParams, global.CRT_SHADER.CRT.Params);

	gpu_set_blendenable(false);
	draw_surface_ext(application_surface, 0, 0, 1, 1, 0, c_white, 1);
	gpu_set_blendenable(true);
	
	shader_reset();
}