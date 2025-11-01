/// ================================================================
/// PLAYER SHIP RENDERING - Active and Captured States
/// ================================================================
/// Renders the player ship sprite when in gameplay mode.
/// Different rendering for ACTIVE vs CAPTURED states.
/// ================================================================

if (global.gameMode == GameMode.GAME_ACTIVE) {

	if (shipStatus == _ShipState.ACTIVE) {
		/// === ACTIVE STATE RENDERING ===
		/// Draw normal ship sprite with thrusters when player is active and flying

		if (global.roomname == "GalagaWars") {
			draw_sprite_ext(xwing_sprite_sheet, shipImage, x, y, 0.8, 0.8, 0, c_white, 1);

			if (global.debug) {
				// draw collision mask
				draw_set_alpha(0.5);
				draw_rectangle_colour(bbox_left, bbox_top, bbox_right, bbox_bottom, c_red, c_red, c_red, c_red, false);
				draw_set_alpha(1);
			}
		}
		else {
			draw_sprite(spr_ship, 0, x, y);
		}

		if (!global.isGamePaused) {
			// if we're not paused, then animate the thrusters
			draw_sprite_ext(sLaserEmit, global.animationIndex/24*2, x-(8*global.scale), y+(32*global.scale), global.scale, global.scale, 0, c_white, 1);
			draw_sprite_ext(sLaserEmit, global.animationIndex/24*2, x+(8*global.scale), y+(32*global.scale), global.scale, global.scale, 0, c_white, 1);
		}
	}
	else if (shipStatus == _ShipState.CAPTURED) {
		/// === CAPTURED STATE RENDERING ===
		/// Render captured player sprite above the enemy captor
		/// Sprite rotates/spins while captured

		/// Calculate rotation based on captured animation counter
		/// Completes full rotation every 360 frames
		var captured_rotation = (capturedanimation / 360) * 360;

		if (global.roomname == "GalagaWars") {
			/// GalagaWars room: Use X-Wing sprite with spin effect
			var frame_index = (capturedanimation / 30) mod 2;  // Alternate frames
			draw_sprite_ext(xwing_sprite_sheet, 2, x, y, 0.8, 0.8, captured_rotation, c_white, 1);
		}
		else {
			/// Original Galaga room: Use ship sprite with spin effect
			draw_sprite_ext(spr_ship, 0, x, y, 1, 1, captured_rotation, c_white, 1);
		}

		/// Draw a glowing effect around captured ship
		if (!global.isGamePaused) {
			/// Create pulsing glow effect
			var glow_alpha = (sin(capturedanimation * 0.02) + 1) / 2;  // Oscillates 0 to 1
			draw_set_alpha(glow_alpha * 0.5);
			draw_circle_colour(x, y, 32, c_yellow, c_red, false);
			draw_set_alpha(1);
		}
	}
}