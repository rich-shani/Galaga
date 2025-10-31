if (global.gameMode == GameMode.GAME_ACTIVE && oPlayer.shipStatus == _ShipState.ACTIVE) {
	if instance_number(EnemyShot) < 8{
		if global.shotnumber > 3 {
			instance_create(x,y,EnemyShot);
		}
	}
}