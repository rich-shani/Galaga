/// @description Shield pickup collection handler
/// Processes shield pickup collection when player collides with oShieldPickup.
/// Grants player temporary invincibility with visual shield effect.
///
/// Shield System:
///   • shieldTimer tracks shield duration (0-5 scale, where 5 = max shield)
///   • Each pickup adds 0.5 to shield capacity
///   • Maximum shield duration: 5.0 (prevents infinite stacking)
///   • Active shield provides invincibility to enemy shots and collisions
///
/// Visual Feedback:
///   • Shield effect is drawn around player in Draw_0.gml
///   • Shield timer decreases over time in Step_0.gml
///   • Player becomes vulnerable when shieldTimer reaches 0
///
/// Collection Requirements:
///   • Player must be in ACTIVE state (cannot collect during death/respawn/capture)
///   • Triggered by Collision_oShieldPickup event (sets alarm[8] = 1)
///
/// @var shieldTimer - Shield duration remaining (0-5 scale)
/// @var GCredit - Sound effect played when shield is collected
///
/// @related Collision_oShieldPickup.gml - Triggers this alarm on collision
/// @related Step_0.gml - Decrements shieldTimer each frame when active
/// @related Draw_0.gml - Draws shield visual effect around player

if (shipStatus == ShipState.ACTIVE) {
	// Play pickup sound effect
	global.Game.Controllers.audioManager.playSound(GCredit);

	// Add 0.5 to shield capacity (on 0-5 scale)
	// Each shield pickup grants additional invincibility time
	shieldTimer += 0.5;
	
	// Clamp to maximum of 5 to prevent infinite stacking
	// Maximum shield duration is approximately 5 seconds of invincibility
	if (shieldTimer > 5) {
		shieldTimer = 5;
	}
}