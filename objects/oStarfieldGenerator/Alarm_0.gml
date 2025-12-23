// ========================================================================
// oStarfieldGenerator - Alarm 0 Event
// ========================================================================
/// @description PARTICLE SYSTEM PAUSE SYNCHRONIZATION
/// Synchronizes the particle system update state with the game's pause state.
///
/// This alarm event is called periodically to ensure the starfield particle system
/// respects the game's pause state. When the game is paused, particle updates are
/// disabled to freeze the starfield animation. When unpaused, automatic updates
/// resume, allowing stars to continue scrolling.
///
/// === USAGE ===
/// This alarm should be triggered regularly (e.g., every step or at intervals)
/// to maintain synchronization between game state and particle system state.
///
/// === BEHAVIOR ===
/// - When paused: Particles stop updating (starfield appears frozen)
/// - When active: Particles update automatically (stars scroll normally)
///
/// === PARTICLE SYSTEM UPDATES ===
/// Automatic updates handle:
/// - Particle movement (stars scrolling down)
/// - Particle lifetime management (removing expired stars)
/// - New particle emission (spawning new stars from emitter)
///
/// @related Create_0.gml - Where particle system (ps) is initialized
/// @var global.Game.State.isPaused - Global pause state flag

// === PAUSE STATE CHECK ===
// Check if the game is currently paused
if (global.Game.State.isPaused) {
	// === GAME IS PAUSED ===
	// Disable automatic particle system updates
	// This freezes the starfield animation when game is paused
	part_system_automatic_update(ps, false);
}
else {
	// === GAME IS ACTIVE ===
	// Enable automatic particle system updates
	// Allows stars to scroll normally during gameplay
	part_system_automatic_update(ps, true);	
}