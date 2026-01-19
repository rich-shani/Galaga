/// @description Points display delay timer
/// Timer event that marks when the points display should become visible.
///
/// Timer System:
///   • Set in Create_0.gml: alarm[1] = 10 frames (0.167 seconds at 60 FPS)
///   • Creates brief delay before showing point value sprite
///   • Prevents instant flash when enemy is destroyed
///
/// Display Logic:
///   • Draw_0.gml checks alarm[1] == -1 to determine when to show sprite
///   • Before expiration (alarm[1] > -1): No display (invisible)
///   • After expiration (alarm[1] == -1): Display point sprite
///
/// Purpose:
///   • Provides smooth visual transition when enemy is destroyed
///   • Prevents jarring instant appearance of point values
///   • Creates brief pause to let explosion animation start first
///
/// Current Implementation:
///   • This alarm event itself is empty (no code executed when timer expires)
///   • The actual display logic is handled in Draw_0.gml (checks alarm[1] == -1)
///   • This event serves as a timer marker
///
/// @related oPointsDisplay/Create_0.gml - Sets alarm[1] = 10 on creation
/// @related oPointsDisplay/Draw_0.gml - Checks alarm[1] == -1 to show/hide sprite
