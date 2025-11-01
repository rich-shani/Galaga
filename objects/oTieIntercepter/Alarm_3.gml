sound_stop(GBeam);

if (oPlayer.shipStatus == _ShipState.CAPTURED) {
	ret = 1; 
	beam_weapon.state = BEAM_STATE.READY; 
	alarm[4] = 90; 
	
	sound_stop(GCaptured); 
	sound_loop(GFighterCaptured)
}