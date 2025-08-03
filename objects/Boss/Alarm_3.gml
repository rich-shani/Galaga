sound_stop(GBeam);

if Ship.shipStatus == ShipState.CAPTURED {ret = 1; loop = 0; alarm[4] = 90; sound_stop(GCaptured); sound_loop(GFighterCaptured)}


