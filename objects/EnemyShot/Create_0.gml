/// @description ENEMY SHOT INITIALIZATION
/// Sets up enemy projectile movement toward player's current position.
///
/// Enemy shots use a "fire and forget" system - they aim at the player's
/// position at the moment of creation, then travel in that direction.
/// They don't home or track the player after creation.
///
/// Targeting System:
///   • Aims at player's current X position (with slight offset for dual shot mode)
///   • Aims at player's Y position
///   • Speed: 5 pixels/frame * global.scale
///
/// Shot Mode Offset:
///   When player has dual fighters (shotMode != 0), shots aim slightly
///   offset from center (14 pixels * shotMode value) to account for
///   dual fighter positioning.
///
/// Movement Calculation:
///   action_move_point() sets velocity toward target point
///   Enemy shot then travels in straight line toward that point
///
/// @variable {number} oPlayer.x - Player's X position at shot creation
/// @variable {number} oPlayer.y - Player's Y position at shot creation
/// @variable {number} oPlayer.shotMode - Shot mode indicator (0=single, ±1=dual)
///
/// @related oEnemyBase/Step_0.gml:69-81 - Where enemy shots are created
/// @related oEnemyBase/Alarm_1.gml - Additional shot creation logic

// === AIM AT PLAYER ===
// Calculate target position: player's current location + shot mode offset
// action_move_point(target_x, target_y, speed) sets movement direction
// Shot will travel toward this point at 5*scale pixels per frame
move_towards_point(oPlayer.x + (32*(oPlayer.shotMode)), oPlayer.y, 5*global.scale);
	
// === COMMENTED OUT: DIRECTION CLAMPING ===
// Original code limited shot angles to prevent too-steep trajectories
// Removed to allow full range of shot angles for increased difficulty
//if direction > 300{direction = 300};
//if direction < 240{direction = 240};

// === COMMENTED OUT: VISUAL SETTINGS ===
// Original sprite animation settings
//depth = -105; image_speed = 0; image_index = 1;