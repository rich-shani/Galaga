switch (state) {
	case ScreenState.FADE_IN:
		timer++;
		
		// did we reach the timer duration?
		if (timer >= duration) {	
			state = ScreenState.FADE_OUT;
		}
		break;
	case ScreenState.FADE_OUT:
		timer--;
		
		if (timer <= 0) {
			instance_destroy();
						
			room_goto(targetRoom);

		}
		break;
}

// set alpha based on the timer (ie between 0, and 1)
alpha = (duration-timer)/duration;