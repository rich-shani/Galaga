if (global.isGamePaused) return;

y -= MISSILE_SPEED;

if (y < MISSILE_OFFSCREEN) instance_destroy();