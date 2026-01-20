# Group Dive Attack Implementation Plan
## oTieIntercepter + oImperialShuttle Coordinated Dives

## Overview

This document provides a detailed, step-by-step approach for implementing the group dive attack feature where `oTieIntercepter` enemies can dive with up to one `oImperialShuttle` follower. This matches the classic Galaga arcade game mechanics where enemies in vertical formation can dive together.

## Core Requirements

1. **oTieIntercepter** can initiate dives alone OR with a follower
2. **oImperialShuttle** can follow an oTieIntercepter during dives
3. **Formation Requirement**: Imperial Shuttles must be positioned **exactly below** the TieIntercepter in the same column
4. **Random Selection**: When multiple eligible shuttles exist, randomly select one (or none for solo dive)
5. **Path Following**: Followers maintain the same path trajectory as the leader with slight offset

## Formation Grid Structure

The game uses a **5 column × 8 row grid** (40 positions total):
- **INDEX range**: 0-39
- **Column calculation**: `INDEX mod 5`
- **Row calculation**: `floor(INDEX / 5)`
- **Directly below**: `INDEX + 5` (if valid, i.e., `< 40`)
- **Two rows below**: `INDEX + 10` (if valid, i.e., `< 40`)

### Example Formation Relationship
```
Row 0: [0]  [1]  [2]  [3]  [4]
Row 1: [5]  [6]  [7]  [8]  [9]
Row 2: [10] [11] [12] [13] [14]
...
```

If TieIntercepter is at INDEX 12 (row 2, column 2):
- Potential follower at INDEX 17 (row 3, column 2) - directly below
- Potential follower at INDEX 22 (row 4, column 2) - two rows below

## Implementation Phases

---

## Phase 1: Data Structure Extensions

### 1.1 Add Group Dive Variables to `oEnemyBase/Create_0.gml`

Add these variables after line 203 (after `beam_weapon` initialization):

```gml
/// ================================================================
/// GROUP DIVE SYSTEM - Variables for coordinated dive attacks
/// ================================================================
/// Allows enemies to dive together, with followers maintaining
/// the same path trajectory as their leader.
/// ================================================================

// Reference to the leader enemy (if this enemy is a follower)
groupLeader = noone;

// Array of follower enemy instance IDs (if this enemy is a leader)
groupFollowers = [];

// Path position offset for followers (0.0 to 1.0)
// Followers start slightly behind the leader on the path
groupPathOffset = 0.15;

// Flag: Can this enemy type lead a group dive?
canLeadGroupDive = false;

// Flag: Can this enemy type follow in a group dive?
canFollowGroupDive = false;
```

### 1.2 Set Flags in Enemy-Specific Create Events

**In `objects/oTieIntercepter/Create_0.gml`** (add after line 26):

```gml
/// === GROUP DIVE CAPABILITY ===
/// TIE Intercepters can lead group dive attacks
canLeadGroupDive = true;
```

**Create `objects/oImperialShuttle/Create_0.gml`** (new file):

```gml
/// ================================================================
/// IMPERIAL SHUTTLE CREATION EVENT
/// ================================================================

// Call parent Create event to initialize base enemy properties
event_inherited();

/// === GROUP DIVE CAPABILITY ===
/// Imperial Shuttles can follow in group dive attacks
canFollowGroupDive = true;
```

---

## Phase 2: Helper Functions

### 2.1 Create Helper Function: Find Eligible Imperial Shuttle Followers

Create a new function in `scripts/EnemyBehavior/EnemyBehavior.gml`:

```gml
/// @function find_imperial_shuttle_follower
/// @description Finds one of up to two possible Imperial Shuttles positioned
///              exactly below the TieIntercepter in the formation grid.
///              Returns randomly selected follower or noone if none available.
/// @param {Id.Instance} _leader The TieIntercepter initiating the dive
/// @return {Id.Instance|noone} Selected follower enemy ID, or noone if none found
function find_imperial_shuttle_follower(_leader) {
    // Validate leader
    if (!instance_exists(_leader)) {
        return noone;
    }
    
    var leader_index = _leader.INDEX;
    var leader_col = leader_index mod 5;
    var leader_row = floor(leader_index / 5);
    
    // Find Imperial Shuttles in the same column, directly below
    // Check up to 2 rows below (positions INDEX+5 and INDEX+10)
    var candidate_indices = [];
    
    // Position directly below (1 row down)
    var below_index_1 = leader_index + 5;
    if (below_index_1 < 40) {
        var below_row = floor(below_index_1 / 5);
        var below_col = below_index_1 mod 5;
        
        // Verify it's in the same column
        if (below_col == leader_col && below_row == leader_row + 1) {
            array_push(candidate_indices, below_index_1);
        }
    }
    
    // Position two rows below
    var below_index_2 = leader_index + 10;
    if (below_index_2 < 40) {
        var below_row = floor(below_index_2 / 5);
        var below_col = below_index_2 mod 5;
        
        // Verify it's in the same column
        if (below_col == leader_col && below_row == leader_row + 2) {
            array_push(candidate_indices, below_index_2);
        }
    }
    
    // Find actual Imperial Shuttle instances at these positions
    var candidates = [];
    
    with (oEnemyBase) {
        // Check if this enemy is an eligible candidate
        if (enemyState == EnemyState.IN_FORMATION &&
            ENEMY_NAME == "oImperialShuttle" &&
            canFollowGroupDive &&
            groupLeader == noone &&  // Not already following someone
            array_length(groupFollowers) == 0) {  // Not leading a group
            
            // Check if this enemy's INDEX matches any candidate position
            var is_candidate = false;
            for (var i = 0; i < array_length(candidate_indices); i++) {
                if (INDEX == candidate_indices[i]) {
                    is_candidate = true;
                    break;
                }
            }
            
            if (is_candidate) {
                array_push(candidates, id);
            }
        }
    }
    
    // Randomly decide whether to use group dive (50% chance if candidates exist)
    if (array_length(candidates) == 0) {
        return noone;  // No eligible followers
    }
    
    // Random chance: sometimes dive alone even if followers available
    if (irandom(1) == 0) {
        return noone;  // Solo dive (50% chance)
    }
    
    // Select one follower randomly if multiple available
    if (array_length(candidates) == 1) {
        return candidates[0];
    } else {
        // Two candidates - randomly select one
        return candidates[irandom(array_length(candidates) - 1)];
    }
}
```

### 2.2 Create Helper Function: Setup Group Dive Attack

Add to `scripts/EnemyBehavior/EnemyBehavior.gml`:

```gml
/// @function setup_group_dive_attack
/// @description Configures and initiates a group dive attack with a leader
///              and single follower. The follower follows the leader's path
///              with a slight offset to maintain formation spacing.
/// @param {Id.Instance} _leader The TieIntercepter leading the dive
/// @param {Id.Instance} _follower The Imperial Shuttle following
/// @param {Int} _path_id The path asset ID to follow
/// @return {undefined}
function setup_group_dive_attack(_leader, _follower, _path_id) {
    if (!instance_exists(_leader) || _path_id == -1) {
        return;
    }
    
    with (_leader) {
        // Store follower reference
        groupFollowers = [_follower];
        groupPathOffset = 0;  // Leader is at position 0 on path
        
        // Start the dive path for leader
        path_start(_path_id, moveSpeed, 0, 0);
        enemyState = EnemyState.IN_DIVE_ATTACK;
        
        // Set shooting timer (shots during dive)
        alarm[1] = ENEMY_SHOT_ALARM;
    }
    
    // Setup the follower
    if (instance_exists(_follower)) {
        with (_follower) {
            // Link to leader
            groupLeader = _leader.id;
            
            // Set path offset (followers start 15% behind leader on path)
            groupPathOffset = 0.15;
            
            // Start following the same path
            path_start(_path_id, moveSpeed, 0, 0);
            
            // Set initial path position to offset (followers start behind leader)
            path_position = groupPathOffset;
            
            // Transition to dive attack state
            enemyState = EnemyState.IN_DIVE_ATTACK;
            
            // Set shooting timer (slightly offset for visual variety)
            alarm[1] = ENEMY_SHOT_ALARM + 10;
        }
    }
    
    // Group dive consumes only ONE dive capacity slot (not two)
    global.Game.Enemy.diveCapacity--;
}
```

---

## Phase 3: Modify Dive Attack Trigger Logic

### 3.1 Update `oEnemyBase/Step_0.gml` - IN_FORMATION State

Modify the dive attack trigger section (around lines 248-289) to check for group dive capability:

**REPLACE** lines 248-289 with:

```gml
if (instance_exists(oPlayer) && global.Game.Enemy.diveCapacity > 0 && global.Game.State.spawnOpen == 0 && oPlayer.alarm[4] == -1) {
    if (
        irandom(10) == 0 && global.Game.State.prohibitDive == 0 &&
        alarm[2] == -1 && oPlayer.shipState == ShipState.ACTIVE && oPlayer.regain == 0
    ) {
        /// All conditions met - initiate dive attack
        
        // Check if this enemy can lead a group dive
        var use_group_dive = false;
        var follower = noone;
        
        if (canLeadGroupDive && ENEMY_NAME == "oTieIntercepter") {
            // Try to find an eligible Imperial Shuttle follower
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
        /// Choose appropriate dive path based on starting formation position
        var selected_path = -1;
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
        
        // Execute dive attack (group or solo)
        if (use_group_dive && selected_path != -1 && instance_exists(follower)) {
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

---

## Phase 4: Add Follower Synchronization Logic

### 4.1 Update `oEnemyBase/Step_0.gml` - IN_DIVE_ATTACK State

Add follower synchronization logic at the **BEGINNING** of the `IN_DIVE_ATTACK` state block (right after line 292):

**INSERT** after line 292 (before beam weapon logic):

```gml
else if (enemyState == EnemyState.IN_DIVE_ATTACK) {
    
    /// ================================================================
    /// GROUP DIVE SYNCHRONIZATION
    /// ================================================================
    /// If this enemy is a follower, synchronize path position with leader.
    /// Followers maintain a fixed offset behind the leader's path position.
    /// ================================================================
    
    if (groupLeader != noone && instance_exists(groupLeader)) {
        var leader = groupLeader;
        
        // Verify leader is still in dive attack
        if (leader.enemyState != EnemyState.IN_DIVE_ATTACK) {
            // Leader changed state, break formation
            groupLeader = noone;
            groupPathOffset = 0;
            // Continue with solo dive behavior
        } else {
            // Sync path position with leader (with offset)
            if (path_index != -1 && leader.path_index != -1) {
                // Calculate target path position (leader position + offset)
                var target_position = leader.path_position + groupPathOffset;
                
                // Clamp to valid range [0, 1]
                if (target_position > 1.0) {
                    target_position = 1.0;
                }
                if (target_position < 0.0) {
                    target_position = 0.0;
                }
                
                // Update path position to maintain offset
                path_position = target_position;
                
                // Sync speed with leader
                speed = leader.speed;
                moveSpeed = leader.moveSpeed;
            }
            
            // If leader finished path, follower should also finish
            if (leader.path_position >= 1.0) {
                if (path_position >= 1.0) {
                    path_end();
                }
            }
        }
    }
    
    // If this is a leader, ensure followers are still synchronized
    // (Followers handle their own sync in their Step event above)
    
    /// ================================================================
    /// BEAM WEAPON LOGIC - Special charge && firing system
    /// ================================================================
```

The rest of the existing beam weapon and dive completion logic continues unchanged.

---

## Phase 5: Cleanup and Edge Case Handling

### 5.1 Add Cleanup Logic to `oEnemyBase/Destroy_0.gml`

Add cleanup logic at the **BEGINNING** of the Destroy event (after line 18, before the boundary check):

```gml
/// ================================================================
/// GROUP DIVE CLEANUP - Break group dive references
/// ================================================================
/// When an enemy is destroyed, clean up group dive relationships
/// to prevent orphaned references and ensure proper state management.
/// ================================================================

// If this was a leader, clear follower references
if (array_length(groupFollowers) > 0) {
    for (var i = 0; i < array_length(groupFollowers); i++) {
        var follower_id = groupFollowers[i];
        if (instance_exists(follower_id)) {
            // Clear follower's leader reference
            follower_id.groupLeader = noone;
            follower_id.groupPathOffset = 0;
            
            // If follower is mid-dive, it will continue solo
            // or transition appropriately based on its state
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

// Clear own references
groupLeader = noone;
groupPathOffset = 0;
```

### 5.2 Handle Path Completion for Groups

In `oEnemyBase/Step_0.gml`, update the dive completion logic (around line 429-482). 

**MODIFY** the section that handles path completion to ensure groups transition together:

```gml
// follow DIVE path until a certain Y location ...
if (y <= DIVE_Y_THRESHOLD * global.Game.Display.scale) {
    // do nothing ... execute DIVE PATH
}
else if ((y > DIVE_Y_THRESHOLD * global.Game.Display.scale)) {
    // If in a group as leader, followers will handle their own transitions
    // If in a group as follower, follow leader's state transitions
    if (groupLeader != noone && instance_exists(groupLeader)) {
        var leader = groupLeader;
        // Follow leader's state - if leader transitions, we should too
        // But only after we've completed our own path checks
    }
    
    // loop if we have more than 2 enemies left on the screen (otherwise, we will move into FINAL ATTACK mode)
    if (attributes.CAN_LOOP && global.Game.Enemy.count > 2) {
        // ... existing loop logic ...
        
        // Clear group references when transitioning to loop
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
        if (groupLeader != noone) {
            groupLeader = noone;
            groupPathOffset = 0;
        }
    }
    // ... rest of existing completion logic ...
}
```

---

## Phase 6: Dive Capacity Accounting

### 6.1 Update Dive Capacity Check

The group dive should consume **ONE dive capacity slot** (for the entire group), not one per enemy. This is already handled in `setup_group_dive_attack()`, but we need to ensure the capacity check doesn't double-count.

**Verify** in `scripts/EnemyManagement/EnemyManagement.gml` that the dive capacity calculation doesn't count followers separately. The current logic should be fine since it checks `enemyState != EnemyState.IN_FORMATION`, but verify:

```gml
// In checkDiveCapacity() function
// This should correctly count groups as 1 since both leader and follower
// will have enemyState == EnemyState.IN_DIVE_ATTACK
```

---

## Testing Checklist

### Basic Functionality
- [ ] TieIntercepter can initiate solo dive (existing behavior preserved)
- [ ] TieIntercepter can initiate group dive with 1 Imperial Shuttle when 1 is available below
- [ ] TieIntercepter can initiate group dive with 1 Imperial Shuttle when 2 are available below (randomly selects one)
- [ ] TieIntercepter sometimes dives alone even when followers are available (random chance)
- [ ] Group maintains formation spacing during dive (15% path offset)
- [ ] Group completes dive together

### Formation Requirements
- [ ] Only Imperial Shuttles in the same column, directly below (INDEX+5 or INDEX+10) are eligible
- [ ] Shuttles in adjacent columns are NOT eligible
- [ ] Shuttles in the same row are NOT eligible
- [ ] Only shuttles in `IN_FORMATION` state are eligible

### Edge Cases
- [ ] Leader destruction breaks group properly (follower continues solo or returns)
- [ ] Follower destruction doesn't break leader
- [ ] Multiple groups can exist simultaneously (if dive capacity allows)
- [ ] Group dive respects dive capacity (counts as 1 dive, not 2)
- [ ] Leader beam weapon works correctly during group dive
- [ ] Group transitions to loop attack correctly
- [ ] Group handles final attack state correctly

### Visual/Gameplay
- [ ] Follower maintains consistent spacing behind leader
- [ ] Path following looks smooth and natural
- [ ] No visual glitches during group dive
- [ ] Sound effects play correctly for group dives

---

## Implementation Order

1. **Phase 1**: Add data structures (variables to Create_0.gml, flags to enemy-specific Create events)
2. **Phase 2**: Create helper functions (`find_imperial_shuttle_follower`, `setup_group_dive_attack`)
3. **Phase 3**: Modify dive trigger logic in Step_0.gml IN_FORMATION state
4. **Phase 4**: Add follower synchronization in Step_0.gml IN_DIVE_ATTACK state
5. **Phase 5**: Add cleanup logic in Destroy_0.gml
6. **Phase 6**: Test and verify dive capacity accounting

---

## Design Notes

### Path Offset Strategy
- **Fixed offset (0.15)**: Simple, predictable, creates visible formation spacing
- Followers start 15% behind leader on the path
- This creates the classic "trailing" formation effect from Galaga

### Randomization Strategy
- **50% chance** to use group dive if eligible followers exist
- This means TieIntercepter will dive alone ~50% of the time even with followers available
- When 2 eligible shuttles exist, randomly selects one (not both)

### Formation Validation
- Uses INDEX math to verify exact column alignment
- Checks `INDEX mod 5` for column matching
- Checks `floor(INDEX / 5)` for row relationship
- Only checks positions INDEX+5 and INDEX+10 (directly below, up to 2 rows)

### Performance Considerations
- Helper function uses single `with` loop to find candidates
- Minimal path position updates per frame
- Cleanup handled efficiently in Destroy event

---

## Future Enhancements (Optional)

1. **Configurable Randomization**: Make solo/group dive probability configurable
2. **Multiple Followers**: Allow 2 shuttles to follow simultaneously (if both available)
3. **Visual Indicators**: Show connection lines or glow effects for group members
4. **Coordinated Shooting**: Synchronize follower shots with leader
5. **Dynamic Grouping**: Allow enemies to join group mid-dive
6. **Different Formations**: V-shape, line, diamond formations during dive

---

## Related Files

- `objects/oEnemyBase/Create_0.gml` - Variable initialization
- `objects/oEnemyBase/Step_0.gml` - Main behavior logic
- `objects/oEnemyBase/Destroy_0.gml` - Cleanup logic
- `objects/oTieIntercepter/Create_0.gml` - TieIntercepter-specific setup
- `objects/oImperialShuttle/Create_0.gml` - Imperial Shuttle-specific setup (to be created)
- `scripts/EnemyBehavior/EnemyBehavior.gml` - Helper functions
- `scripts/EnemyManagement/EnemyManagement.gml` - Dive capacity management
- `datafiles/Patterns/formation_coordinates.json` - Formation grid positions

---

## Summary

This implementation provides a complete solution for group dive attacks matching classic Galaga mechanics. The system:
- Respects formation positioning requirements (exactly below, same column)
- Randomly selects from eligible followers or dives solo
- Maintains proper path synchronization during dives
- Handles cleanup and edge cases appropriately
- Preserves existing solo dive behavior

The implementation is modular, testable, and follows existing code patterns in the project.

