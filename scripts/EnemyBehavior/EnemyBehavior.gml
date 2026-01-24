/// @file EnemyBehavior.gml
/// @description Extracted enemy behavior functions from oEnemyBase/Step_0.gml
///              Reduces 400+ line Step event to <100 lines by extracting logic
///
/// BENEFITS:
///   - Improved readability (each function has single responsibility)
///   - Easier to test individual behaviors
///   - Reduced cyclomatic complexity
///   - Better maintainability
///
/// USAGE:
///   // In oEnemyBase/Step_0.gml:
///   switch(enemyState) {
///       case EnemyState.ENTER_SCREEN: update_enter_screen(self); break;
///       case EnemyState.IN_FORMATION: update_in_formation(self); break;
///       // ...
///   }}

/// @function should_transform
/// @description Checks if enemy should transform (combine with escort)
/// @param {Id.Instance} _enemy Enemy instance
/// @return {Bool} True if should transform
function should_transform(_enemy) {
	with (_enemy) {
		// Check if transformation is enabled for this enemy
		if (!attributes.CAN_TRANSFORM) return false;

		// Check transformation tokens available
		if (global.Game.Enemy.transformTokens <= 0) return false;

		// Check enemy count not too high
		if (global.Game.Enemy.count > MAX_TRANSFORM_ENEMY_COUNT) return false;

		// Check dive capacity available
		if (global.Game.Enemy.diveCapacity <= 0) return false;

		// Random chance
		if (irandom(TRANSFORM_RANDOM_RANGE) != 0) return false;

		return true;
	}
}

/// @function setup_transformation
/// @description Sets up transformation alarm
/// @param {Id.Instance} _enemy Enemy instance
/// @return {undefined}
function setup_transformation(_enemy) {
	with (_enemy) {
		global.Game.Enemy.transformTokens--;
		alarm[EnemyAlarmIndex.DIVE_ATTACK] = TRANSFORM_ALARM_DELAY;
	}
}

/// @function handle_dive_completion
/// @description Handles enemy returning to formation after dive
/// @param {Id.Instance} _enemy Enemy instance
/// @return {undefined}
function start_dive_completion(_enemy) {
	with (_enemy) {
		// Reset position to formation
		x = breathex;
		y = SPAWN_TOP_Y * global.Game.Display.scale;
		speed = entranceSpeed;

		// Reset beam state
		if (beam_weapon.available) {
			beam_weapon.state = BEAM_STATE.READY;
		}
		// Reset group dive logic
		if (array_length(dive_group.followers) > 0) dive_group.followers = [];
		else if (dive_group.isFollowing) dive_group.isFollowing = false;
		
		enemyState = EnemyState.MOVE_INTO_FORMATION;
	}
}

/// @function start_final_attack
/// @description Initializes first dive in IN_FINAL_ATTACK mode
/// @param {Id.Instance} _enemy Enemy instance
/// @return {undefined}
function start_final_attack(_enemy) {
	with (_enemy) {
		// Randomize spawn position
		x = 400 + irandom(96); //SPAWN_EDGE_MARGIN + irandom(global.Game.Display.screenWidth - SPAWN_EDGE_BUFFER);
		y = SPAWN_TOP_Y;

		// Choose path based on position
		if (x > SCREEN_CENTER_X * global.Game.Display.scale) {
			if (attributes.STANDARD.DIVE_PATH2 != noone) {
				var path_id = safe_get_asset(attributes.STANDARD.DIVE_PATH2, -1);
				if (path_id != -1) path_start(path_id, moveSpeed, 0, 0);
			}
		} else {
			if (attributes.STANDARD.DIVE_ALT_PATH2 != noone) {
				var path_id = safe_get_asset(attributes.STANDARD.DIVE_ALT_PATH2, -1);
				if (path_id != -1) path_start(path_id, moveSpeed, 0, 0);
			}
		}

		// Sound and shooting
		global.Game.Controllers.audioManager.stopSound(GDive);
		global.Game.Controllers.audioManager.playSound(GDive);

		enemyState = EnemyState.IN_FINAL_ATTACK;
		alarm[1] = ENEMY_SHOT_ALARM;
	}
}

/// @function find_enemy_followers
/// @description Finds up to 2 enemies associated with a TieIntercepter
///              based on hardcoded INDEX relationships. Returns array of 0, 1, or 2
///              follower instance IDs.
/// @param {Id.Instance} _leader The TieIntercepter initiating the dive
/// @return {Array<Id.Instance>} Array of selected follower enemy IDs (empty if none)
function find_enemy_followers(_leader) {
    var result = [];
    
    // Validate leader
    if (!instance_exists(_leader)) return result;
    
	// if the leader has a captured player, then do not DIVE in a group
	if (oPlayer.captor == _leader.id) return result;
	
	// 25% random chance: sometimes dive alone even if followers available
	if (irandom(3) == 0) return result;  // Solo dive
	
    var leader_index = _leader.INDEX;
    
    // Hardcoded mapping: TieIntercepter INDEX -> Imperial Shuttle INDEXs
    // TieIntercepters at INDEX: 9, 11, 13, 15 (left to right)
    var associated_indices = [];
    
    switch (leader_index) {
        case 9:
            // First TieIntercepter (leftmost) -> Shuttles at INDEX 22, 10
            associated_indices = [22, 10];
            break;
        case 11:
            // Third TieIntercepter -> Shuttles at INDEX 10, 4
            associated_indices = [10, 4];
            break;
        case 13:
            // Second TieIntercepter -> Shuttles at INDEX 4, 12
            associated_indices = [4, 12];
            break;       
        case 15:
            // Fourth TieIntercepter (rightmost) -> Shuttles at INDEX 12, 17
            associated_indices = [12, 17];
            break;
        default:
            // Not a TieIntercepter that can lead group dives
            return result;
    }
    
    // Find actual Imperial Shuttle instances at these INDEX positions
    var candidates = [];
    
	// only canFollow enemies (eg oImperialShuttle) at specific INDEX locations, can form a dive group
    with (oEnemyBase) {
        // Check if this enemy can be part of a dive group AND is IN_FORMATION
        if (dive_group.canFollow && enemyState == EnemyState.IN_FORMATION) { 
            
            // Check if this enemy's INDEX matches any associated position
            var is_candidate = false;
            for (var i = 0; i < array_length(associated_indices); i++) {
                if (INDEX == associated_indices[i]) {
                    is_candidate = true;
                    break;
                }
            }
            
            if (is_candidate) {
                array_push(candidates, id);
            }
        }
    }
    
    if (array_length(candidates) == 0) {
        return result;  // No eligible followers
    }
    
    // Select 1 or 2 followers randomly
    if (array_length(candidates) == 1) {
        // Only one candidate - use it
        array_push(result, candidates[0]);
    } else if (array_length(candidates) == 2) {
        // Two candidates - randomly decide: use 1 or both
		if (irandom(2) == 0) { // 33% chance to use just one
			// Use one (randomly selected)
			array_push(result, candidates[irandom(1)]);
		} else { // 66% chance to use both
            // Use both
            result = candidates;
		}
    }
    
    return result;
}

/// @function setup_dive_attack
/// @description Configures and initiates a group dive attack with a leader
///              and 1-2 followers. Followers follow the leader's path with
///              slight offsets to maintain formation spacing.
/// @param {Id.Instance} _enemy
/// @param {Int} _path_id The path asset ID to follow
/// @param {delay} _delay offset to delay the firing of the enemy missile(s)
/// @return {undefined}
function setup_dive_attack(_enemy, _path_id, _delay = 0) {
	
	with (_enemy) {
        // Start the dive path for leader
        path_start(_path_id, moveSpeed, 0, 0);
        enemyState = EnemyState.IN_DIVE_ATTACK;
        
        // Set shooting timer (shots during dive)
        alarm[1] = ENEMY_SHOT_ALARM + _delay;
	}
}

/// @function setup_group_dive_attack
/// @description Configures and initiates a group dive attack with a leader
///              and 1-2 followers. Followers follow the leader's path with
///              slight offsets to maintain formation spacing.
/// @param {Id.Instance} _leader The TieIntercepter leading the dive
/// @param {Int} _path_id The path asset ID to follow
/// @return {undefined}
function setup_group_dive_attack(_leader, _path_id) {
    if (!instance_exists(_leader) || _path_id == -1) {
        return;
    }
    
	// set the Group leader dive PATH
	setup_dive_attack(_leader, _path_id);
    
    // Setup each follower
    for (var i = 0; i < array_length(dive_group.followers); i++) {
        var follower = dive_group.followers[i];
        if (instance_exists(follower)) {

            // set each of the followers on the same PATH as the Group Leader   
			setup_dive_attack(follower, _path_id, (10 * (i + 1)));
			
			// set the isFollowing flag on this enemy
			// we use this flag to calculate the total number of enemies that are in a DIVE
			// as we count a group as one dive (not 2, or 3)
			follower.dive_group.isFollowing = true;
        }
    }
}