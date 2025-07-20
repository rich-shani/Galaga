if (global.isGamePaused) {
	return;
}

y -= missile_speed;

if (y < 0) instance_destroy();