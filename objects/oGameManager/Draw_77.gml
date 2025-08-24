/// POST DRAW Event

var inst = instance_find(crt_preset_PVM, 0);
var monitor_width = 1160;

if (window_get_fullscreen()) {
	if (inst != noone) {
		inst.viewport_zoom = 1;
		inst.viewport_shift_y = -0.8;
	}

	draw_sprite_stretched(decal, 0, 0, 0, window_get_width(), window_get_height());
//	draw_sprite_stretched(sMonitorFrame, 0, window_get_width()/2 - (monitor_width/2), 0, monitor_width,window_get_height());
}
else {
	if (inst != noone) {
		inst.viewport_zoom = 0.8;
		inst.viewport_shift_y = -1.6;
	}

	//draw_sprite_ext(galaga_header, 0, window_get_width()/2, 5, 0.35, 0.35, 0, c_white, 1);
}