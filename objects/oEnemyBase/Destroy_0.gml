/// @description Destroy event for oTieFighter
/// Handles scoring, sound, and special effects when a Tie Fighter is destroyed.
if (!global.isGameOver) {
	// Check if the Enemy is within the visible play area or during challenge mode
	if (y < 592 * global.scale && x > -16 && x < 464 * global.scale) { // && (y > -16 * global.scale || global.challcount > 0)) {

		// If the Tie Fighter is diving
		if (enemyState == EnemyState.IN_DIVE_ATTACK) {
			oPlayer.alarm[4] = global.hold + irandom(global.hold);

			// If not in transformation state
			if (trans == 0) {
				// Award score based on challenge mode
				if (global.challcount > 0 || global.chall == 1) {
					global.p1score += attributes.DIVE_POINT_VALUE;
				} else {
					global.p1score += attributes.CHALLENGE_POINT_VALUE;
				}
			}
		} else {
			// Not diving, award standard score
			global.p1score += attributes.POINT_VALUE;
		}

		// Handle shot count and TransPoints creation outside challenge mode
		if global.challcount == 0 {
			global.shotcount += 1;
			if global.shotcount == 8 {
				instance_create(round(x), round(y), TransPoints);
			}
		}

		// If in transformation state
		if trans == 1 {
			global.transcount += 1;
			global.p1score += 160;

			// Create TransPoints after 3 transformations
			if global.transcount == 3 {
				instance_create(round(x), round(y), TransPoints);
			}

			// Play transformation sounds based on transnum
			if global.transnum == 1 {
				sound_stop(GBoss2);
				sound_play(GBoss2);
			}
			if global.transnum == 2 {
				sound_stop(GButterfly);
				sound_play(GButterfly);
			}
			if global.transnum == 3 {
				sound_stop(GBoss1);
				sound_play(GBoss1);
			}
		} else {
			// Play sounds based on challenge mode and challenge number
			if global.challcount > 0 || global.chall == 1 {
				sound_stop(GBee);
				sound_play(GBee);
			}

			if global.challcount == 0 {
				if global.chall == 2 || global.chall == 3 || global.chall == 5 || global.chall == 6 || global.chall == 8 {
					sound_stop(GButterfly);
					sound_play(GButterfly);
				}
				if global.chall == 4 {
					sound_stop(GBoss2);
					sound_play(GBoss2);
				}
				if global.chall == 7 {
					sound_stop(GBoss1);
					sound_play(GBoss1);
				}
			}
		}
	}
}
