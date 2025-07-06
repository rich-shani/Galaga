if (Controller.start = 0 or Controller.start = 3) {

  /// draw lives
  lifecount = global.p1lives - 1;
  repeat(lifecount)
  {
    draw_sprite(spr_ship, 0, 16 + (32 * (lifecount - 1)), 560);
    lifecount = lifecount - 1
  };
}

draw_set_font(font0);
draw_set_halign(fa_right);

draw_set_color(c_red);

if blink
  = 0 { draw_text(80, 0, string_hash_to_newline("1UP")) };

draw_text(304, 0, string_hash_to_newline("HIGH SCORE"));

/// if blink = 0{draw_text(416,0,"2UP")}

draw_set_color(c_white);

draw_text(96, 16, string_hash_to_newline(global.p1score));

draw_text(272, 16, string_hash_to_newline(global.disp))

    /// draw_text(428,16,global.p2score);

    draw_set_halign(fa_left);

if instance_number (Ship)
  == 0
  {

    if results
      = 1
      { /// game results

        draw_set_color(c_red);

        draw_text(144, 272, string_hash_to_newline("-RESULTS-"));

        draw_set_color(c_yellow);

        draw_text(64, 272 + 48, string_hash_to_newline("SHOTS FIRED"));
        draw_text(320, 272 + 48, string_hash_to_newline(fire))

            draw_text(
                64, 272 + 48 + 48, string_hash_to_newline("NUMBER OF HITS"));
        draw_text(320, 272 + 48 + 48, string_hash_to_newline(hits))

            draw_set_color(c_white);

        draw_text(
            64, 272 + 48 + 48 + 48, string_hash_to_newline("HIT-MISS RATIO"));

        if (fire = 0 or hits = 0) {
          draw_text(290, 272 + 48 + 48 + 48, string_hash_to_newline("0.0"))
        } else {

          draw_text(290, 272 + 48 + 48 + 48,
              string_hash_to_newline(string_format(100 * (hits / fire), 4, 1)))
        };

        draw_text(290, 272 + 48 + 48 + 48, string_hash_to_newline("      %"));
      }

    if results
      > 1
      { /// initials

        draw_set_color(c_red)

            draw_text(64, 96, string_hash_to_newline("ENTER YOUR INITIALS "));
        draw_sprite_ext(spr_exc, 0, 384, 96, 1, 1, 0, c_red, 1);

        draw_set_color(c_aqua)

            draw_text(96, 144, string_hash_to_newline("SCORE       NAME"));

        draw_set_halign(fa_right);
        draw_text(176, 176, string_hash_to_newline(global.p1score));

        draw_set_halign(fa_left); /// 304,176

        draw_set_color(c_red);
        draw_text(192, 288, string_hash_to_newline("TOP 5"));

        draw_set_color(c_aqua);
        draw_text(160, 304 + 16, string_hash_to_newline("SCORE     NAME"));

        if scored
          = 1 { draw_set_color(c_yellow) };
        draw_text(64, 304 + 32 + 16, string_hash_to_newline("1ST"));
        draw_set_halign(fa_right);
        draw_text(240, 304 + 32 + 16, string_hash_to_newline(global.galaga1));
        draw_set_halign(fa_left);
        draw_text(336, 304 + 32 + 16, string_hash_to_newline(global.init1));
        draw_set_color(c_aqua);
        if scored
          = 1 { draw_text(304, 176, string_hash_to_newline(global.init1)) };

        if scored
          = 2 { draw_set_color(c_yellow) };
        draw_text(64, 304 + 32 + 32 + 16, string_hash_to_newline("2ND"));
        draw_set_halign(fa_right);
        draw_text(
            240, 304 + 32 + 32 + 16, string_hash_to_newline(global.galaga2));
        draw_set_halign(fa_left);
        draw_text(
            336, 304 + 32 + 32 + 16, string_hash_to_newline(global.init2));
        draw_set_color(c_aqua);
        if scored
          = 2 { draw_text(304, 176, string_hash_to_newline(global.init2)) };

        if scored
          = 3 { draw_set_color(c_yellow) };
        draw_text(64, 304 + 32 + 32 + 32 + 16, string_hash_to_newline("3RD"));
        draw_set_halign(fa_right);
        draw_text(240, 304 + 32 + 32 + 32 + 16,
            string_hash_to_newline(global.galaga3));
        draw_set_halign(fa_left);
        draw_text(
            336, 304 + 32 + 32 + 32 + 16, string_hash_to_newline(global.init3));
        draw_set_color(c_aqua);
        if scored
          = 3 { draw_text(304, 176, string_hash_to_newline(global.init3)) };

        if scored
          = 4 { draw_set_color(c_yellow) };
        draw_text(
            64, 304 + 32 + 32 + 32 + 32 + 16, string_hash_to_newline("4TH"));
        draw_set_halign(fa_right);
        draw_text(240, 304 + 32 + 32 + 32 + 32 + 16,
            string_hash_to_newline(global.galaga4));
        draw_set_halign(fa_left);
        draw_text(336, 304 + 32 + 32 + 32 + 32 + 16,
            string_hash_to_newline(global.init4));
        draw_set_color(c_aqua);
        if scored
          = 4 { draw_text(304, 176, string_hash_to_newline(global.init4)) };

        if scored
          = 5 { draw_set_color(c_yellow) };
        draw_text(64, 304 + 32 + 32 + 32 + 32 + 32 + 16,
            string_hash_to_newline("5TH"));
        draw_set_halign(fa_right);
        draw_text(240, 304 + 32 + 32 + 32 + 32 + 32 + 16,
            string_hash_to_newline(global.galaga5));
        draw_set_halign(fa_left);
        draw_text(336, 304 + 32 + 32 + 32 + 32 + 32 + 16,
            string_hash_to_newline(global.init5));
        draw_set_color(c_aqua);
        if scored
          = 5 { draw_text(304, 176, string_hash_to_newline(global.init5)) };

        if results
          < 5
          {
            draw_set_color(c_aqua);
            draw_text(304 + (16 * char), 176,
                string_hash_to_newline(string_char_at(cycle, cyc)));

            if blink
              = 1
              {
                draw_set_color(c_yellow);
                draw_text(304 + (16 * char), 176,
                    string_hash_to_newline(string_char_at(cycle, cyc)))
              }
          }
      }
  }

else { /// screens

  if gameMode
    == GameMode.ATTRACT_MODE
    {

      if att
        < 21
        {

          if att
            > 0
            {
              draw_set_color(c_aqua);
              draw_text(170, 80, string_hash_to_newline("GALAGA"));

              if att
                > 1
                {
                  draw_text(
                      176 - 48, 128, string_hash_to_newline("-- SCORE --"));
                  draw_text(
                      176 - 40, 128, string_hash_to_newline("-        -"));

                  if att
                    > 2
                    {
                      draw_text(176 - 48, 176,
                          string_hash_to_newline("    50    100"));
                      draw_sprite(
                          spr_ship, 10 + floor(global.flip / 30), 128, 168 + 16)

                              if att
                          > 3
                      {
                        draw_text(176 - 48, 224,
                            string_hash_to_newline("    80    160"));
                        draw_sprite(spr_ship, 6 + floor(global.flip / 30), 128,
                            168 + 48 + 16)

                                if att
                            > 4
                        {
                          draw_sprite(spr_ship, 2 + floor(global.flip / 30),
                              224, 168 + 48 + 48 + 24)
                        }
                      }
                    }
                }
            }

          if att
            > 5 and att < 21
            {

              if att
                < 8
                {
                  draw_sprite_ext(spr_ship, 2 + floor(global.flip / 30), 384,
                      336, 1, 1, 0, c_white, 1);
                  draw_sprite_ext(spr_ship, 6 + floor(global.flip / 30),
                      384 + 32, 368, 1, 1, 0, c_white, 1);
                  draw_sprite_ext(spr_ship, 6 + floor(global.flip / 30),
                      384 - 32, 368, 1, 1, 0, c_white, 1)
                };

              if att
                = 8
                {

                  if round (direction / 15)
                    &1 = 0
                    {
                      draw_sprite_ext(spr_ship, 2 + (blip * 2), 384 + x - 16,
                          336 + y - 16, 1, 1, direction - 90, c_white, 1);
                      draw_sprite_ext(spr_ship, 6, 384 + 32 + x - 16,
                          368 + y - 16, 1, 1, direction - 90, c_white, 1);
                      draw_sprite_ext(spr_ship, 6, 384 - 32 + x - 16,
                          368 + y - 16, 1, 1, direction - 90, c_white, 1)
                    }

                  else {
                    draw_sprite_ext(spr_ship, 3 + (blip * 2), 384 + x - 16,
                        336 + y - 16, 1, 1, direction - 90, c_white, 1);
                    draw_sprite_ext(spr_ship, 7, 384 + 32 + x - 16,
                        368 + y - 16, 1, 1, direction - 90, c_white, 1);
                    draw_sprite_ext(spr_ship, 7, 384 - 32 + x - 16,
                        368 + y - 16, 1, 1, direction - 90, c_white, 1)
                  }
                }

              if att
                = 8 or att = 9
                {
                  if round (direction / 15)
                    &1 = 0
                    {
                      draw_sprite_ext(spr_ship, 6, 384 + 32 + x - 16,
                          368 + y - 16, 1, 1, direction - 90, c_white, 1);
                      draw_sprite_ext(spr_ship, 6, 384 - 32 + x - 16,
                          368 + y - 16, 1, 1, direction - 90, c_white, 1)
                    }

                  else {
                    draw_sprite_ext(spr_ship, 7, 384 + 32 + x - 16,
                        368 + y - 16, 1, 1, direction - 90, c_white, 1);
                    draw_sprite_ext(spr_ship, 7, 384 - 32 + x - 16,
                        368 + y - 16, 1, 1, direction - 90, c_white, 1)
                  }
                }

              ///

              if att
                < 11
                {
                  draw_sprite_ext(spr_ship, 2 + floor(global.flip / 30), 288,
                      336, 1, 1, 0, c_white, 1);
                  draw_sprite_ext(spr_ship, 6 + floor(global.flip / 30),
                      288 + 32, 368, 1, 1, 0, c_white, 1)
                }

              if att
                = 11
                {

                  if round (direction / 15)
                    &1 = 0
                    {
                      draw_sprite_ext(spr_ship, 2 + (blip * 2), 288 + x - 16,
                          336 + y - 16, 1, 1, direction - 90, c_white, 1);
                      draw_sprite_ext(spr_ship, 6, 288 + 32 + x - 16,
                          368 + y - 16, 1, 1, direction - 90, c_white, 1)
                    }

                  else {
                    draw_sprite_ext(spr_ship, 3 + (blip * 2), 288 + x - 16,
                        336 + y - 16, 1, 1, direction - 90, c_white, 1);
                    draw_sprite_ext(spr_ship, 7, 288 + 32 + x - 16,
                        368 + y - 16, 1, 1, direction - 90, c_white, 1)
                  }
                }

              if att
                = 11 or att = 12
                {
                  if round (direction / 15)
                    &1 = 0
                    {
                      draw_sprite_ext(spr_ship, 6, 288 + 32 + x - 16,
                          368 + y - 16, 1, 1, direction - 90, c_white, 1)
                    }

                  else {
                    draw_sprite_ext(spr_ship, 7, 288 + 32 + x - 16,
                        368 + y - 16, 1, 1, direction - 90, c_white, 1)
                  }
                }

              ///

              if att
                < 14
                {
                  draw_sprite_ext(spr_ship, 2 + floor(global.flip / 30), 192,
                      336, 1, 1, 0, c_white, 1)
                }

              if att
                = 14
                {

                  if round (direction / 15)
                    &1 = 0
                    {
                      draw_sprite_ext(spr_ship, 2 + (blip * 2), 192 + x - 16,
                          336 + y - 16, 1, 1, direction - 90, c_white, 1)
                    }

                  else {
                    draw_sprite_ext(spr_ship, 3 + (blip * 2), 192 + x - 16,
                        336 + y - 16, 1, 1, direction - 90, c_white, 1)
                  }
                }

              ///

              if att
                < 17
                {
                  draw_sprite_ext(spr_ship,
                      2 + floor(global.flip / 30)
                          + (floor(att / 16) * blip * 2),
                      96, 336, 1, 1, 0, c_white, 1)
                }

              if att
                > 17 and att < 21
                {
                  draw_set_halign(fa_center)

                      draw_set_color(c_white)

                          draw_text(224, 416 + 32,
                              string_hash_to_newline("© 1981-2024 BANDAI"))

                              draw_text(224, 448 + 32,
                                  string_hash_to_newline(
                                      "  NAMCO ENTERTAINMENT, INC. "))

                                  draw_set_color(c_red)

                                      draw_text(224, 480 + 32,
                                          string_hash_to_newline(
                                              "2024 Richard Shannon"))
                }
            }
        }

      if att
        > 20
        {

          draw_set_halign(fa_left);
          draw_set_color(c_blue);
          draw_text(64, 112, string_hash_to_newline("THE GALACTIC HEROES"))

              draw_set_color(c_red);
          draw_text(122, 224, string_hash_to_newline("-- BEST 5 --"));
          draw_text(122 + 8, 224, string_hash_to_newline("-         -"));

          draw_set_color(c_aqua);
          draw_text(160, 320, string_hash_to_newline("SCORE     NAME"));

          draw_text(64, 304 + 32 + 16, string_hash_to_newline("1ST"));
          draw_set_halign(fa_right);
          draw_text(240, 304 + 32 + 16, string_hash_to_newline(global.galaga1));
          draw_set_halign(fa_left);
          draw_text(336, 304 + 32 + 16, string_hash_to_newline(global.init1));

          draw_text(64, 304 + 32 + 32 + 16, string_hash_to_newline("2ND"));
          draw_set_halign(fa_right);
          draw_text(
              240, 304 + 32 + 32 + 16, string_hash_to_newline(global.galaga2));
          draw_set_halign(fa_left);
          draw_text(
              336, 304 + 32 + 32 + 16, string_hash_to_newline(global.init2));

          draw_text(64, 304 + 32 + 32 + 32 + 16, string_hash_to_newline("3RD"));
          draw_set_halign(fa_right);
          draw_text(240, 304 + 32 + 32 + 32 + 16,
              string_hash_to_newline(global.galaga3));
          draw_set_halign(fa_left);
          draw_text(336, 304 + 32 + 32 + 32 + 16,
              string_hash_to_newline(global.init3));

          draw_text(
              64, 304 + 32 + 32 + 32 + 32 + 16, string_hash_to_newline("4TH"));
          draw_set_halign(fa_right);
          draw_text(240, 304 + 32 + 32 + 32 + 32 + 16,
              string_hash_to_newline(global.galaga4));
          draw_set_halign(fa_left);
          draw_text(336, 304 + 32 + 32 + 32 + 32 + 16,
              string_hash_to_newline(global.init4));

          draw_text(64, 304 + 32 + 32 + 32 + 32 + 32 + 16,
              string_hash_to_newline("5TH"));
          draw_set_halign(fa_right);
          draw_text(240, 304 + 32 + 32 + 32 + 32 + 32 + 16,
              string_hash_to_newline(global.galaga5));
          draw_set_halign(fa_left);
          draw_text(336, 304 + 32 + 32 + 32 + 32 + 32 + 16,
              string_hash_to_newline(global.init5));
        }
    }

  if gameMode
    == GameMode.INSTRUCTIONS
    {

      draw_set_color(c_aqua);

      draw_text(96, 208, string_hash_to_newline("PUSH START BUTTON"));

      draw_set_color(c_yellow);

      draw_text(
          64, 208 + 64, string_hash_to_newline("1ST BONUS FOR 30000 PTS"));

      draw_text(
          64, 208 + 64 + 48, string_hash_to_newline("2ND BONUS FOR 70000 PTS"));

      draw_text(64, 208 + 64 + 48 + 48,
          string_hash_to_newline("AND FOR EVERY 70000 PTS"));

      draw_sprite(spr_ship, 0, 32, 8 + 208 + 64);
      draw_sprite(spr_ship, 0, 32, 8 + 208 + 48 + 64);
      draw_sprite(spr_ship, 0, 32, 8 + 208 + 48 + 48 + 64);

      draw_set_halign(fa_center)

          draw_set_color(c_white)

              draw_text(
                  224, 416 + 32, string_hash_to_newline("© 1981-2024 BANDAI"))

                  draw_text(224, 448 + 32,
                      string_hash_to_newline("  NAMCO ENTERTAINMENT, INC. "))

                      draw_set_color(c_red)

                          draw_text(224, 480 + 32,
                              string_hash_to_newline("2024 Richard Shannon"))
    }

  draw_set_halign(fa_left);
  draw_set_color(c_aqua)

      if Ship.gameover
      = 2
  {
    draw_text(160, 288, string_hash_to_newline("GAME OVER"))
  }

  if start
    = 1 { draw_text(176, 288, string_hash_to_newline("PLAYER 1")) };
  if start
    > 1 { draw_text(160, 288, string_hash_to_newline("STAGE 1")) };
  if start
    = 3 { draw_text(160, 256, string_hash_to_newline("PLAYER 1")) };

  if start
    = 0
    {

      if stage
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

        if Ship
          .caught = 1 and Ship.alarm[2] = -1 and Ship.spinanim = 0 and beam
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
