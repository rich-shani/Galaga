/// @description Death Star background rendering
/// Draws the Death Star sprite at the top center of the screen.
/// Uses yoffset to position the sprite (scrolling upward effect) and
/// scale to control its size (grows as it approaches).
///
/// Positioning:
///   • X: 0 (center of screen, sprite origin is centered)
///   • Y: yoffset (starts at 0, decreases to -400 in Step_0.gml)
///   • Scale: Applied to both X and Y dimensions
///   • Rotation: 0 degrees (no rotation)
///   • Color: c_white (full color, no tinting)
///   • Alpha: 1.0 (fully opaque)
///
/// @var yoffset - Vertical position offset (set in Step_0.gml)
/// @var scale - Sprite scaling factor (increases over time)
/// @var death_star - Sprite asset reference
///
/// @related oDeathStar/Create_0.gml - Initial values
/// @related oDeathStar/Step_0.gml - Animation updates

draw_sprite_ext(death_star, 0, 0, yoffset, scale, scale, 0, c_white, 1);