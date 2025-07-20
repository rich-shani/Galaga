#region SHADER
	global.CRT_SHADER = new CRTShaderCreate();
	
	UCRTParams = shader_get_uniform(CRTShader, "params");

	global.CRT_SHADER.CRT.ShaderOn = true;
	application_surface_draw_enable(false);
	
#endregion