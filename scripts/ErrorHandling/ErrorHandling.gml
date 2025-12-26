/// @file ErrorHandling.gml
/// @description Centralized error handling && validation utilities for robust, production-quality code
///              Provides safe wrappers for file operations, asset lookups, && data access
///              All functions include comprehensive error logging && graceful failure handling

// ============================================================================
// ERROR CODE ENUMERATION
// ============================================================================

/// @enum ErrorCode
/// Standard error codes for consistent error reporting
enum ErrorCode {
	SUCCESS = 0,                   // Operation completed successfully
	FILE_NOT_FOUND = 1,            // File does not exist
	JSON_PARSE_ERROR = 2,          // JSON parsing failed
	ASSET_NOT_FOUND = 3,           // Asset does not exist
	INVALID_DATA_STRUCTURE = 4,    // Data structure is malformed
	NULL_REFERENCE = 5,            // Null || undefined reference
	UNKNOWN_ERROR = 99             // Unexpected error occurred
}

// ============================================================================
// LOGGING FUNCTION - Core error reporting
// ============================================================================

/// @function log_error
/// @description Logs an error message with severity level && context information
///              Output format: [SEVERITY] Message (Context: context_name)
///              Writes to both debug console && log file in production
/// @param {String} _error_msg    Error message describing what went wrong
/// @param {String} _context      Context string (function name, module name)
/// @param {Real}   _severity     Severity level: 0=DEBUG, 1=WARNING, 2=ERROR, 3=CRITICAL
/// @return {undefined}
function log_error(_error_msg, _context = "Unknown", _severity = 2) {
	// Define severity level names
	var severity_names = ["DEBUG", "WARNING", "ERROR", "CRITICAL"];

	// Get severity string (with bounds checking)
	var severity_str = ((_severity >= 0 && _severity < 4) ? severity_names[_severity] : "UNKNOWN");

	// Format timestamp
	var timestamp = string(current_year) + "-" +
	                string_format(current_month, 2, 0) + "-" +
	                string_format(current_day, 2, 0) + " " +
	                string_format(current_hour, 2, 0) + ":" +
	                string_format(current_minute, 2, 0) + ":" +
	                string_format(current_second, 2, 0);

	// Format error message with timestamp && context
	var log_msg = "[" + severity_str + "] " + _error_msg + " (Context: " + _context + ")";
	var log_msg_with_timestamp = timestamp + " " + log_msg;

	// === OUTPUT TO DEBUG CONSOLE ===
	// Always output to console for development
	show_debug_message(log_msg);

	// === WRITE TO LOG FILE ===
	// Write to file for production error tracking
	// Only log ERROR && CRITICAL by default (change _severity >= 2 to adjust)
	if (_severity >= 2) {
		try {
			var _file;

			// Open log file (append if exists, create if doesn't)
			if (file_exists("error_log.txt")) {
				_file = file_text_open_append("error_log.txt");
			} else {
				_file = file_text_open_write("error_log.txt");
			}

			// Write log entry
			file_text_writeln(_file);

			// Close file handle
			file_text_close(_file);
		} catch (_exception) {
			// Fail silently if file logging fails (don't create infinite loop)
			show_debug_message("[ERROR] Failed to write to error log file: " + string(_exception));
		}
	}
}

// ============================================================================
// SAFE JSON LOADING - File I/O with comprehensive error handling
// ============================================================================

/// @function safe_load_json
/// @description Safely loads && parses a JSON file with error handling
///              Validates file existence, file content, && JSON syntax
///              Returns default value on any error instead of crashing
/// @param {String} _filepath Path to the JSON file (e.g., "Patterns/wave_spawn.json")
/// @param {*}     _default   Default value to return if loading fails (default: undefined)
/// @return {Struct|*}        Parsed JSON data structure || default value on error
function safe_load_json(_filepath, _default = undefined) {
	// === STEP 1: VALIDATE FILEPATH PARAMETER ===
	if (!is_string(_filepath) || string_length(_filepath) == 0) {
		log_error("Invalid filepath provided", "safe_load_json", 2);
		return _default;
	}

	// === STEP 2: CHECK IF FILE EXISTS ===
	if (!file_exists(_filepath)) {
		log_error("JSON file not found: " + _filepath, "safe_load_json", 2);
		return _default;
	}

	var _data = "";

	// === STEP 3: TRY TO READ AND PARSE FILE ===
	try {
		// Open the file for reading
		var _file_id = file_text_open_read(_filepath);

		// Read entire file line by line
		while (!file_text_eof(_file_id)) {
			_data += file_text_readln(_file_id);
		}

		// Close the file handle
		file_text_close(_file_id);

		// === STEP 4: VALIDATE FILE HAD CONTENT ===
		if (string_length(_data) == 0) {
			log_error("JSON file is empty: " + _filepath, "safe_load_json", 1);
			return _default;
		}

		// === STEP 5: PARSE THE JSON ===
		var _parsed = json_parse(_data);

		// === STEP 6: VALIDATE PARSING SUCCEEDED ===
		// json_parse() returns a string on error, struct on success
		if (is_string(_parsed)) {
			log_error("JSON parse error in " + _filepath + ": " + _parsed, "safe_load_json", 2);
			return _default;
		}

		// === STEP 7: RETURN SUCCESSFULLY PARSED DATA ===
		return _parsed;

	} catch (_exception) {
		// === STEP 8: CATCH ANY UNEXPECTED EXCEPTIONS ===
		log_error("Exception while loading JSON from " + _filepath + ": " + _exception.message, "safe_load_json", 2);
		return _default;
	}
}

// ============================================================================
// SAFE ASSET LOOKUP - GameMaker asset validation
// ============================================================================

/// @function safe_get_asset
/// @description Safely retrieves an asset ID (object, sprite, sound, etc.) with validation
///              Returns -1 if asset doesn't exist (GameMaker standard)
///              Logs missing assets for debugging
/// @param {String} _asset_name Name of the asset to retrieve (e.g., "oTieFighter")
/// @param {Real}   _default    Default value to return if !found (default: -1)
/// @return {Real}              Asset ID || default value if !found
function safe_get_asset(_asset_name, _default = -1) {
	// === VALIDATE ASSET NAME PARAMETER ===
	if (!is_string(_asset_name) || string_length(_asset_name) == 0) {
		log_error("Invalid asset name provided", "safe_get_asset", 2);
		return _default;
	}

	// === TRY TO GET THE ASSET ===
	var _asset_id = asset_get_index(_asset_name);

	// === CHECK IF ASSET WAS FOUND ===
	if (_asset_id == -1) {
		log_error("Asset not found: " + _asset_name, "safe_get_asset", 1);
		return _default;
	}

	// === RETURN VALID ASSET ID ===
	return _asset_id;
}

// ============================================================================
// SAFE STRUCT ACCESS - Dictionary/map safe retrieval
// ============================================================================

/// @function safe_struct_get
/// @description Safely retrieves a value from a struct with validation
///              Checks that struct is valid && key exists before access
///              Returns default value instead of undefined reference errors
/// @param {Struct}   _struct   The struct to read from
/// @param {String}   _key      The key to retrieve
/// @param {*}        _default  Default value if key not found || struct invalid
/// @return {*}                 Value from struct || default value
function safe_struct_get(_struct, _key, _default = undefined) {
	// === VALIDATE STRUCT PARAMETER ===
	if (!is_struct(_struct)) {
		log_error("Invalid struct provided for key: " + _key, "safe_struct_get", 2);
		return _default;
	}

	// === VALIDATE KEY PARAMETER ===
	if (!is_string(_key) || string_length(_key) == 0) {
		log_error("Invalid key provided", "safe_struct_get", 2);
		return _default;
	}

	// === CHECK IF KEY EXISTS IN STRUCT ===
	if (!struct_exists(_struct, _key)) {
		log_error("Struct key not found: " + _key, "safe_struct_get", 1);
		return _default;
	}

	// === RETURN THE VALUE ===
	return _struct[$ _key];
}

// ============================================================================
// SAFE ARRAY ACCESS - Array bounds checking
// ============================================================================

/// @function safe_array_get
/// @description Safely retrieves a value from an array with bounds checking
///              Prevents out-of-bounds array access crashes
///              Returns default value if index is invalid
/// @param {Array}  _array     The array to read from
/// @param {Real}   _index     The index to retrieve (0-based)
/// @param {*}      _default   Default value if index out of bounds
/// @return {*}                Value from array || default value
function safe_array_get(_array, _index, _default = undefined) {
	// === VALIDATE ARRAY PARAMETER ===
	if (!is_array(_array)) {
		log_error("Invalid array provided", "safe_array_get", 2);
		return _default;
	}

	// === VALIDATE INDEX PARAMETER AND BOUNDS ===
	if (!is_real(_index) || _index < 0 || _index >= array_length(_array)) {
		log_error("Array index out of bounds: " + string(_index), "safe_array_get", 1);
		return _default;
	}

	// === RETURN THE VALUE ===
	return _array[_index];
}

// ============================================================================
// JSON STRUCTURE VALIDATION - Ensure required fields exist
// ============================================================================

/// @function validate_json_structure
/// @description Validates that a JSON structure contains all required keys
///              Useful for confirming data files have expected format
///              Prevents accessing missing fields
/// @param {Struct}          _data           The parsed JSON struct to validate
/// @param {Array<String>}   _required_keys  Array of required key names
/// @param {String}          _context        Context string for error messages
/// @return {Bool}                           True if all required keys present, false otherwise
function validate_json_structure(_data, _required_keys, _context = "Unknown") {
	// === VALIDATE PARAMETERS ===
	if (!is_struct(_data)) {
		log_error("JSON data is not a struct in " + _context, "validate_json_structure", 2);
		return false;
	}

	if (!is_array(_required_keys)) {
		log_error("Required keys parameter is not an array in " + _context, "validate_json_structure", 2);
		return false;
	}

	// === CHECK EACH REQUIRED KEY ===
	for (var i = 0; i < array_length(_required_keys); i++) {
		var _key = _required_keys[i];

		if (!struct_exists(_data, _key)) {
			log_error("Required JSON key missing: " + _key + " in " + _context, "validate_json_structure", 2);
			return false;
		}
	}

	// === ALL REQUIRED KEYS PRESENT ===
	return true;
}

// ============================================================================
// SAFE INSTANCE COUNTING - Prevent crashes from invalid objects
// ============================================================================

/// @function safe_instance_number
/// @description Safely counts instances of an object type
///              Returns 0 for invalid objects instead of crashing
///              Useful for checking alive enemies, projectiles, etc.
/// @param {Asset.GMObject} _obj   Object asset to count instances of
/// @return {Real}                 Number of instances, || 0 if invalid object
function safe_instance_number(_obj) {
	try {
		return instance_number(_obj);
	} catch (_exception) {
		log_error("Error counting instances: " + _exception.message, "safe_instance_number", 1);
		return 0;
	}
}

// ============================================================================
// SAFE PATH POSITION RETRIEVAL - Path following with validation
// ============================================================================

/// @function safe_path_get
/// @description Safely gets path position data with validation
///              Ensures path is valid before querying position
///              Returns default position if path invalid
/// @param {Real}         _path_id       Path ID to query
/// @param {Real}         _position      Position along path (0 to 1)
/// @param {Array<Real>}  _default       Default [x, y] to return if path invalid
/// @return {Array<Real>}                [x, y] position array || default
function safe_path_get(_path_id, _position, _default = [0, 0]) {
	// === VALIDATE PATH ID ===
	if (_path_id == -1 || _path_id == noone) {
		log_error("Invalid path ID provided", "safe_path_get", 1);
		return _default;
	}

	// === VALIDATE POSITION RANGE ===
	if (_position < 0 || _position > 1) {
		log_error("Path position out of range: " + string(_position), "safe_path_get", 1);
		return _default;
	}

	try {
		// === GET PATH POSITION ===
		return [path_get_x(_path_id, _position), path_get_y(_path_id, _position)];
	} catch (_exception) {
		log_error("Error getting path position: " + _exception.message, "safe_path_get", 1);
		return _default;
	}
}

// ============================================================================
// UTILITY: Check if value is null || undefined
// ============================================================================

/// @function is_null_or_empty
/// @description Checks if a value is null, undefined, || empty string
///              Useful for quick validation of potentially empty values
/// @param {*} _value  The value to check
/// @return {Bool}     True if null, undefined, || empty string
function is_null_or_empty(_value) {
	return (_value == undefined) || (_value == null) ||
	       (is_string(_value) && string_length(_value) == 0);
}

// ============================================================================
// UTILITY: Safe default value retrieval
// ============================================================================

/// @function coalesce
/// @description Returns the first non-null, non-undefined value from arguments
///              Similar to SQL COALESCE() || JavaScript ??
///              Useful for providing fallback values
/// @param {*} _value1   First value to check
/// @param {*} _value2   Second value (fallback)
/// @param {*} _value3   Third value (fallback), optional
/// @return {*}          First non-null value found
function coalesce(_value1, _value2, _value3 = undefined) {
	if (_value1 != undefined && _value1 != null) return _value1;
	if (_value2 != undefined && _value2 != null) return _value2;
	if (_value3 != undefined && _value3 != null) return _value3;
	return undefined;
}

// ============================================================================
// JSON SCHEMA VALIDATORS - Specific validation for game data files
// ============================================================================

/// @function validate_wave_spawn_json
/// @description Validates the structure of wave_spawn.json
/// @param {Struct} _data The parsed wave spawn data
/// @return {Bool} True if valid, false otherwise
function validate_wave_spawn_json(_data) {
	// Check top-level PATTERN array exists
	if (!validate_json_structure(_data, ["PATTERN"], "wave_spawn.json")) {
		return false;
	}

	var patterns = _data.PATTERN;
	if (!is_array(patterns) || array_length(patterns) == 0) {
		log_error("PATTERN must be a non-empty array", "validate_wave_spawn_json", 2);
		return false;
	}

	// Validate first pattern structure
	var pattern = patterns[0];
	if (!validate_json_structure(pattern, ["WAVE"], "wave_spawn.json pattern")) {
		return false;
	}

	// Validate first wave structure
	if (!is_array(pattern.WAVE) || array_length(pattern.WAVE) == 0) {
		log_error("WAVE must be a non-empty array", "validate_wave_spawn_json", 2);
		return false;
	}

	var wave = pattern.WAVE[0];
	if (!validate_json_structure(wave, ["SPAWN"], "wave_spawn.json wave")) {
		return false;
	}

	// Validate spawn entry structure
	if (!is_array(wave.SPAWN) || array_length(wave.SPAWN) == 0) {
		log_error("SPAWN must be a non-empty array", "validate_wave_spawn_json", 2);
		return false;
	}

	var spawn = wave.SPAWN[0];
	var required_keys = ["ENEMY", "PATH", "SPAWN_XPOS", "SPAWN_YPOS", "INDEX"];
	if (!validate_json_structure(spawn, required_keys, "wave_spawn.json spawn entry")) {
		return false;
	}

	return true;
}

/// @function validate_challenge_spawn_json
/// @description Validates the structure of challenge_spawn.json
/// @param {Struct} _data The parsed challenge spawn data
/// @return {Bool} True if valid, false otherwise
function validate_challenge_spawn_json(_data) {
	// Check top-level CHALLENGES array exists
	if (!validate_json_structure(_data, ["CHALLENGES"], "challenge_spawn.json")) {
		return false;
	}

	var challenges = _data.CHALLENGES;
	if (!is_array(challenges) || array_length(challenges) == 0) {
		log_error("CHALLENGES must be a non-empty array", "validate_challenge_spawn_json", 2);
		return false;
	}

	// Validate first challenge structure
	var challenge = challenges[0];
	var required_keys = ["CHALLENGE_ID", "PATH1", "PATH1_FLIP", "PATH2", "PATH2_FLIP", "WAVES"];
	if (!validate_json_structure(challenge, required_keys, "challenge_spawn.json challenge")) {
		return false;
	}

	// Validate waves array
	if (!is_array(challenge.WAVES) || array_length(challenge.WAVES) == 0) {
		log_error("WAVES must be a non-empty array", "validate_challenge_spawn_json", 2);
		return false;
	}

	// Validate wave entry
	var wave = challenge.WAVES[0];
	if (!validate_json_structure(wave, ["ENEMY", "DOUBLED"], "challenge_spawn.json wave")) {
		return false;
	}

	return true;
}

/// @function validate_enemy_attributes_json
/// @description Validates the structure of enemy attribute JSON files
/// @param {Struct} _data The parsed enemy attributes
/// @param {String} _enemy_name Enemy name for error messages
/// @return {Bool} True if valid, false otherwise
function validate_enemy_attributes_json(_data, _enemy_name = "enemy") {
	var required_keys = ["HEALTH", "POINT_VALUE", "STANDARD"];
	if (!validate_json_structure(_data, required_keys, _enemy_name + " attributes")) {
		return false;
	}

	// Validate STANDARD section
	var standard_keys = ["DIVE_PATH1", "DIVE_ALT_PATH1", "DIVE_PATH2", "DIVE_ALT_PATH2"];
	if (!validate_json_structure(_data.STANDARD, standard_keys, _enemy_name + " STANDARD paths")) {
		return false;
	}

	return true;
}

/// @function validate_formation_coordinates_json
/// @description Validates the structure of formation_coordinates.json
/// @param {Struct} _data The parsed formation coordinates
/// @return {Bool} True if valid, false otherwise
function validate_formation_coordinates_json(_data) {
	if (!validate_json_structure(_data, ["POSITION"], "formation_coordinates.json")) {
		return false;
	}

	var positions = _data.POSITION;
	// position 0 is a place-holder, as the INDEX per enemy is 1..40, so array position 0 is not used
	if (!is_array(positions) || array_length(positions) != 41) {
		log_error("POSITION array must have exactly 40 entries (found: " + string(array_length(positions)) + ")", "validate_formation_coordinates_json", 2);
		return false;
	}

	// Validate first position structure
	var pos = positions[0];
	if (!validate_json_structure(pos, ["_x", "_y"], "formation_coordinates.json position")) {
		return false;
	}

	return true;
}

/// @function validate_game_config_json
/// @description Validates the structure of game_config.json
/// @param {Struct} _data The parsed game configuration
/// @return {Bool} True if valid, false otherwise
function validate_game_config_json(_data) {
	var required_sections = ["PLAYER", "ENEMIES", "CHALLENGE_STAGES", "HIGH_SCORES", "DIFFICULTY"];

	// Check all required sections exist
	for (var i = 0; i < array_length(required_sections); i++) {
		if (!struct_exists(_data, required_sections[i])) {
			log_error("Missing required section: " + required_sections[i], "validate_game_config_json", 2);
			return false;
		}
	}

	// Validate PLAYER section
	var player_keys = ["STARTING_LIVES", "EXTRA_LIFE_FIRST", "EXTRA_LIFE_ADDITIONAL"];
	if (!validate_json_structure(_data.PLAYER, player_keys, "game_config.json PLAYER")) {
		return false;
	}

	// Validate ENEMIES section
	var enemy_keys = ["MAX_DIVE_CAP", "DIVE_CAP_START", "MAX_BOSS_DIVE_CAP"];
	if (!validate_json_structure(_data.ENEMIES, enemy_keys, "game_config.json ENEMIES")) {
		return false;
	}

	return true;
}

// ============================================================================
// END OF ERROR HANDLING SCRIPT
// ============================================================================
// Summary of functions provided:
//
// LOG_ERROR()                   - Log errors with severity levels
// SAFE_LOAD_JSON()              - Load && parse JSON safely
// SAFE_GET_ASSET()              - Get GameMaker assets safely
// SAFE_STRUCT_GET()             - Access struct values safely
// SAFE_ARRAY_GET()              - Access array elements safely
// VALIDATE_JSON_STRUCTURE()     - Validate JSON structure
// SAFE_INSTANCE_NUMBER()        - Count instances safely
// SAFE_PATH_GET()               - Get path positions safely
// IS_NULL_OR_EMPTY()            - Check for null/empty values
// COALESCE()                    - Get first non-null value
//
// Use these functions throughout your codebase for robust error handling
// && graceful failure instead of crashes.
// ============================================================================
