//draw_set_font(fAtari12); // Replace with your font
//draw_set_halign(fa_center);
//draw_set_valign(fa_middle);
//draw_set_color(c_white); // Or use gradients/colors for retro effect

//var center_y = room_height - 48; 

//for (var i = 0; i < msg_length; i++) {
//    var char_x = scroll_x + (i * char_spacing);
    
//    // Only draw characters within screen bounds to optimize
//    if (char_x > -char_spacing && char_x < room_width) {
//        // Calculate sine wave vertical offset
//        var wave_y = sin((char_x * frequency) + (i * phase_offset)) * amplitude;
        
//        // Draw each character with wave offset (optional color gradient for Amiga style)
//        draw_text_color(char_x, center_y + wave_y, msg[i], c_red, c_red, c_yellow, c_yellow, 1);
//    }
//}

// only display text messages in window-mode 
if (!window_get_fullscreen()) {
	draw_set_font(fAtari12);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_color(c_white);

	var center_y = screen_height - 48;

	for (var i = 0; i < msg_length; i++) {
	    var char_x = scroll_x + (i * char_spacing);
    
	    // Only draw visible characters
	    if (char_x > -char_spacing && char_x < screen_width) {
	        // Sine wave offset (apply during scrolling and holding)
	        var wave_y = sin((char_x * frequency) + (i * phase_offset) + (current_time / 1000)) * amplitude;
	        draw_text_color(char_x, center_y + wave_y, msg[i], c_red, c_red, c_yellow, c_yellow, 1);
	    }
	}
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_top); 
}                     