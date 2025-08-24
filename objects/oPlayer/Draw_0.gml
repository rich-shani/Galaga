if (global.gameMode != GameMode.GAME_PAUSED) {
	// the player ship is 3 sprites; ship and two thrusters
	if (global.ArcadeSprites) {
		draw_sprite_ext(sXWing,0,x,y,1,1,0,c_white,1);
		//draw_sprite(sXWing,1,x,y);
	}
	else {
	
	//	draw_sprite(sXWing,1,x,y);
	}
	
	if (!global.isGamePaused) {
		// if we're not paused, then animate the thrusters
//		draw_sprite(sLaserEmit,image_index/12,x-8,y+26);
//		draw_sprite(sLaserEmit,image_index/12,x+8,y+26);
	}
}