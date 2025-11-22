if (laserColor) {
	draw_sprite_ext(sRedLazer, 0, x, y, 0.5, 0.5, 270, c_white, 1);
}
else {
	draw_sprite_ext(sGoldLazer, 0, x, y, 0.5, 0.5, 270, c_white, 1);	
}

if (global.debug) {
	// draw collision mask
	draw_set_alpha(0.5);
	draw_rectangle_colour(bbox_left,bbox_top,bbox_right,bbox_bottom,c_red,c_red,c_red,c_red,false);
	draw_set_alpha(1);
}