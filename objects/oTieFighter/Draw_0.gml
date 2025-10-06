//// DRAW in FORMATION ....
//if (dive == 0 and alarm[0] == -1) {
//	var d = (direction)%360;
//	// divide 0..360 by 15, ie 24 sprite images for the animation
//	var i = round(d/15);
	
//	draw_sprite_ext(sTieFighter,i,x,y,1,1,0,c_white,1);
//}
//else { // DRAW as it moves on a PATH

	//var d = (direction)%360;
	// divide 0..360 by 15, ie 24 sprite images for the animation
	var i = round(direction/15);
					
	draw_sprite_ext(sTieFighter,i,x,y,1,1,0,c_white,1);
 //}


