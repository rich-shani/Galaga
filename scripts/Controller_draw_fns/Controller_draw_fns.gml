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
	// Red text with slight transparency for "1UP" and "HIGH SCORE" labels
	draw_set_color(c_red);
	draw_set_alpha(0.6);

	// === "1UP" INDICATOR ===
	// Blinks on/off to draw attention during active gameplay
	// Blink state controlled by oGameManager alarm[8] (14 frame interval)
	if (oGameManager.blink) { draw_text(80*global.scale, 10*global.scale, string_hash_to_newline("1UP")) };

	// === "HIGH SCORE" LABEL ===
	// Always visible (no blinking)
	draw_text(304*global.scale, 10*global.scale, string_hash_to_newline("HIGH SCORE"));

	// === SCORE VALUES ===
	// White text for actual score numbers
	draw_set_color(c_white);

	// === PLAYER SCORE ===
	// Only show player score once gameplay has started
	// Hidden during attract mode and instructions
	if (global.gameMode >= GameMode.GAME_PLAYER_MESSAGE) {
		draw_text(96*global.scale, 26*global.scale, string_hash_to_newline(global.p1score));
	}

	// === HIGH SCORE ===
	// Always display the high score
	// global.disp is updated from global.galaga1 (top score)
	draw_text(272*global.scale, 26*global.scale, string_hash_to_newline(global.disp))

	// === RESET DRAWING STATE ===
	// Restore default text alignment and opacity
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
///   • White values and percentage
///
/// Special Cases:
///   • If no shots fired or no hits, displays "0.0%" instead of dividing by zero
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
	draw_text(144*global.scale, 272*global.scale, string_hash_to_newline("-RESULTS-"));

	// === STATISTICS LABELS ===
	// Yellow text for "SHOTS FIRED" and "NUMBER OF HITS" labels
	draw_set_color(c_yellow);

	// === SHOTS FIRED ===
	// Display total shots player fired during this stage
	draw_text(64*global.scale, (272 + 48)*global.scale, string_hash_to_newline("SHOTS FIRED"));
	draw_text(320*global.scale, (272 + 48)*global.scale, string_hash_to_newline(fire))

	// === NUMBER OF HITS ===
	// Display total successful hits (enemy collisions) during this stage
	draw_text(64*global.scale, (272 + 48 + 48)*global.scale, string_hash_to_newline("NUMBER OF HITS"));
	draw_text(320*global.scale, (272 + 48 + 48)*global.scale, string_hash_to_newline(hits))

	// === ACCURACY RATIO ===
	// White text for hit-miss ratio label and percentage
	draw_set_color(c_white);
	draw_text(64*global.scale, (272 + 48 + 48 + 48)*global.scale, string_hash_to_newline("HIT-MISS RATIO"));

	// === CALCULATE AND DISPLAY PERCENTAGE ===
	// Check for division by zero or zero hits
	if (fire = 0 or hits = 0) {
		// No shots or no hits = 0.0%
		draw_text(290*global.scale, (272 + 48 + 48 + 48)*global.scale, string_hash_to_newline("0.0"))
	}
	else {
		// Calculate percentage: (hits / shots) * 100
		// string_format(value, width, decimal_places) formats to 1 decimal place
		// Example: 34 hits / 40 shots = 85.0%
		draw_text(290*global.scale, (272 + 48 + 48 + 48)*global.scale,
		string_hash_to_newline(string_format(100 * (hits / fire), 4, 1)))
	};

	draw_text(290*global.scale, (272 + 48 + 48 + 48)*global.scale, string_hash_to_newline("      %"));

	return;
}

function Draw_Enter_Initials() {
	
	draw_set_color(c_red)

	draw_text(64*global.scale, 96*global.scale, string_hash_to_newline("ENTER YOUR INITIALS "));
	draw_sprite_ext(spr_exc, 0, 384*global.scale, 96*global.scale, 1, 1, 0, c_red, 1);

	draw_set_color(c_aqua)

	draw_text(96*global.scale, 144*global.scale, string_hash_to_newline("SCORE       NAME"));

	draw_set_halign(fa_right);
	draw_text(176*global.scale, 176*global.scale, string_hash_to_newline(global.p1score));
	draw_set_halign(fa_left);

	draw_set_color(c_red);
	draw_text(192*global.scale, 288*global.scale, string_hash_to_newline("TOP 5"));

	draw_set_color(c_aqua);
	draw_text(160*global.scale, (304 + 16)*global.scale, string_hash_to_newline("SCORE     NAME"));

	if scored = 1 { draw_set_color(c_yellow) }
	
	draw_text(64*global.scale, (304 + 32 + 16)*global.scale, string_hash_to_newline("1ST"));
	draw_set_halign(fa_right);
	draw_text(240*global.scale, (304 + 32 + 16)*global.scale, string_hash_to_newline(global.galaga1));
	draw_set_halign(fa_left);
	draw_text(336*global.scale, (304 + 32 + 16)*global.scale, string_hash_to_newline(global.init1));
	draw_set_color(c_aqua);
	
	if scored = 1 { draw_text(304*global.scale, 176*global.scale, string_hash_to_newline(global.init1)) }

	if scored = 2 { draw_set_color(c_yellow) }
	
	draw_text(64*global.scale, (304 + 32 + 32 + 16)*global.scale, string_hash_to_newline("2ND"));
	draw_set_halign(fa_right);
	draw_text(
	240*global.scale, (304 + 32 + 32 + 16)*global.scale, string_hash_to_newline(global.galaga2));
	draw_set_halign(fa_left);
	draw_text(
	336*global.scale, (304 + 32 + 32 + 16)*global.scale, string_hash_to_newline(global.init2));
	draw_set_color(c_aqua);
	if scored = 2 { draw_text(304*global.scale, 176*global.scale, string_hash_to_newline(global.init2)) }

	if scored = 3 { draw_set_color(c_yellow) }
	draw_text(64*global.scale, (304 + 32 + 32 + 32 + 16)*global.scale, string_hash_to_newline("3RD"));
	draw_set_halign(fa_right);
	draw_text(240*global.scale, (304 + 32 + 32 + 32 + 16)*global.scale,
	string_hash_to_newline(global.galaga3));
	draw_set_halign(fa_left);
	draw_text(
	336*global.scale, (304 + 32 + 32 + 32 + 16)*global.scale, string_hash_to_newline(global.init3));
	draw_set_color(c_aqua);
	if scored = 3 { draw_text(304*global.scale, 176*global.scale, string_hash_to_newline(global.init3)) }

	if scored = 4 { draw_set_color(c_yellow) }
	draw_text(64*global.scale, (304 + 32 + 32 + 32 + 32 + 16)*global.scale, string_hash_to_newline("4TH"));
	draw_set_halign(fa_right);
	draw_text(240*global.scale, (304 + 32 + 32 + 32 + 32 + 16)*global.scale,
	string_hash_to_newline(global.galaga4));
	draw_set_halign(fa_left);
	draw_text(336*global.scale, (304 + 32 + 32 + 32 + 32 + 16)*global.scale,
	string_hash_to_newline(global.init4));
	draw_set_color(c_aqua);
	if scored = 4 { draw_text(304*global.scale, 176*global.scale, string_hash_to_newline(global.init4)) }

	if scored = 5 { draw_set_color(c_yellow) }
	draw_text(64*global.scale, (304 + 32 + 32 + 32 + 32 + 32 + 16)*global.scale,
	string_hash_to_newline("5TH"));
	draw_set_halign(fa_right);
	draw_text(240*global.scale, (304 + 32 + 32 + 32 + 32 + 32 + 16)*global.scale,
	string_hash_to_newline(global.galaga5));
	draw_set_halign(fa_left);
	draw_text(336*global.scale, (304 + 32 + 32 + 32 + 32 + 32 + 16)*global.scale,
	string_hash_to_newline(global.init5));
	draw_set_color(c_aqua);
	if scored = 5 { draw_text(304*global.scale, 176*global.scale, string_hash_to_newline(global.init5)) }

	if global.results < 5 {
		draw_set_color(c_aqua);
		draw_text((304 + (16 * char))*global.scale, 176*global.scale,
		string_hash_to_newline(string_char_at(cycle, cyc)));

		if oGameManager.blink {
			draw_set_color(c_yellow);
			draw_text((304 + (16 * char))*global.scale, 176*global.scale,
			string_hash_to_newline(string_char_at(cycle, cyc)))
		}
	}
	
	return;
}
	
function Draw_Instructions() {
		
	draw_set_color(c_aqua);

	draw_text(96*global.scale, 208*global.scale, string_hash_to_newline("PUSH START BUTTON"));

	draw_set_color(c_yellow);

	draw_text(64*global.scale, (208 + 64)*global.scale, string_hash_to_newline("1ST BONUS FOR 20000 PTS"));

	draw_text(64*global.scale, (208 + 64 + 48)*global.scale, string_hash_to_newline("2ND BONUS FOR 70000 PTS"));

	draw_text(64*global.scale, (208 + 64 + 48 + 48)*global.scale, string_hash_to_newline("AND FOR EVERY 70000 PTS"));

	// which ship to draw ... 
	if (global.roomname == "GalagaWars") {
		draw_sprite_ext(xwing_sprite_sheet,2,32*global.scale, (8 + 208 + 64)*global.scale,0.8,0.8,0,c_white,1);
		draw_sprite_ext(xwing_sprite_sheet,2,32*global.scale, (8 + 208 + 48 + 64)*global.scale,0.8,0.8,0,c_white,1);
		draw_sprite_ext(xwing_sprite_sheet,2,32*global.scale, (8 + 208 + 48 + 48 + 64)*global.scale,0.8,0.8,0,c_white,1);
	}
	else {
		draw_sprite(spr_ship, 0, 32*global.scale, (8 + 208 + 64)*global.scale);
		draw_sprite(spr_ship, 0, 32*global.scale, (8 + 208 + 48 + 64)*global.scale);
		draw_sprite(spr_ship, 0, 32*global.scale, (8 + 208 + 48 + 48 + 64)*global.scale);
	}
	
	draw_set_halign(fa_center);
	draw_set_color(c_white);

	draw_text(224*global.scale, (416 + 32)*global.scale, string_hash_to_newline("© 1981-2024 BANDAI"));
	draw_text(224*global.scale, (448 + 32)*global.scale,
	string_hash_to_newline("  NAMCO ENTERTAINMENT, INC. "));

	draw_set_color(c_red)
	draw_text(224*global.scale, (480 + 32)*global.scale,
	string_hash_to_newline("2025 Richard Shannon"));
	draw_set_halign(fa_left);
	
	return;
}
	
function Draw_Lives() {
	// draw lives
	lifecount = global.p1lives - 1;
	repeat(lifecount)
	{
		if (global.roomname = "GalagaWars") {
			draw_sprite_ext(sXWing, 0, (20 + 34 * (lifecount - 1))*global.scale, 560*global.scale, 0.6, 0.6, 0, c_white, 1);
		}
		else {
			draw_sprite(spr_ship, 0, 16 + (32 * (lifecount - 1))*global.scale, 560*global.scale);
		}

		lifecount = lifecount - 1
	};
	
	return;
}

function Draw_Credits() {
	draw_set_color(c_white);
	draw_text(16*global.scale, 550*global.scale, "CREDIT " + string(global.credits));
	
	return;
}

function Draw_ChallengeStage_Results() {		
	
	/// challenging stage end
	if global.results > 1{ 
		draw_set_color(c_aqua); 
		draw_text(80*global.scale,288*global.scale,"NUMBER OF HITS");
	
		if global.results > 2 { ///display shottotal
		    draw_text(340*global.scale,288*global.scale, global.shottotal);
		    if global.results > 3 { ///display "PERFECT!" or "BONUS"
		        if global.shottotal = 40 {
		            draw_set_color(c_red); 
		            if global.results > 4 or (alarm[2] > 84 or (alarm[2] < 68 and alarm[2] > 50) or (alarm[2] < 34 and alarm[2] > 16)) {
		                draw_text(160*global.scale,240*global.scale,"PERFECT"); draw_sprite_ext(spr_exc,0,304-16,240*global.scale,1,1,0,c_red,1);
		            }
		        }
		        else { draw_text(144*global.scale,336*global.scale,"BONUS"); }
		        if global.results > 4 {///display "SPECIAL BONUS 10000 PTS" or custom multiplied number;
		            if global.shottotal = 40 {
		                draw_set_color(c_yellow);
		                draw_text(32*global.scale,336*global.scale,"SPECIAL BONUS 10000 PTS");
		            }
		            else{draw_text(240*global.scale,336*global.scale, global.shottotal*100);}
		        }
		    }
		}
	}
}