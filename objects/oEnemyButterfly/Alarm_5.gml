if global.lvl = 1 or global.lvl = 10 or global.lvl = 18{}else{
	if global.shotnumber = 2{if instance_number(EnemyShot) < 4{instance_create(x,y,EnemyShot);}}
	if global.shotnumber = 3{if instance_number(EnemyShot) < 6{instance_create(x,y,EnemyShot);}}
	if global.shotnumber = 4{if instance_number(EnemyShot) < 8{instance_create(x,y,EnemyShot);}}
}
