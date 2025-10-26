switch (ScreenShown) {
	case TITLE_SCREEN.TITLE:

		draw_set_font(fAtari24);

		// GALAGA, SCORE, INTRO
		draw_set_color(c_aqua);
		draw_sprite_ext(galagawars_logo, -1, 224*global.scale, 5*global.scale,0.55,0.55,0,c_white,1);
			
			if sequence > 1 {
				draw_text((176 - 48)*global.scale, 132*global.scale, string_hash_to_newline("-- SCORE --"));
				draw_text((176 - 40)*global.scale, 132*global.scale, string_hash_to_newline("-        -"));

				if sequence > 2 {
					draw_text((176 - 48)*global.scale, 176*global.scale, string_hash_to_newline("    50    100"));
					draw_sprite_ext(sTieFighter, animationIndex/4, 104*global.scale, (168+16)*global.scale, 1, 1, 0, c_white, 1);
						
					if sequence > 3 {
						draw_text((176 - 48)*global.scale, 224*global.scale, string_hash_to_newline("    80    160"));
						draw_sprite_ext(sImperialShuttle, animationIndex/4, 104*global.scale, (168+48+16)*global.scale, 1, 1, 0, c_white, 1);
						
						if sequence > 4 {											
							draw_sprite_ext(sTieIntercepter, 18, 224*global.scale, (168 + 48 + 48 + 24)*global.scale, 1, 1, 0, c_white, 1);										
						} // sequence > 4
					} // sequence > 3
				} // sequence > 2
			} // sequence > 1

		// animation sequence for the attract page ... ie dive, shoot and points
		if (sequence > 5 && sequence < 21) {

			// Draw initial enemy postiion for block #1
			if (sequence < 8) {
				// INTERCEPTER
				draw_sprite_ext(sTieIntercepter, 18, 364*global.scale, 336*global.scale, 1, 1, 0, c_white, 1);
					
				// IMPERIAL SHUTTLE 1
				draw_sprite_ext(sImperialShuttle, 18, (364 + 24)*global.scale, 368*global.scale, 1, 1, 0, c_white, 1);
				// IMPERIAL SHUTTLE 2
				draw_sprite_ext(sImperialShuttle, 18, (364 - 24)*global.scale, 368*global.scale, 1, 1, 0, c_white, 1);
			}

			// Animate enemy block #1
			if (sequence = 8) {
				var i = round(direction/15);
					
				var color = (hitFlag ? c_maroon : c_white);
				draw_sprite_ext(sTieIntercepter, i, 364*global.scale+x, 336*global.scale+y, 1, 1, 0, color, 1);
					
				// IMPERIAL SHUTTLE 1
				draw_sprite_ext(sImperialShuttle, i, (364 + 24)*global.scale+x, 368*global.scale+y, 1, 1, 0, c_white, 1);
				// IMPERIAL SHUTTLE 2
				draw_sprite_ext(sImperialShuttle, i, (364 - 24)*global.scale+x, 368*global.scale+y, 1, 1, 0, c_white, 1);
			}

			// Draw initial enemy postiion for block #2
			if sequence < 11 {
				// BOSS
				draw_sprite_ext(sTieIntercepter, 18, 268*global.scale, 336*global.scale, 1, 1, 0, c_white, 1);
					
				// IMPERIAL SHUTTLE 1
				draw_sprite_ext(sImperialShuttle, 18, (268 + 24)*global.scale, 368*global.scale, 1, 1, 0, c_white, 1);
			}

			// Animate enemy block #2
			if sequence == 11 {
			
				var i = round(direction/15);
				
				var color = (hitFlag ? c_maroon : c_white);
				draw_sprite_ext(sTieIntercepter, i, 268*global.scale+x, 336*global.scale+y, 1, 1, 0, color, 1);
					
				// IMPERIAL SHUTTLE 1
				draw_sprite_ext(sImperialShuttle, i, (268 + 24)*global.scale+x, 368*global.scale+y, 1, 1, 0, c_white, 1);
			}
			
			// Draw initial enemy postiion for block #3
			if sequence < 14 {
				
				draw_sprite_ext(sTieIntercepter, 18, 172*global.scale, 336*global.scale, 1, 1, 0, c_white, 1);
			}

			// Animate enemy block #3
			if sequence == 14 {
				
				var i = round(direction/15);
					
				var color = (hitFlag ? c_maroon : c_white);
				draw_sprite_ext(sTieIntercepter, i, 172*global.scale+x, 336*global.scale+y, 1, 1, 0, color, 1);
			}

			// DRAW ship & final BOSS
			if sequence < 17 {
				
				// note - ignore the hit flag until we get to sequence 16
				var color = (floor(sequence / 16) * hitFlag ? c_maroon : c_white);
				draw_sprite_ext(sTieIntercepter, 18, 76*global.scale, 336*global.scale, 1, 1, 0, color, 1);
			

				// SHIP
				draw_sprite_ext(xwing_sprite_sheet,2,player_x,player_y,0.8,0.8,0,c_white,1);
					
				// MISSLE
				if (attshot) {
					draw_sprite_ext(sBlueLazer, 0, attshotx, attshoty, 0.5, 0.5, 90, c_white, 1);
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
	
		break;
	case TITLE_SCREEN.HIGH_SCORE:

		// draw the High Score table
		draw_set_font(fAtari24);

		draw_sprite_ext(galagawars_logo, -1, 224*global.scale, 5*global.scale,0.55,0.55,0,c_white,1);
		
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
				
				//if (global.disp < player_score) {
				//	// set the high score to the highest score from the online high score table
				//	global.disp = player_score;
				//}
			}
	
			// reset the color to white
			draw_set_color(c_white);
			draw_set_font(fAtari12);
			draw_text(350, 1100, "Online scoring via GM scoreboard");
			draw_set_color(c_aqua);
		}
		else {
			// can't get the high scores from the GM Scoreboard site
			draw_set_color(c_white);
			draw_set_font(fAtari12);
						
			draw_text(340, 600, "Check your internet connection");
			draw_set_color(c_aqua);
		}
		
		break;
}