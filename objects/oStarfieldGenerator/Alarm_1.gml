// ========================================================================
// oStarfieldGenerator - Alarm 1 Event
// ========================================================================
/// @description SET COLOR MODE
/// Changes particle color to green RGB (0,255,0) for color starfield mode.
///
/// This alarm event is triggered to switch the starfield from black & white
/// mode to color mode. When activated, all existing and newly spawned stars
/// will appear in green, giving the classic Galaga-style colored starfield effect.
///
/// === COLOR SPECIFICATION ===
/// RGB values: (0, 255, 0) = Pure green
/// Color range format: (min_red, min_green, min_blue, max_red, max_green, max_blue)
/// All values set to 0,255,0,255,0,255 = solid green with no color variation
///
/// === VISUAL EFFECT ===
/// Stars will render as green dots instead of white, matching the classic
/// arcade game aesthetic where stars appear in various colors (green, white, etc.)
///
/// === USAGE ===
/// Typically called when player toggles color mode or at game start if color
/// mode is the default. Can be triggered by KeyPress_67 (C key) event.
///
/// @related Create_0.gml - Where particle type (pt) is initialized
/// @related Alarm_2.gml - Sets black and white mode (white stars)
/// @related KeyPress_67.gml - Toggles between color and B&W modes

// === COLOR MODE ACTIVATION ===
// Set particle color to green RGB values (0,255,0) with full opacity
// This affects all particles of this type (existing and future)
part_type_color_rgb(pt, 0, 255, 0, 255, 0, 255);