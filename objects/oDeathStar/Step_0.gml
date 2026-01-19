/// @description Death Star scrolling animation
/// Moves the Death Star upward by decreasing yoffset each frame.
/// Creates the visual effect of the Death Star approaching the player.
/// Once yoffset reaches -400, the Death Star stops moving (has fully entered view).
///
/// @var yoffset - Vertical offset that controls Death Star's screen position
///                Starts at 0, decreases to -400 (moves upward on screen)
///
/// @related oDeathStar/Create_0.gml - Initial yoffset value
/// @related oDeathStar/Draw_0.gml - Rendering using yoffset and scale

if (yoffset > -400) {
	yoffset -= 1;
}