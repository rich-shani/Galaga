/// ================================================================
/// PLAYER SHIP RENDERING - Active && Captured States
/// ================================================================
/// Renders the player ship sprite when in gameplay mode.
/// Different rendering for ACTIVE vs CAPTURED states.
///
/// MIGRATION NOTE:
///   Migrated to use global.Game.State.mode && isPaused
/// ================================================================

if (global.Game.State.mode == GameMode.GAME_ACTIVE) {

	if (shipStatus == ShipState.ACTIVE) {
		/// === ACTIVE STATE RENDERING ===
		/// Draw normal ship sprite with thrusters when player is active && flying
		draw_sprite_ext(xwing_sprite_sheet, shipImage, x, y, 0.8, 0.8, 0, c_white, 1);

		// DUAL Mode; draw second fighter
		if (shotMode == ShotMode.DOUBLE) {
			// Draw docked dual fighter (positioned to right of main fighter)
			draw_sprite_ext(xwing_sprite_sheet, shipImage, x + DUAL_FIGHTER_OFFSET_X, y, 0.8, 0.8, 0, c_white, 1);
		}

		if (global.debug) {
			// draw collision mask
			draw_set_alpha(0.5);
			draw_rectangle_colour(bbox_left, bbox_top, bbox_right, bbox_bottom, c_red, c_red, c_red, c_red, false);
			draw_set_alpha(1);
		}

		if (!global.Game.State.isPaused) {
			// if we're not paused, then animate the thrusters
			draw_sprite_ext(sLaserEmit, global.Game.Display.animationIndex/24*2, x-(8*global.Game.Display.scale), y+(32*global.Game.Display.scale), global.Game.Display.scale, global.Game.Display.scale, 0, c_white, 1);
			draw_sprite_ext(sLaserEmit, global.Game.Display.animationIndex/24*2, x+(8*global.Game.Display.scale), y+(32*global.Game.Display.scale), global.Game.Display.scale, global.Game.Display.scale, 0, c_white, 1);

			// DUAL Mode; draw second fighter thrusters
			if (shotMode == ShotMode.DOUBLE) {
				// Draw docked dual fighter (positioned to right of main fighter)
				draw_sprite_ext(sLaserEmit, global.Game.Display.animationIndex/24*2, x+DUAL_FIGHTER_OFFSET_X-(8*global.Game.Display.scale), y+(32*global.Game.Display.scale), global.Game.Display.scale, global.Game.Display.scale, 0, c_white, 1);
				draw_sprite_ext(sLaserEmit, global.Game.Display.animationIndex/24*2, x+DUAL_FIGHTER_OFFSET_X+(8*global.Game.Display.scale), y+(32*global.Game.Display.scale), global.Game.Display.scale, global.Game.Display.scale, 0, c_white, 1);
			}
		}
	}
	else if (shipStatus == ShipState.RELEASING) {

		/// Draw normal ship sprite 
		draw_sprite_ext(xwing_sprite_sheet, shipImage, x, y, 0.8, 0.8, 0, c_white, 1);
		
		// Draw descending fighter during rescue animation
		draw_sprite_ext(xwing_sprite_sheet, shipImage, rescued_fighter_x, rescued_fighter_y, 0.8, 0.8, 0, c_white, 1);		
	}
	else if (shipStatus == ShipState.CAPTURED) {

	}
}