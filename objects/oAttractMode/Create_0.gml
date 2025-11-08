// Blip counter, initialized to 0.
// Likely used for short visual or audio effects, such as UI blinking or sound triggers.
hitFlag = 0;

/// @section Attract Mode
// Pause flag for attract mode, initialized to 0.
// When non-zero, likely pauses attract mode animations or transitions.
attpause = 0;

// Flag to indicate if a shot is active in attract mode (0 = no shot, 1 = shot active).
attshot = 0;

// Y-coordinate of the attract mode shot, initialized to 0.
// Used to position a demo shot during attract mode rendering.
attshoty = 0;

// X-coordinate of the attract mode shot, initialized to 0.
// Used alongside attshoty for rendering a shot in attract mode.
attshotx = 0;

// Attract mode state or timer, initialized to 0.
// Likely incremented to control the sequence of events in attract mode (e.g., demo ship movement).
sequence = 0;

// x position target for Ship
shipXPosTarget = 0;

/// @section Timers
// Alarm 3 set to 60 steps (typically 1 second at 60 FPS).
// Likely used for timing boss beam mechanics or other timed events.
alarm[3] = 60;

/// @section Movement
// Initial direction of the controller or related object, set to 90 degrees (upward).
// Possibly used for enemy or shot movement in attract mode or specific mechanics.
direction = 90;

// high score table colors
colors = [c_yellow, c_white, c_green, c_red, c_blue];
	
// pre-fetch sprite sheets (to avoid game glitches)
var _sprites_to_load = [sTieFighter, sTieIntercepter, sImperialShuttle, xwing_sprite_sheet];
sprite_prefetch_multi(_sprites_to_load);