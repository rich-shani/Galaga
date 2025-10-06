/// @section Main Gameplay
// Render game elements when in gameplay mode (oGameManager.gameMode == GameMode.GAME_ACTIVE)
if (global.gameMode == GameMode.GAME_ACTIVE && shipStatus == _ShipState.ACTIVE) {
	
		if (global.roomname == "GalagaWars") {
			draw_sprite_ext(xwing_sprite_sheet,shipImage,x,y,0.8,0.8,0,c_white,1);
		}
		else {
			draw_sprite(spr_ship, 0, x, y);
		}
			
		if (!global.isGamePaused) {
			// if we're not paused, then animate the thrusters			
			draw_sprite_ext(sLaserEmit,global.animationIndex/24*2,x-(8*global.scale),y+(32*global.scale),global.scale,global.scale,0,c_white,1);
			draw_sprite_ext(sLaserEmit,global.animationIndex/24*2,x+(8*global.scale),y+(32*global.scale),global.scale,global.scale,0,c_white,1);		
		}
		
}