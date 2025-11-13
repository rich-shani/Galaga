// Return explosion to pool when animation completes
if (image_index > 9.8) {
	if (global.explosion_pool != undefined) {
		global.explosion_pool.release(self);
	} else {
		instance_destroy();
	}
}