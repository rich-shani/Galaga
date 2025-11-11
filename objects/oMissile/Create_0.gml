/// @section Macros for Game Constants

// Off-screen coordinate for shots (-32 ensures shots are not visible/processed).
MISSILE_OFFSCREEN = -32;
// Speed of shots in pixels per step (12 pixels for consistent movement).
MISSILE_SPEED = 24;

// Play shooting sound
sound_stop(GShot);
sound_play(GShot);