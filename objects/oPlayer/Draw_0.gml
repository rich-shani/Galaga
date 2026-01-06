/// ========================================================================
/// oPlayer - DRAW EVENT (Player Ship Rendering)
/// ========================================================================
/// @description Renders the player ship sprite and visual effects based on
///              current ship state. Handles different rendering for ACTIVE,
///              RELEASING, and CAPTURED states, including dual fighter mode
///              and thruster animations.
/// 
/// Rendering Features:
///   • Ship sprite drawing (with tilt animation based on movement direction)
///   • Dual fighter rendering (when shotMode == DOUBLE)
///   • Thruster animation (engine effects when not paused)
///   • Debug collision box (when global.debug is enabled)
///   • Rescue animation (RELEASING state)
/// 
/// Sprite Details:
///   • Main sprite: xwing_sprite_sheet (subimage selected by shipImage variable)
///   • Thruster sprite: sLaserEmit (animated based on global.Game.Display.animationIndex)
///   • Scale: 0.8 for ship, 1.0 for thrusters (scaled by global.Game.Display.scale)
/// 
/// State-Based Rendering:
///   • ACTIVE: Full rendering (ship + thrusters + dual fighter if applicable)
///   • RELEASING: Main ship + descending rescued fighter
///   • CAPTURED: No rendering (handled by enemy captor object)
///   • DEAD/RESPAWN: No rendering (ship not visible during these states)
/// 
/// @author Galaga Wars Team
/// @event Draw (Event 0) - Runs every frame for rendering
/// @related Step_0.gml - Updates shipImage and shipStatus variables
/// @related Create_0.gml - Initializes shipImage and shotMode variables
/// ========================================================================

// ========================================================================
// GAME MODE CHECK - Only Render During Active Gameplay
// ========================================================================
// Only render player ship during active gameplay mode
// Prevents rendering during menus, transitions, or other game states
// ========================================================================
if (global.Game.State.mode == GameMode.GAME_ACTIVE) {

	// ========================================================================
	// ACTIVE STATE RENDERING - Normal Gameplay
	// ========================================================================
	// Draw ship sprite with thrusters when player is active and flying
	// Includes dual fighter support and animated thruster effects
	// ========================================================================
	if (shipStatus == ShipState.ACTIVE) {

		// ========================================================================
		// MAIN SHIP SPRITE - Primary Player Fighter
		// ========================================================================
		// Draw the main player ship sprite
		// Parameters:
		//   • Sprite: xwing_sprite_sheet (sprite resource)
		//   • Subimage: shipImage (0-3, selected based on movement direction in Step_0.gml)
		//   • Position: x, y (current player position)
		//   • Scale: 0.8, 0.8 (80% size for visual effect)
		//   • Rotation: 0 (no rotation)
		//   • Color: c_white (full color, no tinting)
		//   • Alpha: 1.0 (fully opaque)
		// ========================================================================
		draw_sprite_ext(xwing_sprite_sheet, shipImage, x, y, 0.8, 0.8, 0, c_white, 1);

		// ========================================================================
		// DUAL FIGHTER MODE - Second Fighter Rendering
		// ========================================================================
		// Draw second fighter when in DOUBLE shot mode (rescued fighter docked)
		// Positioned to the right of main fighter by DUAL_FIGHTER_OFFSET_X pixels
		// Uses same sprite and subimage as main fighter for visual consistency
		// ========================================================================
		if (shotMode == ShotMode.DOUBLE) {
			// Draw docked dual fighter (positioned to right of main fighter)
			draw_sprite_ext(xwing_sprite_sheet, shipImage, x + DUAL_FIGHTER_OFFSET_X, y, 0.8, 0.8, 0, c_white, 1);
		}

		// ========================================================================
		// SHIELD VISUAL EFFECT - Draw Shield When Active
		// ========================================================================
		// Draw glowing shield effect around player when shield is active
		// Shield provides invincibility and visual feedback to player
		// Uses pulsing animation to make it more visible
		// ========================================================================
		if (isShieldActive) {
			// Calculate pulse animation based on shield timer
			// Creates a pulsing effect that gets faster as shield expires
			var pulse = (sin(global.Game.Display.animationIndex * 0.15) + 1) / 2; // 0 to 1
			var alpha = 0.5 + (pulse * 0.5); // Pulse between 0.5 and 1.0
			var shieldRadius = 40 * global.Game.Display.scale;
			
			// Draw outer glow circle (cyan/blue)
			draw_set_alpha(alpha * 0.6);
			draw_set_colour(c_purple);
			draw_circle(x, y, shieldRadius * 1.2, false);
			
			// Draw inner shield ring (brighter)
			draw_set_alpha(alpha * 0.8);
			draw_set_colour(c_white);
			draw_circle(x, y, shieldRadius * 0.7, false);
			
			if (shotMode == ShotMode.DOUBLE) {
				// Draw outer glow circle (cyan/blue)
				draw_set_alpha(alpha * 0.6);
				draw_set_colour(c_purple);
				draw_circle(x + DUAL_FIGHTER_OFFSET_X, y, shieldRadius * 1.2, false);
			
				// Draw inner shield ring (brighter)
				draw_set_alpha(alpha * 0.8);
				draw_set_colour(c_white);
				draw_circle(x + DUAL_FIGHTER_OFFSET_X, y, shieldRadius * 0.7, false);						
			}
					
			// Reset drawing settings
			draw_set_alpha(1);
			draw_set_colour(c_white);
		}
		
		// ========================================================================
		// DEBUG COLLISION BOX - Development Tool
		// ========================================================================
		// Draw collision bounding box when debug mode is enabled
		// Helps visualize collision detection area during development
		// Uses semi-transparent red rectangle to show collision boundaries
		// ========================================================================
		if (global.debug) {
			// Set alpha to 50% for semi-transparent collision box
			draw_set_alpha(0.5);
			// Draw red rectangle using bounding box coordinates
			draw_rectangle_colour(bbox_left, bbox_top, bbox_right, bbox_bottom, c_red, c_red, c_red, c_red, false);
			// Reset alpha to 100% for normal drawing
			draw_set_alpha(1);
		}

		// ========================================================================
		// THRUSTER ANIMATION - Engine Effects
		// ========================================================================
		// Animate and draw thruster effects when game is not paused
		// Thrusters are drawn below and to the sides of the ship
		// Animation frame is calculated from global animation index for smooth looping
		// ========================================================================
		if (!global.Game.State.isPaused) {
			// Calculate thruster animation frame from global animation index
			// Divides by 24 and multiplies by 2 to create smooth animation cycle
			var thruster_frame = global.Game.Display.animationIndex / 24 * 2;
			
			// Draw left thruster (offset 8 pixels left from center, 32 pixels down)
			draw_sprite_ext(sLaserEmit, thruster_frame, 
				x - (8 * global.Game.Display.scale), 
				y + (32 * global.Game.Display.scale), 
				global.Game.Display.scale, global.Game.Display.scale, 0, c_white, 1);
			
			// Draw right thruster (offset 8 pixels right from center, 32 pixels down)
			draw_sprite_ext(sLaserEmit, thruster_frame, 
				x + (8 * global.Game.Display.scale), 
				y + (32 * global.Game.Display.scale), 
				global.Game.Display.scale, global.Game.Display.scale, 0, c_white, 1);

			// ========================================================================
			// DUAL FIGHTER THRUSTERS - Second Fighter Engine Effects
			// ========================================================================
			// Draw thruster effects for second fighter when in DOUBLE mode
			// Uses same animation and positioning logic as main fighter
			// Positioned relative to second fighter (x + DUAL_FIGHTER_OFFSET_X)
			// ========================================================================
			if (shotMode == ShotMode.DOUBLE) {
				// Left thruster of second fighter
				draw_sprite_ext(sLaserEmit, thruster_frame, 
					x + DUAL_FIGHTER_OFFSET_X - (8 * global.Game.Display.scale), 
					y + (32 * global.Game.Display.scale), 
					global.Game.Display.scale, global.Game.Display.scale, 0, c_white, 1);
				
				// Right thruster of second fighter
				draw_sprite_ext(sLaserEmit, thruster_frame, 
					x + DUAL_FIGHTER_OFFSET_X + (8 * global.Game.Display.scale), 
					y + (32 * global.Game.Display.scale), 
					global.Game.Display.scale, global.Game.Display.scale, 0, c_white, 1);
			}
		}
	}
	// ========================================================================
	// RELEASING STATE RENDERING - Rescue Animation
	// ========================================================================
	// Draw main ship and descending rescued fighter during rescue sequence
	// Rescued fighter position is interpolated in Step_0.gml (RELEASING state)
	// ========================================================================
	else if (shipStatus == ShipState.RELEASING) {
		// Draw main player ship sprite (centered position)
		draw_sprite_ext(xwing_sprite_sheet, 2, x, y, 0.8, 0.8, 0, c_white, 1);
		
		// Draw descending fighter during rescue animation
		// Position (rescued_fighter_x, rescued_fighter_y) is updated in Step_0.gml
		// Fighter smoothly moves from captor's position toward docking position
		draw_sprite_ext(xwing_sprite_sheet, 2, rescued_fighter_x, rescued_fighter_y, 0.8, 0.8, 0, c_white, 1);		
	}
	// ========================================================================
	// CAPTURED STATE RENDERING - No Drawing
	// ========================================================================
	// When player is captured, rendering is handled by the captor enemy object
	// The player ship follows the captor's position and is drawn by the enemy
	// This prevents duplicate rendering or positioning conflicts
	// ========================================================================
	else if (shipStatus == ShipState.CAPTURED) {
		// No rendering - handled by captor enemy object
	}
}