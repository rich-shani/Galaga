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
	
	// === SHIELD HEALTH BAR ===
	// Draw shield health bar at bottom of screen during active gameplay
	if (global.Game.State.mode == GameMode.GAME_ACTIVE) {
		Draw_ShieldHealthBar();
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

/// @function Draw_Scores
/// @description Renders the score header at the top of the screen
///
/// Displays the classic arcade score layout:
///   • "1UP" label (blinking during active gameplay)
///   • Player 1's current score
///   • "HIGH SCORE" label
///   • Current high score value
///
/// Visual Details:
///   • Red text with 60% alpha for labels
///   • White text for score values
///   • Right-aligned text for proper arcade aesthetic
///   • Blinking "1UP" indicator using oGameManager.blink flag
///
/// The player score only appears once gameplay begins (after GAME_PLAYER_MESSAGE mode).
/// High score is always visible once past attract mode.
///
/// @global {number} p1score - Player 1's current score
/// @global {number} disp - Current high score to display
/// @global {GameMode} gameMode - Current game mode
/// @variable {boolean} oGameManager.blink - Blink state for "1UP" indicator
///
/// @related Hud.gml:Draw_Hud - Calls this function to render scores

function Draw_Scores() {

	// === TEXT ALIGNMENT SETUP ===
	// Use right alignment for arcade-style score display
	draw_set_halign(fa_right);

	// === LABEL STYLING ===
	// Red text with slight transparency for "1UP" && "HIGH SCORE" labels
	draw_set_color(c_red);
	draw_set_alpha(0.6);

	// === "1UP" INDICATOR ===
	// Blinks on/off to draw attention during active gameplay
	// Blink state controlled by oGameManager alarm[8] (14 frame interval)
	if (global.Game.Controllers.uiManager.blinkCounter) { draw_text(80*global.Game.Display.scale, 10*global.Game.Display.scale, "1UP"); };

	// === "HIGH SCORE" LABEL ===
	// Always visible (no blinking)
	draw_text(304*global.Game.Display.scale, 10*global.Game.Display.scale, "HIGH SCORE");

	// === SCORE VALUES ===
	// White text for actual score numbers
	draw_set_color(c_white);

	// === PLAYER SCORE ===
	// Only show player score once gameplay has started
	// Hidden during attract mode && instructions
	if (global.Game.State.mode >= GameMode.GAME_PLAYER_MESSAGE) {
		draw_text(96*global.Game.Display.scale, 26*global.Game.Display.scale, global.Game.Player.score);
	}

	// === HIGH SCORE ===
	// Always display the high score
	// global.Game.HighScores.display is synced to top score
	draw_text(272*global.Game.Display.scale, 26*global.Game.Display.scale, global.Game.HighScores.display);

	// === RESET DRAWING STATE ===
	// Restore default text alignment && opacity
	draw_set_halign(fa_left);
	draw_set_alpha(1);

	return;
}

/// @function Draw_Results
/// @description Renders the end-of-stage results screen
///
/// Displays player performance statistics at the end of each stage:
///   • Total shots fired
///   • Number of hits
///   • Hit-miss ratio as percentage
///
/// This screen appears briefly before the next stage begins, giving players
/// feedback on their accuracy. The hit-miss ratio is calculated as:
///   ratio = (hits / shots_fired) * 100
///
/// Visual Layout:
///   • Red "-RESULTS-" header
///   • Yellow labels for statistics
///   • White values && percentage
///
/// Special Cases:
///   • If no shots fired || no hits, displays "0.0%" instead of dividing by zero
///   • Percentage formatted to 1 decimal place (e.g., "85.7%")
///
/// @variable {number} fire - Total shots fired this stage (from oGameManager)
/// @variable {number} hits - Total successful hits this stage (from oGameManager)
///
/// @related Hud.gml:Draw_Hud - Calls this function during SHOW_RESULTS mode
/// @related oGameManager/Alarm_2.gml - Triggers results display after stage


function Draw_Results() {

	// === HEADER ===
	// Red "-RESULTS-" title centered on screen
	draw_set_color(c_red);
	draw_text(144*global.Game.Display.scale, 272*global.Game.Display.scale, "-RESULTS-");

	// === STATISTICS LABELS ===
	// Yellow text for "SHOTS FIRED" && "NUMBER OF HITS" labels
	draw_set_color(c_yellow);

	// === SHOTS FIRED ===
	// Display total shots player fired during this stage
	draw_text(64*global.Game.Display.scale, (272 + 48)*global.Game.Display.scale, "SHOTS FIRED");
	draw_text(320*global.Game.Display.scale, (272 + 48)*global.Game.Display.scale, global.Game.Player.shotsFired);

	// === NUMBER OF HITS ===
	// Display total successful hits (enemy collisions) during this stage
	draw_text(64*global.Game.Display.scale, (272 + 48 + 48)*global.Game.Display.scale, "NUMBER OF HITS");
	draw_text(320*global.Game.Display.scale, (272 + 48 + 48)*global.Game.Display.scale, global.Game.Player.hits);

	// === ACCURACY RATIO ===
	// White text for hit-miss ratio label && percentage
	draw_set_color(c_white);
	draw_text(64*global.Game.Display.scale, (272 + 48 + 48 + 48)*global.Game.Display.scale, "HIT-MISS RATIO");

	// === CALCULATE AND DISPLAY PERCENTAGE ===
	// Check for division by zero || zero hits
	if (global.Game.Player.shotsFired == 0 || global.Game.Player.hits == 0) {
		// No shots || no hits = 0.0%
		draw_text(290*global.Game.Display.scale, (272 + 48 + 48 + 48)*global.Game.Display.scale, "0.0");
	}
	else {
		// Calculate percentage: (hits / shots) * 100
		// string_format(value, width, decimal_places) formats to 1 decimal place
		// Example: 34 hits / 40 shots = 85.0%
		draw_text(290*global.Game.Display.scale, (272 + 48 + 48 + 48)*global.Game.Display.scale,
		string_format(100 * (global.Game.Player.hits / global.Game.Player.shotsFired), 4, 1));
	};

	draw_text(290*global.Game.Display.scale, (272 + 48 + 48 + 48)*global.Game.Display.scale, "      %");

	return;
}

function Draw_Enter_Initials() {
	
	draw_set_color(c_red)

	draw_text(64*global.Game.Display.scale, 96*global.Game.Display.scale, "ENTER YOUR INITIALS ");
	draw_sprite_ext(spr_exc, 0, 384*global.Game.Display.scale, 96*global.Game.Display.scale, 1, 1, 0, c_red, 1);

	draw_set_color(c_aqua)

	draw_set_halign(fa_right);
	draw_text(176*global.Game.Display.scale, 176*global.Game.Display.scale, global.Game.Player.score);
	draw_set_halign(fa_left);

	draw_set_color(c_red);
	draw_text(192*global.Game.Display.scale, 288*global.Game.Display.scale, "TOP 5");

	draw_set_color(c_aqua);
	draw_text(160*global.Game.Display.scale, (304 + 16)*global.Game.Display.scale, "SCORE     NAME");

    // === DISPLAY INITIALS ===
    // Calculate positions for 3 characters
    var base_x = 192 * global.Game.Display.scale;
    var base_y = 160 * global.Game.Display.scale;
    var char_spacing = 32 * global.Game.Display.scale;

	// Get the position being edited (scored = 1-5)
    var pos_idx = scored - 1;
    var current_initials = global.Game.HighScores.initials[pos_idx];
	var TITLE = ["1ST", "2ND", "3RD", "4TH", "5TH"];
	
	for (i = 0; i < 5; i++) {
		var player_initials = global.Game.HighScores.initials[i];
		var player_score = global.Game.HighScores.scores[i];
		
		// is this the NEW player score?
		if (scored == i) { draw_set_color(c_yellow); }
		
		draw_text(64*global.Game.Display.scale, (352 + 32*i)*global.Game.Display.scale, TITLE[i]);
		draw_set_halign(fa_right);
		draw_text(240*global.Game.Display.scale, (352+ 32*i)*global.Game.Display.scale, player_score);
		draw_set_halign(fa_left);
		draw_text(336*global.Game.Display.scale, (352+ 32*i)*global.Game.Display.scale, player_initials);	
		
		draw_set_color(c_aqua);
	
		if (scored == i) { 
			draw_text(304*global.Game.Display.scale, 176*global.Game.Display.scale, player_initials);
		}
	}

	if global.Game.State.results < 5 {
		draw_set_color(c_aqua);
		draw_text((304 + (16 * global.Game.HighScores.initials_idx))*global.Game.Display.scale, 176*global.Game.Display.scale,
		string_char_at(global.Game.Input.characterCycle, cyc));

		if (global.Game.Controllers.uiManager.blinkCounter) {
			draw_set_color(c_yellow);
			draw_text((304 + (16 * global.Game.HighScores.initials_idx))*global.Game.Display.scale, 176*global.Game.Display.scale,
			string_char_at(global.Game.Input.characterCycle, cyc));
		}
	}
	
	return;
}
	
function Draw_Instructions() {
		
	draw_set_color(c_aqua);

	draw_text(96*global.Game.Display.scale, 208*global.Game.Display.scale, "PUSH START BUTTON");

	draw_set_color(c_yellow);

	draw_text(64*global.Game.Display.scale, (208 + 64)*global.Game.Display.scale, "1ST BONUS FOR 20000 PTS");

	draw_text(64*global.Game.Display.scale, (208 + 64 + 48)*global.Game.Display.scale, "2ND BONUS FOR 70000 PTS");

	draw_text(64*global.Game.Display.scale, (208 + 64 + 48 + 48)*global.Game.Display.scale, "AND FOR EVERY 70000 PTS");

	// which ship to draw ... 
	draw_sprite_ext(xwing_sprite_sheet,2,32*global.Game.Display.scale, (8 + 208 + 64)*global.Game.Display.scale,0.8,0.8,0,c_white,1);
	draw_sprite_ext(xwing_sprite_sheet,2,32*global.Game.Display.scale, (8 + 208 + 48 + 64)*global.Game.Display.scale,0.8,0.8,0,c_white,1);
	draw_sprite_ext(xwing_sprite_sheet,2,32*global.Game.Display.scale, (8 + 208 + 48 + 48 + 64)*global.Game.Display.scale,0.8,0.8,0,c_white,1);

	
	draw_set_halign(fa_center);
	draw_set_color(c_white);

	draw_text(224*global.Game.Display.scale, (416 + 32)*global.Game.Display.scale, "© 1981 BANDAI");
	draw_text(224*global.Game.Display.scale, (448 + 32)*global.Game.Display.scale,
	"  NAMCO ENTERTAINMENT, INC. ");

	draw_set_color(c_red)
	draw_text(224*global.Game.Display.scale, (480 + 32)*global.Game.Display.scale,
	"2025 Richard Shannon");
	draw_set_halign(fa_left);
	
	return;
}
	
function Draw_Lives() {
	// draw lives
	var lifecount = global.Game.Player.lives - 1;
	repeat(lifecount)
	{
		draw_sprite_ext(xwing_sprite_sheet, 2, (20 + 34 * (lifecount - 1))*global.Game.Display.scale, 560*global.Game.Display.scale, 0.6, 0.6, 0, c_white, 1);

		lifecount = lifecount - 1
	};
	
	return;
}

function Draw_ShieldHealthBar() {
	/// @function Draw_ShieldHealthBar
	/// @description Draws the shield health bar at the bottom of the screen
	///              Shows shield capacity from 0 (empty) to 5 (full)
	///              Only displays when player exists and game is active
	
	// Only draw if player exists
	if (!instance_exists(oPlayer)) {
		return;
	}
	
	var bar_x = 128 * global.Game.Display.scale;
	var bar_y = 565 * global.Game.Display.scale;
	var bar_width = 400;
	var bar_height = 20;
	
	// Get shield value (0 to 5)
	var shield_value = oPlayer.shieldTimer;
	if (shield_value < 0) {
		shield_value = 0;
	}
	if (shield_value > 5) {
		shield_value = 5;
	}
	
	// Calculate fill percentage (0.0 to 1.0)
	var fill_percentage = shield_value / 5.0;
	var fill_width = bar_width * fill_percentage;
	
	// Draw background (empty bar) - dark red/black
	draw_set_color(c_black);
	draw_set_alpha(0.8);
	draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);
	draw_set_alpha(1.0);
	
	// Draw filled portion - green when full, yellow when medium, red when low
	if (fill_percentage > 0) {
		var bar_color = c_green;
		if (fill_percentage < 0.4) {
			bar_color = c_red;
		} else if (fill_percentage < 0.7) {
			bar_color = c_yellow;
		}
		
		draw_set_color(bar_color);
		draw_set_alpha(0.9);
		draw_rectangle(bar_x, bar_y, bar_x + fill_width, bar_y + bar_height, false);
		draw_set_alpha(1.0);
	}
	
	// Draw border
	draw_set_color(c_white);
	draw_set_alpha(1.0);
	draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, true);
	
	return;
}

function Draw_Credits() {
	draw_set_color(c_white);
	draw_text(16*global.Game.Display.scale, 550*global.Game.Display.scale, "CREDIT " + string(global.Game.Player.credits));
	
	return;
}

function Draw_ChallengeStage_Results() {		
	
	/// challenging stage end
	if global.Game.State.results > 1{ 
		draw_set_color(c_aqua); 
		draw_text(80*global.Game.Display.scale,288*global.Game.Display.scale,"NUMBER OF HITS");
	
		if global.Game.State.results > 2 { ///display shottotal
		    draw_text(340*global.Game.Display.scale,288*global.Game.Display.scale, global.Game.Player.shotTotal);
		    if global.Game.State.results > 3 { ///display "PERFECT!" || "BONUS"
		        if global.Game.Player.shotTotal = 40 {
		            draw_set_color(c_red); 
		            if global.Game.State.results > 4 || (alarm[2] > 84 || (alarm[2] < 68 && alarm[2] > 50) || (alarm[2] < 34 && alarm[2] > 16)) {
		                draw_text(160*global.Game.Display.scale,240*global.Game.Display.scale,"PERFECT"); draw_sprite_ext(spr_exc,0,304-16,240*global.Game.Display.scale,1,1,0,c_red,1);
		            }
		        }
		        else { draw_text(144*global.Game.Display.scale,336*global.Game.Display.scale,"BONUS"); }
		        if global.Game.State.results > 4 {///display "SPECIAL BONUS 10000 PTS" || custom multiplied number;
		            if global.Game.Player.shotTotal = 40 {
		                draw_set_color(c_yellow);
		                draw_text(32*global.Game.Display.scale,336*global.Game.Display.scale,"SPECIAL BONUS 10000 PTS");
		            }
		            else{draw_text(240*global.Game.Display.scale,336*global.Game.Display.scale, global.Game.Player.shotTotal*100);}
		        }
		    }
		}
	}
}

/// @function Draw_Debug_Overlay
/// @description Renders debug information overlay when debug mode is enabled
///
/// Displays comprehensive game state information including:
///   • Game mode and state flags
///   • Player stats (score, lives, shot mode)
///   • Enemy counts and dive capacity
///   • Level and wave progression
///   • Performance metrics (FPS)
///   • Formation state
///
/// Visual Details:
///   • Semi-transparent black background
///   • Green text for readability
///   • Positioned in top-right corner
///   • Multi-line display with organized sections
///
/// Toggle debug mode with F3 key (see oGameManager KeyPress_114)
///
/// @related oGameManager/Draw_0.gml - Calls this when global.debug is true
///
function Draw_Debug_Overlay() {
	// === SETUP DRAWING PROPERTIES ===
	var _x = 10;
	var _y = 80;
	var _line_height = 18;
	var _current_y = _y;

	// Draw semi-transparent background
	draw_set_alpha(0.7);
	draw_set_color(c_black);
	draw_rectangle(_x - 5, _y - 5, _x + 280, _y + 430, false);
	draw_set_alpha(1);

	// Set text properties
	draw_set_color(c_lime);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(fAtari6);

	// === HEADER ===
	draw_text(_x, _current_y, "=== DEBUG MODE (F3 to toggle) ===");
	_current_y += _line_height * 1.5;

	// === GAME STATE SECTION ===
	draw_text(_x, _current_y, "Game Mode: " + GetGameModeName(global.Game.State.mode));
	_current_y += _line_height;

	draw_text(_x, _current_y, "Paused: " + (global.Game.State.isPaused ? "YES" : "NO"));
	_current_y += _line_height;

	draw_text(_x, _current_y, "Game Over: " + (global.Game.State.isGameOver ? "YES" : "NO"));
	_current_y += _line_height;

	_current_y += _line_height * 0.5;

	// === PLAYER SECTION ===
	draw_text(_x, _current_y, "Player Score: " + string(global.Game.Player.score));
	_current_y += _line_height;

	draw_text(_x, _current_y, "Player Lives: " + string(global.Game.Player.lives));
	_current_y += _line_height;

	var shotMode = instance_exists(oPlayer) ? (oPlayer.shotMode == ShotMode.SINGLE ? "SINGLE" : "DUAL") : "N/A";
	draw_text(_x, _current_y, "Shot Mode: " + shotMode);
	_current_y += _line_height;

	var shipState = instance_exists(oPlayer) ? GetShipStateName(oPlayer.shipStatus) : "N/A";
	draw_text(_x, _current_y, "Ship State: " + shipState);
	_current_y += _line_height;

	_current_y += _line_height * 0.5;

	// === ENEMY SECTION ===
	draw_text(_x, _current_y, "Enemy Count: " + string(global.Game.Enemy.count));
	_current_y += _line_height;

	draw_text(_x, _current_y, "Dive Capacity: " + string(global.Game.Enemy.diveCapacity) + " / " + string(global.Game.Enemy.diveCapacityStart));
	_current_y += _line_height;

	draw_text(_x, _current_y, "Captured: " + (global.Game.Enemy.capturedPlayer ? "YES" : "NO"));
	_current_y += _line_height;

	_current_y += _line_height * 0.5;

	// === LEVEL SECTION ===
	draw_text(_x, _current_y, "Level: " + string(global.Game.Level.current) + " Wave: " + string(global.Game.Level.wave));
	_current_y += _line_height;

	draw_text(_x, _current_y, "Challenge Stage: " + (global.Game.Challenge.isActive ? "YES" : "NO"));
	_current_y += _line_height;

	draw_text(_x, _current_y, "Challenge Count: " + string(global.Game.Challenge.countdown) + " / " + string(global.Game.Challenge.intervalsToNext));
	_current_y += _line_height;

	_current_y += _line_height * 0.5;

	// === PERFORMANCE SECTION ===
	draw_text(_x, _current_y, "FPS: " + string(fps) + " / " + string(fps_real));
	_current_y += _line_height;

	draw_text(_x, _current_y, "Instances: " + string(instance_count));
	_current_y += _line_height;

	_current_y += _line_height * 0.5;

	// === ASSET CACHE STATS ===
	if (global.asset_cache != undefined) {
		var hit_rate = get_asset_cache_hit_rate();
		draw_text(_x, _current_y, "Asset Cache: " + string(round(hit_rate)) + "% hits");
		_current_y += _line_height;

		draw_text(_x, _current_y, "Cached Assets: " + string(global.asset_cache_stats.unique_assets));
		_current_y += _line_height;
	}

	_current_y += _line_height * 0.5;

	// === OBJECT POOL STATS ===
	if (global.shot_pool != undefined) {
		var shot_stats = global.shot_pool.getStats();
		draw_text(_x, _current_y, "Shot Pool: " + string(shot_stats.current_active) + "/" + string(shot_stats.current_pooled));
		_current_y += _line_height;
	}

	if (global.missile_pool != undefined) {
		var missile_stats = global.missile_pool.getStats();
		draw_text(_x, _current_y, "Missile Pool: " + string(missile_stats.current_active) + "/" + string(missile_stats.current_pooled));
		_current_y += _line_height;
	}

	// Reset draw properties
	draw_set_color(c_white);
	draw_set_alpha(1);
}

/// @function GetGameModeName
/// @description Returns a human-readable name for a GameMode enum value
/// @param {Real} _mode The GameMode enum value
/// @return {String} The mode name
function GetGameModeName(_mode) {
	switch(_mode) {
		case GameMode.INITIALIZE: return "INITIALIZE";
		case GameMode.ATTRACT_MODE: return "ATTRACT_MODE";
		case GameMode.INSTRUCTIONS: return "INSTRUCTIONS";
		case GameMode.GAME_PLAYER_MESSAGE: return "PLAYER_MESSAGE";
		case GameMode.GAME_STAGE_MESSAGE: return "STAGE_MESSAGE";
		case GameMode.SPAWN_ENEMY_WAVES: return "SPAWN_WAVES";
		case GameMode.GAME_READY: return "READY";
		case GameMode.GAME_ACTIVE: return "ACTIVE";
		case GameMode.SHOW_RESULTS: return "RESULTS";
		case GameMode.ENTER_INITIALS: return "ENTER_INITIALS";
		case GameMode.CHALLENGE_STAGE_MESSAGE: return "CHALLENGE_MESSAGE";
		case GameMode.GAME_PAUSED: return "PAUSED";
		default: return "UNKNOWN";
	}
}

/// @function GetShipStateName
/// @description Returns a human-readable name for a ShipState enum value
/// @param {Real} _state The ShipState enum value
/// @return {String} The state name
function GetShipStateName(_state) {
	switch(_state) {
		case ShipState.ACTIVE: return "ACTIVE";
		case ShipState.CAPTURED: return "CAPTURED";
		case ShipState.RELEASING: return "RELEASING";
		case ShipState.DEAD: return "DEAD";
		case ShipState.RESPAWN: return "RESPAWN";
		default: return "UNKNOWN";
	}
}