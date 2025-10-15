// draw splash screen
draw_sprite_stretched(sprite_splash_screen, -1, 0, 0, _w, _h);

draw_set_font(fAtari12);
draw_set_color(c_yellow);

draw_text(30,_h-70,"GalagaWars");
draw_text(30,_h-40, "By Richard Shannon");
draw_set_color(c_white);