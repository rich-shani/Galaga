/// @description HUD MESSAGES AND RANK DISPLAY
Draw_Hud();

/// @section Rank Display Rendering
// Render all rank display sprites stored in the array
for (var i = 0; i < array_length(global.Game.Controllers.uiManager.rankDisplaySprites); i++) {
    var sprite_data = global.Game.Controllers.uiManager.rankDisplaySprites[i];

    // Draw a portion of the bkgd_Rank sprite at the specified position
    draw_sprite_part(
        bkgd_Rank,                  // Sprite to draw from
        0,                          // Subimage (frame) to use
        sprite_data.sprite_x,       // X position in the source sprite
        sprite_data.sprite_y,       // Y position in the source sprite
        sprite_data.sprite_width,   // Width of the area to draw
        sprite_data.sprite_height,  // Height of the area to draw
        sprite_data.x_pos,          // X position to draw at
        sprite_data.y_pos           // Y position to draw at
    );
}

/// @section Debug Mode Overlay
// Draw debug information when global.debug is enabled
// Toggle with F3 key (see KeyPress_114.gml)
if (global.debug) {
	Draw_Debug_Overlay();
}