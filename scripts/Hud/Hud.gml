/// @function Draw_Hud
/// @description Main HUD rendering function - displays all on-screen UI elements
///
/// This is the master HUD function called from oGameManager's Draw event.
/// It orchestrates the display of all UI elements based on game mode:
///   • Scores (1UP && HIGH SCORE)
///   • Lives/Credits counter
///   • Game state messages (PLAYER 1, STAGE #, READY, etc.)
///   • Results screen
///   • High score entry
///   • Game Over message
///   • Pause overlay
///
/// The HUD adapts dynamically based on:
///   • global.Game.State.mode - Current game state
///   • global.Game.State.isPaused - Pause flag
///   • global.Game.Challenge.isActive - Challenge stage flag
///
/// Font Selection:
///   • GalagaWars room: fAtari24 (2x scale)
///   • Galaga/Galaga2 rooms: fAtari12 (1x scale)
///
/// @related Controller_draw_fns.gml - Contains Draw_Scores, Draw_Lives, etc.
/// @related oGameManager/Draw_0.gml - Calls this function

function Draw_Hud(){
	// === FONT SETUP ===
	// Select appropriate retro Atari font based on room scale
	// GalagaWars uses 2x scale (24pt), original Galaga uses 1x scale (12pt)

	draw_set_font(fAtari24);

	// === SCORE DISPLAY ===
	// Show scores (1UP && HIGH SCORE) once past attract mode
	// Attract mode (demo) doesn't show scores
	if (global.Game.State.mode > GameMode.ATTRACT_MODE) {
		// Draw the score header && values at top of screen
		Draw_Scores();
	}

	// === GAME OVER CHECK ===
	// If game over flag is set, display GAME OVER message && exit
	// No other UI elements are drawn in game over state
	if (global.Game.State.isGameOver)
	{
		draw_set_color(c_red);
		draw_text(160*global.Game.Display.scale, 288*global.Game.Display.scale, "GAME OVER");

		return;  // Exit function early, skip all other drawing
	}

	// === CREDITS/LIVES DISPLAY ===
	// Before stage message, show credits counter
	// After game starts, show lives counter
	if (global.Game.State.mode < GameMode.GAME_STAGE_MESSAGE) {
		Draw_Credits();
	}
	else {
		Draw_Lives();
	}

	// === PAUSE OVERLAY ===
	// If game is paused, display large "GAME PAUSED" message
	// This takes priority over all other game mode messages
	if (global.Game.State.isPaused) {
		draw_set_font(fAtari36);
		draw_set_color(c_green);

		draw_text(100*global.Game.Display.scale,265*global.Game.Display.scale, "GAME PAUSED");

		// Reset font && color for other UI elements
		draw_set_color(c_white);
		draw_set_font(fAtari24);
	}
	else {
		// === GAME MODE MESSAGES ===
		// Display appropriate message/screen based on current game mode
		// Each mode has specific UI requirements
		draw_set_color(c_aqua);

		switch (global.Game.State.mode) {
			case GameMode.INSTRUCTIONS:
				/// Display instructions screen (controls, scoring, etc.)
				Draw_Instructions();
				break

			case GameMode.SHOW_RESULTS:
				/// Display end-of-stage results (shots fired, hits, accuracy %)
				Draw_Results();
				break;

			case GameMode.ENTER_INITIALS:
				/// Display high score entry screen with keyboard input
				Draw_Enter_Initials();
				break;

			case GameMode.GAME_PLAYER_MESSAGE:
				/// Display "PLAYER 1" message at start of game
				/// Shown briefly before stage message
				draw_text(176*global.Game.Display.scale, 288*global.Game.Display.scale, "PLAYER 1");
				break;

			case GameMode.GAME_STAGE_MESSAGE:
				/// Display "STAGE #" message before each level
				/// Shows current stage number (global.Game.Level.current)
				draw_text(160*global.Game.Display.scale, 288*global.Game.Display.scale, "STAGE");
				draw_text(260*global.Game.Display.scale, 288*global.Game.Display.scale, global.Game.Level.current);
				break;

			case GameMode.CHALLENGE_STAGE_MESSAGE:
				/// Display "CHALLENGING STAGE" message before bonus round
				/// Challenge stages occur every 4 levels
				draw_text(100*global.Game.Display.scale, 288*global.Game.Display.scale, "CHALLENGING STAGE");
				break;

			case GameMode.GAME_READY:
				/// Display stage indicator just before gameplay begins
				/// Shows either "CHALLENGING STAGE" || "STAGE #"
				if (global.Game.Challenge.isActive) {
					draw_text(100*global.Game.Display.scale, 288*global.Game.Display.scale, "CHALLENGING STAGE");
				}
				else {
					draw_text(160*global.Game.Display.scale, 288*global.Game.Display.scale, "STAGE");
					draw_text(260*global.Game.Display.scale, 288*global.Game.Display.scale, global.Game.Level.current);
				}
				break;

			case GameMode.GAME_ACTIVE:
				/// During active gameplay, show "READY" during player respawn
				/// Displays only when player is respawning (alarm[1] active) && has lives
				if ((oPlayer.alarm[1] > -1) && (global.Game.Player.lives > 0)) {
					draw_text(170*global.Game.Display.scale, 288*global.Game.Display.scale, "READY");
		        }
				else if (oPlayer.alarm[5] > -1) {
					draw_text(110*global.Game.Display.scale, 288*global.Game.Display.scale, "FIGHTER CAPTURED");
				}
				break;

		} // SWITCH STATEMENT
	}

	// === CHALLENGE STAGE RESULTS ===
	// If in a challenge stage, overlay challenge-specific results
	// Shows perfect clear bonus && enemy count
	if (global.Game.Challenge.isActive) {
		Draw_ChallengeStage_Results();
	}
}
