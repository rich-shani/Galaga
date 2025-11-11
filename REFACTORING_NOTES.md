# Refactoring Notes

This file documents recommended refactorings that require GameMaker Studio 2 IDE operations.

## Priority 2: Point Display Objects Consolidation

### Current State

There are 5 duplicate objects that display point values:
- `Points150` (sprite frame 0)
- `Points400` (sprite frame 1)
- `Points800` (sprite frame 2)
- `Points1000` (sprite frame 3)
- `Points1600` (sprite frame 4)

All objects are identical except for the sprite frame index in their `Draw_0` event.

**Code Duplication:**
- 5 objects × 4 files each = 20 files
- ~100 lines of duplicated code
- Maintenance burden: changes must be made 5 times

### Recommended Refactoring

**Create Single Unified Object: `oPointsDisplay`**

#### Step 1: Create New Object in GameMaker IDE

1. Right-click in Objects folder → Create → Object
2. Name it `oPointsDisplay`
3. Add the following events:

**Create_0.gml:**
```gml
/// @description Initialize point display with configurable sprite frame
/// Instance variable 'spriteFrame' should be passed during instance_create_layer

// Validate spriteFrame was provided
if (!variable_instance_exists(id, "spriteFrame")) {
    log_error("oPointsDisplay created without spriteFrame parameter", "oPointsDisplay Create", 2);
    spriteFrame = 0;  // Default to 150 points
}

alarm[1] = 10;  // Delay before showing
alarm[0] = 70;  // Destroy after display
```

**Draw_0.gml:**
```gml
/// @description Draw the appropriate points sprite
if (alarm[1] == -1) {
    draw_sprite_ext(spr_Galagapoints, spriteFrame, x, y,
                    global.Game.Display.scale, global.Game.Display.scale,
                    0, c_white, 1);
}
```

**Alarm_0.gml:**
```gml
instance_destroy();
```

**Alarm_1.gml:**
```gml
// Empty - alarm[1] is just a display delay timer
```

#### Step 2: Update Usage in oTitleScreen/Alarm_1.gml

Replace the four instance_create calls (lines 26, 34, 41, 46):

**Before:**
```gml
instance_create(360*global.Game.Display.scale+x, 336*global.Game.Display.scale+y, Points1600);
instance_create(260*global.Game.Display.scale+x, 336*global.Game.Display.scale+y, Points800);
instance_create(180*global.Game.Display.scale+x, 336*global.Game.Display.scale+y, Points400);
instance_create(80*global.Game.Display.scale, 336*global.Game.Display.scale, Points150);
```

**After:**
```gml
instance_create_layer(360*global.Game.Display.scale+x, 336*global.Game.Display.scale+y, "UI", oPointsDisplay, { spriteFrame: 4 });  // 1600 points
instance_create_layer(260*global.Game.Display.scale+x, 336*global.Game.Display.scale+y, "UI", oPointsDisplay, { spriteFrame: 2 });  // 800 points
instance_create_layer(180*global.Game.Display.scale+x, 336*global.Game.Display.scale+y, "UI", oPointsDisplay, { spriteFrame: 1 });  // 400 points
instance_create_layer(80*global.Game.Display.scale, 336*global.Game.Display.scale, "UI", oPointsDisplay, { spriteFrame: 0 });  // 150 points
```

**Sprite Frame Mapping:**
- Frame 0 = 150 points
- Frame 1 = 400 points
- Frame 2 = 800 points
- Frame 3 = 1000 points
- Frame 4 = 1600 points

#### Step 3: Delete Old Objects

In GameMaker IDE:
1. Right-click each old object → Delete
   - `Points150`
   - `Points400`
   - `Points800`
   - `Points1000`
   - `Points1600`

2. Confirm deletion when prompted

#### Step 4: Test

1. Run the game and verify title screen displays point values correctly
2. Check that timing matches original behavior (10 frame delay, 70 frame duration)

### Expected Benefits

- **Code Reduction:** Removes ~100 lines of duplicated code
- **Maintainability:** Single source of truth for point display logic
- **Flexibility:** Easy to add new point values (just use different spriteFrame)
- **Consistency:** All point displays guaranteed to behave identically

### Estimated Time: 15 minutes

---

## Other Refactoring Recommendations

### Object Renaming: oGameMGR → oTitleScreenManager

**Requires:** GameMaker IDE refactoring tool

**Steps:**
1. Right-click `oGameMGR` in Objects folder
2. Select "Rename"
3. Enter new name: `oTitleScreenManager`
4. IDE will automatically update all references

**Rationale:** Current name suggests general game management, but object only handles title screen logic.

---

*Last Updated: 2025-11-11*
