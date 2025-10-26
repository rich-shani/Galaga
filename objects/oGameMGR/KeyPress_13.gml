// Press Enter to start the Game (from the Title screen)
if (state == GameState.TITLE_SCREEN) {

	state = GameState.PLAY_GAME;
	room_goto(GalagaWars);
}