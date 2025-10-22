
// destroy missile
instance_destroy(other);

// increment the hit counter
oGameManager.hits += 1;

// check if we're out of HEALTH
hitCount--;

if (hitCount == 0) {

	if (irandom(1)) {
		instance_create(round(x), round(y), oExplosion);
	}
	else {
		instance_create(round(x), round(y), oExplosion2);	
	}
					
	// destroy Enemy
	instance_destroy(self);
}