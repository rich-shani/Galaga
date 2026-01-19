/// @description Fullscreen Toggle (F key - KeyCode 70)
/// Toggles between windowed and fullscreen display modes.
///
/// Fullscreen System:
///   • Toggles fullscreen state using GameMaker's window functions
///   • Stores fullscreen preference in global.Game.Input.fullScreen
///   • Applies change immediately to game window
///
/// Usage:
///   • Press F key during gameplay or menus to toggle fullscreen
///   • Useful for maximizing screen real estate on larger displays
///   • Can be toggled at any time during gameplay
///
/// Key Mapping:
///   • Key 70 = "F" key on keyboard
///   • Standard fullscreen toggle key
///
/// @var global.Game.Input.fullScreen - Current fullscreen state (true/false)
///
/// @related oGameManager/KeyPress_80.gml - Pause toggle (P key)
/// @related oGameManager/KeyPress_72.gml - Visual effects toggle (H key)

// Toggle fullscreen mode
// Get current fullscreen state and invert it
global.Game.Input.fullScreen = !window_get_fullscreen();

// Apply the new fullscreen setting to the game window
window_set_fullscreen(global.Game.Input.fullScreen);