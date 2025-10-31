if (ScreenShown == TITLE_SCREEN.TITLE) {
	
	hitFlag = 0;
	
	// advance the attract mode sequence counter and reset the alarm timer
	sequence += 1;
	
	if (sequence == 15) {
		// need this to get the second shot to hit the BOSS enemy
		alarm[1] = 10;
	} 
	else if (sequence < 22) {
		// otherwise, standard sequence is per second (ie 60 frames)
		alarm[1] = 60;
	}

	if sequence == 6 {
		shipXPosTarget = 380*global.scale;
	}

	if sequence == 9{
		shipXPosTarget = 280*global.scale; 
		attpause = 30; 
		
		instance_create(360*global.scale+x,336*global.scale+y,oExplosion); 
		instance_create(360*global.scale+x,336*global.scale+y,Points1600);
	}

	if (sequence == 12) {
		shipXPosTarget = 160*global.scale; 
		
		// need to add offset of the moving enemy sprite from the original coords
		instance_create(260*global.scale+x,336*global.scale+y,oExplosion); 
		instance_create(260*global.scale+x,336*global.scale+y,Points800);
	}

	if sequence == 15 {
		shipXPosTarget = 80*global.scale; 
		
		instance_create(180*global.scale+x,336*global.scale+y,oExplosion); 
		instance_create(180*global.scale+x,336*global.scale+y,Points400);
	}

	if sequence == 17{
		instance_create(80*global.scale,336*global.scale,oExplosion); 
		instance_create(80*global.scale,336*global.scale,Points150); 
		alarm[1] = 70;
	}

	// set the path - to animate the BOSS/BUTTERFLY blocks
	if (sequence == 8 or sequence == 11) {
		x=0; y=0; 
		
		path_start(AttractMode_PATH,3*global.scale,0,0);
	}

	if (sequence == 14) {
		path_end(); 
		x=0; y=0;
		
		path_start(AttractMode_PATH_FLIP,3*global.scale,0,0);
	}

	if (sequence == 16) {
		path_end(); 
		x=0; y=0;
	}
	
	// end of gameMode mode (step 21)
	if (sequence == 21) {

		// reset vars
		player_x = 448;
		player_y = 1024;
	    hitFlag = 0; attpause = 0; attshot = 0; attshotx = 0; attshoty = 0; shipXPosTarget = 0;
		
		alarm[0] = 60;
	}
}

