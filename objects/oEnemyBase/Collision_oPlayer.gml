/// @description Enemy-Player Collision
///

// process the collision, using Alarm 11 (as we can also call the hit from the player (DOUBLE SHOT mode)
alarm[11] = 1;

// Notify the PLAYER that it was HIT
if (oPlayer.alarm[11] < 0) {
	oPlayer.alarm[11] = 1;
}
