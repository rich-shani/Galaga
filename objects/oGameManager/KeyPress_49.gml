/// @description Credit Insert Handler (Key 1 - KeyCode 49)
/// Processes credit insertion when player presses the "1" key.
/// Credits allow players to start games or continue after game over.
///
/// Credit System:
///   • Maximum credits: 10 (prevents excessive credit accumulation)
///   • Each press adds 1 credit to global.Game.Player.credits
///   • Credits are consumed when starting a game or continuing
///   • Plays credit sound effect (GCredit) on successful insertion
///
/// Usage:
///   • Title screen: Insert credits before starting a game
///   • Game over: Insert credits to continue/restart
///   • Attract mode: Insert credits to start playing
///
/// Key Mapping:
///   • Key 49 = "1" key on keyboard
///   • Standard arcade-style credit input
///
/// @var global.Game.Player.credits - Current number of credits (0-10)
/// @var GCredit - Sound effect played when credit is inserted
///
/// @related oGameManager/Step_0.gml - Checks credits when starting games

// Increment the credits counter (maximum is 10 credits)
if (global.Game.Player.credits < 10) {
	// Add one credit to the player's credit count
	global.Game.Player.credits += 1;

	// Play credit insertion sound effect for audio feedback
	global.Game.Controllers.audioManager.playSound(GCredit);
}