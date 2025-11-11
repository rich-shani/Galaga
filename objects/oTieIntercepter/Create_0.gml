/// ================================================================
/// TIE INTERCEPTER CREATION EVENT
/// ================================================================
/// Initializes TIE Intercepter-specific attributes && enables the
/// beam weapon capability that differentiates this enemy type from
/// standard TIE Fighters.
///
/// The TIE Intercepter is equipped with:
/// • Advanced beam weapon (can fire charged energy beam)
/// • Enhanced combat AI
/// • Strategic attack patterns
///
/// Beam weapon characteristics:
/// • Activates during dive attack phase
/// • Requires player in vulnerable state (single-ship mode)
/// • One beam per dive cycle
/// • Deals significant damage if player is hit
/// ================================================================

/// Call parent Create event to initialize base enemy properties
event_inherited();

/// === ENABLE BEAM WEAPON ===
/// TIE Intercepters are equipped with a special beam weapon
/// that can be fired during dive attack sequences
beam_weapon.available = true;