/// ========================================================================
/// oPlayer - STEP EVENT (Main Game Loop)
/// ========================================================================
/// @description Main player control logic - handles input, movement, shooting,
///              state transitions, and game flow control
/// 
/// This is the primary event that runs every frame during gameplay. It implements
/// a state machine that processes different behaviors based on the current shipStatus.
/// 
/// State Machine Flow:
///   • ACTIVE     → Normal gameplay, full player control (movement, shooting)
///   • CAPTURED   → Player held by enemy tractor beam (no control, follows captor)
///   • DEAD       → Player destroyed, waiting for death animation/respawn/game over
///   • RESPAWN    → Respawn animation in progress, waiting for timer
///   • RELEASING  → Rescued fighter descending to dock with player
/// 
/// Input Handling:
///   • Supports both keyboard (arrow keys, spacebar) and gamepad (analog stick, A button)
///   • Horizontal movement: Left/Right arrows or gamepad left analog horizontal axis
///   • Shooting: Spacebar or gamepad A button (gp_face1)
///   • Movement speed controlled by movespeed variable (set in Create_0.gml)
/// 
/// Shooting Mechanics:
///   • Rate-limited by missileInterval cooldown timer
///   • Max missiles: 2 in SINGLE mode, 4 in DOUBLE mode
///   • Uses object pool system (global.missile_pool) for performance
///   • Falls back to instance_create if pool unavailable
/// 
/// Performance Considerations:
///   • Early return if game is paused (skips all processing)
///   • Only processes during GAME_ACTIVE mode
///   • State machine ensures only relevant code runs per state
/// 
/// @author Galaga Wars Team
/// @event Step (Event 0) - Runs every frame
/// @related Create_0.gml - Variable initialization
/// @related Draw_0.gml - Rendering based on shipStatus and shipImage
/// @related Collision_oEnemyShot.gml - Triggered when hit by enemy projectile
/// @related objects/oEnemyBase/Step_0.gml - Enemy capture logic
/// ========================================================================

// ========================================================================
// PAUSE CHECK - Early Exit
// ========================================================================
/// @description If game is paused, skip all player logic this frame
///              Prevents input processing, movement, and state changes during pause
///              This ensures player state remains frozen when game is paused
/// ========================================================================
if (global.Game.State.isPaused) return;

// ========================================================================
// GAME MODE CHECK - Active Gameplay Only
// ========================================================================
/// @description Only process player logic during active gameplay mode
///              Prevents player input/state changes during menus, transitions, etc.
///              Other game modes (ATTRACT_MODE, SHOW_RESULTS, etc.) don't need player logic
/// ========================================================================
if (global.Game.State.mode == GameMode.GAME_ACTIVE) {

	// ========================================================================
	// SHIP STATE MACHINE - Main Behavior Controller
	// ========================================================================
	/// @description Central state machine that processes different behaviors
	///              based on current shipStatus. Each state has distinct logic:
	///              • ACTIVE: Input handling, movement, shooting
	///              • CAPTURED/DEAD: Death animation, life loss, respawn logic
	///              • RELEASING: Rescue animation, docking sequence
	///              • RESPAWN: Timer wait, position reset, reactivation
	/// ========================================================================
	switch (shipStatus) {
		case ShipState.ACTIVE:
			/// ========================================================================
			/// ACTIVE STATE - Normal Player Control
			/// ========================================================================
			/// @description Player has full control: movement left/right and shooting
			///              This is the primary gameplay state where player interacts
			///              with the game. Supports both gamepad and keyboard input.
			/// 
			/// Features:
			///   • Horizontal movement (left/right)
			///   • Ship sprite selection based on movement direction
			///   • Missile firing with cooldown and max bullet limits
			///   • Boundary clamping to keep player on screen
			///   • Dual fighter support (if shotMode == DOUBLE)
			/// ========================================================================

			/// @var fireIsPressed - Flag indicating fire button was pressed this frame
			///                       Set by input checks, used to trigger missile spawn
			var fireIsPressed = false;

			// ========================================================================
			// GAMEPAD INPUT HANDLING
			// ========================================================================
			/// @description Process gamepad input if gamepad is connected and enabled
			///              Reads analog stick for movement and face button for shooting
			///              Applies deadzone to prevent drift from analog stick center
			/// ========================================================================
			if (global.Game.Input.useGamepad) {
				// === HORIZONTAL MOVEMENT - Analog Stick ===
				// Read horizontal axis value from left analog stick (-1.0 to 1.0)
				// Apply deadzone of 0.1 to prevent drift when stick is released
				// Values outside deadzone trigger movement, inside deadzone = centered
				var _h_input = gamepad_axis_value(0, gp_axislh);
				// Determine movement direction and ship sprite based on analog input
				if (_h_input > 0.1) {
					// Moving right - stick pushed to the right
					xDirection = 1;
					shipImage = 3;  // Right-tilted ship sprite (visual feedback)
				}
				else if (_h_input < -0.1) {
					// Moving left - stick pushed to the left
					xDirection = -1;
					shipImage = 1;  // Left-tilted ship sprite (visual feedback)
				}
				else {
					// Centered - stick within deadzone, no movement
					xDirection = 0;
					shipImage = 2;  // Center ship sprite (default/straight position)
				}

				// === FIRE BUTTON - Gamepad ===
				// Check if A button (gp_face1) was pressed this frame
				// Only triggers on button press, not hold (check_pressed vs check)
				if (gamepad_button_check_pressed(0, gp_face1)) fireIsPressed = true;
			}
			else {
				// ========================================================================
				// KEYBOARD INPUT HANDLING
				// ========================================================================
				// Alternative control scheme using keyboard arrow keys
				// keyboard_check returns 1 if key is held, 0 if not
				// Subtraction creates direction value: -1 (left), 0 (none), 1 (right)
				// 
				// Note: Previous implementation used A/D keys (commented out)
				//       Current implementation uses arrow keys for consistency with gamepad
				// ========================================================================
				xDirection = keyboard_check(vk_right) - keyboard_check(vk_left);
				
				// === SHIP SPRITE SELECTION - Keyboard ===
				// Choose ship sprite based on movement direction for visual feedback
				// Sprite selection provides visual indication of ship tilt/movement
				if (xDirection == -1) shipImage = 1;       // Left-tilted sprite
				else if (xDirection == 1) shipImage = 3;   // Right-tilted sprite
				else shipImage = 2;                        // Centered sprite (no movement)

				// === FIRE BUTTON - Keyboard ===
				// Spacebar triggers shooting (only on key press, not hold)
				if (keyboard_check_pressed(vk_space)) fireIsPressed = true;
			}

			// ========================================================================
			// MOVEMENT CALCULATION & APPLICATION
			// ========================================================================
			// Calculate pixel displacement this frame based on direction and speed
			// movespeed is set in Create_0.gml (typically PLAYER_BASE_MOVE_SPEED = 5)
			// Direction multiplier: -1 (left), 0 (none), 1 (right)
			// Result: dx = -movespeed (left), 0 (none), +movespeed (right)
			// ========================================================================
			dx = xDirection * movespeed;

			// Apply calculated displacement to x position
			// Position updates every frame when direction is non-zero
			x += dx;

			// ========================================================================
			// BOUNDARY CHECK - Keep Player On Screen
			// ========================================================================
			// Clamp player position to stay within playable area
			// SHIP_MIN_X and SHIP_MAX_X are defined in Create_0.gml (based on game mode)
			// Prevents player from leaving screen boundaries
			// 
			// Dual fighter mode adjustment:
			//   In DOUBLE mode, reduce max X by SHIP_SPACE to prevent second fighter
			//   (which is offset to the right by DUAL_FIGHTER_OFFSET_X) from going off-screen
			// ========================================================================
			if (shotMode == ShotMode.SINGLE) {
				x = clamp(x, SHIP_MIN_X, SHIP_MAX_X);
			}
			else if (shotMode == ShotMode.DOUBLE) {
				x = clamp(x, SHIP_MIN_X, SHIP_MAX_X - SHIP_SPACE);
			}

			// ========================================================================
			// SHOOTING LOGIC - Missile Firing System
			// ========================================================================
			// Handle missile firing with rate limiting and bullet count restrictions
			// This creates balanced gameplay that rewards timing and prevents bullet spam
			// ========================================================================
			if (fireIsPressed) {

				// ========================================================================
				// MISSILE SPAWN CONDITIONS - Rate Limiting & Bullet Cap
				// ========================================================================
				// Only spawn missile if both conditions are met:
				//   1. Cooldown expired (missileInterval <= 0) - prevents rapid fire
				//   2. Less than maxBullets missiles on screen - prevents bullet spam
				//      • SINGLE mode: max 2 missiles (one fighter, double shot)
				//      • DOUBLE mode: max 4 missiles (two fighters, double shot each)
				//
				// This creates a fair shooting system that rewards timing and skill
				// while preventing overwhelming the enemies with unlimited bullets
				// ========================================================================
				var maxBullets = (shotMode == ShotMode.DOUBLE) ? 4 : 2;
				
				// Get active missile count - use pool stats if available, else instance count
				// Pool system provides more accurate count and better performance
				var activeMissiles = (global.missile_pool != undefined) 
					? global.missile_pool.stats.current_active 
					: instance_number(oMissile);
				
				if (missileInterval <= 0 && activeMissiles < maxBullets) {
					// ========================================================================
					// SPAWN MISSILE - Object Pool System
					// ========================================================================
					// Use object pool if available for better performance (avoids GC spikes)
					// Falls back to instance_create_layer if pool not initialized
					// 
					// Missile spawn position:
					//   • Y offset: y - PLAYER_MISSILE_SPAWN_OFFSET_Y (spawns above ship)
					//   • X position: Player's x position (centered on fighter)
					// ========================================================================
					if (global.missile_pool != undefined) {
						// Use object pool - acquire missile from pool
						var missile = global.missile_pool.acquire(x, y - PLAYER_MISSILE_SPAWN_OFFSET_Y);
						
						// In DOUBLE mode, spawn second missile from second fighter position
						if (shotMode == ShotMode.DOUBLE) {
							global.missile_pool.acquire(x + DUAL_FIGHTER_OFFSET_X, y - PLAYER_MISSILE_SPAWN_OFFSET_Y);
						}
					} else {
						// Fallback: Use standard instance creation (slower, but works if pool unavailable)
						instance_create_layer(x, y - PLAYER_MISSILE_SPAWN_OFFSET_Y, "GameSprites", oMissile);
						
						// In DOUBLE mode, spawn second missile from second fighter position
						if (shotMode == ShotMode.DOUBLE) {
							instance_create_layer(x + DUAL_FIGHTER_OFFSET_X, y - PLAYER_MISSILE_SPAWN_OFFSET_Y, "GameSprites", oMissile);
						}
					}

					// === AUDIO FEEDBACK ===
					// Play shooting sound effect (GShot sound, volume 1.0 = 100%)
					// Provides audio feedback to confirm shot was fired
					global.Game.Controllers.audioManager.playSound(GShot, 1);

					// === COOLDOWN TIMER RESET ===
					// Set cooldown to 0.1 seconds (6 frames at 60 FPS)
					// Prevents firing too rapidly and maintains game balance
					// Calculation: 0.1 seconds * game speed in FPS = frames to wait
					missileInterval = 0.1 * game_get_speed(gamespeed_fps);

					// === SHOT STATISTICS TRACKING ===
					// Track shot fired via ScoreManager for accuracy calculation
					// Used for statistics, achievements, and gameplay analysis
					if (global.Game.Controllers.scoreManager != undefined) {
						global.Game.Controllers.scoreManager.recordShot();
					}
				}
			}

			// ========================================================================
			// COOLDOWN REDUCTION - Frame-by-Frame Timer Decrement
			// ========================================================================
			// Decrement missile cooldown timer each frame
			// When it reaches 0 or below, player can fire again (cooldown expired)
			// This creates the rate-limiting behavior for shooting
			// ========================================================================
			missileInterval -= 1;
			break;
		case ShipState.CAPTURED:
		case ShipState.DEAD:
			/// ========================================================================
			/// DEAD/CAPTURED STATE - Player Destruction or Capture Handling
			/// ========================================================================
			/// @description Handles death animation completion, life loss, and 
			///              respawn/game over logic. Both CAPTURED and DEAD states
			///              use similar logic initially (wait for animation, deduct life).
			/// 
			/// State Differences:
			///   • DEAD: Player was destroyed by enemy shot (alarm[0] handles animation)
			///   • CAPTURED: Player was captured by enemy beam (alarm[5] handles animation)
			/// 
			/// Life Loss Flow:
			///   1. Wait for death/capture animation to complete (alarm timer)
			///   2. Turn off screen shake effect
			///   3. Deduct one life from player
			///   4. Check remaining lives:
			///      • Lives > 0: Transition to RESPAWN state (set alarm[1] or alarm[5])
			///      • Lives = 0: Trigger game over (set alarm[10])
			/// ========================================================================

			// ========================================================================
			// DEATH ANIMATION DELAY - Wait for Explosion Sequence
			// ========================================================================
			// Wait for explosion/death animation to complete before processing life loss
			// alarm[0] is set in Alarm_11.gml when player is hit (120 frames = 2 seconds)
			// If alarm still running, skip all processing this frame (early return)
			// This ensures explosion animation plays fully before game logic proceeds
			// ========================================================================
			if (alarm[0] > 0) return;

			// ========================================================================
			// SCREEN SHAKE CLEANUP - Disable Visual Effect
			// ========================================================================
			// Turn off screen shake effect if it's still active
			// Screen shake is typically enabled during death/explosion in Alarm_11.gml
			// Must be disabled here to prevent shake persisting after death sequence
			// ========================================================================
			if (layer_get_visible("ScreenShake")) {
				layer_set_visible("ScreenShake", false);
			}

			// ========================================================================
			// LIFE LOSS AND RESPAWN/GAME OVER LOGIC
			// ========================================================================
			// Only process if game isn't already over (prevents double-processing)
			// Handles life deduction and determines next game state
			// ========================================================================
			if (!global.Game.State.isGameOver) {
				// === DEDUCT LIFE ===
				// Remove one life from player's remaining lives
				// Life count is tracked in global.Game.Player.lives
				global.Game.Player.lives -= 1;

				// ========================================================================
				// CHECK FOR REMAINING LIVES - Determine Next State
				// ========================================================================
				// Check if player has lives remaining to determine respawn vs game over
				// Note: Different alarm timers are used for DEAD vs CAPTURED states
				//       DEAD uses alarm[1], CAPTURED uses alarm[5]
				// ========================================================================
				if (global.Game.Player.lives > 0) {
					// === PLAYER HAS LIVES REMAINING - RESPAWN ===
					
					if (shipStatus == ShipState.DEAD) {
						// === DEAD STATE RESPAWN ===
						// Player was destroyed, prepare to respawn after delay
						shipStatus = ShipState.RESPAWN;
						shotMode = ShotMode.SINGLE;  // Always respawn in SINGLE mode (lose dual fighter if had one)

						// Set respawn timer to PLAYER_RESPAWN_DELAY_FRAMES (180 frames = 3 seconds at 60 FPS)
						// Gives player brief moment to prepare and prevents immediate re-entry
						alarm[1] = PLAYER_RESPAWN_DELAY_FRAMES;
					}
					else { 
						// === CAPTURED STATE RESPAWN ===
						// Player was captured, prepare to respawn after delay
						// Note: Different timer (alarm[5]) is used for captured state
						shipStatus = ShipState.RESPAWN;
						
						// Set captured respawn timer (300 frames = 5 seconds at 60 FPS)
						// Longer delay for captured state to allow for capture sequence completion
						alarm[5] = 300;
					}
				}
				else {
					// ========================================================================
					// GAME OVER - No Lives Remaining
					// ========================================================================
					// No lives remaining, end the game
					// Set game over flag to trigger cleanup and results screen
					// ========================================================================
					global.Game.State.isGameOver = true;

					// Stop all audio (prevents music/sounds from continuing during game over)
					// Important: Prevents sound loops from continuing after game ends
					global.Game.Controllers.audioManager.stopAll();
					
					// Set cleanup/game over sequence timer (120 frames = 2 seconds at 60 FPS)
					// Triggers high score check and transition to results screen
					// Alarm[10] handler in Alarm_10.gml cleans up enemies and shows results
					alarm[10] = 120;
				}
			}

			break;

		case ShipState.RELEASING:
			/// ========================================================================
			/// RELEASING STATE - Rescued Fighter Docking Animation
			/// ========================================================================
			/// @description After captor is destroyed, the rescued fighter smoothly
			///              descends from the captor's position to dock with main player.
			///              This creates a visual sequence showing the rescue completion.
			/// 
			/// Animation Sequence:
			///   1. Player centers horizontally (if off-center)
			///   2. Rescued fighter descends vertically from captor's Y position
			///   3. Rescued fighter moves horizontally toward docking position (right of player)
			///   4. When within 64 pixels of player, docking completes
			///   5. shotMode changes to DOUBLE (dual fighter mode enabled)
			///   6. State transitions to RESPAWN for brief delay before reactivation
			/// 
			/// Variables Used:
			///   • rescued_fighter_x/y: Position of descending fighter (drawn in Draw_0.gml)
			///   • DUAL_FIGHTER_OFFSET_X: Horizontal offset for docked position (84 pixels)
			/// ========================================================================

			// ========================================================================
			// CENTER PLAYER - Align Player for Docking
			// ========================================================================
			// Center player horizontally on screen to prepare for docking sequence
			// Moves player toward center at 3 pixels per frame if off-center
			// This ensures clean docking animation alignment
			// ========================================================================
			if (x < SCREEN_CENTER_X * global.Game.Display.scale) {
				x += 3;  // Move right toward center
			}
			else if (x > SCREEN_CENTER_X * global.Game.Display.scale) {
				x -= 3;  // Move left toward center
			}
			
			// ========================================================================
			// DESCENT ANIMATION - Rescued Fighter Movement
			// ========================================================================
			// Move rescued fighter downward toward player position
			// Fighter starts at captor's position (set when captor is destroyed)
			// Moves toward docking position: x + DUAL_FIGHTER_OFFSET_X (right of player)
			// ========================================================================
			if (rescued_fighter_y < y - 64) {
				// === FIGHTER STILL DESCENDING ===
				// Still above player (64 pixel threshold) - continue descending
				// Descent speed: 4 pixels per frame (smooth animation)
				rescued_fighter_y += 4;

				// Gradually move horizontally toward player's right side (docking position)
				// Target X: Player's X + DUAL_FIGHTER_OFFSET_X (84 pixels to the right)
				var target_x = x + DUAL_FIGHTER_OFFSET_X;
				if (rescued_fighter_x < target_x) rescued_fighter_x += 2;  // Move right
				else if (rescued_fighter_x > target_x) rescued_fighter_x -= 2;  // Move left
			}
			else {
				// ========================================================================
				// DOCKING COMPLETE - Fighter Has Reached Player
				// ========================================================================
				// Rescued fighter has reached player position (within 64 pixels vertically)
				// Complete the docking sequence and enable dual fighter mode
				// ========================================================================
				
				// Clear capture flags - no longer captured
				global.Game.Enemy.capturedPlayer = false;
				captor = noone;  // Clear captor reference

				// Reset rescued fighter tracking variables (no longer needed)
				rescued_fighter_x = 0;
				rescued_fighter_y = 0;
				
				// === DOCKING COMPLETE - Audio Cleanup ===
				// Stop rescue sound effect (if still playing)
				global.Game.Controllers.audioManager.stopSound(GRescue); 
		
				// === ENABLE DUAL FIGHTER MODE ===
				// Rescued fighter has successfully docked - enable double ship mode!
				// This provides the player with double firepower (4 max missiles)
				shotMode = ShotMode.DOUBLE;
				
				// Transition to RESPAWN state for brief delay before reactivation
				// This gives a moment for the player to see the dual fighter formation
				shipStatus = ShipState.RESPAWN;	
				
				// Set ship sprite to center/straight position (facing forward)
				shipImage = 2;
			
				// Set respawn timer to half of normal delay (PLAYER_RESPAWN_DELAY_FRAMES / 2)
				// Shorter delay since player didn't die - just completed rescue
				// Gives brief moment before reactivating controls
				alarm[1] = PLAYER_RESPAWN_DELAY_FRAMES / 2;
			}
		break;			

		case ShipState.RESPAWN:
			/// ========================================================================
			/// RESPAWN STATE - Player Ship Reappearing After Death/Rescue
			/// ========================================================================
			/// @description Waits for respawn timer to expire, then returns player
			///              to ACTIVE state at default starting position. This state
			///              provides a brief pause between death/capture and reactivation.
			/// 
			/// Respawn Sources:
			///   • DEAD state: Normal death respawn (alarm[1] set to PLAYER_RESPAWN_DELAY_FRAMES)
			///   • CAPTURED state: Capture respawn (alarm[5] set to 300 frames)
			///   • RELEASING state: Rescue completion (alarm[1] set to PLAYER_RESPAWN_DELAY_FRAMES/2)
			/// 
			/// When timer expires:
			///   • shipStatus changes to ACTIVE (player regains control)
			///   • Position resets to center-bottom of screen
			///   • Player can immediately start moving and shooting
			/// ========================================================================

			// ========================================================================
			// CHECK FOR CAPTURED STATE RESPAWN TIMER
			// ========================================================================
			// If fighter was CAPTURED, alarm[5] is used instead of alarm[1]
			// Wait for captured respawn timer if it's still running
			// If alarm[5] > -1, it's still counting down - skip processing this frame
			// ========================================================================
			if (alarm[5] > -1) return;
			
			// ========================================================================
			// RESPAWN TIMER CHECK - Wait for Delay to Complete
			// ========================================================================
			// Wait for respawn animation/delay to complete (alarm[1] reaches -1)
			// alarm[1] is set by previous states (DEAD or RELEASING)
			// When timer expires (alarm[1] == -1), reactivate player
			// ========================================================================
			if (alarm[1] == -1) {
				// ========================================================================
				// REACTIVATE PLAYER - Return to Normal Gameplay
				// ========================================================================
				// Return to normal gameplay state - player regains full control
				shipStatus = ShipState.ACTIVE;

				// ========================================================================
				// RESET POSITION - Move to Starting Location
				// ========================================================================
				// Place player at default starting position (center-bottom of screen)
				// This ensures player always spawns in a safe, predictable location
				// Position scales with display scale for resolution independence
				// ========================================================================
				x = SCREEN_CENTER_X * global.Game.Display.scale;  // Horizontal center
				y = PLAYER_SPAWN_Y * global.Game.Display.scale;  // Near bottom of screen
			}

			break;
	}
}