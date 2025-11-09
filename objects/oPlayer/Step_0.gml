/// @description PLAYER MOVEMENT AND INPUT HANDLING
/// Main player control logic - handles input, movement, shooting, and state transitions.
///
/// This event only runs during GAME_ACTIVE mode and processes different behaviors
/// based on the current shipStatus (_ShipState enum).
///
/// Ship States:
///   • ACTIVE     - Normal gameplay, full player control
///   • CAPTURED   - Player is held by enemy tractor beam
///   • DEAD       - Player destroyed, waiting to respawn or game over
///   • RESPAWN    - Respawn animation in progress
///   • RELEASING  - Player is being released from capture
///
/// @related oPlayer/Create_0.gml - Where shipStatus and variables are initialized
/// @related objects/oEnemyBase/Step_0.gml:320-360 - Enemy capture logic

// === PAUSE CHECK ===
// If game is paused, skip all player logic this frame
if (global.Game.State.isPaused) return;

// === GAME MODE CHECK ===
// Only process player logic during active gameplay
if (global.Game.State.mode == GameMode.GAME_ACTIVE) {

	// === SHIP STATE MACHINE ===
	// Process player behavior based on current state
	switch (shipStatus) {
		case _ShipState.ACTIVE:
			/// ================================================================
			/// ACTIVE STATE - Normal player control
			/// ================================================================
			/// Player has full control: movement left/right and shooting
			/// Supports both gamepad and keyboard input
			/// ================================================================

			var fireIsPressed = false;

			// === GAMEPAD INPUT ===
			// Check if gamepad is connected and active
			if (oGameManager.useGamepad) {
				// === HORIZONTAL MOVEMENT ===
				// Read analog stick value (-1.0 to 1.0)
				// Apply deadzone of 0.1 to prevent drift
				var _h_input = gamepad_axis_value(0, gp_axislh);
				if (_h_input > 0.1) {
					// Moving right
					xDirection = 1;
					shipImage = 3;  // Right-tilted ship sprite
				}
				else if (_h_input < -0.1) {
					// Moving left
					xDirection = -1;
					shipImage = 1;  // Left-tilted ship sprite
				}
				else {
					// Centered
					xDirection = 0;
					shipImage = 2;  // Center ship sprite
				}

				// === FIRE BUTTON ===
				// A button on the XBOX Controller (gp_face1)
				if (gamepad_button_check_pressed(0,gp_face1)) fireIsPressed = true;
			}
			else {
				// === KEYBOARD INPUT ===
				// Alternative control scheme using A/D keys
				// keyboard_check returns 1 if pressed, 0 if not
				// Subtraction creates -1 (left), 0 (none), or 1 (right)
				xDirection = keyboard_check(ord("D")) - keyboard_check(ord("A"));

				// === SHIP SPRITE SELECTION ===
				// Choose ship sprite based on movement direction
				if (xDirection == -1) shipImage = 1;       // Left-tilted
				else if (xDirection == 1) shipImage = 3;   // Right-tilted
				else shipImage = 2;                        // Centered

				// === FIRE BUTTON ===
				// Spacebar to fire
				if (keyboard_check_pressed(vk_space)) fireIsPressed = true;
			}

			// === MOVEMENT CALCULATION ===
			// Calculate pixel displacement this frame
			// movespeed is set in Create_0.gml (typically 6 * global.Game.Display.scale)
			dx = xDirection * movespeed;

			// Apply movement to x position
			x += dx;

			// === BOUNDARY CHECK ===
			// Clamp player position to stay within playable area
			// SHIP_MIN_X and SHIP_MAX_X defined in Create_0.gml
			// Prevents player from leaving screen boundaries
			if (shotMode == _ShotMode.SINGLE) x = clamp(x, SHIP_MIN_X, SHIP_MAX_X);
			else if (shotMode == _ShotMode.DOUBLE) x = clamp(x, SHIP_MIN_X, SHIP_MAX_X-SHIP_SPACE);

			// === SHOOTING LOGIC ===
			// Handle missile firing with rate limiting
			if (fireIsPressed) {

				// === MISSILE SPAWN CONDITIONS ===
				// Only spawn missile if:
				//   1. Cooldown expired (missileInterval <= 0)
				//   2. Less than 2 missiles on screen (prevents spam)
				//
				// This creates a fair shooting system that rewards timing
				// and prevents overwhelming the enemies with bullets
				var maxBullets = (shotMode == _ShotMode.DOUBLE) ? 4 : 2;
				if (missileInterval <= 0 && instance_number(oMissile) < maxBullets) {
					// === SPAWN MISSILE ===
					// Create missile 48 pixels above player ship
					// Spawned on "GameSprites" layer (same as enemies)
					instance_create_layer(x, y-48, "GameSprites", oMissile);
					if (shotMode == _ShotMode.DOUBLE) {
						instance_create_layer(x + DUAL_FIGHTER_OFFSET_X, y-48, "GameSprites", oMissile);
					}
					
					// === AUDIO FEEDBACK ===
					// Play shooting sound effect
					audio_play_sound(GShot, 1, false);

					// === COOLDOWN TIMER ===
					// Set cooldown to 0.1 seconds (6 frames at 60 FPS)
					// Prevents firing too rapidly
					missileInterval = 0.1*game_get_speed(gamespeed_fps);

					// === SHOT STATISTICS ===
					// Increment fire counter for accuracy tracking
					// Used to calculate hit ratio (hits/fires) at stage end
					oGameManager.fire += 1;
				}
			}

			// === COOLDOWN REDUCTION ===
			// Decrement missile cooldown timer each frame
			// When it reaches 0, player can fire again
			missileInterval -= 1;
			break;
		case _ShipState.CAPTURED:
		case _ShipState.DEAD:
			/// ================================================================
			/// DEAD/CAPTURED STATE - Player is destroyed or captured
			/// ================================================================
			/// Handles death animation, life loss, and respawn/game over logic
			/// Both CAPTURED and DEAD states use similar logic initially
			/// ================================================================

			// === DEATH ANIMATION DELAY ===
			// Wait for explosion/death animation to complete (alarm[0])
			// If alarm still running, skip processing this frame
			if (alarm[0] > 0) return;

			// === SCREEN SHAKE CLEANUP ===
			// Turn off screen shake effect if it's still active
			// Screen shake is typically enabled during death/explosion
			if (layer_get_visible("ScreenShake")) {
				// Turn screen shake OFF
				layer_set_visible("ScreenShake", false);
			}

			// === LIFE LOSS AND RESPAWN LOGIC ===
			// Only process if game isn't already over
			if (!global.Game.State.isGameOver) {
				// === DEDUCT LIFE ===
				// Remove one life from player
				global.Game.Player.lives -= 1;

				// === CHECK FOR REMAINING LIVES ===
				if (global.Game.Player.lives > 0) {
					// === RESPAWN ===
					// Player has lives remaining, prepare to respawn
				    shipStatus = _ShipState.RESPAWN;
					shotMode = _ShotMode.SINGLE;

					// Set respawn timer to PLAYER_RESPAWN_DELAY_FRAMES
					// Gives player brief moment to prepare
					alarm[1] = PLAYER_RESPAWN_DELAY_FRAMES;
				}
				else {
					// === GAME OVER ===
					// No lives remaining, end the game
					global.Game.State.isGameOver = true;

					// just incase there's a sound running in a loop, clear ...
					audio_stop_all();
					
					// Set cleanup/game over sequence timer (2 seconds)
					// Triggers high score check and return to title
					alarm[10] = 120;
				}
			}

			break;

		case _ShipState.RELEASING:
			/// ================================================================
			/// RELEASING STATE - Rescued fighter descending to join player
			/// ================================================================
			/// After captor is destroyed, the rescued fighter smoothly
			/// descends from the captor's position to dock with main player
			/// ================================================================

			// center player ...
			if (x < 448) {
				x += 3;
			}
			else if (x > 448) {
				x -= 3;
			}
			
			// === DESCENT ANIMATION ===
			// Move rescued fighter downward toward player position
			if (rescued_fighter_y < y - 64) {
				// Still above player - continue descending
				rescued_fighter_y += 4; // Descent speed

				// Gradually move horizontally toward player's right side
				var target_x = x + DUAL_FIGHTER_OFFSET_X; // Position to right of player
				if (rescued_fighter_x < target_x) rescued_fighter_x += 2;
				else if (rescued_fighter_x > target_x) rescued_fighter_x -= 2;
			}
	      else {		
			// no longer captured ...
			global.Game.Enemy.capturedPlayer = false;
			captor = noone;

			// Reset rescued fighter tracking
			rescued_fighter_x = 0;
			rescued_fighter_y = 0;
			
			// === DOCKING COMPLETE ===
			sound_stop(GRescue); 
		
			// Rescued fighter has reached player position
			shotMode = _ShotMode.DOUBLE; // Enable dual fighter mode!
			shipStatus = _ShipState.RESPAWN;	
			
			// draw the ship facing up
			shipImage = 2
			
			// Set respawn timer to PLAYER_RESPAWN_DELAY_FRAMES
			// Gives player brief moment to prepare
			alarm[1] = PLAYER_RESPAWN_DELAY_FRAMES/2;
		}
		break;			

		case _ShipState.RESPAWN:
			/// ================================================================
			/// RESPAWN STATE - Player ship reappearing
			/// ================================================================
			/// Waits for respawn timer (alarm[1]) to expire, then returns
			/// player to ACTIVE state at default starting position
			/// ================================================================

			// === RESPAWN TIMER CHECK ===
			// Wait for respawn animation/delay to complete (alarm[1])
			if (alarm[1] ==-1) {
				// === REACTIVATE PLAYER ===
				// Return to normal gameplay state
				shipStatus = _ShipState.ACTIVE;

				// === RESET POSITION ===
				// Place player at starting position (center-bottom of screen)
				x = 224*global.Game.Display.scale;  // Horizontal center
				y = 528*global.Game.Display.scale;  // Near bottom of screen
			}

			break;
	}
}