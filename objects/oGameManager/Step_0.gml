// Step Event (to check for input)
if (keyboard_check_pressed(ord("F"))) { // Press F to toggle
    fullScreen = !window_get_fullscreen(); // Toggle the state
    window_set_fullscreen(fullScreen);
}