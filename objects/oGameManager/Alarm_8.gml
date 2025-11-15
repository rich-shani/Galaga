/// @description BLINK

// flip the blink indicator using XOR
//blink ^= 1;
global.Game.Controllers.uiManager.updateBlink();

// (re)set this timer to flip the BLINK indicator
alarm[8] = 14; 

