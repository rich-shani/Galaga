/// @description Handles the rendering of a ranking display using sprite data for draw event
/// This alarm builds up an array of sprite information that will be rendered in the Draw event
/// The display shows ones, tens, and hundreds digits at specific positions with sound effects

/// @section Rank Display Logic
// Check if the game level is greater than 0 and the rank is positive to display the ranking
if (global.Game.Level.current > 0 && rank > 0) {

    /// @subsection Ones Digit
    // Handle the ones digit of the rank when rank equals onerank (the ones component of the rank)
    if (rank == onerank) {
        // If the ones digit is greater than 4, use sprite section at offset (16,0; 16x32 pixels)
        if (one > 4) {
            array_push(rank_display_sprites, {
                sprite_x: 32,
                sprite_y: 0,
                sprite_width: 32,
                sprite_height: 64,
                x_pos: 440 * global.Game.Display.scale - (32 * rank),
                y_pos: 544 * global.Game.Display.scale
            });
        }
        // Otherwise, use the default sprite section (0,0) for digits 0-4
        else {
            array_push(rank_display_sprites, {
                sprite_x: 0,
                sprite_y: 0,
                sprite_width: 32,
                sprite_height: 64,
                x_pos: 440 * global.Game.Display.scale - (32 * rank),
                y_pos: 544 * global.Game.Display.scale
            });
        }
    }

    // Display the ones digit for ranks slightly below onerank (onerank-1 to onerank-4)
    // Uses the default sprite section (0,0) for consistency, adjusting the x-position based on rank
    if (rank == onerank - 1) {
        array_push(rank_display_sprites, {
            sprite_x: 0,
            sprite_y: 0,
            sprite_width: 32,
            sprite_height: 64,
            x_pos: 440 * global.Game.Display.scale - (32 * rank),
            y_pos: 544 * global.Game.Display.scale
        });
    }
    if (rank == onerank - 2) {
        array_push(rank_display_sprites, {
            sprite_x: 0,
            sprite_y: 0,
            sprite_width: 32,
            sprite_height: 64,
            x_pos: 440 * global.Game.Display.scale - (32 * rank),
            y_pos: 544 * global.Game.Display.scale
        });
    }
    if (rank == onerank - 3) {
        array_push(rank_display_sprites, {
            sprite_x: 0,
            sprite_y: 0,
            sprite_width: 32,
            sprite_height: 64,
            x_pos: 440 * global.Game.Display.scale - (32 * rank),
            y_pos: 544 * global.Game.Display.scale
        });
    }
    if (rank == onerank - 4) {
        array_push(rank_display_sprites, {
            sprite_x: 0,
            sprite_y: 0,
            sprite_width: 32,
            sprite_height: 64,
            x_pos: 440 * global.Game.Display.scale - (32 * rank),
            y_pos: 544 * global.Game.Display.scale
        });
    }

    /// @subsection Tens Digit
    // Handle the tens digit when rank equals the sum of onerank and tenrank, and tenrank is positive
    if (tenrank > 0 && rank == onerank + tenrank) {
        // For tens digit > 4, use wider sprite section (128,0; 32x32 pixels) to accommodate larger digits
        // Position adjusted by (onerank*16) to align with the ones digit
        if (ten > 4) {
            array_push(rank_display_sprites, {
                sprite_x: 256,
                sprite_y: 0,
                sprite_width: 64,
                sprite_height: 64,
                x_pos: 440 * global.Game.Display.scale - (64 * rank) + (onerank * 32),
                y_pos: 544 * global.Game.Display.scale
            });
        }
        // For tens digit 3 or 4, use sprite section at (96,0)
        if (ten == 3 || ten == 4) {
            array_push(rank_display_sprites, {
                sprite_x: 192,
                sprite_y: 0,
                sprite_width: 64,
                sprite_height: 64,
                x_pos: 440 * global.Game.Display.scale - (64 * rank) + (onerank * 32),
                y_pos: 544 * global.Game.Display.scale
            });
        }
        // For tens digit 2, use sprite section at (64,0)
        if (ten == 2) {
            array_push(rank_display_sprites, {
                sprite_x: 128,
                sprite_y: 0,
                sprite_width: 64,
                sprite_height: 64,
                x_pos: 440 * global.Game.Display.scale - (64 * rank) + (onerank * 32),
                y_pos: 544 * global.Game.Display.scale
            });
        }
        // For tens digit 1, use sprite section at (32,0)
        if (ten == 1) {
            array_push(rank_display_sprites, {
                sprite_x: 64,
                sprite_y: 0,
                sprite_width: 64,
                sprite_height: 64,
                x_pos: 440 * global.Game.Display.scale - (64 * rank) + (onerank * 32),
                y_pos: 544 * global.Game.Display.scale
            });
        }
    }

    // Handle tens digit for ranks one less than onerank + tenrank, when tenrank > 1
    if (tenrank > 1 && rank == onerank + tenrank - 1) {
        // For tens digit 8 or 9, use sprite section at (96,0)
        if (ten == 9 || ten == 8) {
            array_push(rank_display_sprites, {
                sprite_x: 192,
                sprite_y: 0,
                sprite_width: 64,
                sprite_height: 64,
                x_pos: 440 * global.Game.Display.scale - (64 * rank) + (onerank * 32),
                y_pos: 544 * global.Game.Display.scale
            });
        }
        // For tens digit 7, use sprite section at (64,0)
        if (ten == 7) {
            array_push(rank_display_sprites, {
                sprite_x: 128,
                sprite_y: 0,
                sprite_width: 64,
                sprite_height: 64,
                x_pos: 440 * global.Game.Display.scale - (64 * rank) + (onerank * 32),
                y_pos: 544 * global.Game.Display.scale
            });
        }
        // For tens digit 4 or 6, use sprite section at (32,0)
        if (ten == 6 || ten == 4) {
            array_push(rank_display_sprites, {
                sprite_x: 64,
                sprite_y: 0,
                sprite_width: 64,
                sprite_height: 64,
                x_pos: 440 * global.Game.Display.scale - (64 * rank) + (onerank * 32),
                y_pos: 544 * global.Game.Display.scale
            });
        }
    }

    // Handle tens digit for ranks two less than onerank + tenrank, when tenrank > 2
    if (tenrank > 2 && rank == onerank + tenrank - 2) {
        // For tens digit 9, use sprite section at (32,0)
        if (ten == 9) {
            array_push(rank_display_sprites, {
                sprite_x: 64,
                sprite_y: 0,
                sprite_width: 64,
                sprite_height: 64,
                x_pos: 440 * global.Game.Display.scale - (64 * rank) + (onerank * 32),
                y_pos: 544 * global.Game.Display.scale
            });
        }
    }

    /// @subsection Hundreds Digit
    // Display the hundreds digit when rank exceeds the sum of onerank and tenrank
    // Uses a wider sprite section (128,0; 32x32 pixels) for the hundreds place
    if (rank > tenrank + onerank) {
        array_push(rank_display_sprites, {
            sprite_x: 256,
            sprite_y: 0,
            sprite_width: 64,
            sprite_height: 64,
            x_pos: 440 * global.Game.Display.scale - (64 * rank) + (onerank * 32),
            y_pos: 544 * global.Game.Display.scale
        });
    }

    /// @subsection Rank Update and Sound
    // Decrease the rank counter to progress through the ranking display
    rank -= 1;

    // Play a ranking sound (GRank) if a challenge mode is active
    if (global.Game.Challenge.count > 0) {
        sound_play(GRank);
    }

    // Set alarm 1 to 7 steps to control the timing of rank updates
    // Creates a delay between displaying each rank for a smooth animation
    alarm[AlarmIndex.RANK_UPDATE] = 7;
}

/// @section Level Progression
// When rank reaches 0, transition can be triggered
// (Original code commented out - may be handled elsewhere)
//if (rank == 0) {
//    nextlevel = 2;
//    alarm[10] = 50;
//}
