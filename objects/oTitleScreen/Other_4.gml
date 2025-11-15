
// Stops all currently playing sounds to ensure a clean audio state at initialization.
// Prevents audio overlap from previous game states || sessions.
global.Game.Controllers.audioManager.stopAll();

global.Game.Controllers.audioManager.loopSound(Galaga_Theme_Remix_Short);

