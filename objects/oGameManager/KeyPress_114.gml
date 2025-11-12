/// @description Toggle Debug Mode (F3 key)
/// Toggles the debug overlay display that shows:
///   • Game state and mode
///   • Player stats (score, lives, ship state)
///   • Enemy counts and dive capacity
///   • Level and wave progression
///   • Performance metrics (FPS, instance count)
///
/// Visual feedback provided via debug message

// Toggle the debug flag
global.debug = !global.debug;

// Log the state change
if (global.debug) {
	show_debug_message("[DEBUG MODE] Enabled - Press F3 to disable");
} else {
	show_debug_message("[DEBUG MODE] Disabled - Press F3 to enable");
}
