# Group Dive Attack Implementation Approach

## Overview
This document outlines the approach for implementing group dive attacks where an `oTieIntercepter` can initiate a dive attack and be accompanied by one of two possible `oImperialShuttle` enemies that follow the same path, similar to the classic Galaga game mechanics.

## Current System Analysis

### Existing Components
1. **Enemy State Machine**: Enemies use `EnemyState` enum with states including `IN_FORMATION` and `IN_DIVE_ATTACK`
2. **Path System**: Enemies use `path_start()` to follow predefined paths during dive attacks
3. **Formation Grid**: 5×8 grid (40 positions) where each enemy has an `INDEX` (0-39)
4. **Escort Flag**: Already exists in `Create_0.gml` but is currently unused
5. **Dive Trigger**: Currently in `IN_FORMATION` state around line 248-288 of `Step_0.gml`

### Key Files
- `objects/oEnemyBase/Step_0.gml` - Main enemy behavior logic
- `objects/oEnemyBase/Create_0.gml` - Enemy initialization
- `datafiles/Patterns/oTieIntercepter.json` - TIE Intercepter configuration
- `datafiles/Patterns/oImperialShuttle.json` - Imperial Shuttle configuration

## Proposed Implementation

### Phase 1: Data Structure Extensions

#### 1.1 Add Group Dive Variables to Create_0.gml
```gml
// Group dive attack system
groupLeader = noone;           // Reference to leader enemy (if this is a follower)
groupFollowers = [];           // Array of follower enemy IDs (if this is a leader)
groupPathOffset = 0;           // Path position offset for followers (0.0 to 1.0)
groupFormationOffset = {       // Position offset relative to leader
    x: 0,
    y: 0
};
canLeadGroupDive = false;      // Flag: can this enemy type lead group dives?
canFollowGroupDive = false;    // Flag: can this enemy type follow in group dives?
```

#### 1.2 Set Flags in Enemy-Specific Create Events
**In `objects/oTieIntercepter/Create_0.gml`:**
```gml
canLeadGroupDive = true;  // TIE Intercepters can lead group dives
```

**In `objects/oImperialShuttle/Create_0.gml`:**
```gml
canFollowGroupDive = true;  // Imperial Shuttles can follow in group dives
```

### Phase 2: Helper Functions

#### 2.1 Find One of Two Imperial Shuttles Function
Create a new function in `scripts/EnemyBehavior/EnemyBehavior.gml`:

```gml
/// @function find_imperial_shuttle_follower
/// @description Finds one of two possible Imperial Shuttles in formation that can join a group dive
/// @description The function searches for up to 2 Imperial Shuttles and randomly selects one
/// @param {Id.Instance} _leader The enemy initiating the group dive (oTieIntercepter)
/// @return {Id.Instance|noone} Single enemy instance ID that can follow, or noone if none found
function find_imperial_shuttle_follower(_leader) {
    var candidates = [];
    var leader_index = _leader.INDEX;
    
    // Formation is 5 columns × 8 rows
    // Calculate row and column from INDEX (0-39)
    var leader_row = floor(leader_index / 5);
    var leader_col = leader_index mod 5;
    
    // Check adjacent positions (same row, left and right)
    var adjacent_indices = [];
    
    // Left neighbor (if not on left edge)
    if (leader_col > 0) {
        var left_index = leader_index - 1;
        if (left_index >= 0 && left_index < 40) {
            array_push(adjacent_indices, left_index);
        }
    }
    
    // Right neighbor (if not on right edge)
    if (leader_col < 4) {
        var right_index = leader_index + 1;
        if (right_index >= 0 && right_index < 40) {
            array_push(adjacent_indices, right_index);
        }
    }
    
    // Also check row above and below for more flexible grouping
    // Row above
    if (leader_row > 0) {
        var above_index = leader_index - 5;
        if (above_index >= 0) {
            array_push(adjacent_indices, above_index);
        }
    }
    
    // Row below
    if (leader_row < 7) {
        var below_index = leader_index + 5;
        if (below_index < 40) {
            array_push(adjacent_indices, below_index);
        }
    }
    
    // Find Imperial Shuttles at these positions
    with (oEnemyBase) {
        // Check if this enemy is a candidate
        if (enemyState == EnemyState.IN_FORMATION &&
            ENEMY_NAME == "oImperialShuttle" &&
            canFollowGroupDive &&
            groupLeader == noone &&  // Not already following someone
            array_length(groupFollowers) == 0) {  // Not leading a group
            
            // Check if this enemy's INDEX matches any adjacent position
            var is_adjacent = false;
            for (var i = 0; i < array_length(adjacent_indices); i++) {
                if (INDEX == adjacent_indices[i]) {
                    is_adjacent = true;
                    break;
                }
            }
            
            if (is_adjacent) {
                array_push(candidates, id);
            }
        }
    }
    
    // Return one of the candidates (randomly select if multiple found)
    if (array_length(candidates) == 0) {
        return noone;
    } else if (array_length(candidates) == 1) {
        return candidates[0];
    } else {
        // Two candidates found - randomly select one
        return candidates[irandom(array_length(candidates) - 1)];
    }
}
```

#### 2.2 Setup Group Dive Function
```gml
/// @function setup_group_dive_attack
/// @description Sets up a group dive attack with leader and a single follower
/// @param {Id.Instance} _leader The enemy leading the dive (oTieIntercepter)
/// @param {Id.Instance} _follower Single follower enemy ID (oImperialShuttle)
/// @param {Int} _path_id The path asset ID to follow
/// @return {undefined}
function setup_group_dive_attack(_leader, _follower, _path_id) {
    with (_leader) {
        // Store follower reference (as array for consistency with existing code)
        groupFollowers = [_follower];
        groupPathOffset = 0;  // Leader is at position 0
        
        // Start the dive path for leader
        path_start(_path_id, moveSpeed, 0, 0);
        enemyState = EnemyState.IN_DIVE_ATTACK;
        
        // Set shooting timer
        alarm[1] = ENEMY_SHOT_ALARM;
        
        // Decrement dive capacity (only once for the group)
        global.Game.Enemy.diveCapacity--;
    }
    
    // Setup the follower
    if (instance_exists(_follower)) {
        with (_follower) {
            // Link to leader
            groupLeader = _leader.id;
            groupPathOffset = 0.15;  // 15% path offset behind leader
            
            // Calculate formation offset (for visual spacing)
            var leader_index = _leader.INDEX;
            var follower_index = INDEX;
            var leader_row = floor(leader_index / 5);
            var leader_col = leader_index mod 5;
            var follower_row = floor(follower_index / 5);
            var follower_col = follower_index mod 5;
            
            groupFormationOffset.x = (follower_col - leader_col) * 32;  // Approx spacing
            groupFormationOffset.y = (follower_row - leader_row) * 32;
            
            // Start following the same path (with offset)
            path_start(_path_id, moveSpeed, 0, 0);
            path_position = groupPathOffset;  // Start at offset position
            
            enemyState = EnemyState.IN_DIVE_ATTACK;
            
            // Set shooting timer (slightly offset for visual variety)
            alarm[1] = ENEMY_SHOT_ALARM + 10;
        }
    }
}
```

### Phase 3: Modify Step_0.gml

#### 3.1 Update IN_FORMATION State (around line 248)
Modify the dive attack trigger section to check for group dive capability:

```gml
// In IN_FORMATION state, around line 248-288
if (instance_exists(oPlayer) && global.Game.Enemy.diveCapacity > 0 && global.Game.State.spawnOpen == 0 && oPlayer.alarm[4] == -1) {
    if (
        irandom(10) == 0 && global.Game.State.prohibitDive == 0 &&
        alarm[2] == -1 && oPlayer.shipStatus == ShipState.ACTIVE && oPlayer.regain == 0
    ) {
        /// All conditions met - initiate dive attack
        
        // Check if this enemy can lead a group dive
        var use_group_dive = false;
        var follower = noone;
        
        if (canLeadGroupDive && ENEMY_NAME == "oTieIntercepter") {
            // Try to find one of two possible Imperial Shuttles
            follower = find_imperial_shuttle_follower(self);
            if (follower != noone) {
                use_group_dive = true;
            }
        }
        
        // Set global flags to prevent concurrent dives
        global.Game.State.prohibitDive = 1;
        if (instance_exists(oGameManager)) {
            oGameManager.alarm[0] = PROHIBIT_RESET_DELAY;
        }
        
        // Play dive sound effect
        global.Game.Controllers.audioManager.stopSound(GDive);
        global.Game.Controllers.audioManager.playSound(GDive);
        
        /// === DIVE PATH SELECTION ===
        var selected_path = noone;
        if (xstart > SCREEN_CENTER_X * global.Game.Display.scale) {
            // Enemy on right side of formation → use right dive path
            if (attributes.STANDARD.DIVE_PATH1 != noone) {
                selected_path = safe_get_asset(attributes.STANDARD.DIVE_PATH1, -1);
            }
        } else {
            // Enemy on left side of formation → use left dive path
            if (attributes.STANDARD.DIVE_ALT_PATH1 != noone) {
                selected_path = safe_get_asset(attributes.STANDARD.DIVE_ALT_PATH1, -1);
            }
        }
        
        if (use_group_dive && selected_path != -1) {
            // Setup group dive attack
            setup_group_dive_attack(self, follower, selected_path);
        } else {
            // Solo dive attack (existing behavior)
            if (selected_path != -1) {
                path_start(selected_path, moveSpeed, 0, 0);
            }
            
            // Set shooting timer
            alarm[1] = ENEMY_SHOT_ALARM;
            
            // Transition to dive attack state
            enemyState = EnemyState.IN_DIVE_ATTACK;
            
            // Decrement dive capacity
            global.Game.Enemy.diveCapacity--;
        }
    }
}
```

#### 3.2 Update IN_DIVE_ATTACK State (around line 292)
Add follower synchronization logic:

```gml
else if (enemyState == EnemyState.IN_DIVE_ATTACK) {
    
    // === GROUP DIVE SYNCHRONIZATION ===
    // If this is a follower, sync with leader's path position
    if (groupLeader != noone && instance_exists(groupLeader)) {
        var leader = groupLeader;
        
        // Sync path position with leader (with offset)
        if (path_index != -1 && leader.path_index != -1) {
            // Calculate target path position
            var target_position = leader.path_position + groupPathOffset;
            
            // Clamp to valid range
            if (target_position > 1.0) {
                target_position = 1.0;
            }
            
            // Update path position
            path_position = target_position;
            
            // Sync speed
            speed = leader.speed;
            
            // If leader finished path, finish this one too
            if (leader.path_position >= 1.0 && path_position >= 1.0) {
                path_end();
            }
        }
        
        // If leader is destroyed or changed state, break formation
        if (leader.enemyState != EnemyState.IN_DIVE_ATTACK) {
            groupLeader = noone;
            groupPathOffset = 0;
        }
    }
    
    // If this is a leader, update followers
    if (array_length(groupFollowers) > 0) {
        // Followers will sync themselves in their Step event
        // Just ensure we're still in dive attack
    }
    
    // ... existing beam weapon logic continues ...
    
    // ... existing dive path completion logic continues ...
}
```

### Phase 4: Cleanup and Edge Cases

#### 4.1 Handle Follower Destruction
In `objects/oEnemyBase/Destroy_0.gml`, add cleanup:

```gml
// If this was a leader, clear follower references
if (array_length(groupFollowers) > 0) {
    for (var i = 0; i < array_length(groupFollowers); i++) {
        var follower = groupFollowers[i];
        if (instance_exists(follower)) {
            follower.groupLeader = noone;
            follower.groupPathOffset = 0;
        }
    }
    groupFollowers = [];
}

// If this was a follower, notify leader
if (groupLeader != noone && instance_exists(groupLeader)) {
    // Remove this follower from leader's list
    var leader = groupLeader;
    var index = array_first_index_of(leader.groupFollowers, id);
    if (index != -1) {
        array_delete(leader.groupFollowers, index, 1);
    }
}
```

#### 4.2 Handle Path Completion for Groups
In `Step_0.gml`, around line 410-460, update path completion logic:

```gml
// When dive path completes
if (y > DIVE_Y_THRESHOLD * global.Game.Display.scale) {
    // ... existing loop/final attack logic ...
    
    // If in a group, handle group completion
    if (array_length(groupFollowers) > 0) {
        // Notify followers to complete their paths
        for (var i = 0; i < array_length(groupFollowers); i++) {
            var follower = groupFollowers[i];
            if (instance_exists(follower)) {
                // Follower will handle its own completion in its Step event
            }
        }
        groupFollowers = [];
    }
    
    if (groupLeader != noone) {
        // This is a follower - follow leader's state transition
        var leader = groupLeader;
        if (leader.enemyState != EnemyState.IN_DIVE_ATTACK) {
            // Leader completed, so should we
            groupLeader = noone;
            groupPathOffset = 0;
        }
    }
}
```

## Implementation Steps

1. **Add variables to Create_0.gml** (Phase 1.1)
2. **Set flags in enemy-specific Create events** (Phase 1.2)
3. **Create helper functions** (Phase 2)
4. **Modify IN_FORMATION state** (Phase 3.1)
5. **Modify IN_DIVE_ATTACK state** (Phase 3.2)
6. **Add cleanup logic** (Phase 4)
7. **Test with various formation configurations**

## Design Considerations

### Path Offset Strategy
- **Current**: Fixed offset (0.15) for single follower - Simple, predictable
- **Option A**: Fixed offset (0.15) - Simple, predictable (current implementation)
- **Option B**: Dynamic offset based on formation spacing - More visually accurate
- **Recommendation**: Start with Option A, refine to Option B if needed

### Follower Selection
- **Current**: Searches adjacent positions (same row left/right, and row above/below)
- **Selection Logic**: If 2 Imperial Shuttles are found, randomly selects one
- **Future Enhancement**: Could use distance-based selection or prefer specific positions

### Group Size
- **Current**: 1 follower (2 total enemies: oTieIntercepter + 1 oImperialShuttle)
- **Selection**: Randomly selects 1 of 2 possible Imperial Shuttles if both are available
- **Future**: Could be configurable per enemy type

### Visual Spacing
- Followers maintain relative formation spacing during dive
- Uses `groupFormationOffset` to preserve visual relationship

## Testing Checklist

- [ ] TIE Intercepter can initiate solo dive (existing behavior preserved)
- [ ] TIE Intercepter can initiate group dive with 1 Imperial Shuttle (when 1 available)
- [ ] TIE Intercepter can initiate group dive with 1 Imperial Shuttle (when 2 available, randomly selects one)
- [ ] Group maintains formation during dive
- [ ] Group completes dive together
- [ ] Leader destruction breaks group properly
- [ ] Follower destruction doesn't break leader
- [ ] Multiple groups can exist simultaneously (if dive capacity allows)
- [ ] Group dive respects dive capacity (counts as 1 dive, not 2)
- [ ] When 2 Imperial Shuttles are adjacent, selection is random

## Future Enhancements

1. **Formation Patterns**: Different group formations (V-shape, line, etc.)
2. **Dynamic Grouping**: Enemies can join mid-dive
3. **Multiple Followers**: Allow 2 Imperial Shuttles to follow simultaneously
4. **Mixed Groups**: Other enemy types can follow (e.g., TIE Fighters)
5. **Group Behaviors**: Coordinated shooting, synchronized loops
6. **Visual Effects**: Group dive trails, formation indicators
7. **Selection Strategy**: Configurable follower selection (random, closest, strongest, etc.)

