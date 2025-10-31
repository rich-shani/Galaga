/// @description PLAYER HIT

// PLAYER explosion animation
instance_create(round(x), round(y), oExplosion3);

// screem shake ON
layer_set_visible("ScreenShake", true);

// PLAYER explosion sound
sound_stop(GDie); sound_play(GDie); 
			
// Update ship status to DEAD
shipStatus = _ShipState.DEAD;	

// move Ship location off-screen
// this addresses an edge condition with Enemy collision
// x = 224*global.scale*2;

// set timer (to pause before respawn, or game over)
alarm[0] = 120;