function UIManager() constructor {
    // Display state
    blinkCounter = 1;
    rankDisplaySprites = [];

    // Score digit display (hundreds, tens, ones)
    scoreDisplay = {
        hundreds: 0,
        tens: 0,
        ones: 0
    };

    // Rank digit display (hundreds, tens, ones)
    rankDisplay = {
        hundreds: 0,
        tens: 0,
        ones: 0
    };

    // Character global.Game.Input.characterCycle for high score entry
    characterCycle = "ABCDEFGHIJKLMNOPQRSTUVWXYZ .";

    // Update display digits from current score
    updateScoreDisplay = function(score) {
        scoreDisplay.ones = score mod 10;
        scoreDisplay.tens = (score div 10) mod 10;
        scoreDisplay.hundreds = (score div 100) mod 10;
    };

    // Update rank digits from current rank
    updateRankDisplay = function(rank) {
        rankDisplay.ones = rank mod 10;
        rankDisplay.tens = (rank div 10) mod 10;
        rankDisplay.hundreds = (rank div 100) mod 10;
    };

    // Tick blink counter
    updateBlink = function() {
        blinkCounter ^= 1;
    };

    // Check if UI should be visible (blinking effect)
    isVisible = function() {
        return blinkCounter;
    };
}