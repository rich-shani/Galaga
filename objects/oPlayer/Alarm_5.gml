/// ========================================================================
/// oPlayer - ALARM EVENT 5 (Captured Player Respawn Timer Completion)
/// ========================================================================
/// @description Timer event that marks completion of captured player respawn delay.
///              Used when player is captured and needs to respawn after the capture
///              sequence completes.
/// 
/// Capture Respawn Flow:
///   1. Player is captured by enemy (shipState = CAPTURED)
///   2. Capture sequence plays (player follows captor)
///   3. Step_0.gml (DEAD/CAPTURED state) sets alarm[5] = 300 frames (5 seconds)
///   4. Timer counts down to -1 (expires)
///   5. Step_0.gml (RESPAWN state) checks if alarm[5] > -1, waits if active
///   6. When expired (alarm[5] == -1), normal respawn logic proceeds
/// 
/// Timer Duration:
///   • 300 frames = 5 seconds at 60 FPS
///   • Longer than normal respawn delay to allow capture sequence to complete
///   • Ensures player doesn't respawn while still visually captured
/// 
/// Current Implementation:
///   • This alarm event itself is empty (no code executed when timer expires)
///   • The actual respawn logic is handled in Step_0.gml RESPAWN state
///   • This event serves as a timer marker for captured state respawn
/// 
/// Difference from Alarm[1]:
///   • alarm[1]: Normal respawn timer (for DEAD state)
///   • alarm[5]: Captured respawn timer (for CAPTURED state)
///   • Different durations and use cases
/// 
/// @author Galaga Wars Team
/// @event Alarm 5 - Captured player respawn delay timer
/// @related Step_0.gml - Sets alarm[5] in CAPTURED state, checks in RESPAWN state
/// @related Alarm_1.gml - Normal respawn timer (for comparison)
/// ========================================================================

// Timer completion is handled in Step_0.gml RESPAWN state (checks alarm[5] > -1)
// This alarm event serves as a timer marker - expiration allows respawn logic to proceed