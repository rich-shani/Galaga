/// ========================================================================
/// oShieldPickup - CREATE EVENT (Initialization)
/// ========================================================================
/// @description Shield pickup object that drops from enemies when killed.
///              Falls down the screen and can be collected by the player.
///              When collected, grants the player 2 seconds of invincibility
///              with a visual shield effect.
/// ========================================================================

// === MOVEMENT VARIABLES ===
// Shield pickup falls downward at a constant speed
fallSpeed = 3 * global.Game.Display.scale;

// === LIFETIME ===
// Shield pickup will despawn after this many frames if not collected
// 300 frames = 5 seconds at 60 FPS
lifetime = 300;

// === VISUAL EFFECT ===
// Rotation for visual appeal
rotation = 0;
rotationSpeed = 8;

