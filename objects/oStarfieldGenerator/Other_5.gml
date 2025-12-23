// ========================================================================
// oStarfieldGenerator - Other Event 5 (Room End)
// ========================================================================
/// @description PARTICLE SYSTEM CLEANUP
/// Properly destroys all particle system components when the room ends.
///
/// This event is called when leaving the room to clean up resources and prevent
/// memory leaks. Particle systems, emitters, and particle types must be explicitly
/// destroyed when no longer needed, as they are not automatically garbage collected.
///
/// === CLEANUP ORDER ===
/// Components are destroyed in reverse order of creation:
/// 1. Particle Type (pt) - Individual particle definition
/// 2. Particle Emitters (pe) - Spawn regions (destroy_all removes all emitters)
/// 3. Particle System (ps) - Main container (must be destroyed last)
///
/// This order ensures dependencies are cleaned up properly. Destroying the particle
/// system first would leave orphaned emitters and types that can't be properly freed.
///
/// === MEMORY MANAGEMENT ===
/// Failing to destroy these resources can lead to:
/// - Memory leaks (resources not freed)
/// - Performance degradation (accumulating unused particle systems)
/// - Crashes (too many particle systems active simultaneously)
///
/// === DESTRUCTION NOTES ===
/// - part_type_destroy(): Removes particle type definition
/// - part_emitter_destroy_all(): Removes all emitters from the system
/// - part_system_destroy(): Removes the entire particle system and all its particles
///
/// @related Create_0.gml - Where particle system components are created
/// @note This is called automatically when the room ends (Other Event 5)

// === CLEANUP SEQUENCE ===
// Destroy particle system components in reverse order of creation
// This prevents memory leaks and ensures proper resource cleanup

// Step 1: Destroy particle type definition
// Removes the particle type that defines star appearance and behavior
part_type_destroy(pt);

// Step 2: Destroy all particle emitters
// Removes all emitters from the particle system (including the main emitter pe)
part_emitter_destroy_all(ps);

// Step 3: Destroy the particle system itself
// Removes the entire particle system, all particles, and frees all associated memory
// This must be done last, as it depends on emitters and types being cleaned up first
part_system_destroy(ps);