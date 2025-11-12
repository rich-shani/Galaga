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
	if (oGameManager.blink) { draw_text(80*global.Game.Display.scale, 10*global.Game.Display.scale, string_hash_to_newline("1UP")) };

	// === "HIGH SCORE" LABEL ===
	// Always visible (no blinking)
	draw_text(304*global.Game.Display.scale, 10*global.Game.Display.scale, string_hash_to_newline("HIGH SCORE"));

	// === SCORE VALUES ===
	// White text for actual score numbers
	draw_set_color(c_white);

	// === PLAYER SCORE ===
	// Only show player score once gameplay has started
	// Hidden during attract mode && instructions
	if (global.Game.State.mode >= GameMode.GAME_PLAYER_MESSAGE) {
		draw_text(96*global.Game.Display.scale, 26*global.Game.Display.scale, string_hash_to_newline(global.Game.Player.score));
	}

	// === HIGH SCORE ===
	// Always display the high score
	// global.Game.HighScores.display is synced to top score
	draw_text(272*global.Game.Display.scale, 26*global.Game.Display.scale, string_hash_to_newline(global.Game.HighScores.display));

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
	draw_text(144*global.Game.Display.scale, 272*global.Game.Display.scale, string_hash_to_newline("-RESULTS-"));

	// === STATISTICS LABELS ===
	// Yellow text for "SHOTS FIRED" && "NUMBER OF HITS" labels
	draw_set_color(c_yellow);

	// === SHOTS FIRED ===
	// Display total shots player fired during this stage
	draw_text(64*global.Game.Display.scale, (272 + 48)*global.Game.Display.scale, string_hash_to_newline("SHOTS FIRED"));
	draw_text(320*global.Game.Display.scale, (272 + 48)*global.Game.Display.scale, string_hash_to_newline(fire))

	// === NUMBER OF HITS ===
	// Display total successful hits (enemy collisions) during this stage
	draw_text(64*global.Game.Display.scale, (272 + 48 + 48)*global.Game.Display.scale, string_hash_to_newline("NUMBER OF HITS"));
	draw_text(320*global.Game.Display.scale, (272 + 48 + 48)*global.Game.Display.scale, string_hash_to_newline(hits))

	// === ACCURACY RATIO ===
	// White text for hit-miss ratio label && percentage
	draw_set_color(c_white);
	draw_text(64*global.Game.Display.scale, (272 + 48 + 48 + 48)*global.Game.Display.scale, string_hash_to_newline("HIT-MISS RATIO"));

	// === CALCULATE AND DISPLAY PERCENTAGE ===
	// Check for division by zero || zero hits
	if (fire == 0 || hits == 0) {
		// No shots || no hits = 0.0%
		draw_text(290*global.Game.Display.scale, (272 + 48 + 48 + 48)*global.Game.Display.scale, string_hash_to_newline("0.0"))
	}
	else {
		// Calculate percentage: (hits / shots) * 100
		// string_format(value, width, decimal_places) formats to 1 decimal place
		// Example: 34 hits / 40 shots = 85.0%
		draw_text(290*global.Game.Display.scale, (272 + 48 + 48 + 48)*global.Game.Display.scale,
		string_hash_to_newline(string_format(100 * (hits / fire), 4, 1)))
	};

	draw_text(290*global.Game.Display.scale, (272 + 48 + 48 + 48)*global.Game.Display.scale, string_hash_to_newline("      %"));

	return;
}

function Draw_Enter_Initials() {
	
	draw_set_color(c_red)

	draw_text(64*global.Game.Display.scale, 96*global.Game.Display.scale, string_hash_to_newline("ENTER YOUR INITIALS "));
	draw_sprite_ext(spr_exc, 0, 384*global.Game.Display.scale, 96*global.Game.Display.scale, 1, 1, 0, c_red, 1);

	draw_set_color(c_aqua)

	draw_set_halign(fa_right);
	draw_text(176*global.Game.Display.scale, 176*global.Game.Display.scale, string_hash_to_newline(global.Game.Player.score));
	draw_set_halign(fa_left);

	draw_set_color(c_red);
	draw_text(192*global.Game.Display.scale, 288*global.Game.Display.scale, string_hash_to_newline("TOP 5"));

	draw_set_color(c_aqua);
	draw_text(160*global.Game.Display.scale, (304 + 16)*global.Game.Display.scale, string_hash_to_newline("SCORE     NAME"));

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
		string_hash_to_newline(string_char_at(cycle, cyc)));

		if oGameManager.blink {
			draw_set_color(c_yellow);
			draw_text((304 + (16 * global.Game.HighScores.initials_idx))*global.Game.Display.scale, 176*global.Game.Display.scale,
			string_hash_to_newline(string_char_at(cycle, cyc)))
		}
	}
	
	return;
}
	
function Draw_Instructions() {
		
	draw_set_color(c_aqua);

	draw_text(96*global.Game.Display.scale, 208*global.Game.Display.scale, string_hash_to_newline("PUSH START BUTTON"));

	draw_set_color(c_yellow);

	draw_text(64*global.Game.Display.scale, (208 + 64)*global.Game.Display.scale, string_hash_to_newline("1ST BONUS FOR 20000 PTS"));

	draw_text(64*global.Game.Display.scale, (208 + 64 + 48)*global.Game.Display.scale, string_hash_to_newline("2ND BONUS FOR 70000 PTS"));

	draw_text(64*global.Game.Display.scale, (208 + 64 + 48 + 48)*global.Game.Display.scale, string_hash_to_newline("AND FOR EVERY 70000 PTS"));

	// which ship to draw ... 
	draw_sprite_ext(xwing_sprite_sheet,2,32*global.Game.Display.scale, (8 + 208 + 64)*global.Game.Display.scale,0.8,0.8,0,c_white,1);
	draw_sprite_ext(xwing_sprite_sheet,2,32*global.Game.Display.scale, (8 + 208 + 48 + 64)*global.Game.Display.scale,0.8,0.8,0,c_white,1);
	draw_sprite_ext(xwing_sprite_sheet,2,32*global.Game.Display.scale, (8 + 208 + 48 + 48 + 64)*global.Game.Display.scale,0.8,0.8,0,c_white,1);

	
	draw_set_halign(fa_center);
	draw_set_color(c_white);

	draw_text(224*global.Game.Display.scale, (416 + 32)*global.Game.Display.scale, string_hash_to_newline("© 1981-2024 BANDAI"));
	draw_text(224*global.Game.Display.scale, (448 + 32)*global.Game.Display.scale,
	string_hash_to_newline("  NAMCO ENTERTAINMENT, INC. "));

	draw_set_color(c_red)
	draw_text(224*global.Game.Display.scale, (480 + 32)*global.Game.Display.scale,
	string_hash_to_newline("2025 Richard Shannon"));
	draw_set_halign(fa_left);
	
	return;
}
	
function Draw_Lives() {
	// draw lives
	lifecount = global.Game.Player.lives - 1;
	repeat(lifecount)
	{
		draw_sprite_ext(sXWing, 0, (20 + 34 * (lifecount - 1))*global.Game.Display.scale, 560*global.Game.Display.scale, 0.6, 0.6, 0, c_white, 1);

		lifecount = lifecount - 1
	};
	
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