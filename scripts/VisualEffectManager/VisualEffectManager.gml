/// @file VisualEffectsManager.gml
/// @description Manages visual effects (pause effect, nebula background, color cycling)

function VisualEffectsManager() constructor {
    // Visual effect layer handles
    pauseEffectFX = -1;
    scrollingNebulaLayer = -1;
	scrollingNebulaFX = -1;
	
    // Nebula color palette
    hueValues = [
        NEBULA_HUE_BLUE,
        NEBULA_HUE_CYAN,
        NEBULA_HUE_GREEN,
        NEBULA_HUE_YELLOW_GREEN,
        NEBULA_HUE_YELLOW,
        NEBULA_HUE_ORANGE,
        NEBULA_HUE_RED,
        NEBULA_HUE_MAGENTA
    ];

    // Skip flag (for visual effects timing)
	skipFrame = 0;
	exhaleFlag = 0;

    // Initialize layers
	initialize = function() {
		pauseEffectFX = layer_get_fx("PauseEffect");
		scrollingNebulaLayer = layer_get_id("ScrollingNebula");
		scrollingNebulaFX = layer_get_fx("ScrollingNebula");

        if (pauseEffectFX == -1) {
            log_error("PauseEffect layer not found", "VisualEffectsManager", 1);
        }
        if (scrollingNebulaLayer == -1) {
            log_error("ScrollingNebula layer not found", "VisualEffectsManager", 1);
        }
    };

    // Get current hue for nebula effect based on level
	getCurrentHue = function(level) {
        var hueIndex = level mod array_length(hueValues);
        return hueValues[hueIndex];
    };

	initialize();
}