/// @description Handles drawing the player ship, its shots, and related visual effects (e.g., explosions, capture, regain).
/// This script is executed in the Draw event of the player ship object.
/// It assumes the existence of sprites (spr_shot, spr_ship, spr_explode), a Controller object with gameMode, start, att, and attshot properties, and variables/macros from the initialization code.
/// The rendering accounts for game mode, attract mode, double ship mode, death animations, and capture/regain states.

/// @section Attract Mode Shot
// Draw a shot in attract mode (demo mode) if Controller.attshot is 1.
// Controller.attshotx and Controller.attshoty define the shot's position in attract mode.
// Uses spr_shot with default scale (1,1), rotation (shot1dir), white color, and full opacity (1).
if (Controller.attshot == 1) {
    draw_sprite_ext(spr_shot, 0, Controller.attshotx, Controller.attshoty, 1, 1, shot1dir, c_white, 1);
}

/// @section Main Gameplay and Attract Mode Rendering
// Render game elements when in gameplay mode (Controller.gameMode == GameMode.GAME_ACTIVE)
// or in specific attract mode states (Controller.att between 6 and 17, inclusive).
// Controller.att likely represents the attract mode state or timer.
if (global.gameMode == GameMode.GAME_ACTIVE || (Controller.att > 5 && Controller.att < 18)) {

        /// @subsubsection Shots
        // Draw the first shot if it is active (shot1x, shot1y are not off-screen).
        // Uses spr_shot with no scaling (1,1), rotation based on shot1dir, white color, and full opacity.
        draw_sprite_ext(spr_shot, 0, shot1x, shot1y, 1, 1, shot1dir, c_white, 1);

        // Draw the second shot, similar to the first, using shot2x, shot2y, and shot2dir.
        draw_sprite_ext(spr_shot, 0, shot2x, shot2y, 1, 1, shot2dir, c_white, 1);

        // Draw an additional shot for the right ship in double mode (dub1 == 1).
        // Offset by Ship.SHIP_SPACE (28 pixels) to align with the right ship's position.
        if (dub1 == 1) {
            draw_sprite_ext(spr_shot, 0, shot1x + Ship.SHIP_SPACE, shot1y, 1, 1, shot1dir, c_white, 1);
        }

        // Draw an additional shot for the right ship’s second shot in double mode (dub2 == 1).
        // Also offset by Ship.SHIP_SPACE for the right ship.
        if (dub2 == 1) {
            draw_sprite_ext(spr_shot, 0, shot2x + Ship.SHIP_SPACE, shot2y, 1, 1, shot2dir, c_white, 1);
        }

        /// @subsubsection Second Ship Death Animation
        // Draw the explosion animation for the right ship in double mode when hit (deadanim2 between 0 and 4).
        // Uses spr_explode with the frame index calculated as floor(deadanim2 + 5) to select the appropriate explosion frame.
        // Positioned at secondx (right ship’s X-coordinate) and y=528 (bottom of the screen).
 //       if (deadanim2 > 0 && deadanim2 < 4) {
           // draw_sprite(spr_explode, floor(deadanim2 + 5), secondx, 528);
		//   draw_sprite(sExplosion3, floor(deadanim2 + 5), secondx, 528);
  //      }

        /// @subsubsection Ship Rendering
        // Draw the ship when alive (shipStatus == 0) or respawning (shipStatus == 2).
        // Uses spr_ship at the ship’s position (x, y) with default frame (0).
        if (shipStatus == 0 || shipStatus == 2) {
			
			if (global.roomname == "starwars") {
				draw_sprite_ext(sXWing,shipDirection,x,y,0.8,0.8,0,c_white,1);
			}
			else {
				draw_sprite(spr_ship, 0, x, y);
			}
			
			if (!global.isGamePaused) {
				// if we're not paused, then animate the thrusters
				draw_sprite(sLaserEmit,global.animationIndex/24*2,x-(8*global.scale),y+(24*global.scale));
				draw_sprite(sLaserEmit,global.animationIndex/24*2,x+(8*global.scale),y+(24*global.scale));
			}
			
            // If in double mode, draw a second ship offset by Ship.SHIP_SPACE (28 pixels) to the right.
            if (shotMode == ShotMode.DOUBLE) {
                
			
				if (global.roomname == "starwars") {
					draw_sprite_ext(sXWing,shipDirection,x+(Ship.SHIP_SPACE*2),y,0.8,0.8,0,c_white,1);
				}
				else {
					draw_sprite(spr_ship, 0, x + Ship.SHIP_SPACE, y);
				}
			
				if (!global.isGamePaused) {
					// if we're not paused, then animate the thrusters
					draw_sprite(sLaserEmit,global.animationIndex/24*2,x+Ship.SHIP_SPACE-(8*global.scale),y+(24*global.scale));
					draw_sprite(sLaserEmit,global.animationIndex/24*2,x+Ship.SHIP_SPACE+(8*global.scale),y+(24*global.scale));
				}
			}
        }

        /// @subsubsection Caught State Animation
        // Draw the ship when caught by a boss’s beam.
        // If alarm[2] == -1 and spinanim == 0, skip drawing (likely a transition state).
        // Otherwise, draw spr_ship with rotation (spinanim) to show the ship spinning, positioned at (x, y).
        if (shipStatus == ShipState.CAPTURED || shipStatus == ShipState.RELEASING) {
            if (alarm[2] != -1 || spinanim != 0) {
                draw_sprite_ext(spr_ship, 0, x, y, 1, 1, spinanim, c_white, 1);
            }
        }

        /// @subsubsection Regain Animation
        // Draw the regained ship during the regain process (regain == 1).
        // Uses spr_ship at the new ship’s position (newshipx, newshipy) with rotation (spinanim).
        // Typically occurs after rescuing a captured ship from a boss.
        if (regain == 1) {
            draw_sprite_ext(spr_ship, 0, newshipx, newshipy, 1, 1, spinanim, c_white, 1);
        }
  //  }
}