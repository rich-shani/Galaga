/// @description send a score to gmscoreboard.com (global.tagid must be set to your scoreboard secret tagid)
/// @param player name
/// @param score

function set_score(_player, _score){
	global.gmscoreboard_response = http_get("https://gmscoreboard-2021-backend-nodejs-9hpr6.ondigitalocean.app/api/set-score/?tagid="+global.tagid+"&player="+_player+"&score="+string(_score));
}