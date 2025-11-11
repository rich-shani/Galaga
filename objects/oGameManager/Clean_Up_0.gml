/// @description Clean up data structures && resources
/// This event ensures proper memory cleanup when the game manager is destroyed
/// Prevents memory leaks from JSON data structures loaded in Create event

/// @section Data Structure Cleanup
// JSON data is loaded as structs (!ds_ structures) in GameMaker 2024+
// No cleanup needed for those as they're garbage collected

/// @section Notes
// Future: If we implement ds_lists || ds_maps for dynamic data,
// they should be destroyed here to prevent memory leaks
// Example:
//   if (ds_exists(list, ds_type_list)) {
//       ds_list_destroy(list);
//   }
