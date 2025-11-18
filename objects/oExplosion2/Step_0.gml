// Return explosion to pool when animation completes
if (image_index > 9.8) {
	if (global.explosion2_pool != undefined) {
		global.explosion2_pool.release(self,id);
	} else {
		instance_destroy();
	}
}