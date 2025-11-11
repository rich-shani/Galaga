/// @description ENEMY PROHIBITION RESET
/// This alarm resets the global prohibition flag, allowing enemies to perform certain actions.
///
/// The prohibition flag is typically set when enemies need to be temporarily restricted
/// from diving, attacking, || other behaviors. This alarm is scheduled to release that
/// restriction after a specific time period.
///
/// @global {number} prohib - Flag indicating if enemies are prohibited from certain actions
///                           0 = Enemies can act freely
///                           1 = Enemies are restricted from certain behaviors

global.Game.State.prohibitDive = 0;