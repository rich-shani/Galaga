// 1UP & HIGH SCORE (red text)

draw_set_font(font0);
draw_set_halign(fa_right);

draw_set_color(c_red);
if (blink) { draw_text(80, 10, string_hash_to_newline("1UP")) };
draw_text(304, 10, string_hash_to_newline("HIGH SCORE"));

draw_set_color(c_white);
draw_text(96, 26, string_hash_to_newline(global.p1score));
draw_text(272, 26, string_hash_to_newline(global.disp))

draw_set_halign(fa_left);
	
// is the Game Paused?
if (global.isGamePaused) { 
	draw_set_font(fAtari24);
	draw_set_color(c_green);
	
	draw_text(50,265, "GAME PAUSED");
}
else { // Draw screen based on Game Mode
	
	switch (global.gameMode) {
		case GameMode.ATTRACT_MODE:
			Draw_Attract_Mode();
			break;
		case GameMode.INSTRUCTIONS:
			Draw_Instructions();
			break
		case GameMode.SHOW_RESULTS:
			Draw_Results();
			break;
		case GameMode.ENTER_INITIALS:
			Draw_Enter_Initials();
			break;
		case GameMode.GAME_ACTIVE:
			Draw_Lives();
			break;
	}

  // draw_set_halign(fa_left);
  draw_set_color(c_aqua)

      if global.gameover
      = 2
  {
    draw_text(160, 288, string_hash_to_newline("GAME OVER"))
  }

  if global.startMode
    = StartMode.SHOW_PLAYER1 { draw_text(176, 288, string_hash_to_newline("PLAYER 1")) };
  if global.startMode
    > StartMode.SHOW_PLAYER1 { draw_text(160, 288, string_hash_to_newline("STAGE 1")) };
  if global.startMode
    = StartMode.GAME_STARTED { draw_text(160, 256, string_hash_to_newline("PLAYER 1")) };

  if global.startMode
    = StartMode.INITIALIZE
    {

      if global.stage
        = 1
        {

          if global
            .challcount = 0
            {
              draw_text(96, 288, string_hash_to_newline("CHALLENGING STAGE"))
            }
          else {
            draw_text(160, 288, string_hash_to_newline("STAGE"));
            draw_text(160 + (6 * 16), 288, string_hash_to_newline(global.lvl))
          };
        }

      if Ship
        .alarm[1] > -1
        {

          if global
            .p1lives > 0
            {
              draw_text(160, 288, string_hash_to_newline("READY"))
            }
        }

      draw_set_color(c_red)

          with Boss
      {

        if Ship.shipStatus == ShipState.CAPTURED and Ship.alarm[2] = -1 and Ship.spinanim = 0 and beam
              = 1 and direction = 270
          {

            with Controller
            {
              sound_stop(GCaptured);
              draw_text(
                  112, 288 + 16, string_hash_to_newline("FIGHTER CAPTURED"))
            }
          }
      }

      /// challenging stage end

      if results
        > 1
        { /// display "NUMBER OF HITS"

          draw_set_color(c_aqua);
          draw_text(96 - 16, 288, string_hash_to_newline("NUMBER OF HITS"))

                  if results
              > 2
          { /// display shottotal

            draw_text(352 - 16, 288, string_hash_to_newline(shottotal))

                    if results
                > 3
            { /// display "PERFECT!" or "BONUS"

              if shottotal
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
                draw_text(144 - 16, 336, string_hash_to_newline("BONUS"))
              }

              if results
                > 4
                { /// display "SPECIAL BONUS 10000 PTS" or custom multiplied
                  /// number;

                  if shottotal
                    = 40
                    {

                      draw_set_color(c_yellow)

                          draw_text(48 - 16, 336,
                              string_hash_to_newline("SPECIAL BONUS 10000 PTS"))
                    }

                  else {
                    draw_text(
                        256 - 16, 336, string_hash_to_newline(shottotal * 100))
                  }
                }
            }
          }
        }
    }
}