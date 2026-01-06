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

