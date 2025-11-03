/// ================================================================
/// TIE INTERCEPTER DRAWING - Normal sprite with optional beam overlay
/// ================================================================
/// Renders the TIE Intercepter sprite with color based on health state.
/// When beam weapon is active, draws beam animation overlay on top.
/// ================================================================

/// === BEAM ANIMATION OVERLAY ===
/// Draw beam charging animation if beam is currently active 
if (alarm[3] > -1) {
	/// Beam is in active firing phase - draw beam animation with scaling

	/// BEAM CHARGE-UP PHASE: Scales from small to full size
	/// Visible when alarm[3] is in upper 2/3 of timer duration
	if (alarm[3] > ((2 * global.beamtime) / 3) - 1) {		
		draw_sprite_ext(spr_beam, floor(beam_weapon.animation / 2), round(x), round(y),
			((abs(global.beamtime - alarm[3]) * global.scale) / (global.beamtime / 3)),
			((abs(global.beamtime - alarm[3]) * global.scale) / (global.beamtime / 3)),
			0, c_white, ((abs(global.beamtime - alarm[3])) / (global.beamtime / 3)));
	}

	/// BEAM SUSTAIN PHASE: Full size, full opacity
	/// Visible in the middle 1/3 of timer duration
	else if (alarm[3] < ((2 * global.beamtime) / 3) && alarm[3] > global.beamtime / 3) {
		draw_sprite_ext(spr_beam, floor(beam_weapon.animation / 2), round(x), round(y),
			1 * global.scale, 1 * global.scale, 0, c_white, 1);
	}

	/// BEAM POWER-DOWN PHASE: Scales from full to small size
	/// Visible when alarm[3] is in lower 1/3 of timer duration
	else if (alarm[3] < (global.beamtime / 3) + 1) {
		draw_sprite_ext(spr_beam, floor(beam_weapon.animation / 2), round(x), round(y),
			((alarm[3] * global.scale) / (global.beamtime / 3)),
			((alarm[3] * global.scale) / (global.beamtime / 3)),
			0, c_white, ((alarm[3]) / (global.beamtime / 3)));
	}
}

/// === MAIN SPRITE DRAWING ===
/// Draw TIE Intercepter sprite with color based on hit count
var i = round(direction / 15);

if (hitCount == 2) {
	/// Full health: Draw in white (normal color)
	draw_sprite_ext(sTieIntercepter, i, x, y, 1, 1, 0, c_white, 1);
} else {
	/// Damaged: Draw in maroon (damaged state color)
	draw_sprite_ext(sTieIntercepter, i, x, y, 1, 1, 0, c_maroon, 1);
}

/// === CAPTURED PLAYER RENDERING ===
/// ================================================================
/// Draw captured player sprite when player is held by this enemy's beam
/// ================================================================
/// If player is captured by this enemy's beam, render player sprite above enemy
if (oPlayer.captor == id) {
	
	var player_rotation = beam_weapon.animation * 30;
	
	if (beam_weapon.state == BEAM_STATE.CAPTURE_PLAYER) {
		/// GalagaWars: Use X-Wing with spin effect
		draw_sprite_ext(xwing_sprite_sheet, 2, beam_weapon.player_x, beam_weapon.player_y, 0.8, 0.8, player_rotation, c_white, 1);
	}
	else {
		/// GalagaWars: Use X-Wing with spin effect
		draw_sprite_ext(xwing_sprite_sheet, 2, x, y-72, 0.8, 0.8, 0, c_white, 0.5);

		/// Draw pulsing glow effect around captured player
		var glow_alpha = (sin(player_rotation * 0.02) + 1) / 2;  // Oscillates 0 to 1
		draw_set_alpha(glow_alpha * 0.5);
		draw_circle_colour(x, y-72, 48, c_yellow, c_red, false);
		draw_set_alpha(1);
	}
}

/// === DEBUG COLLISION DISPLAY ===
if (global.debug) {
	// Draw collision bounding box for debugging
	draw_set_alpha(0.5);
	draw_rectangle_colour(bbox_left, bbox_top, bbox_right, bbox_bottom, c_red, c_red, c_red, c_red, false);
	draw_set_alpha(1);
}

