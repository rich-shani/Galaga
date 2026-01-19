/// @description Points display lifetime expiration
/// Destroys the points display object after it has been visible for the specified duration.
///
/// Timer System:
///   • Set in Create_0.gml: alarm[0] = 70 frames (1.167 seconds at 60 FPS)
///   • This alarm fires when the display duration expires
///   • Object is destroyed to prevent memory leaks and visual clutter
///
/// Purpose:
///   • Provides temporary visual feedback for point values when enemies are destroyed
///   • Prevents point displays from accumulating on screen indefinitely
///   • Ensures clean visual presentation
///
/// @related oPointsDisplay/Create_0.gml - Sets alarm[0] = 70 on creation
/// @related oPointsDisplay/Draw_0.gml - Renders point sprite while active
/// @related oEnemyBase/Destroy_0.gml - Creates oPointsDisplay when enemies die
instance_destroy();