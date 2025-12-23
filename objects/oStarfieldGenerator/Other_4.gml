// ========================================================================
// oStarfieldGenerator - Other Event 4 (Room Start)
// ========================================================================
/// @description PRE-GENERATE STARFIELD
/// Pre-populates the screen with stars by running the particle system update
/// multiple times before the room becomes visible.
///
/// This event is called when the room starts to immediately fill the screen
/// with stars, rather than waiting for them to gradually spawn and scroll in.
/// Without this pre-generation, players would see an empty screen that slowly
/// fills with stars, which looks unpolished.
///
/// === PRE-GENERATION PROCESS ===
/// Runs the particle system update loop 1000 times, which:
/// - Spawns new particles from the emitter each iteration
/// - Updates particle positions (stars scrolling down)
/// - Allows stars to distribute across the screen
/// - Creates a fully-formed starfield immediately upon room start
///
/// === PERFORMANCE CONSIDERATION ===
/// This is a one-time cost paid at room start. The 1000 iterations ensure
/// enough stars have spawned and distributed to fill the visible area.
/// After this initial generation, the particle system runs automatically
/// at normal frame rate.
///
/// === TIMING ===
/// This event fires at room start (Other Event 4), before the first Draw event,
/// ensuring the starfield is ready when the player sees the screen.
///
/// @related Create_0.gml - Where particle system (ps) is initialized
/// @related Alarm_0.gml - Handles pause state synchronization

// === PRE-GENERATION LOOP ===
// Run the particle system update multiple times to create a fully-formed starfield
// This ensures the screen is populated with stars immediately when the room loads
repeat(1000) {
	// Update particle system:
	// - Spawns new particles from emitter
	// - Updates particle positions (stars moving down)
	// - Manages particle lifetimes (removes expired particles)
	// - Distributes particles across the screen
	part_system_update(ps);
}