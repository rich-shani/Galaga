/// @description HIGH SCORE REFRESH TIMER
/// This alarm periodically refreshes the high score table from the server/storage.
/// It's used to keep the high scores up-to-date in real-time, especially useful
/// for online leaderboards || shared high score systems.
///
/// The refresh occurs every 5 minutes (18000 frames at 60 FPS) to balance between
/// staying current && !overwhelming the system with frequent requests.
///
/// @function get_scores(count) - Fetches the top N high scores from storage
/// @param {number} count - Number of high scores to retrieve (5 in this case)

// load the latest scores
get_scores(5);

// setup an alarm to refresh the high score table every 5 minutes
// 5 minutes * 60 seconds * 60 frames = 18000 frames
alarm[0]=5*60*60;