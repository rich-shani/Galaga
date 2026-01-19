/// @description TransPoints bonus display initialization
/// Creates a bonus points display that appears when combo conditions are met.
/// Awards bonus points based on transformation sequence or level progression.
///
/// Timer System:
///   • alarm[1] = 10: Delay before showing the bonus sprite (10 frames)
///   • alarm[0] = 70: Total display duration before destroying (70 frames)
///   • Draw event checks alarm[1] == -1 to know when to display
///
/// Scoring System:
///   Normal Mode (Challenge not active):
///     • transformNum = 1: +1000 points
///     • transformNum = 2: +2000 points
///     • transformNum = 3: +3000 points
///
///   Challenge Mode (Challenge active):
///     • Level < 11: +1000 points
///     • Level < 19: +1500 points
///     • Level < 27: +2000 points
///     • Level >= 27: +3000 points
///
/// Purpose:
///   • Rewards players for combo sequences (8 consecutive kills, 3 transformations)
///   • Provides visual feedback for bonus point awards
///   • Scales bonus with difficulty/level progression
///
/// @related oEnemyBase/Destroy_0.gml - Spawns TransPoints when combo conditions met
/// @related TransPoints/Draw_0.gml - Displays appropriate bonus sprite based on points

// Delay before showing the bonus display (10 frames = 0.167 seconds at 60 FPS)
alarm[1] = 10;

// Total display duration before destroying (70 frames = 1.167 seconds at 60 FPS)
alarm[0] = 70;

// Award bonus points based on game mode and conditions
if (!global.Game.Challenge.isActive) {
	// Normal mode: Points based on transformation sequence number
	// Higher transformation numbers = higher point values
	if global.Game.Enemy.transformNum = 1{global.Game.Player.score += 1000};
	if global.Game.Enemy.transformNum = 2{global.Game.Player.score += 2000};
	if global.Game.Enemy.transformNum = 3{global.Game.Player.score += 3000};
}
else {
	// Challenge mode: Points scale with current level
	// Higher levels = higher point values to maintain difficulty balance
	if global.Game.Level.current < 11{global.Game.Player.score += 1000}
	else{
		if global.Game.Level.current < 19{global.Game.Player.score += 1500}
		else{
			if global.Game.Level.current < 27{global.Game.Player.score += 2000}
			else{
				global.Game.Player.score += 3000
			}
		}
	}
}


