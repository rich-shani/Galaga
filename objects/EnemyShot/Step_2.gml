/// @description ENEMY SHOT OFF-SCREEN CHECK
/// Destroys enemy shots that travel past bottom of screen.
///
/// Enemy shots are destroyed when they pass the player's zone && leave
/// the visible playfield. This prevents shots from existing indefinitely
/// && consuming resources/collision checks.
///
/// Destruction Threshold:
///   • Y > 576 * global.Game.Display.scale (bottom of screen + buffer)
///   • Also destroyed on collision with player (see Collision events)
///
/// This is checked in End Step (Step_2) to ensure it runs after all
/// movement && collision checks have completed for this frame.
///
/// @related EnemyShot/Create_0.gml - Where shot movement is initialized
/// @related oPlayer/Collision_EnemyShot.gml - Player hit detection

// === OFF-SCREEN CHECK ===
// Destroy shot when it travels past bottom of visible screen
// 576 * scale = bottom boundary (below player starting position)
if y > 576*global.Game.Display.scale{instance_destroy()}