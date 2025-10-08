/// @description transition and dive logic
/// This event handles the transition and dive logic for the Tie Fighter enemy.
/// It sets up alarms, paths, and global variables for movement and behavior.

// Set transition and dive flags
trans = 1;
dive = 1;

// Set global prohibition flag and start game manager alarm
global.prohib = 1;
oGameManager.alarm[0] = 15;

// Set local alarm for this object
alarm[1] = 75;

// Choose path based on starting x position
if (xstart > 224*global.scale) {
    // Start normal Bee1 path and set transition side to right
    path_start(Bee1, spd * global.scale, 0, false);
    global.transside = 1;
} else {
    // Start flipped Bee1 path and set transition side to left
    path_start(Bee1Flip, spd * global.scale, 0, false);
    global.transside = 0;
}

// Set alarm[3] based on transition number
if (global.transnum == 1) {
    alarm[3] = 44;
}
if (global.transnum == 2) {
    alarm[3] = 25;
}
if (global.transnum == 3) {
    alarm[3] = 66;
}
