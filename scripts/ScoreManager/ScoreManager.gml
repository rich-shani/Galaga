/// @file ScoreManager.gml
/// @description Specialized controller for score management and extra life tracking
///              Extracted from oGameManager to reduce god object complexity
///
/// RESPONSIBILITIES:
///   - Score tracking and updates
///   - Extra life awarding at milestones
///   - High score management and entry
///   - Results screen scoring (perfect bonus, challenge bonus)
///
/// RELATED FILES:
///   - scripts/HighScoreSystem.gml - High score table and initial entry
///   - scripts/GameConstants.gml - EXTRA_LIFE thresholds

/// @function ScoreManager
/// @description Constructor for ScoreManager controller
/// @return {Struct} ScoreManager instance
function ScoreManager() constructor {
	// Score tracking
	total_score = 0;
	shots_fired = 0;
	shots_hit = 0;

	// Extra life tracking
	next_extra_life_score = get_config_value("PLAYER", "EXTRA_LIFE_FIRST", EXTRA_LIFE_FIRST_THRESHOLD);
	extra_life_interval = get_config_value("PLAYER", "EXTRA_LIFE_ADDITIONAL", EXTRA_LIFE_ADDITIONAL_THRESHOLD);
	max_extra_life_score = get_config_value("SCORE", "MAX_SCORE_FOR_EXTRA_LIVES", MAX_SCORE_FOR_EXTRA_LIVES);

	/// @function addScore
	/// @description Adds points to player score and checks for extra lives
	/// @param {Real} _points Points to add
	/// @return {Bool} True if extra life was awarded
	static addScore = function(_points) {
		// Add points
		global.Game.Player.score += _points;
		total_score = global.Game.Player.score;

		// Check for extra life
		return checkForExtraLife();
	};

	/// @function addEnemyScore
	/// @description Adds score for destroying an enemy
	/// @param {String} _enemy_name Enemy name (e.g., "oTieFighter")
	/// @param {Real} _base_points Base point value
	/// @param {Bool} _is_diving Whether enemy was diving
	/// @return {Real} Points awarded
	static addEnemyScore = function(_enemy_name, _base_points, _is_diving) {
		// Diving enemies are worth 2x points
		var points = _is_diving ? (_base_points * 2) : _base_points;

		addScore(points);
		return points;
	};

	/// @function checkForExtraLife
	/// @description Checks if player has reached extra life milestone
	/// @return {Bool} True if extra life was awarded
	static checkForExtraLife = function() {
		// Check if score exceeds next threshold
		if (total_score > next_extra_life_score && total_score < max_extra_life_score) {

			// Reset first life marker after initial award
			if (next_extra_life_score == EXTRA_LIFE_FIRST_THRESHOLD) {
				next_extra_life_score = 0;
			}

			// Move to next threshold
			next_extra_life_score += extra_life_interval;

			// Award life
			sound_play(GLife);
			global.Game.Player.lives += 1;

			log_error("Extra life awarded at score: " + string(total_score), "ScoreManager.checkForExtraLife", 1);

			return true;
		}

		return false;
	};

	/// @function recordShot
	/// @description Records that a shot was fired
	/// @return {undefined}
	static recordShot = function() {
		shots_fired++;
		global.Game.Player.shotsFired = shots_fired;
	};

	/// @function recordHit
	/// @description Records that a shot hit an enemy
	/// @return {undefined}
	static recordHit = function() {
		shots_hit++;
		global.Game.Player.hits = shots_hit;
	};

	/// @function getAccuracy
	/// @description Calculates shot accuracy as percentage
	/// @return {Real} Accuracy percentage (0-100)
	static getAccuracy = function() {
		if (shots_fired == 0) return 0;
		return (shots_hit / shots_fired) * 100;
	};

	/// @function isPerfectAccuracy
	/// @description Checks if player has perfect accuracy (40/40 shots)
	/// @return {Bool} True if perfect
	static isPerfectAccuracy = function() {
		return (shots_hit == 40 && shots_fired == 40);
	};

	/// @function calculateChallengeBonus
	/// @description Calculates bonus for challenge stage
	/// @param {Real} _enemies_destroyed Number of enemies destroyed
	/// @return {Real} Bonus points
	static calculateChallengeBonus = function(_enemies_destroyed) {
		// Challenge stages have 40 enemies (8 per wave × 5 waves)
		// Perfect clear: 10000 points
		// Otherwise: 100 points per enemy
		if (_enemies_destroyed == 40) {
			return 10000; // Perfect bonus
		} else {
			return _enemies_destroyed * 100;
		}
	};

	/// @function calculateResultsScore
	/// @description Calculates final results screen bonuses
	/// @param {Real} _challenge_enemies_killed Enemies killed in challenge
	/// @return {Struct} Results data {bonus_points, is_perfect, accuracy}
	static calculateResultsScore = function(_challenge_enemies_killed) {
		var bonus = 0;
		var is_perfect = false;

		// Check for perfect accuracy
		if (isPerfectAccuracy()) {
			bonus = 10000;
			is_perfect = true;
		} else if (_challenge_enemies_killed > 0) {
			bonus = _challenge_enemies_killed * 100;
		}

		return {
			bonus_points: bonus,
			is_perfect: is_perfect,
			accuracy: getAccuracy(),
			shots_fired: shots_fired,
			shots_hit: shots_hit
		};
	};

	/// @function resetShotTracking
	/// @description Resets shot tracking for new challenge stage
	/// @return {undefined}
	static resetShotTracking = function() {
		shots_fired = 0;
		shots_hit = 0;
		global.Game.Player.shotsFired = 0;
		global.Game.Player.hits = 0;
	};

	/// @function checkHighScore
	/// @description Checks if current score is a high score
	/// @return {Real} Position in high score table (1-5) or -1 if not a high score
	static checkHighScore = function() {
		var scores = global.Game.HighScores.scores;

		for (var i = 0; i < array_length(scores); i++) {
			if (total_score > scores[i]) {
				return i + 1; // Return 1-based position
			}
		}

		return -1; // Not a high score
	};

	/// @function insertHighScore
	/// @description Inserts current score into high score table
	/// @param {Real} _position Position in table (1-5)
	/// @param {String} _initials Player initials (2-3 characters)
	/// @return {undefined}
	static insertHighScore = function(_position, _initials) {
		// Convert to 0-based index
		var index = _position - 1;

		// Shift lower scores down
		for (var i = 4; i > index; i--) {
			global.Game.HighScores.scores[i] = global.Game.HighScores.scores[i - 1];
			global.Game.HighScores.initials[i] = global.Game.HighScores.initials[i - 1];
		}

		// Insert new score
		global.Game.HighScores.scores[index] = total_score;
		global.Game.HighScores.initials[index] = _initials;

		show_debug_message("[ScoreManager] High score inserted at position " +
			string(_position) + ": " + string(total_score) + " - " + _initials);
	};

	/// @function getScore
	/// @description Gets current total score
	/// @return {Real} Current score
	static getScore = function() {
		return total_score;
	};

	/// @function reset
	/// @description Resets score manager for new game
	/// @return {undefined}
	static reset = function() {
		total_score = 0;
		shots_fired = 0;
		shots_hit = 0;
		next_extra_life_score = EXTRA_LIFE_FIRST_THRESHOLD;

		global.Game.Player.score = 0;
		global.Game.Player.shotsFired = 0;
		global.Game.Player.hits = 0;
	};
}