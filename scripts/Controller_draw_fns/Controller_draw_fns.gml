function Draw_Scores() {
	
	draw_set_halign(fa_right);

	draw_set_color(c_red);
	draw_set_alpha(0.6);
	
	if (oGameManager.blink) { draw_text(80*global.scale, 10*global.scale, string_hash_to_newline("1UP")) };
	draw_text(304*global.scale, 10*global.scale, string_hash_to_newline("HIGH SCORE"));

	draw_set_color(c_white);
	// DRAW PLAYER1 SCORE (if we're passed the ATTRACT, and INSTRUCTIONS stage)
	if (global.gameMode >= GameMode.GAME_PLAYER_MESSAGE) {	
		draw_text(96*global.scale, 26*global.scale, string_hash_to_newline(global.p1score));
	}
	// DRAW HIGH SCORE
	draw_text(272*global.scale, 26*global.scale, string_hash_to_newline(global.disp))

	draw_set_halign(fa_left);
	draw_set_alpha(1);
	
	return;
}

function Draw_Results() {

	draw_set_color(c_red);

	draw_text(144*global.scale, 272*global.scale, string_hash_to_newline("-RESULTS-"));

	draw_set_color(c_yellow);

	draw_text(64*global.scale, (272 + 48)*global.scale, string_hash_to_newline("SHOTS FIRED"));
	draw_text(320*global.scale, (272 + 48)*global.scale, string_hash_to_newline(fire))

	draw_text(64*global.scale, (272 + 48 + 48)*global.scale, string_hash_to_newline("NUMBER OF HITS"));
	draw_text(320*global.scale, (272 + 48 + 48)*global.scale, string_hash_to_newline(hits))

	draw_set_color(c_white);

	draw_text(64*global.scale, (272 + 48 + 48 + 48)*global.scale, string_hash_to_newline("HIT-MISS RATIO"));

	if (fire = 0 or hits = 0) {
		draw_text(290*global.scale, (272 + 48 + 48 + 48)*global.scale, string_hash_to_newline("0.0"))
	} 
	else {

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
	if results > 1{ 
		draw_set_color(c_aqua); 
		draw_text(80*global.scale,288*global.scale,"NUMBER OF HITS");
	
		if results > 2 { ///display shottotal
		    draw_text(340*global.scale,288*global.scale, global.shottotal);
		    if results > 3 { ///display "PERFECT!" or "BONUS"
		        if global.shottotal = 40 {
		            draw_set_color(c_red); 
		            if results > 4 or (alarm[2] > 84 or (alarm[2] < 68 and alarm[2] > 50) or (alarm[2] < 34 and alarm[2] > 16)) {
		                draw_text(160*global.scale,240*global.scale,"PERFECT"); draw_sprite_ext(spr_exc,0,304-16,240*global.scale,1,1,0,c_red,1);
		            }
		        }
		        else { draw_text(144*global.scale,336*global.scale,"BONUS"); }
		        if results > 4 {///display "SPECIAL BONUS 10000 PTS" or custom multiplied number;
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