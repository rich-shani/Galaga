// set at instance creation (from oSplashScreen)
w = 0;
h = 0;
duration = 0;
targetRoom = 0;
c = c_white;

// local variables
timer = 0;
alpha = 0;

enum ScreenState {
	FADE_IN,
	FADE_OUT
}

// initial mode is to FADE IN
state = ScreenState.FADE_IN;