function newlevel() {
	sound_stop(GBreathe); global.transside = 0;
	global.challcount = global.challcount + 1;
	if global.challcount < 4{
		///pattern
		if global.lvl = 1{global.pattern = 0}; if global.lvl = 2{global.pattern = 1}; if global.lvl = 4{global.pattern = 2};
		if global.lvl > 4{global.pattern = global.pattern - 1; if global.pattern = -1{global.pattern = 2}};
		///rogue
		if global.lvl > 3{global.rogue = 1}
		if global.lvl > 7{global.rogue = 2}
		if global.lvl > 11{global.rogue = 3}
		if global.lvl > 15{global.rogue = 4}
		if global.lvl = 10 or global.lvl = 18{global.rogue = 0};
		///fastenter
		if global.lvl > 7{global.fastenter = 1};
		if global.lvl = 10{global.fastenter = 0};
		///fast
		if global.lvl > 11{global.fast = 1};
		///shotnumber
		if global.lvl > 11{global.shotnumber = 3};
		if global.lvl > 19{global.shotnumber = 4};
		///bosscap
		if global.lvl > 11{global.bosscap = 3}
		if global.lvl > 19{global.bosscap = 4}
	}
	else{
		global.challcount = 0; sound_play(GChallenging);
		global.chall += 1; if global.chall = 9{global.chall = 1}; script_execute(challenging);
		///transnum
		global.transnum = global.transnum + 1; if global.transnum = 4{global.transnum = 1};
		///divecapstart
		if global.divecapstart < 6{global.divecapstart = global.divecapstart + 1};
		///last attack
		if global.lastattack < 8{global.lastattack = global.lastattack + 1};
		///beamtime
		if global.beamtime > 150{global.beamtime = global.beamtime - 50};
	}
	///hold
	global.hold -= 3; if global.hold < 1{global.hold = 1};
	///starspeed
	if global.lvl = 4 or global.lvl = 8 or global.lvl = 12{};

	///if keyboard_check_pressed(ord("1")) = true{global.transnum = global.transnum + 1; if global.transnum = 4{global.transnum = 0}};
	///if keyboard_check_pressed(ord("2")) = true{global.pattern = global.pattern + 1; if global.pattern = 3{global.pattern = 0}; room_restart();}
	///if keyboard_check_pressed(ord("3")) = true{global.fighterstore = global.fighterstore + 1; if global.fighterstore = 5{global.fighterstore = 0}};
	///if keyboard_check_pressed(ord("4")) = true{global.rogue = global.rogue + 1; if global.rogue = 5{global.rogue = 0}};
	///if keyboard_check_pressed(ord("5")) = true{global.fast = global.fast + 1; if global.fast = 2{global.fast = 0}};
	///if keyboard_check_pressed(ord("6")) = true{global.fastenter = global.fastenter + 1; if global.fastenter = 2{global.fastenter = 0}};
	///if keyboard_check_pressed(ord("7")) = true{global.shotnumber = global.shotnumber + 1; if global.shotnumber = 5{global.shotnumber = 2}}; //stage 6, stage 16,
	///if keyboard_check_pressed(ord("8")) = true{global.divecapstart = global.divecapstart + 1; if global.divecapstart = 7{global.divecapstart = 2}};
	///if keyboard_check_pressed(ord("9")) = true{global.lastattack = global.lastattack + 1; if global.lastattack = 9{global.lastattack = 4}};
	///if keyboard_check_pressed(ord("0")) = true{global.beamtime = global.beamtime - 50; if global.beamtime = 100{global.beamtime = 350}};
	///rogue = 
	///1 for 1 bee per side (stage 3), 
	///2 for 1 bee and 1 butterfly (stage 9),
	///3 for 2 bees and 1 butterfly (stage 12),
	///4 for 2 bees and 2 butterflies (stage 16)



}
