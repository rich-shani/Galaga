switch (ScreenShown) {
	case TITLE_SCREEN.TITLE:

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
}