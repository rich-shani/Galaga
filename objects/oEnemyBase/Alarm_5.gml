/// @description enemy shooting logic 
// Handles enemy shooting logic based on level and shot number

// Only allow shooting if not on levels 1, 10, or 18
if (global.lvl == 1 || global.lvl == 10 || global.lvl == 18) {
    // No shooting on these levels
} else {
    // Shot logic based on shotnumber

    // If shotnumber is 2, allow up to 4 EnemyShot instances
    if (global.shotnumber == 2) {
        if instance_number(EnemyShot) < 4 {
            instance_create(x, y, EnemyShot);
        }
    }

    // If shotnumber is 3, allow up to 6 EnemyShot instances
    if (global.shotnumber == 3) {
        if instance_number(EnemyShot) < 6 {
            instance_create(x, y, EnemyShot);
        }
    }

    // If shotnumber is 4, allow up to 8 EnemyShot instances
    if (global.shotnumber == 4) {
        if instance_number(EnemyShot) < 8 {
            instance_create(x, y, EnemyShot);
        }
    }
}
