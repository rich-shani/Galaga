function newlevel() {
	sound_stop(GBreathe); global.transside = 0;
	global.Game.Challenge.count = global.Game.Challenge.count + 1;
	
	if global.Game.Challenge.count < LEVEL_CHALLENGE_THRESHOLD {
		///pattern
		if global.Game.Level.current = 1{global.Game.Level.pattern = 0;};
		if global.Game.Level.current = 2{global.Game.Level.pattern = 1;};
		if global.Game.Level.current = 4{global.Game.Level.pattern = 2;};
		if global.Game.Level.current > 4{
			global.Game.Level.pattern = global.Game.Level.pattern - 1;
			if global.Game.Level.pattern = -1{global.Game.Level.pattern = 2;}
		};

		// === LEVEL PROGRESSION - Dynamic difficulty scaling ===
		// Each threshold activates new enemy behaviors and game mechanics

		if (global.Game.Level.current > LEVEL_ROGUE_1_START) {
			global.Game.Rogue.level = 1;
		}

		if (global.Game.Level.current > LEVEL_ROGUE_2_START) {
			global.Game.Rogue.level = 2;
			global.Game.State.fastEnter = 1;
		}

		if (global.Game.Level.current == LEVEL_FASTENTER_RESET) {
			// Reset difficulty parameters at level 10
			global.Game.State.fastEnter = 0;
			global.Game.Rogue.level = 1;
		}

		if (global.Game.Level.current > LEVEL_ROGUE_3_START) {
			global.Game.Rogue.level = 3;
			global.Game.State.fast = 1;
			global.shotnumber = 3;
			global.bosscap = 2;
		}

		if (global.Game.Level.current > LEVEL_ROGUE_4_START) {
			global.Game.Rogue.level = 4;
		}

		if (global.Game.Level.current > LEVEL_ADVANCED_SHOTS) {
			global.shotnumber = 4;
			global.bosscap = 4;
		}

		// Calculate progressive speed multiplier based on level
		var curve = speed_curves.SPEED_CURVE.LEVEL_MULTIPLIERS;
		global.Game.Difficulty.speedMultiplier = 1.0;

		for (var i = 0; i < array_length(curve); i++) {
			if (global.Game.Level.current >= curve[i].LEVEL) {
				global.Game.Difficulty.speedMultiplier = curve[i].MULTIPLIER;
			}
		}

		global.Game.Challenge.isActive = false;
		global.Game.State.mode = GameMode.GAME_STAGE_MESSAGE;
	}
	else{
		global.Game.Challenge.isActive = true;

		// reset shot counter for challenge stage(s)
		global.Game.Player.shotTotal = 0;

		global.Game.State.mode = GameMode.CHALLENGE_STAGE_MESSAGE;
		
		global.Game.Challenge.count = 0; sound_play(GChallenging);
		global.Game.Challenge.current += 1; if global.Game.Challenge.current = 9{global.Game.Challenge.current = 1}; script_execute(challenging);
		///transnum
		global.Game.Enemy.transformNum = global.Game.Enemy.transformNum + 1; if global.Game.Enemy.transformNum = 4{global.Game.Enemy.transformNum = 1};
		///divecapstart
		if global.Game.Enemy.diveCapacityStart < 6{global.Game.Enemy.diveCapacityStart = global.Game.Enemy.diveCapacityStart + 1};
		///last attack
		if global.Game.State.lastAttack < 8{global.Game.State.lastAttack = global.Game.State.lastAttack + 1};
		///beamtime - reduce as we advance per challenge stage, ie makes it harder to be captured as the BEAM time will reduce from 300, to 250, to 200, to 150
		if global.Game.Enemy.beamDuration > 150{global.Game.Enemy.beamDuration = global.Game.Enemy.beamDuration - 50};
	}

	///hold
	global.Game.State.hold -= 3; if global.Game.State.hold < 1{global.Game.State.hold = 1};
	///starspeed
	if global.Game.Level.current = 4 || global.Game.Level.current = 8 || global.Game.Level.current = 12{};

	///if keyboard_check_pressed(ord("1")) = true{global.Game.Enemy.transformNum = global.Game.Enemy.transformNum + 1; if global.Game.Enemy.transformNum = 4{global.Game.Enemy.transformNum = 0}};
	///if keyboard_check_pressed(ord("2")) = true{global.Game.Level.pattern = global.Game.Level.pattern + 1; if global.Game.Level.pattern = 3{global.Game.Level.pattern = 0}; room_restart();}
	///if keyboard_check_pressed(ord("3")) = true{global.fighterstore = global.fighterstore + 1; if global.fighterstore = 5{global.fighterstore = 0}};
	///if keyboard_check_pressed(ord("4")) = true{global.Game.Rogue.level = global.Game.Rogue.level + 1; if global.Game.Rogue.level = 5{global.Game.Rogue.level = 0}};
	///if keyboard_check_pressed(ord("5")) = true{global.Game.State.fast = global.Game.State.fast + 1; if global.Game.State.fast = 2{global.Game.State.fast = 0}};
	///if keyboard_check_pressed(ord("6")) = true{global.Game.State.fastEnter = global.Game.State.fastEnter + 1; if global.Game.State.fastEnter = 2{global.Game.State.fastEnter = 0}};
	///if keyboard_check_pressed(ord("7")) = true{global.shotnumber = global.shotnumber + 1; if global.shotnumber = 5{global.shotnumber = 2}}; //stage 6, stage 16,
	///if keyboard_check_pressed(ord("8")) = true{global.Game.Enemy.diveCapacityStart = global.Game.Enemy.diveCapacityStart + 1; if global.Game.Enemy.diveCapacityStart = 7{global.Game.Enemy.diveCapacityStart = 2}};
	///if keyboard_check_pressed(ord("9")) = true{global.Game.State.lastAttack = global.Game.State.lastAttack + 1; if global.Game.State.lastAttack = 9{global.Game.State.lastAttack = 4}};
	///if keyboard_check_pressed(ord("0")) = true{global.Game.Enemy.beamDuration = global.Game.Enemy.beamDuration - 50; if global.Game.Enemy.beamDuration = 100{global.Game.Enemy.beamDuration = 350}};
	///rogue = 
	///1 for 1 bee per side (stage 3), 
	///2 for 1 bee && 1 butterfly (stage 9),
	///3 for 2 bees && 1 butterfly (stage 12),
	///4 for 2 bees && 2 butterflies (stage 16)



}
