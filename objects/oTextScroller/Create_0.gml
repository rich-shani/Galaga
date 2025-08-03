// Create Event
messages = [
    "Galaga Redux",
    "F10: slow/normal\t\t\tF12: reset",
	"F: fullscreen\t\t\tP:pause"
];

current_message = 0;
message_text = messages[current_message];
msg_length = string_length(message_text);
msg = array_create(msg_length);

// Split the string into an array of characters
for (var i = 0; i < msg_length; i++) {
    msg[i] = string_char_at(message_text, i + 1);
}

// Initial position (off-screen to the right)
screen_width = view_get_wport(view_current);
screen_height = view_get_hport(view_current);

scroll_x = screen_width;

// Parameters for scrolling and wave
scroll_speed = 3;          // Pixels per step
char_spacing = 24;        // Spacing between characters (match font width)
amplitude = 0;           // Wave height
frequency = 0.1;          // Wave tightness
phase_offset = 0.2;       // Wave progression per character
center_x = screen_width / 2; // Where text centers during hold

// State machine
state = "scrolling";      // States: "scrolling", "holding", "advancing"
hold_duration = 180;      // Frames to hold (3 seconds at 60 FPS)
hold_timer = 0;