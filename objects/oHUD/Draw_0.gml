

draw_set_font(fAtari12);
draw_set_color(c_red);

if (global.gamestate == GameState.INTRO_GAME) {
	//increase values
	time += increase;

	// timer, used to flash the 1UP at start of game
	if (time >= 25 || time <= 0) { increase = -increase; }

	// flash the 1UP title
	draw_set_alpha(lerp(0.3,1,time/25));
	draw_text(120,20,"1UP");
	
	draw_set_color(c_aqua);
	draw_text(370, 475, "PLAYER 1");

	draw_set_alpha(1);
	draw_set_color(c_red);
}
else draw_text(120,20,"1UP");

draw_text(400,20,"HIGH SCORE");

draw_set_color(c_white);

draw_text(160,40, string(oGameManager.score));
draw_text(440,40, string(oGameManager.highScore));

// draw player sprites to show how many lives we have 
for (var i = 0; i < oGameManager.nLives-1; i++ ) {
	if (global.ArcadeSprites) {
		draw_sprite_ext(OG_sPlayer, 1 ,30 + (i * 50),850,0.8,0.8,0,c_white,1);	
	}
	else draw_sprite_ext(sPlayer, 1 ,30 + (i * 50),850,0.8,0.8,0,c_white,1);	
}

// Is the Game Paused?
if (oGameManager.isGamePaused) {
	draw_set_font(fAtari32);
	draw_set_color(c_green);
	
	draw_text(270,465, "GAME PAUSED");
}

