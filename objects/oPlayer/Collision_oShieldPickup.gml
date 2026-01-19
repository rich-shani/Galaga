/// @description Shield pickup collision handler
/// Processes collision between player ship and shield pickup item.
/// Destroys the pickup and triggers shield activation.
///
/// Collision Flow:
///   1. Player collides with oShieldPickup (detected by GameMaker collision system)
///   2. Shield pickup is destroyed (removed from game world)
///   3. Trigger shield collection processing (alarm[8]) which grants invincibility
///
/// Shield Activation:
///   • Alarm[8] event (Alarm_8.gml) handles the actual shield grant logic
///   • Adds 0.5 to shieldTimer (shield duration, 0-5 scale)
///   • Maximum shield duration is clamped to 5.0
///
/// Performance:
///   • Shield pickup is immediately destroyed after collision
///   • Prevents multiple collisions with same pickup instance
///
/// @param other - Reference to the oShieldPickup instance that collided
/// @related Alarm_8.gml - Processes shield grant and timer increment
/// @related oShieldPickup - Shield pickup object definition

// Destroy the shield pickup item (player has collected it)
instance_destroy(other);

// Trigger shield collection processing on next frame
// Alarm_8.gml will grant shield invincibility and play sound effect
alarm[8] = 1;