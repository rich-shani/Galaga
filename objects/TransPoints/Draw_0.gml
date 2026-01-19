/// @description TransPoints bonus visual display
/// Draws the appropriate bonus points sprite based on game mode and conditions.
/// Only displays after initial delay (alarm[1] expires) to prevent instant flash.
///
/// Display Logic:
///   • Waits for alarm[1] == -1 (10 frame delay from Create event)
///   • Selects sprite frame based on point value awarded
///   • Sprite frame corresponds to point values:
///     - Frame 3: 1000 points
///     - Frame 4: 1500 points
///     - Frame 6: 2000 points
///     - Frame 7: 3000 points
///
/// Normal Mode (Challenge not active):
///   • Frame selection based on transformation sequence number (transformNum)
///   • transformNum 1 → Frame 3 (1000 pts)
///   • transformNum 2 → Frame 6 (2000 pts)
///   • transformNum 3 → Frame 7 (3000 pts)
///
/// Challenge Mode (Challenge active):
///   • Frame selection based on current level
///   • Level < 11 → Frame 3 (1000 pts)
///   • Level < 19 → Frame 4 (1500 pts)
///   • Level < 27 → Frame 6 (2000 pts)
///   • Level >= 27 → Frame 7 (3000 pts)
///
/// Rendering:
///   • Uses global.Game.Display.scale for proper scaling across resolutions
///   • Full color (c_white) with full alpha (1.0)
///   • No rotation (0 degrees)
///
/// @var spr_Galagapoints - Sprite asset containing point value displays
/// @related TransPoints/Create_0.gml - Awards points and sets timers
/// @related TransPoints/Alarm_0.gml - Destroys after display duration

// Only draw after initial delay has expired (prevents instant flash)
if alarm[1] = -1 {
	if (!global.Game.Challenge.isActive) {
		// Normal mode: Display based on transformation sequence number
		// Sprite frame corresponds to point value awarded in Create event
		if global.Game.Enemy.transformNum = 1 {
			// 1000 points bonus
			draw_sprite_ext(spr_Galagapoints,3,x,y,global.Game.Display.scale,global.Game.Display.scale,0,c_white,1);
		}
		else if global.Game.Enemy.transformNum = 2 {
			// 2000 points bonus
			draw_sprite_ext(spr_Galagapoints,6,x,y,global.Game.Display.scale,global.Game.Display.scale,0,c_white,1);
		}
		else if global.Game.Enemy.transformNum = 3 {
			// 3000 points bonus
			draw_sprite_ext(spr_Galagapoints,7,x,y,global.Game.Display.scale,global.Game.Display.scale,0,c_white,1);
		}
	}
	else {
		// Challenge mode: Display based on current level progression
		// Sprite frame corresponds to point value awarded in Create event
		if global.Game.Level.current < 11 {
			// 1000 points bonus (early levels)
			draw_sprite_ext(spr_Galagapoints,3,x,y,global.Game.Display.scale,global.Game.Display.scale,0,c_white,1);
		} 
		else if global.Game.Level.current < 19 {
			// 1500 points bonus (mid-levels)
			draw_sprite_ext(spr_Galagapoints,4,x,y,global.Game.Display.scale,global.Game.Display.scale,0,c_white,1);
		} 
		else if global.Game.Level.current < 27 {
			// 2000 points bonus (high-levels)
			draw_sprite_ext(spr_Galagapoints,6,x,y,global.Game.Display.scale,global.Game.Display.scale,0,c_white,1);
		} 
		else {
			// 3000 points bonus (max-levels)
			draw_sprite_ext(spr_Galagapoints,7,x,y,global.Game.Display.scale,global.Game.Display.scale,0,c_white,1);
		}
	}
}