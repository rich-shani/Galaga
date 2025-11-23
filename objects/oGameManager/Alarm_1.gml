/// @description Handles the rendering of a ranking display using sprite data for draw event
/// This alarm builds up an array of sprite information that will be rendered in the Draw event
/// The display shows ones, tens, && hundreds digits at specific positions with sound effects

/// @section Rank Display Logic
// Check if the game level is greater than 0 && the rank is positive to display the ranking
if (global.Game.Level.current > 0 && rank > 0) {

    /// @subsection Ones Digit
    // Handle the ones digit of the rank when rank equals global.Game.Controllers.uiManager.rankDisplay.ones (the ones component of the rank)
    if (rank == global.Game.Controllers.uiManager.rankDisplay.ones) {
        // If the ones digit is greater than 4, use sprite section at offset (16,0; 16x32 pixels)
        if (global.Game.Controllers.uiManager.scoreDisplay.ones > 4) {
            array_push(global.Game.Controllers.uiManager.rankDisplaySprites, {
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
            array_push(global.Game.Controllers.uiManager.rankDisplaySprites, {
                sprite_x: 0,
                sprite_y: 0,
                sprite_width: 32,
                sprite_height: 64,
                x_pos: 440 * global.Game.Display.scale - (32 * rank),
                y_pos: 544 * global.Game.Display.scale
            });
        }
    }

    // Display the ones digit for ranks slightly below global.Game.Controllers.uiManager.rankDisplay.ones (global.Game.Controllers.uiManager.rankDisplay.ones-1 to global.Game.Controllers.uiManager.rankDisplay.ones-4)
    // Uses the default sprite section (0,0) for consistency, adjusting the x-position based on rank
    if (rank == global.Game.Controllers.uiManager.rankDisplay.ones - 1) {
        array_push(global.Game.Controllers.uiManager.rankDisplaySprites, {
            sprite_x: 0,
            sprite_y: 0,
            sprite_width: 32,
            sprite_height: 64,
            x_pos: 440 * global.Game.Display.scale - (32 * rank),
            y_pos: 544 * global.Game.Display.scale
        });
    }
    if (rank == global.Game.Controllers.uiManager.rankDisplay.ones - 2) {
        array_push(global.Game.Controllers.uiManager.rankDisplaySprites, {
            sprite_x: 0,
            sprite_y: 0,
            sprite_width: 32,
            sprite_height: 64,
            x_pos: 440 * global.Game.Display.scale - (32 * rank),
            y_pos: 544 * global.Game.Display.scale
        });
    }
    if (rank == global.Game.Controllers.uiManager.rankDisplay.ones - 3) {
        array_push(global.Game.Controllers.uiManager.rankDisplaySprites, {
            sprite_x: 0,
            sprite_y: 0,
            sprite_width: 32,
            sprite_height: 64,
            x_pos: 440 * global.Game.Display.scale - (32 * rank),
            y_pos: 544 * global.Game.Display.scale
        });
    }
    if (rank == global.Game.Controllers.uiManager.rankDisplay.ones - 4) {
        array_push(global.Game.Controllers.uiManager.rankDisplaySprites, {
            sprite_x: 0,
            sprite_y: 0,
            sprite_width: 32,
            sprite_height: 64,
            x_pos: 440 * global.Game.Display.scale - (32 * rank),
            y_pos: 544 * global.Game.Display.scale
        });
    }

    /// @subsection Tens Digit
    // Handle the tens digit when rank equals the sum of global.Game.Controllers.uiManager.rankDisplay.ones && global.Game.Controllers.uiManager.rankDisplay.tens, && global.Game.Controllers.uiManager.rankDisplay.tens is positive
    if (global.Game.Controllers.uiManager.rankDisplay.tens > 0 && rank == global.Game.Controllers.uiManager.rankDisplay.ones + global.Game.Controllers.uiManager.rankDisplay.tens) {
        // For tens digit > 4, use wider sprite section (128,0; 32x32 pixels) to accommodate larger digits
        // Position adjusted by (global.Game.Controllers.uiManager.rankDisplay.ones*16) to align with the ones digit
        if (global.Game.Controllers.uiManager.scoreDisplay.tens > 4) {
            array_push(global.Game.Controllers.uiManager.rankDisplaySprites, {
                sprite_x: 256,
                sprite_y: 0,
                sprite_width: 64,
                sprite_height: 64,
                x_pos: 440 * global.Game.Display.scale - (64 * rank) + (global.Game.Controllers.uiManager.rankDisplay.ones * 32),
                y_pos: 544 * global.Game.Display.scale
            });
        }
        // For tens digit 3 || 4, use sprite section at (96,0)
        if (global.Game.Controllers.uiManager.scoreDisplay.tens == 3 || global.Game.Controllers.uiManager.scoreDisplay.tens == 4) {
            array_push(global.Game.Controllers.uiManager.rankDisplaySprites, {
                sprite_x: 192,
                sprite_y: 0,
                sprite_width: 64,
                sprite_height: 64,
                x_pos: 440 * global.Game.Display.scale - (64 * rank) + (global.Game.Controllers.uiManager.rankDisplay.ones * 32),
                y_pos: 544 * global.Game.Display.scale
            });
        }
        // For tens digit 2, use sprite section at (64,0)
        if (global.Game.Controllers.uiManager.scoreDisplay.tens == 2) {
            array_push(global.Game.Controllers.uiManager.rankDisplaySprites, {
                sprite_x: 128,
                sprite_y: 0,
                sprite_width: 64,
                sprite_height: 64,
                x_pos: 440 * global.Game.Display.scale - (64 * rank) + (global.Game.Controllers.uiManager.rankDisplay.ones * 32),
                y_pos: 544 * global.Game.Display.scale
            });
        }
        // For tens digit 1, use sprite section at (32,0)
        if (global.Game.Controllers.uiManager.scoreDisplay.tens == 1) {
            array_push(global.Game.Controllers.uiManager.rankDisplaySprites, {
                sprite_x: 64,
                sprite_y: 0,
                sprite_width: 64,
                sprite_height: 64,
                x_pos: 440 * global.Game.Display.scale - (64 * rank) + (global.Game.Controllers.uiManager.rankDisplay.ones * 32),
                y_pos: 544 * global.Game.Display.scale
            });
        }
    }

    // Handle tens digit for ranks global.Game.Controllers.uiManager.scoreDisplay.ones less than global.Game.Controllers.uiManager.rankDisplay.ones + global.Game.Controllers.uiManager.rankDisplay.tens, when global.Game.Controllers.uiManager.rankDisplay.tens > 1
    if (global.Game.Controllers.uiManager.rankDisplay.tens > 1 && rank == global.Game.Controllers.uiManager.rankDisplay.ones + global.Game.Controllers.uiManager.rankDisplay.tens - 1) {
        // For tens digit 8 || 9, use sprite section at (96,0)
        if (global.Game.Controllers.uiManager.scoreDisplay.tens == 9 || global.Game.Controllers.uiManager.scoreDisplay.tens == 8) {
            array_push(global.Game.Controllers.uiManager.rankDisplaySprites, {
                sprite_x: 192,
                sprite_y: 0,
                sprite_width: 64,
                sprite_height: 64,
                x_pos: 440 * global.Game.Display.scale - (64 * rank) + (global.Game.Controllers.uiManager.rankDisplay.ones * 32),
                y_pos: 544 * global.Game.Display.scale
            });
        }
        // For tens digit 7, use sprite section at (64,0)
        if (global.Game.Controllers.uiManager.scoreDisplay.tens == 7) {
            array_push(global.Game.Controllers.uiManager.rankDisplaySprites, {
                sprite_x: 128,
                sprite_y: 0,
                sprite_width: 64,
                sprite_height: 64,
                x_pos: 440 * global.Game.Display.scale - (64 * rank) + (global.Game.Controllers.uiManager.rankDisplay.ones * 32),
                y_pos: 544 * global.Game.Display.scale
            });
        }
        // For tens digit 4 || 6, use sprite section at (32,0)
        if (global.Game.Controllers.uiManager.scoreDisplay.tens == 6 || global.Game.Controllers.uiManager.scoreDisplay.tens == 4) {
            array_push(global.Game.Controllers.uiManager.rankDisplaySprites, {
                sprite_x: 64,
                sprite_y: 0,
                sprite_width: 64,
                sprite_height: 64,
                x_pos: 440 * global.Game.Display.scale - (64 * rank) + (global.Game.Controllers.uiManager.rankDisplay.ones * 32),
                y_pos: 544 * global.Game.Display.scale
            });
        }
    }

    // Handle tens digit for ranks two less than global.Game.Controllers.uiManager.rankDisplay.ones + global.Game.Controllers.uiManager.rankDisplay.tens, when global.Game.Controllers.uiManager.rankDisplay.tens > 2
    if (global.Game.Controllers.uiManager.rankDisplay.tens > 2 && rank == global.Game.Controllers.uiManager.rankDisplay.ones + global.Game.Controllers.uiManager.rankDisplay.tens - 2) {
        // For tens digit 9, use sprite section at (32,0)
        if (global.Game.Controllers.uiManager.scoreDisplay.tens == 9) {
            array_push(global.Game.Controllers.uiManager.rankDisplaySprites, {
                sprite_x: 64,
                sprite_y: 0,
                sprite_width: 64,
                sprite_height: 64,
                x_pos: 440 * global.Game.Display.scale - (64 * rank) + (global.Game.Controllers.uiManager.rankDisplay.ones * 32),
                y_pos: 544 * global.Game.Display.scale
            });
        }
    }

    /// @subsection Hundreds Digit
    // Display the hundreds digit when rank exceeds the sum of global.Game.Controllers.uiManager.rankDisplay.ones && global.Game.Controllers.uiManager.rankDisplay.tens
    // Uses a wider sprite section (128,0; 32x32 pixels) for the hundreds place
    if (rank > global.Game.Controllers.uiManager.rankDisplay.tens + global.Game.Controllers.uiManager.rankDisplay.ones) {
        array_push(global.Game.Controllers.uiManager.rankDisplaySprites, {
            sprite_x: 256,
            sprite_y: 0,
            sprite_width: 64,
            sprite_height: 64,
            x_pos: 440 * global.Game.Display.scale - (64 * rank) + (global.Game.Controllers.uiManager.rankDisplay.ones * 32),
            y_pos: 544 * global.Game.Display.scale
        });
    }

    /// @subsection Rank Update && Sound
    // Decrease the rank counter to progress through the ranking display
    rank -= 1;

    // Play a ranking sound (GRank) if a challenge mode is active
    if (global.Game.Challenge.countdown > 0) {
        global.Game.Controllers.audioManager.playSound(GRank);
    }

    // Set alarm 1 to 7 steps to control the timing of rank updates
    // Creates a delay between displaying each rank for a smooth animation
    alarm[AlarmIndex.RANK_UPDATE] = 7;
}

/// @section Level Progression
// When rank reaches 0, transition is handled by game state manager
