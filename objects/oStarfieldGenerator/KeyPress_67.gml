// ========================================================================
// oStarfieldGenerator - Key Press Event 67 (C Key)
// ========================================================================
/// @description TOGGLE COLOR MODE
/// Toggles the starfield between color mode (green) and black & white mode (white).
///
/// This event is triggered when the player presses the 'C' key (key code 67).
/// It switches the particle color between green (color mode) and white (B&W mode),
/// allowing players to customize the starfield appearance during gameplay.
///
/// === KEY MAPPING ===
/// Key code 67 = 'C' key (ASCII character code)
/// This provides a convenient toggle for visual customization without menu navigation.
///
/// === CURRENT BEHAVIOR ===
/// Currently, this always sets color mode to green. For a true toggle, you would
/// need to track the current mode state and switch between Alarm_1 (green) and
/// Alarm_2 (white) logic. Consider enhancing this to cycle between modes.
///
/// === SUGGESTED ENHANCEMENT ===
/// To implement true toggling, store a mode flag (e.g., colorMode = true/false)
/// in Create_0, then check it here and switch accordingly:
/// ```
/// if (colorMode) {
///     part_type_color_rgb(pt, 255, 255, 255, 255, 255, 255);  // White
///     colorMode = false;
/// } else {
///     part_type_color_rgb(pt, 0, 255, 0, 255, 0, 255);  // Green
///     colorMode = true;
/// }
/// ```
///
/// @related Create_0.gml - Where particle type (pt) is initialized
/// @related Alarm_1.gml - Sets color mode (green stars)
/// @related Alarm_2.gml - Sets black and white mode (white stars)
/// @note Key code 67 corresponds to the 'C' key on standard keyboards

// === COLOR MODE TOGGLE ===
// Set particle color to green RGB values (0,255,0) with full opacity
// This changes all stars to green color mode
// Note: This currently only sets green mode. For true toggling, implement
// mode state tracking to alternate between green and white.
part_type_color_rgb(pt, 0, 255, 0, 255, 0, 255);