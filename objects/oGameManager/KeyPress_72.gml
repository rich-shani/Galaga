/// @description Visual Effects Hue Update (H key - KeyCode 72)
/// Updates the scrolling nebula background hue effect based on current level.
/// Creates dynamic color shifts that reflect level progression.
///
/// Visual Effects System:
///   • Applies hue shift filter to scrolling nebula background layer
///   • Hue value changes based on current level number
///   • Creates visual variety and progression feedback
///   • Uses "_filter_hue" shader effect
///
/// Hue Calculation:
///   • getCurrentHue(level) calculates appropriate hue for level
///   • Different levels produce different color themes
///   • Provides visual progression indicator
///
/// Usage:
///   • Press H key to refresh/update hue effect (manual trigger)
///   • Typically updated automatically during level transitions
///   • Useful for testing or manual adjustment
///
/// Key Mapping:
///   • Key 72 = "H" key on keyboard
///   • "H" for "Hue" effect
///
/// @var global.Game.Controllers.visualEffects.scrollingNebulaFX - Hue filter effect ID
/// @var global.Game.Controllers.visualEffects.getCurrentHue() - Function to calculate hue by level
/// @var global.Game.Level.current - Current level number
///
/// @related oGameManager/KeyPress_70.gml - Fullscreen toggle (F key)
/// @related scripts/VisualEffectManager/VisualEffectManager.gml - Visual effects system

// Update scrolling nebula hue effect if the filter is active
if (global.Game.Controllers.visualEffects.scrollingNebulaFX != -1) 
{
	// Verify the effect is the hue filter (safety check)
	if (fx_get_name(global.Game.Controllers.visualEffects.scrollingNebulaFX) == "_filter_hue")
	{
		// Set the hue shift parameter based on current level
		// Creates dynamic color progression as player advances levels
		fx_set_parameter(global.Game.Controllers.visualEffects.scrollingNebulaFX, "g_HueShift",
						global.Game.Controllers.visualEffects.getCurrentHue(global.Game.Level.current));
	}
}

