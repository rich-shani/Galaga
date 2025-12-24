/// @description DRAW DECAL & CRT

var inst = instance_find(crt_preset_PVM, 0);

if (window_get_fullscreen()) {
	if (inst != noone) {
		inst.viewport_zoom = 1;
		inst.viewport_shift_y = -0.8;
	}

	draw_sprite_stretched(galagawars_decal, 0, 0, 0, window_get_width(), window_get_height());
}
else {
	if (inst != noone) {
		inst.viewport_zoom = 1;
		inst.viewport_shift_y = -0.8;
	}
}