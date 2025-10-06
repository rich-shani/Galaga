/// @description Draw HUD messages

// 1UP & HIGH SCORE (red text)

// load retro Atari font
if (global.roomname == "GalagaWars") {
	draw_set_font(fAtari24);	
}
else draw_set_font(fAtari12);

// draw the scores (top of screen)
Draw_Scores();
	
// is the Game Paused?
if (global.isGamePaused) { 
	draw_set_font(fAtari24);
	draw_set_color(c_green);
	
	draw_text(50,265, "GAME PAUSED");
}
else { 
	// Draw screen based on Game Mode
	switch (global.gameMode) {
		case GameMode.INSTRUCTIONS:
			Draw_Instructions();
			break
		case GameMode.SHOW_RESULTS:
			Draw_Results();
			break;
		case GameMode.ENTER_INITIALS:
			Draw_Enter_Initials();
			break;
	}
	
	// show CREDITS if we're not in an active game
	if (global.gameMode < GameMode.GAME_STAGE_MESSAGE) {
		Draw_Credits();
	}
	else {
		Draw_Lives();
	}

	draw_set_color(c_aqua);

	if global.gameover
	{
		draw_text(160, 288, string_hash_to_newline("GAME OVER"));
	}
	else if (instance_number(Ship) > 0) {
	
		if global.gameMode == GameMode.GAME_PLAYER_MESSAGE { 
			// launch the death star animation ...
			instance_create_layer(0, 0, "GameSprites", oDeathStar);
			
			draw_text(176*global.scale, 288*global.scale, string_hash_to_newline("PLAYER 1"));
		}
		else if global.gameMode == GameMode.GAME_STAGE_MESSAGE { 
	        draw_text(160*global.scale, 288*global.scale, string_hash_to_newline("STAGE"));
	        draw_text(160 + (6 * 16), 288*global.scale, string_hash_to_newline(global.lvl));
		}
		else if (global.gameMode == GameMode.GAME_READY) {
			draw_text(160*global.scale, 256*global.scale, string_hash_to_newline("PLAYER 1"));
	        draw_text(160*global.scale, 288*global.scale, string_hash_to_newline("STAGE"));
	        draw_text(160 + (6 * 16), 288*global.scale, string_hash_to_newline(global.lvl));
		}
		else if (global.gameMode == GameMode.GAME_ACTIVE) {

	      if global.stage
	        = 1
	        {

	          if global
	            .challcount = 0
	            {
	              draw_text(96*global.scale, 288*global.scale, string_hash_to_newline("CHALLENGING STAGE"));
	            }
	          else {
	            draw_text(160*global.scale, 288*global.scale, string_hash_to_newline("STAGE"));
	            draw_text(160 + (6 * 16), 288*global.scale, string_hash_to_newline(global.lvl));
	          }
	        }

	      if Ship
	        .alarm[1] > -1
	        {

	          if global
	            .p1lives > 0
	            {
	              draw_text(160*global.scale, 288*global.scale, string_hash_to_newline("READY"));
	            }
	        }

	      draw_set_color(c_red)

	          with Boss
	      {

	        if oPlayer.shipStatus == _ShipState.CAPTURED and oPlayer.alarm[2] = -1 and oPlayer.spinanim = 0 and beam
	              = 1 and direction = 270
	          {

	            with oGameManager
	            {
	              sound_stop(GCaptured);
	              draw_text(
	                  112, 288 + 16, string_hash_to_newline("FIGHTER CAPTURED"));
	            }
	          }
	      }

	      /// challenging stage end

	      if results
	        > 1
	        { /// display "NUMBER OF HITS"

	          draw_set_color(c_aqua);
	          draw_text(96 - 16, 288, string_hash_to_newline("NUMBER OF HITS"));

	                  if results
	              > 2
	          { /// display global.shottotal

	            draw_text(352 - 16, 288, string_hash_to_newline(global.shottotal));

	                    if results
	                > 3
	            { /// display "PERFECT!" or "BONUS"

	              if global.shottotal
	                = 40
	                {

	                  draw_set_color(c_red);

	                  if results
	                    > 4 or(alarm[2] > 84 or(alarm[2] < 68 and alarm[2] > 50)
	                               or(alarm[2] < 34 and alarm[2] > 16))
	                    {

	                      draw_text(
	                          176 - 16, 240, string_hash_to_newline("PERFECT"));
	                      draw_sprite_ext(
	                          spr_exc, 0, 304 - 16, 240, 1, 1, 0, c_red, 1);
	                    }
	                }

	              else {
	                draw_text(144 - 16, 336, string_hash_to_newline("BONUS"));
	              }

	              if results
	                > 4
	                { /// display "SPECIAL BONUS 10000 PTS" or custom multiplied
	                  /// number;

	                  if global.shottotal
	                    = 40
	                    {

	                      draw_set_color(c_yellow)

	                          draw_text(48 - 16, 336,
	                              string_hash_to_newline("SPECIAL BONUS 10000 PTS"));
	                    }

	                  else {
	                    draw_text(
	                        256 - 16, 336, string_hash_to_newline(global.shottotal * 100));
	                  }
	                }
	            }
	          }
	        }
	    }
	}
}