//scroll_x -= scroll_speed;

//// Loop the text seamlessly when it scrolls off-screen
//if (scroll_x + (msg_length * char_spacing) < 0) {
//	// set an alarm, as a pause to then start again ...
	
//    scroll_x = room_width; // Reset to right side
//}

// only display text messages in window-mode 
if (!window_get_fullscreen()) {
	switch (state) {
	    case "scrolling":
	        scroll_x -= scroll_speed;
        
	        // Check if text is centered
	        var text_width = msg_length * char_spacing;
	        var text_center = scroll_x + (text_width / 2);
	        if (abs(text_center - center_x) < scroll_speed) {
	            scroll_x = center_x - (text_width / 2); // Snap to center
	            state = "holding";
	            hold_timer = hold_duration;
	        }
	        break;
        
	    case "holding":
	        hold_timer--;
	        if (hold_timer <= 0) {
	            state = "advancing";
	        }
	        break;
        
	    case "advancing":
	        scroll_x -= scroll_speed;
	        if (scroll_x + (msg_length * char_spacing) < 0) {
	            // Move to next message
	            current_message = (current_message + 1) % array_length(messages);
	            message_text = messages[current_message];
	            msg_length = string_length(message_text);
	            msg = array_create(msg_length);
	            for (var i = 0; i < msg_length; i++) {
	                msg[i] = string_char_at(message_text, i + 1);
	            }
	            scroll_x = screen_width; // Reset to right
	            state = "scrolling";
	        }
	        break;
	}
}