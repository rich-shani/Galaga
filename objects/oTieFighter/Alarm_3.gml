/// @description spit logic and transformation
/// Handles spit logic and transformation spawning

// Check if spit equals 2
if (spit == 2) {
    // Set path speed based on global scale
    path_speed = 3 * global.scale;
} else {
    // Increment spit counter
    spit = spit + 1;

    // Spawn a Transform instance at current position
    instance_create(x, y, Transform);

    // If less than 3 transformations have occurred
    if (global.transnum < 3) {
        // Stop movement
        path_speed = 0;

        // Set alarm[3] based on transformation count
        if (global.transnum == 1) {
            alarm[3] = 11;
        } else {
            // If only one Transform exists, set alarm to 9, otherwise 8
            if (instance_number(Transform) == 1) {
                alarm[3] = 9;
            } else {
                alarm[3] = 8;
            }
        }
    } else {
        // If 3 or more transformations, set alarm to 7
        alarm[3] = 7;
    }
}


