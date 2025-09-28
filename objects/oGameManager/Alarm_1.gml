/// @description Handles the rendering of a ranking display using tiles for a high-score or level ranking system.
/// This script is executed in a Step or Draw event of a controller object to display the player's rank (e.g., in a high-score table).
/// It assumes the existence of a tile set (bkgd_Rank) with digit sprites, global variables (e.g., global.lvl, global.challcount), and controller variables (e.g., rank, start, nextlevel).
/// The display shows ones, tens, and hundreds digits at specific positions, with sound effects and level progression logic.

/// @section Rank Display Logic
// Check if the game level is greater than 0 and the rank is positive to display the ranking.
// global.lvl likely represents the current game level or wave; rank is the current rank being displayed.
if (global.lvl > 0 && rank > 0) {
    /// @subsection Ones Digit
    // Handle the ones digit of the rank when rank equals onerank (the ones component of the rank).
    if (rank == onerank) {
        // If the ones digit is greater than 4, use a specific tile from bkgd_Rank (offset 16,0; 16x32 pixels).
        // Positioned at x=440-(16*rank), y=544, depth=-10 to ensure visibility above other elements.
        if (one > 4) {
            tile_add(bkgd_Rank, 16, 0, 16, 32, 440*global.scale - (16 * rank), 544*global.scale, -10);
        }
        // Otherwise, use the default tile (offset 0,0) for digits 0-4.
        else {
            tile_add(bkgd_Rank, 0, 0, 16, 32, 440*global.scale - (16 * rank), 544*global.scale, -10);
        }
    }

    // Display the ones digit for ranks slightly below onerank (onerank-1 to onerank-4).
    // Uses the default tile (0,0) for consistency, adjusting the x-position based on rank.
    if (rank == onerank - 1) {
        tile_add(bkgd_Rank, 0, 0, 16, 32, 440*global.scale - (16 * rank), 544*global.scale, -10);
    }
    if (rank == onerank - 2) {
        tile_add(bkgd_Rank, 0, 0, 16, 32, 440*global.scale - (16 * rank), 544*global.scale, -10);
    }
    if (rank == onerank - 3) {
        tile_add(bkgd_Rank, 0, 0, 16, 32, 440*global.scale - (16 * rank), 544*global.scale, -10);
    }
    if (rank == onerank - 4) {
        tile_add(bkgd_Rank, 0, 0, 16, 32, 440*global.scale - (16 * rank), 544*global.scale, -10);
    }

    /// @subsection Tens Digit
    // Handle the tens digit when rank equals the sum of onerank and tenrank, and tenrank is positive.
    // tenrank likely represents the tens component of the rank.
    if (tenrank > 0 && rank == onerank + tenrank) {
        // For tens digit > 4, use a wider tile (128,0; 32x32 pixels) to accommodate larger digits.
        // Position adjusted by (onerank*16) to align with the ones digit.
        if (ten > 4) {
            tile_add(bkgd_Rank, 128, 0, 32, 32, 440*global.scale - (32 * rank) + (onerank * 16), 544*global.scale, -10);
        }
        // For tens digit 3 or 4, use tile at (96,0).
        if (ten == 3 || ten == 4) {
            tile_add(bkgd_Rank, 96, 0, 32, 32, 440*global.scale - (32 * rank) + (onerank * 16), 544*global.scale, -10);
        }
        // For tens digit 2, use tile at (64,0).
        if (ten == 2) {
            tile_add(bkgd_Rank, 64, 0, 32, 32, 440*global.scale - (32 * rank) + (onerank * 16), 544*global.scale, -10);
        }
        // For tens digit 1, use tile at (32,0).
        if (ten == 1) {
            tile_add(bkgd_Rank, 32, 0, 32, 32, 440*global.scale - (32 * rank) + (onerank * 16), 544*global.scale, -10);
        }
    }

    // Handle tens digit for ranks one less than onerank + tenrank, when tenrank > 1.
    if (tenrank > 1 && rank == onerank + tenrank - 1) {
        // For tens digit 8 or 9, use tile at (96,0).
        if (ten == 9 || ten == 8) {
            tile_add(bkgd_Rank, 96, 0, 32, 32, 440*global.scale - (32 * rank) + (onerank * 16), 544*global.scale, -10);
        }
        // For tens digit 7, use tile at (64,0).
        if (ten == 7) {
            tile_add(bkgd_Rank, 64, 0, 32, 32, 440*global.scale - (32 * rank) + (onerank * 16), 544*global.scale, -10);
        }
        // For tens digit 4 or 6, use tile at (32,0).
        if (ten == 6 || ten == 4) {
            tile_add(bkgd_Rank, 32, 0, 32, 32, 440*global.scale - (32 * rank) + (onerank * 16), 544*global.scale, -10);
        }
    }

    // Handle tens digit for ranks two less than onerank + tenrank, when tenrank > 2.
    if (tenrank > 2 && rank == onerank + tenrank - 2) {
        // For tens digit 9, use tile at (32,0).
        if (ten == 9) {
            tile_add(bkgd_Rank, 32, 0, 32, 32, 440*global.scale - (32 * rank) + (onerank * 16), 544*global.scale, -10);
        }
    }

    /// @subsection Hundreds Digit
    // Display the hundreds digit when rank exceeds the sum of onerank and tenrank.
    // Uses a wider tile (128,0; 32x32 pixels) for the hundreds place, positioned with the same offset logic.
    if (rank > tenrank + onerank) {
        tile_add(bkgd_Rank, 128, 0, 32, 32, 440*global.scale - (32 * rank) + (onerank * 16), 544*global.scale, -10);
    }

    /// @subsection Rank Update and Sound
    // Decrease the rank counter to progress through the ranking display (e.g., from highest to lowest).
    rank -= 1;

    // Play a ranking sound (GRank) if a challenge mode is active (global.challcount > 0) and the game is in the initial state (start == 0).
    // Likely used to provide audio feedback during the ranking display.
    if (global.challcount > 0) { //&& global.gameMode == GameMode.GAME_ACTIVE) {
        sound_play(GRank);
    }

    // Set alarm 1 to 7 steps (approximately 0.117 seconds at 60 FPS) to control the timing of rank updates.
    // Likely used to create a delay between displaying each rank for a smooth animation.
    alarm[1] = 7;
}

/// @section Level Progression
// When rank reaches 0, trigger the transition to the next level.
// Sets nextlevel to 2 to indicate the level transition state and sets alarm 10 to 50 steps (approximately 0.833 seconds).
// Likely used to pause briefly before advancing to the next wave or stage.
//if (rank == 0) {
//    nextlevel = 2;
//    alarm[10] = 50;
//}