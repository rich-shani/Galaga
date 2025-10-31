# Error Handling Quick Reference

## Quick Start

All error handling functions are available in `scripts/ErrorHandling/ErrorHandling.gml`

### Common Usage Examples

#### 1. Safe Asset Lookup
```gml
var enemy_id = safe_get_asset("oTieFighter", -1);
if (enemy_id != -1) {
    instance_create_layer(x, y, "GameSprites", enemy_id);
} else {
    log_error("Enemy asset not found", "my_function", 2);
}
```

#### 2. Safe JSON Loading
```gml
var data = safe_load_json("Patterns/wave_spawn.json", {});
if (!is_struct(data)) {
    log_error("Failed to load wave data", "my_function", 2);
    return; // Exit with safe default
}
```

#### 3. Safe Struct Access
```gml
var health = safe_struct_get(attributes, "HEALTH", 1);
// health will be 1 if HEALTH key doesn't exist
```

#### 4. Safe Array Access
```gml
var enemy_type = safe_array_get(enemy_array, index, "oTieFighter");
// enemy_type will be "oTieFighter" if index is out of bounds
```

#### 5. Logging Errors
```gml
log_error("Something went wrong", "my_function_name", 2);
// Outputs: [ERROR] Something went wrong (Context: my_function_name)
```

## Error Severity Levels

| Level | Name | Use When |
|-------|------|----------|
| 0 | DEBUG | Development info, non-critical |
| 1 | WARNING | Recoverable issues |
| 2 | ERROR | Degraded functionality |
| 3 | CRITICAL | Requires immediate attention |

## Function Reference

### `log_error(msg, context, severity)`
Logs error with severity level
```gml
log_error("Asset failed to load", "spawnEnemy", 2);
```

### `safe_load_json(filepath, default)`
Loads JSON safely with fallback
```gml
var config = safe_load_json("config.json", {});
```

### `safe_get_asset(name, default)`
Gets asset ID safely
```gml
var path_id = safe_get_asset("my_path", -1);
```

### `safe_struct_get(struct, key, default)`
Gets struct value safely
```gml
var health = safe_struct_get(enemy_data, "HEALTH", 1);
```

### `safe_array_get(array, index, default)`
Gets array element safely
```gml
var value = safe_array_get(my_array, 5, 0);
```

### `validate_json_structure(data, required_keys, context)`
Validates JSON has required fields
```gml
var required = ["WAVE", "SPAWN", "ENEMY"];
if (validate_json_structure(data, required, "wave_data")) {
    // data is valid
}
```

### `safe_instance_number(object)`
Counts instances safely
```gml
var count = safe_instance_number(oTieFighter);
```

### `safe_path_get(path_id, position, default)`
Gets path position safely
```gml
var pos = safe_path_get(path_id, 0, [0, 0]);
var x = pos[0];
var y = pos[1];
```

## Error Message Format

All errors follow this format:
```
[SEVERITY] Error message (Context: function_name)
```

Example output:
```
[ERROR] Asset not found: oTieFighter (Context: spawnEnemy)
[WARNING] Challenge path not found: ChallPath1 (Context: spawnChallengeEnemy)
[CRITICAL] global.formation_data is not initialized (Context: oEnemyBase Create_0)
```

## Debug Console Output

Run the game and check the Output panel in GameMaker to see error messages:

1. **Open Output Panel:** Debug → Output (Alt+O)
2. **Filter by context:** Use Ctrl+F to search for function names
3. **Check severity:** Look for [ERROR] and [CRITICAL] messages first
4. **Find related errors:** Group errors by context to understand impact

## Common Error Scenarios

### Asset Not Found
```gml
[ERROR] Asset not found: oMissingEnemy (Context: spawnEnemy)
```
**Solution:** Check that enemy object name matches JSON data

### Path Not Found
```gml
[ERROR] Challenge path not found: ChallPath_Wrong (Context: spawnChallengeEnemy)
```
**Solution:** Verify path exists in GameMaker path editor with exact name

### JSON Parse Error
```gml
[ERROR] JSON parse error in Patterns/wave_spawn.json: ... (Context: safe_load_json)
```
**Solution:** Validate JSON file syntax (check for missing commas, quotes, etc.)

### Missing Data Field
```gml
[ERROR] Struct key not found: HEALTH (Context: safe_struct_get)
```
**Solution:** Ensure JSON files have all required fields

### Uninitialized Global
```gml
[CRITICAL] global.enemy_attributes is not initialized (Context: oEnemyBase Create_0)
```
**Solution:** Verify globals are initialized in Create event before use

## Adding Error Handling to New Code

### Template for New Functions
```gml
function my_spawn_function() {
    // Validate inputs
    var asset_id = safe_get_asset("oTieFighter", -1);
    if (asset_id == -1) {
        log_error("Cannot spawn enemy: asset not found", "my_spawn_function", 2);
        return; // Exit early
    }

    // Safe data access
    var enemy_data = safe_struct_get(wave_data, "ENEMY", {});
    if (!is_struct(enemy_data)) {
        log_error("Enemy data is invalid", "my_spawn_function", 2);
        return;
    }

    // Proceed with valid data
    instance_create_layer(0, 0, "GameSprites", asset_id);
}
```

## Best Practices

1. **Always use safe functions for external data**
   - JSON files
   - Asset names
   - Struct/array access

2. **Log at appropriate severity**
   - DEBUG: For development diagnostics
   - WARNING: For recoverable issues
   - ERROR: For functionality loss
   - CRITICAL: For potential crashes

3. **Provide context in error messages**
   - Include the asset/key that failed
   - Mention expected vs. actual values
   - Add context about what was being attempted

4. **Use meaningful default values**
   - Return values that allow game to continue
   - Use sensible fallbacks (1 for health, 0 for counts)
   - Only return undefined if function requires valid data

5. **Check for critical errors early**
   - Validate global data on startup
   - Check required files exist before loading
   - Fail fast for unrecoverable issues

## Testing Error Handling

### Simulate Missing Assets
```gml
// In debug console or test code:
show_debug_message(safe_get_asset("nonexistent_asset", -1));
// Should output: [WARNING] Asset not found: nonexistent_asset (Context: safe_get_asset)
```

### Simulate Bad JSON
```gml
// Create test JSON file with invalid syntax
var data = safe_load_json("invalid.json", {});
// Should log parse error and return empty struct
```

### Monitor in Production
Check debug console during gameplay:
- Watch for [ERROR] level messages
- Note which assets/paths are missing
- Use as basis for content updates

## Support

For questions about error handling:
1. Check this quick reference
2. Review ERROR_HANDLING_IMPROVEMENTS.md for detailed documentation
3. Look at modified code in GameManager_STEP_FNs.gml and oEnemyBase/Create_0.gml
4. Test with the Error Handling Utility functions
