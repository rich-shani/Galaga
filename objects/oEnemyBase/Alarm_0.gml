/// @description Sprite rotation delay timer
/// This alarm is set to 60 frames when an enemy reaches formation position
/// (see Step_0.gml line 191). It creates a brief delay before the enemy
/// sprite rotates to face downward (270 degrees).
///
/// Purpose:
///   • Prevents immediate rotation when enemy first enters formation
///   • Allows visual breathing animation to stabilize
///   • Gives Draw function time to smoothly rotate sprite
///
/// Behavior:
///   • Set to 60 frames in MOVE_INTO_FORMATION state transition
///   • When alarm[0] == -1 (expired), enemy can rotate to face down
///   • Checked in Step_0.gml line 223 to enable rotation
///
/// @related oEnemyBase/Step_0.gml:191 - Where alarm[0] is set
/// @related oEnemyBase/Step_0.gml:223 - Where alarm[0] is checked for rotation
