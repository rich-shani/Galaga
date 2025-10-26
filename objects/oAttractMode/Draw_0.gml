if (global.gameMode == GameMode.ATTRACT_MODE) {
	
	// sequence 0 to 20 is for the attract mode animation
	// sequence 21 to 30 is for the high score table
	
	if (sequence < 21) { // DRAW Attract Mode Sequence

		// GALAGA, SCORE, INTRO
		if sequence > 0 {
			draw_set_color(c_aqua);
			if (global.roomname == "GalagaWars") {
		//		draw_text(130*global.scale, 80*global.scale, string_hash_to_newline("GALAGA WARS"));
				draw_sprite_ext(galagawars_logo, -1, 224*global.scale, 5*global.scale,0.55,0.55,0,c_white,1);
			}
			else {
				draw_text(170*global.scale, 80*global.scale, string_hash_to_newline("GALAGA"));					
			}
			
			if sequence > 1 {
				draw_text((176 - 48)*global.scale, 128*global.scale, string_hash_to_newline("-- SCORE --"));
				draw_text((176 - 40)*global.scale, 128*global.scale, string_hash_to_newline("-        -"));

				if sequence > 2 {
					draw_text((176 - 48)*global.scale, 176*global.scale, string_hash_to_newline("    50    100"));
					if (global.roomname == "GalagaWars") {
							
						draw_sprite_ext(sTieFighter, global.animationIndex/4, 104*global.scale, (168+16)*global.scale, 1, 1, 0, c_white, 1);
					}
					else {
						draw_sprite(spr_ship, 10 + floor(global.flip / 30), 128*global.scale, (168 + 16)*global.scale);
					}
						
					if sequence > 3 {
						draw_text((176 - 48)*global.scale, 224*global.scale,
						string_hash_to_newline("    80    160"));
										
						if (global.roomname == "GalagaWars") {
							draw_sprite_ext(sImperialShuttle, global.animationIndex/4, 104*global.scale, (168+48+16)*global.scale, 1, 1, 0, c_white, 1);
						}
						else {
							draw_sprite(spr_ship, 6 + floor(global.flip / 30), 128*global.scale, (168 + 48 + 16)*global.scale);
						}
						
						if sequence > 4 {											
							if (global.roomname == "GalagaWars") {
								draw_sprite_ext(sTieIntercepter, 18, 224*global.scale, (168 + 48 + 48 + 24)*global.scale, 1, 1, 0, c_white, 1);
							}
							else {
								// draw Boss image
								draw_sprite(spr_ship, 2 + floor(global.flip / 30), 224*global.scale, (168 + 48 + 48 + 24)*global.scale);
							}
											
						} // sequence > 4
					} // sequence > 3
				} // sequence > 2
			} // sequence > 1
		} // sequence > 0

		// animation sequence for the attract page ... ie dive, shoot and points
		if (sequence > 5 && sequence < 21) {

			// Draw initial enemy postiion for block #1
			if (sequence < 8) {
				
				// BOSS
				if (global.roomname == "GalagaWars") {
					// INTERCEPTER
					draw_sprite_ext(sTieIntercepter, 18, 364*global.scale, 336*global.scale, 1, 1, 0, c_white, 1);
					
					// IMPERIAL SHUTTLE 1
					draw_sprite_ext(sImperialShuttle, 18, (364 + 24)*global.scale, 368*global.scale, 1, 1, 0, c_white, 1);
					// IMPERIAL SHUTTLE 2
					draw_sprite_ext(sImperialShuttle, 18, (364 - 24)*global.scale, 368*global.scale, 1, 1, 0, c_white, 1);
				}
				else {
					// draw Boss image
					draw_sprite_ext(spr_ship, 2 + floor(global.flip / 30), 364*global.scale, 336*global.scale, 1, 1, 0, c_white, 1);
					
					// BUTTERFLY 1
					draw_sprite_ext(spr_ship, 6 + floor(global.flip / 30),
						(364 + 32)*global.scale, 368*global.scale, 1, 1, 0, c_white, 1);
					// BUTTERFLY 2
					draw_sprite_ext(spr_ship, 6 + floor(global.flip / 30),
						(364 - 32)*global.scale, 368*global.scale, 1, 1, 0, c_white, 1);
				}
			}

			// Animate enemy block #1
			if (sequence = 8) {
				// BOSS
				if (global.roomname == "GalagaWars") {
					var i = round(direction/15);
					
					var color = (hitFlag ? c_maroon : c_white);
					draw_sprite_ext(sTieIntercepter, i, 364*global.scale+x, 336*global.scale+y, 1, 1, 0, color, 1);
					
					// IMPERIAL SHUTTLE 1
					draw_sprite_ext(sImperialShuttle, i, (364 + 24)*global.scale+x, 368*global.scale+y, 1, 1, 0, c_white, 1);
					// IMPERIAL SHUTTLE 2
					draw_sprite_ext(sImperialShuttle, i, (364 - 24)*global.scale+x, 368*global.scale+y, 1, 1, 0, c_white, 1);
				}
				else {
					// BOSS
					draw_sprite_ext(spr_ship, 3 + (hitFlag * 2), (364*global.scale + x),
									(336*global.scale + y), 1, 1, direction - 90, c_white, 1);
									
					// BUTTERFLY 1
					draw_sprite_ext(spr_ship, 7, (364 + 32)*global.scale + x,
										(368)*global.scale + y, 1, 1, direction - 90, c_white, 1);
					// BUTTERFLY 2
					draw_sprite_ext(spr_ship, 7, (364 - 32)*global.scale + x,
										(368)*global.scale + y, 1, 1, direction - 90, c_white, 1);
				}
			}

			// Draw initial enemy postiion for block #2
			if sequence < 11 {
				// BOSS
				if (global.roomname == "GalagaWars") {
					
					draw_sprite_ext(sTieIntercepter, 18, 268*global.scale, 336*global.scale, 1, 1, 0, c_white, 1);
					
					// IMPERIAL SHUTTLE 1
					draw_sprite_ext(sImperialShuttle, 18, (268 + 24)*global.scale, 368*global.scale, 1, 1, 0, c_white, 1);
				}
				else {
					// BOSS
					draw_sprite_ext(spr_ship, 2 + floor(global.flip / 30), 268*global.scale, 336*global.scale, 1, 1, 0, c_white, 1);
					
					// BUTTERFLY 1
					draw_sprite_ext(spr_ship, 6 + floor(global.flip / 30),
						(268 + 32)*global.scale, 368*global.scale, 1, 1, 0, c_white, 1);
				}
				
			}

			// Animate enemy block #2
			if sequence == 11 {

					
				if (global.roomname == "GalagaWars") {
					var i = round(direction/15);
				
					var color = (hitFlag ? c_maroon : c_white);
					draw_sprite_ext(sTieIntercepter, i, 268*global.scale+x, 336*global.scale+y, 1, 1, 0, color, 1);
					
					// IMPERIAL SHUTTLE 1
					draw_sprite_ext(sImperialShuttle, i, (268 + 24)*global.scale+x, 368*global.scale+y, 1, 1, 0, c_white, 1);
				}
				else {
					// BOSS
					draw_sprite_ext(spr_ship, 3 + (hitFlag * 2), (268*global.scale + x),
											(336*global.scale + y), 1, 1, direction - 90, c_white, 1);
					// BUTTERFLY 1
					draw_sprite_ext(spr_ship, 7, (268 + 32)*global.scale + x,
											(368*global.scale + y), 1, 1, direction - 90, c_white, 1);
				}
			}
			
			// Draw initial enemy postiion for block #3
			if sequence < 14 {
				if (global.roomname == "GalagaWars") {
					// BOSS
					draw_sprite_ext(sTieIntercepter, 18, 172*global.scale, 336*global.scale, 1, 1, 0, c_white, 1);
				}
				else {
					draw_sprite_ext(spr_ship, 2 + floor(global.flip / 30), 172*global.scale,
										336*global.scale, 1, 1, 0, c_white, 1);
				}
			}

			// Animate enemy block #3
			if sequence == 14 {
				if (global.roomname == "GalagaWars") {
					var i = round(direction/15);
					
					var color = (hitFlag ? c_maroon : c_white);
					draw_sprite_ext(sTieIntercepter, i, 172*global.scale+x, 336*global.scale+y, 1, 1, 0, color, 1);
				}
				else {
					// BOSS
					draw_sprite_ext(spr_ship, 3 + (hitFlag * 2), (172*global.scale + x),
										(336*global.scale + y), 1, 1, direction - 90, c_white, 1);
				}
			}

			// DRAW ship & final BOSS
			if sequence < 17 {
				if (global.roomname == "GalagaWars") {
					// note - ignore the hit flag until we get to sequence 16
					var color = (floor(sequence / 16) * hitFlag ? c_maroon : c_white);
					draw_sprite_ext(sTieIntercepter, 18, 76*global.scale, 336*global.scale, 1, 1, 0, color, 1);
				}
				else {
					// BOSS
					draw_sprite_ext(spr_ship, 2 + floor(global.flip / 30) +
										(floor(sequence / 16) * hitFlag * 2),
											76*global.scale, 336*global.scale, 1, 1, 0, c_white, 1);
				}
				
				// SHIP
				if (global.roomname == "GalagaWars") {
					draw_sprite_ext(xwing_sprite_sheet,2,oPlayer.x,oPlayer.y,0.8,0.8,0,c_white,1);
					
					// MISSLE
					if (attshot) {
					    draw_sprite_ext(sBlueLazer, 0, attshotx, attshoty, 0.5, 0.5, 90, c_white, 1);
					}
				}
				else {
					draw_sprite(spr_ship, 0, oPlayer.x, oPlayer.y);
										
					// MISSLE
					if (attshot) {
					    draw_sprite_ext(spr_shot, 0, attshotx, attshoty, 1, 1, 0, c_white, 1);
					}
				}
			} // sequence < 17

			// SHOW CREDITS
			if (sequence > 17) {
				draw_set_halign(fa_center)

				draw_set_color(c_white)

				draw_text(224*global.scale, (416 + 32)*global.scale,
					string_hash_to_newline("© 1981-2024 BANDAI"))

				draw_text(224*global.scale, (448 + 32)*global.scale,
					string_hash_to_newline(
						"  NAMCO ENTERTAINMENT, INC. "))

				draw_set_color(c_red)

				draw_text(224*global.scale, (480 + 32)*global.scale,
					string_hash_to_newline(
						"2025 Richard Shannon"))
						
				draw_set_halign(fa_left)
			} // CREDITS
		} // sequence 5 to 20
	} // sequence < 21
	else if (sequence > 20) {	// DRAW HIGH SCORE TABLE ...
		if (global.roomname == "GalagaWars") {
			draw_sprite_ext(galagawars_logo, -1, 224*global.scale, 5*global.scale,0.55,0.55,0,c_white,1);
		}
		
		draw_set_halign(fa_left);
		draw_set_color(c_blue);
		draw_text(68*global.scale, 150*global.scale, string_hash_to_newline("THE GALACTIC HEROES"))

		draw_set_color(c_red);
		draw_text(122*global.scale, 224*global.scale, string_hash_to_newline("-- BEST 5 --"));
		draw_text((122 + 8)*global.scale, 224*global.scale, string_hash_to_newline("-         -"));

		draw_set_color(c_aqua);
		draw_text(160*global.scale, 320*global.scale, string_hash_to_newline("SCORE     NAME"));

		if !ds_list_empty(global.gmscoreboard_scores) {
			var num = ds_list_size(global.gmscoreboard_scores);

			var TITLE = ["1ST", "2ND", "3RD", "4TH", "5TH"];
			
			for (var i = 0; i < num; i++){
				var item = ds_list_find_value(global.gmscoreboard_scores, i);
				var player = item[? "player"];
				var player_score = item[? "score"];

				draw_set_color(colors[min(i,4)]);
				
				draw_text(64*global.scale, (352 + 32*i)*global.scale, TITLE[i]);
				draw_set_halign(fa_right);
				draw_text(240*global.scale, (352+ 32*i)*global.scale, player_score);
				draw_set_halign(fa_left);
				draw_text(336*global.scale, (352+ 32*i)*global.scale, player);	
				
				if (global.disp < player_score) {
					// set the high score to the highest score from the online high score table
					global.disp = player_score;
				}
			}
		}

		draw_set_color(c_aqua);
		
//		draw_text(64*global.scale, (304 + 32 + 16)*global.scale, string_hash_to_newline("1ST"));
//		draw_set_halign(fa_right);
//		draw_text(240*global.scale, (304 + 32 + 16)*global.scale, string_hash_to_newline(global.galaga1));
//		draw_set_halign(fa_left);
//		draw_text(336*global.scale, (304 + 32 + 16)*global.scale, string_hash_to_newline(global.init1));

//		draw_text(64*global.scale, (304 + 32 + 32 + 16)*global.scale, string_hash_to_newline("2ND"));
		//draw_set_halign(fa_right);
		//draw_text(
		//	240*global.scale, (304 + 32 + 32 + 16)*global.scale, string_hash_to_newline(global.galaga2));
		//draw_set_halign(fa_left);
		//draw_text(
		//	336*global.scale, (304 + 32 + 32 + 16)*global.scale, string_hash_to_newline(global.init2));

//		draw_text(64*global.scale, (304 + 32 + 32 + 32 + 16)*global.scale, string_hash_to_newline("3RD"));
		//draw_set_halign(fa_right);
		//draw_text(240*global.scale, (304 + 32 + 32 + 32 + 16)*global.scale,
		//	string_hash_to_newline(global.galaga3));
		//draw_set_halign(fa_left);
		//draw_text(336*global.scale, (304 + 32 + 32 + 32 + 16)*global.scale,
		//	string_hash_to_newline(global.init3));

//		draw_text(
//			64*global.scale, (304 + 32 + 32 + 32 + 32 + 16)*global.scale, string_hash_to_newline("4TH"));
		//draw_set_halign(fa_right);
		//draw_text(240*global.scale, (304 + 32 + 32 + 32 + 32 + 16)*global.scale,
		//	string_hash_to_newline(global.galaga4));
		//draw_set_halign(fa_left);
		//draw_text(336*global.scale, (304 + 32 + 32 + 32 + 32 + 16)*global.scale,
		//	string_hash_to_newline(global.init4));

//		draw_text(64*global.scale, (304 + 32 + 32 + 32 + 32 + 32 + 16)*global.scale,
//			string_hash_to_newline("5TH"));
		//draw_set_halign(fa_right);
		//draw_text(240*global.scale, (304 + 32 + 32 + 32 + 32 + 32 + 16)*global.scale,
		//	string_hash_to_newline(global.galaga5));
		//draw_set_halign(fa_left);
		//draw_text(336*global.scale, (304 + 32 + 32 + 32 + 32 + 32 + 16)*global.scale,
		//	string_hash_to_newline(global.init5));
	}
}