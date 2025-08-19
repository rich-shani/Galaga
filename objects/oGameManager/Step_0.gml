
// === DEBUG INPUT HANDLING ===

// If the F10 key is pressed, toggle game speed between 60 FPS and 10 FPS for debugging
if keyboard_check_pressed(vk_f10) == true {
    if game_get_speed(gamespeed_fps) == 60 {
        // Switch to slow motion
        game_set_speed(10, gamespeed_fps);
    } else {
        // Switch back to normal speed
        game_set_speed(60, gamespeed_fps);
    }
}

// If the F12 key is pressed, restart the game (useful for quick resetting during testing)
if keyboard_check_pressed(vk_f12) == true {
    game_restart();
}