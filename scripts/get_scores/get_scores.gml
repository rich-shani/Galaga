/// @description retreive score data from gmscoreboard.com (global.tagid must be set to your scoreboard secret tagid)
/// @param number of scores to get.

function get_scores(_num){
//	global.gmscoreboard_response = http_get("https://gmscoreboard.com/api/get-scores/?tagid="+global.tagid+"&num="+string(_num));
	global.gmscoreboard_response = http_get("https://gmscoreboard-2021-backend-nodejs-9hpr6.ondigitalocean.app/api/get-scores/?tagid="+global.tagid+"&num="+string(_num));
}