/// @description Enemy shot visual rendering
/// Draws enemy projectiles with alternating colors for visual variety.
/// Shots are drawn at half scale (0.5x) and rotated 270 degrees (pointing down).
///
/// Color System:
///   • laserColor = 0: Gold laser sprite (default enemy shot)
///   • laserColor = 1: Red laser sprite (alternate enemy shot)
///   • Color is randomly assigned in Step_2.gml on initialization
///
/// Rendering Parameters:
///   • Scale: 0.5 (half size for performance and visual style)
///   • Rotation: 270 degrees (pointing downward toward player)
///   • Alpha: 1.0 (fully opaque)
///
/// Debug Mode:
///   • Draws collision bounding box in red (semi-transparent)
///   • Only visible when global.debug is enabled
///
/// @var laserColor - Color variant selector (0 = gold, 1 = red)
/// @var sRedLazer - Red laser sprite asset
/// @var sGoldLazer - Gold laser sprite asset
///
/// @related oEnemyShot/Create_0.gml - Initial laserColor value
/// @related oEnemyShot/Step_2.gml - Movement and target locking

if (laserColor) {
	draw_sprite_ext(sRedLazer, 0, x, y, 0.5, 0.5, 270, c_white, 1);
}
else {
	draw_sprite_ext(sGoldLazer, 0, x, y, 0.5, 0.5, 270, c_white, 1);	
}

if (global.debug) {
	// draw collision mask
	draw_set_alpha(0.5);
	draw_rectangle_colour(bbox_left,bbox_top,bbox_right,bbox_bottom,c_red,c_red,c_red,c_red,false);
	draw_set_alpha(1);
}