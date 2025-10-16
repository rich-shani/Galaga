if (!splashScreenSetup) {
	// randomize the seed
	randomise();
	
	// randomize the splash screen
	sprite_splash_screen = asset_get_index("Splash" + string(irandom(9)));
	
	// play intro music
	audio_play_sound(intro_music, 1, false);

	// create instance
	var _inst = instance_create_depth(0, 0, 0, oFadeScreen);
	
	// set properties
	_inst.w = _w;
	_inst.h = _h;
	_inst.targetRoom = GalagaWars;
	_inst.duration = 170;
	_inst.c = c_black;
	_inst.timer = 0;
	
	splashScreenSetup = true;
}