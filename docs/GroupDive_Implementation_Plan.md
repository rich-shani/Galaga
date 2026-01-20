# Group Dive Attack Implementation Plan
## oTieIntercepter + oImperialShuttle Coordinated Dives

## Overview

This document provides a detailed, step-by-step approach for implementing the group dive attack feature where `oTieIntercepter` enemies can dive with up to two `oImperialShuttle` followers. This matches the classic Galaga arcade game mechanics where enemies in formation can dive together.

## Core Requirements

1. **oTieIntercepter** can initiate dives alone OR with followers (1 or 2)
2. **oImperialShuttle** can follow an oTieIntercepter during dives
3. **Formation Requirement**: TieIntercepters are always in row 0, Imperial Shuttles are always in row 1
4. **Hardcoded Relationships**: Group relationships are hardcoded based on specific INDEX values (see Formation Mapping below)
5. **Random Selection**: Randomly choose 0, 1, or 2 followers from eligible shuttles (can dive alone even if followers available)
6. **Path Following**: Followers maintain the same path trajectory as the leader with slight offset

## Formation Grid Structure

The game uses a **5 column × 8 row grid** (40 positions total):
- **INDEX range**: 0-39
- **TieIntercepters**: Always in row 0 (4 positions)
- **Imperial Shuttles**: Always in row 1 (associated with specific TieIntercepters)
- **INDEX values are NOT sequential** - specific INDEX values must be used

### Hardcoded Group Formation Mapping

The relationship between TieIntercepters and their associated Imperial Shuttles is **hardcoded** based on INDEX values:

| TieIntercepter INDEX | Imperial Shuttle INDEXs (left to right) |
|---------------------|------------------------------------------|
| 9                   | 22, 10                                   |
| 13                  | 10, 2                                    |
| 11                  | 4, 12                                    |
| 15                  | 12, 17                                   |

**TieIntercepter positions (left to right)**: 9, 13, 11, 15

**Notes:**
- Each TieIntercepter has exactly 2 associated Imperial Shuttle positions
- Up to 2 of the associated shuttles can join a group dive
- If an Imperial Shuttle doesn't exist at an INDEX (destroyed or not spawned), it cannot be selected
- Note: Some Imperial Shuttle INDEXs appear for multiple TieIntercepters (e.g., INDEX 10 for both 9 and 13; INDEX 12 for both 11 and 15)

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
/// @function find_imperial_shuttle_followers
/// @description Finds up to 2 Imperial Shuttles associated with a TieIntercepter
///              based on hardcoded INDEX relationships. Returns array of 0, 1, or 2
///              follower instance IDs.
/// @param {Id.Instance} _leader The TieIntercepter initiating the dive
/// @return {Array<Id.Instance>} Array of selected follower enemy IDs (empty if none)
function find_imperial_shuttle_followers(_leader) {
    var result = [];
    
    // Validate leader
    if (!instance_exists(_leader)) {
        return result;
    }
    
    var leader_index = _leader.INDEX;
    
    // Hardcoded mapping: TieIntercepter INDEX -> Imperial Shuttle INDEXs
    // TieIntercepters at INDEX: 9, 13, 11, 15 (left to right)
    var associated_indices = [];
    
    switch (leader_index) {
        case 9:
            // First TieIntercepter (leftmost) -> Shuttles at INDEX 22, 10
            associated_indices = [22, 10];
            break;
        case 13:
            // Second TieIntercepter -> Shuttles at INDEX 10, 2
            associated_indices = [10, 2];
            break;
        case 11:
            // Third TieIntercepter -> Shuttles at INDEX 4, 12
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
    
    with (oEnemyBase) {
        // Check if this enemy is an eligible candidate
        if (enemyState == EnemyState.IN_FORMATION &&
            ENEMY_NAME == "oImperialShuttle" &&
            canFollowGroupDive &&
            groupLeader == noone &&  // Not already following someone
            array_length(groupFollowers) == 0) {  // Not leading a group
            
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
    
    // Randomly decide whether to use group dive (50% chance if candidates exist)
    if (array_length(candidates) == 0) {
        return result;  // No eligible followers
    }
    
    // Random chance: sometimes dive alone even if followers available
    if (irandom(1) == 0) {
        return result;  // Solo dive (50% chance)
    }
    
    // Select 1 or 2 followers randomly
    if (array_length(candidates) == 1) {
        // Only one candidate - use it
        array_push(result, candidates[0]);
    } else if (array_length(candidates) == 2) {
        // Two candidates - randomly decide: use 1 or both
        if (irandom(1) == 0) {
            // Use one (randomly selected)
            array_push(result, candidates[irandom(1)]);
        } else {
            // Use both
            result = candidates;
        }
    }
    
    return result;
}
```

### 2.2 Create Helper Function: Setup Group Dive Attack

Add to `scripts/EnemyBehavior/EnemyBehavior.gml`:

```gml
/// @function setup_group_dive_attack
/// @description Configures and initiates a group dive attack with a leader
///              and 1-2 followers. Followers follow the leader's path with
///              slight offsets to maintain formation spacing.
/// @param {Id.Instance} _leader The TieIntercepter leading the dive
/// @param {Array<Id.Instance>} _followers Array of 1-2 Imperial Shuttles following
/// @param {Int} _path_id The path asset ID to follow
/// @return {undefined}
function setup_group_dive_attack(_leader, _followers, _path_id) {
    if (!instance_exists(_leader) || _path_id == -1) {
        return;
    }
    
    // Validate followers array
    var valid_followers = [];
    for (var i = 0; i < array_length(_followers); i++) {
        if (instance_exists(_followers[i])) {
            array_push(valid_followers, _followers[i]);
        }
    }
    
    // Limit to 2 followers max
    if (array_length(valid_followers) > 2) {
        valid_followers = array_slice(valid_followers, 0, 2);
    }
    
    with (_leader) {
        // Store follower references
        groupFollowers = valid_followers;
        groupPathOffset = 0;  // Leader is at position 0 on path
        
        // Start the dive path for leader
        path_start(_path_id, moveSpeed, 0, 0);
        enemyState = EnemyState.IN_DIVE_ATTACK;
        
        // Set shooting timer (shots during dive)
        alarm[1] = ENEMY_SHOT_ALARM;
    }
    
    // Setup each follower
    for (var i = 0; i < array_length(valid_followers); i++) {
        var follower = valid_followers[i];
        if (instance_exists(follower)) {
            with (follower) {
                // Link to leader
                groupLeader = _leader.id;
                
                // Set path offset (followers start behind leader on path)
                // First follower: 15% offset, second follower: 30% offset
                groupPathOffset = 0.15 + (i * 0.15);
                
                // Start following the same path
                path_start(_path_id, moveSpeed, 0, 0);
                
                // Set initial path position to offset (followers start behind leader)
                path_position = groupPathOffset;
                
                // Transition to dive attack state
                enemyState = EnemyState.IN_DIVE_ATTACK;
                
                // Set shooting timer (offset for visual variety)
                alarm[1] = ENEMY_SHOT_ALARM + (10 * (i + 1));
            }
        }
    }
    
    // Group dive consumes only ONE dive capacity slot (for entire group)
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
        var followers = [];
        
        if (canLeadGroupDive && ENEMY_NAME == "oTieIntercepter") {
            // Try to find eligible Imperial Shuttle followers (1 or 2)
            followers = find_imperial_shuttle_followers(self);
            if (array_length(followers) > 0) {
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
        if (use_group_dive && selected_path != -1 && array_length(followers) > 0) {
            // Setup group dive attack (with 1 or 2 followers)
            setup_group_dive_attack(self, followers, selected_path);
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
- [ ] TieIntercepter can initiate group dive with 1 Imperial Shuttle when 1 is available in eligible positions
- [ ] TieIntercepter can initiate group dive with 1 Imperial Shuttle when 2+ are available (randomly selects 1)
- [ ] TieIntercepter can initiate group dive with 2 Imperial Shuttles when 2+ are available (randomly selects 2)
- [ ] TieIntercepter sometimes dives alone even when followers are available (random chance)
- [ ] Group maintains formation spacing during dive (15% and 30% path offsets for followers)
- [ ] Group completes dive together

### Formation Requirements
- [ ] Only TieIntercepters at INDEX 9, 13, 11, or 15 can lead group dives
- [ ] Each TieIntercepter has hardcoded associated Imperial Shuttle INDEXs:
  - INDEX 9 → Shuttles at INDEX 22, 10
  - INDEX 13 → Shuttles at INDEX 10, 2
  - INDEX 11 → Shuttles at INDEX 4, 12
  - INDEX 15 → Shuttles at INDEX 12, 17
- [ ] Only Imperial Shuttles at the specific associated INDEXs are eligible
- [ ] Shuttles at non-associated INDEXs are NOT eligible
- [ ] Only shuttles in `IN_FORMATION` state are eligible
- [ ] If a shuttle is destroyed/not spawned, it cannot be selected
- [ ] Note: Some Imperial Shuttle INDEXs are shared (10 for both 9 and 13; 12 for both 11 and 15), so a shuttle can only join the group if it matches the initiating TieIntercepter's association

### Edge Cases
- [ ] Leader destruction breaks group properly (followers continue solo or return)
- [ ] One follower destruction doesn't break leader or other follower
- [ ] Multiple groups can exist simultaneously (if dive capacity allows)
- [ ] Group dive respects dive capacity (counts as 1 dive, not 2 or 3)
- [ ] Leader beam weapon works correctly during group dive
- [ ] Group transitions to loop attack correctly
- [ ] Group handles final attack state correctly
- [ ] When 2 eligible shuttles exist, selection of 1 or both is random (50/50)
- [ ] Shared INDEX handling: When INDEX 10 exists, only joins group for TieIntercepter 9 or 13 based on which initiated
- [ ] Shared INDEX handling: When INDEX 12 exists, only joins group for TieIntercepter 11 or 15 based on which initiated

### Visual/Gameplay
- [ ] Followers maintain consistent spacing behind leader (15% and 30% offsets)
- [ ] Path following looks smooth and natural for both 1 and 2 followers
- [ ] Formation spacing looks correct with 2 followers (not overlapping)
- [ ] No visual glitches during group dive
- [ ] Sound effects play correctly for group dives

---

## Implementation Order

1. **Phase 1**: Add data structures (variables to Create_0.gml, flags to enemy-specific Create events)
2. **Phase 2**: Create helper functions (`find_imperial_shuttle_followers`, `setup_group_dive_attack`)
3. **Phase 3**: Modify dive trigger logic in Step_0.gml IN_FORMATION state
4. **Phase 4**: Add follower synchronization in Step_0.gml IN_DIVE_ATTACK state
5. **Phase 5**: Add cleanup logic in Destroy_0.gml
6. **Phase 6**: Test and verify dive capacity accounting

---

## Design Notes

### Path Offset Strategy
- **Progressive offsets**: First follower at 15%, second follower at 30% behind leader
- Creates visible formation spacing with multiple followers
- This creates the classic "trailing" formation effect from Galaga

### Randomization Strategy
- **50% chance** to use group dive if eligible followers exist
- This means TieIntercepter will dive alone ~50% of the time even with followers available
- When 1 eligible shuttle exists: uses it
- When 2 eligible shuttles exist: randomly selects 1 or both (50/50 chance)
- When 3 eligible shuttles exist: randomly selects 1 or 2 (equal probability)

### Formation Validation
- Uses hardcoded switch statement to map TieIntercepter INDEX to associated Shuttle INDEXs
- Four TieIntercepters at INDEX: 9, 13, 11, 15 (left to right)
- Each TieIntercepter has exactly 2 associated Imperial Shuttle positions
- Validates that Imperial Shuttles exist at the specific INDEX values
- No positional math required - purely INDEX-based lookup

### Performance Considerations
- Helper function uses single `with` loop to find candidates
- Minimal path position updates per frame
- Cleanup handled efficiently in Destroy event

---

## Future Enhancements (Optional)

1. **Configurable Randomization**: Make solo/group dive probability configurable
2. **Visual Indicators**: Show connection lines or glow effects for group members
3. **Coordinated Shooting**: Synchronize follower shots with leader
4. **Dynamic Grouping**: Allow enemies to join group mid-dive
5. **Different Formations**: V-shape, line, diamond formations during dive
6. **Variable Path Offsets**: Adjust offsets based on number of followers for better spacing

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
- Uses hardcoded INDEX relationships for precise formation control (4 TieIntercepters at INDEX 9, 13, 11, 15)
- Each TieIntercepter has 2 associated Imperial Shuttle INDEXs hardcoded in a switch statement
- Randomly selects 0, 1, or 2 followers from eligible shuttles based on INDEX lookups
- Maintains proper path synchronization during dives with progressive offsets (15% and 30%)
- Handles cleanup and edge cases appropriately
- Preserves existing solo dive behavior

The implementation is modular, testable, and follows existing code patterns in the project. The hardcoded INDEX approach ensures precise control over which enemies can group together, matching the specific formation layout of the game.

