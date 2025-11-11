/// @description
/// 
/// This script is triggered by alarm[7]. On the first loop, it checks if the player has scored && plays a sound if so.
/// The alarm is then reset to trigger again after 633 steps. On subsequent loops, it increments the loop counter,
/// && restarts the room on the 4th loop. Otherwise, it continues resetting the alarm for the next cycle.
/// 
/// @global {number} loop - Tracks the current loop count for alarm[7].
/// @global {number} scored - Indicates if the player has scored (1 if true).
/// @function sound_loop(sound) - Plays the specified sound in a loop.
/// @function room_restart() - Restarts the current room.
/// @event alarm[7] - This script is executed when alarm[7] triggers.

// Check if this is the first loop
if loop == 0 {
	loop = 1; // Set loop to 1 to indicate first run
	if scored == 1 {
		sound_loop(G1stEnd633); // Play sound if scored
	}
	alarm[7] = 633; // Set alarm[7] to trigger again after 633 steps
	exit; // Exit the script
}
else {
	loop += 1; // Increment loop counter
	if loop == 4 {
		room_goto(TitleScreen);
	} 
	else {
		alarm[7] = 633; // Otherwise, set alarm[7] again
	}
	exit; // Exit the script
}