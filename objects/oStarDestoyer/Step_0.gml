

if (yoffset > -400) {
	yoffset -= 1;
	//instance_destroy(id);	
}

// reduce the size of the ship as it floats upwards
//scale = 1.0 + yoffset/3000; // yoffset is negative, so ship will get smaller overtime