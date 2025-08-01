if (window_get_fullscreen()) {
	draw_sprite_stretched(decal, 0, 0, 0, window_get_width(), window_get_height());
	draw_sprite_stretched(spr_example_overlay_1, 0, 1045, 0, 1360,window_get_height());
}
else {
	//draw_sprite(galaga_marquee, 0, 0, 0, window_get_width(), window_get_height());
//	draw_sprite(galaga_header, 0,  window_get_width()/2 ,0); 
	draw_sprite_ext(galaga_header, 0, window_get_width()/2, 5, 0.35, 0.35, 0, c_white, 1);
}