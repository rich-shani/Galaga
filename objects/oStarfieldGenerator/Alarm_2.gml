// ========================================================================
// oStarfieldGenerator - Alarm 2 Event
// ========================================================================
/// @description SET BLACK & WHITE MODE
/// Changes particle color to white RGB (255,255,255) for monochrome starfield mode.
///
/// This alarm event is triggered to switch the starfield from color mode to
/// black & white mode. When activated, all existing and newly spawned stars
/// will appear in white, creating a classic monochrome starfield effect.
///
/// === COLOR SPECIFICATION ===
/// RGB values: (255, 255, 255) = Pure white
/// Color range format: (min_red, min_green, min_blue, max_red, max_green, max_blue)
/// All values set to 255,255,255,255,255,255 = solid white with no color variation
///
/// === VISUAL EFFECT ===
/// Stars will render as white dots instead of green, providing a clean,
/// monochrome appearance that may be preferred for certain visual styles
/// or for better visibility against colored backgrounds.
///
/// === USAGE ===
/// Typically called when player toggles to B&W mode or for specific visual
/// sequences requiring monochrome aesthetics. Can be triggered by KeyPress_67 (C key) event.
///
/// @related Create_0.gml - Where particle type (pt) is initialized
/// @related Alarm_1.gml - Sets color mode (green stars)
/// @related KeyPress_67.gml - Toggles between color and B&W modes

// === BLACK & WHITE MODE ACTIVATION ===
// Set particle color to white RGB values (255,255,255) with full opacity
// This affects all particles of this type (existing and future)
part_type_color_rgb(pt, 255, 255, 255, 255, 255, 255);