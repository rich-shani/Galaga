enum TITLE_SCREEN {
	TITLE,
	HIGH_SCORE,
	INSTRUCTIONS
}

// start with the high score table shown ...
ScreenShown = TITLE_SCREEN.HIGH_SCORE;

// high score table colors
colors = [c_yellow, c_white, c_green, c_red, c_blue];
		
alarm[0] = 4*60;

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

player_x = 448;
player_y = 1024;

SHIP_MOVE_INCREMENT = 6;

animationIndex = 0;

// high score table colors
colors = [c_yellow, c_white, c_green, c_red, c_blue];

credits = 0;

// pre-fetch sprite sheets (to avoid game glitches)
var _sprites_to_load = [sTieFighter, sTieIntercepter, sImperialShuttle, xwing_sprite_sheet];
sprite_prefetch_multi(_sprites_to_load);