function __global_object_depths() {
	// Initialise the global array that allows the lookup of the depth of a given object
	// GM2.0 does not have a depth on objects so on import from 1.x a global array is created
	// NOTE: MacroExpansion is used to insert the array initialisation at import time
	//gml_pragma( "global", "__global_object_depths()");

	//// insert the generated arrays here
	//global.__objectDepths[0] = 0; // Bee
	//global.__objectDepths[1] = 0; // Butterfly
	//global.__objectDepths[2] = 0; // Boss
	//global.__objectDepths[3] = 0; // oGameManager
	//global.__objectDepths[4] = 0; // Ship
	//global.__objectDepths[5] = 0; // Explosion
	//global.__objectDepths[6] = 0; // EnemyShot
	//global.__objectDepths[7] = 0; // Transform
	//global.__objectDepths[8] = 0; // TransPoints
	//global.__objectDepths[9] = 0; // Points400
	//global.__objectDepths[10] = 0; // Points800
	//global.__objectDepths[11] = 0; // Points1600
	//global.__objectDepths[12] = 0; // Points1000
	//global.__objectDepths[13] = 0; // Fighter
	//global.__objectDepths[14] = 0; // Stars
	//global.__objectDepths[15] = 0; // Points150


	//global.__objectNames[0] = "Bee";
	//global.__objectNames[1] = "Butterfly";
	//global.__objectNames[2] = "Boss";
	//global.__objectNames[3] = "oGameManager";
	//global.__objectNames[4] = "Ship";
	//global.__objectNames[5] = "oExplosion3";
	//global.__objectNames[6] = "EnemyShot";
	//global.__objectNames[7] = "Transform";
	//global.__objectNames[8] = "TransPoints";
	//global.__objectNames[9] = "Points400";
	//global.__objectNames[10] = "Points800";
	//global.__objectNames[11] = "Points1600";
	//global.__objectNames[12] = "Points1000";
	//global.__objectNames[13] = "Fighter";
	//global.__objectNames[14] = "Stars";
	//global.__objectNames[15] = "Points150";


	//// create another array that has the correct entries
	//var len = array_length_1d(global.__objectDepths);
	//global.__objectID2Depth = [];
	//for( var i=0; i<len; ++i ) {
	//	var objID = asset_get_index( global.__objectNames[i] );
	//	if (objID >= 0) {
	//		global.__objectID2Depth[ objID ] = global.__objectDepths[i];
	//	} // end if
	//} // end for


}
