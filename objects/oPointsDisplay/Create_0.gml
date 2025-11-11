/// @description Initialize point display with configurable sprite frame
/// Instance variable 'spriteFrame' should be passed during instance_create_layer

// Validate spriteFrame was provided
if (!variable_instance_exists(id, "spriteFrame")) {
    log_error("oPointsDisplay created without spriteFrame parameter", "oPointsDisplay Create", 2);
    spriteFrame = 0;  // Default to 150 points
}

alarm[1] = 10;  // Delay before showing
alarm[0] = 70;  // Destroy after display