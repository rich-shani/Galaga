/// ========================================================================
/// oShieldPickup - DRAW EVENT (Visual Rendering)
/// ========================================================================
/// @description Draws the shield pickup as a glowing circular shield icon.
///              Uses pulsing animation to make it more visible.
/// ========================================================================

// === PULSE ANIMATION ===
// Create a pulsing effect using sine wave
var pulse = (sin(global.Game.Display.animationIndex * 0.1) + 1) / 2; // 0 to 1
var alpha = 0.6 + (pulse * 0.4); // Pulse between 0.6 and 1.0
var scale = 1.0 + (pulse * 0.2); // Pulse size between 1.0 and 1.2

var i = rotation/45; // 8 animation frames per rotation

draw_sprite_ext(sCoin, i, x, y, scale, scale, 0, c_white, alpha);

// === DRAW SHIELD ICON ===
// Draw outer glow circle (cyan/blue)
//draw_set_alpha(alpha * 0.5);
//draw_set_colour(c_navy);
//draw_circle(x, y, 16 * global.Game.Display.scale * scale, false);

//// Draw inner shield circle (white/blue)
//draw_set_alpha(alpha);
//draw_set_colour(c_white);
//draw_circle(x, y, 12 * global.Game.Display.scale * scale, false);

//// Draw shield symbol (simple arc shape)
//draw_set_alpha(alpha);
//draw_set_colour(c_aqua);
//var shieldRadius = 10 * global.Game.Display.scale * scale;
//// Draw a semi-circle arc to represent a shield
//draw_arc(x, y - shieldRadius * 0.3, shieldRadius, 180, 0, false);

// Reset drawing settings
//draw_set_alpha(1);
//draw_set_colour(c_white);

