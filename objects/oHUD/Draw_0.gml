//// score panel
//draw_set_font(fAtari12);
//draw_set_color(c_white);

//draw_text(180,20,"1UP");
//draw_text(200,40, string(oGameManager.score));

//draw_text(280,20,"HIGH SCORE");
//if (oGameManager.highScore == 0) {
//	draw_text(360,40, "00");
//}
//else {
//	draw_text(360,40, string(oGameManager.highScore));
//}

//// draw pacman sprites to show how many lives we have 
//for (var i = 0; i < oGameManager.nPacmanLives-1; i++ ) {
//	draw_sprite_ext(PacMan_Right, 1 ,180 + (i * 32),630,1,1,0,c_white,1);	
//}

//// level
//draw_text(600, 620, string(oGameManager.level));

//if ((oGameManager.state == GameState.PLAY_GAME) && oGameManager.showInstructions) {
//	draw_set_color(c_black);
//	draw_set_alpha(0.5);
//	draw_rectangle(790,490,1020,660,false);
//	draw_set_alpha(1);

//	// Game Instructions
//	draw_set_font(fAtari6);
//	draw_set_color(c_white);

//	draw_text(800,500,"Hold 1 for FREEZE mode");
//	draw_text(800,520,"Hold 2 for TURBO mode");

//	draw_text(800,560,"I for Instructions");
//	draw_text(800,580,"R to reset/reload");
//	draw_text(800,600,"P to Pause/Unpause");
//	draw_text(800,620,"D to enable/disable DATA");
//	draw_text(800,640,"T to enable/disable TARGET");
//}

