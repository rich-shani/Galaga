enum TITLE_SCREEN {
	TITLE,
	HIGH_SCORE
}

// start with the high score table shown ...
ScreenShown = TITLE_SCREEN.HIGH_SCORE;

var layerId = layer_get_id("Background");
if (layerId != -1) 
{
	backgroundId = layer_background_get_id(layerId);
}

// high score table colors
colors = [c_yellow, c_white, c_green, c_red, c_blue];
		
alarm[0] = 4*60;

global.scale = 2;