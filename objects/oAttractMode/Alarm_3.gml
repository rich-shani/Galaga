/// @description Attract Mode Timer

// gameMode mode ... 30 steps, one per second, unless we're at step 15
if (global.Game.State.mode == GameMode.ATTRACT_MODE) {

	hitFlag = 0;
	
	// advance the attract mode sequence counter and reset the alarm timer
	sequence += 1;
	
	if (sequence == 15) {
		// need this to get the second shot to hit the BOSS enemy
		alarm[3] = 10;
	} 
	else {
		// otherwise, standard sequence is per second (ie 60 frames)
		alarm[3] = 60;
	}

	if sequence == 6 {
		shipXPosTarget = 380*global.Game.Display.scale;
	}

	if sequence == 9{
		shipXPosTarget = 280*global.Game.Display.scale; 
		attpause = 30; 
		
		instance_create(360*global.Game.Display.scale+x,336*global.Game.Display.scale+y,oExplosion); 
		instance_create(360*global.Game.Display.scale+x,336*global.Game.Display.scale+y,Points1600);
	}

	if (sequence == 12) {
		shipXPosTarget = 160*global.Game.Display.scale; 
		
		// need to add offset of the moving enemy sprite from the original coords
		instance_create(260*global.Game.Display.scale+x,336*global.Game.Display.scale+y,oExplosion); 
		instance_create(260*global.Game.Display.scale+x,336*global.Game.Display.scale+y,Points800);
	}

	if sequence == 15 {
		shipXPosTarget = 80*global.Game.Display.scale; 
		
		instance_create(180*global.Game.Display.scale+x,336*global.Game.Display.scale+y,oExplosion); 
		instance_create(180*global.Game.Display.scale+x,336*global.Game.Display.scale+y,Points400);
	}

	if sequence == 17{
		instance_create(80*global.Game.Display.scale,336*global.Game.Display.scale,oExplosion); 
		instance_create(80*global.Game.Display.scale,336*global.Game.Display.scale,Points150); 
		alarm[3] = 70;
	}

	// set the path - to animate the BOSS/BUTTERFLY blocks
	if (sequence == 8 or sequence == 11) {
		x=0; y=0; 
		
		path_start(AttractMode_PATH,3*global.Game.Display.scale,0,0);
	}

	if (sequence == 14) {
		path_end(); 
		x=0; y=0;
		
		path_start(AttractMode_PATH_FLIP,3*global.Game.Display.scale,0,0);
	}

	if (sequence == 16) {
		path_end(); 
		x=0; y=0;
	}
	
	// end of gameMode mode (step 30)
	if (sequence == 30) {

		// reset vars
	    oPlayer.x = oPlayer.xstart; 
		oPlayer.y = oPlayer.ystart;

	    sequence = 0; hitFlag = 0; attpause = 0; attshot = 0; attshotx = 0; attshoty = 0; shipXPosTarget = 0;
	}
}


