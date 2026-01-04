instance_destroy(other);

global.Game.Controllers.audioManager.playSound(GCredit);

// adds half a second of shield per pickup
shieldTimer += 0.5; // 30 frames is 0.5 seconds at 60 fps

// MAX shield strength is 5 seconds ....
if (shieldTimer > 5) shieldTimer = 5;