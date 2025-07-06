function shot1for2(argument0) {
	if argument0 = 0{
	if Ship.dub1 = 1{
	    with Bee{
	    if abs(x - Ship.shot1x - 28) < 11 and abs(y - Ship.shot1y) < 11{instance_destroy()}
	}
	    with Butterfly{
	    if abs(x - Ship.shot1x - 28) < 11 and abs(y - Ship.shot1y) < 11{instance_destroy()}
	}
	    with Transform{
	    if abs(x - Ship.shot1x - 28) < 11 and abs(y - Ship.shot1y) < 11{instance_destroy()}
	}
	with Fighter{
	    if abs(x - Ship.shot1x - 28) < 11 and abs(y - Ship.shot1y) < 11{instance_destroy()}
	}
	with Boss{if y > -17{
	    if hit = 0{
	        if abs(x - Ship.shot1x - 28) < 11 and abs(y - Ship.shot1y) < 11{hit = 1; exit}
	    }
	    if hit = 1{
	        if abs(x - Ship.shot1x - 28) < 11 and abs(y - Ship.shot1y) < 11{if carrying = 1 and dive = 1{Ship.regain = 1; Ship.alarm[3] = 90; Ship.newshipy = Fighter.y; Ship.newshipx = Fighter.x; with Fighter{instance_destroy()}}; instance_destroy()}
	    }
	}}
	}
	}
	if argument0 = 1{
	if Ship.dub2 = 1{
	    with Bee{
	    if abs(x - Ship.shot2x - 28) < 11 and abs(y - Ship.shot2y) < 11{instance_destroy()}
	}
	    with Butterfly{
	    if abs(x - Ship.shot2x - 28) < 11 and abs(y - Ship.shot2y) < 11{instance_destroy()}
	}
	    with Transform{
	    if abs(x - Ship.shot2x - 28) < 11 and abs(y - Ship.shot2y) < 11{instance_destroy()}
	}
	with Fighter{
	    if abs(x - Ship.shot2x - 28) < 11 and abs(y - Ship.shot2y) < 11{instance_destroy()}
	}
	with Boss{if y > -17{
	    if hit = 0{
	        if abs(x - Ship.shot2x - 28) < 11 and abs(y - Ship.shot2y) < 11{hit = 1; exit}
	    }
	    if hit = 1{
	        if abs(x - Ship.shot2x - 28) < 11 and abs(y - Ship.shot2y) < 11{if carrying = 1 and dive = 1{Ship.regain = 1; Ship.alarm[3] = 90; Ship.newshipy = Fighter.y; Ship.newshipx = Fighter.x; with Fighter{instance_destroy()}}; instance_destroy()}
	    }
	}}
	}
	}
	if argument0 = 2{
	if Ship.dub1 = 1{
	    with Bee{
	    if abs(x - Ship.shot1x) < 11 and abs(y - Ship.shot1y) < 11{instance_destroy()}
	}
	    with Butterfly{
	    if abs(x - Ship.shot1x) < 11 and abs(y - Ship.shot1y) < 11{instance_destroy()}
	}
	    with Transform{
	    if abs(x - Ship.shot1x) < 11 and abs(y - Ship.shot1y) < 11{instance_destroy()}
	}
	with Fighter{
	    if abs(x - Ship.shot1x) < 11 and abs(y - Ship.shot1y) < 11{instance_destroy()}
	}
	with Boss{if y > -17{
	    if hit = 0{
	        if abs(x - Ship.shot1x) < 11 and abs(y - Ship.shot1y) < 11{hit = 1; exit}
	    }
	    if hit = 1{
	        if abs(x - Ship.shot1x) < 11 and abs(y - Ship.shot1y) < 11{if carrying = 1 and dive = 1{Ship.regain = 1; Ship.alarm[3] = 90; Ship.newshipy = Fighter.y; Ship.newshipx = Fighter.x; with Fighter{instance_destroy()}}; instance_destroy()}
	    }
	}}
	}
	}
	if argument0 = 3{
	if Ship.dub2 = 1{
	    with Bee{
	    if abs(x - Ship.shot2x) < 11 and abs(y - Ship.shot2y) < 11{instance_destroy()}
	}
	    with Butterfly{
	    if abs(x - Ship.shot2x) < 11 and abs(y - Ship.shot2y) < 11{instance_destroy()}
	}
	    with Transform{
	    if abs(x - Ship.shot2x) < 11 and abs(y - Ship.shot2y) < 11{instance_destroy()}
	}
	with Fighter{
	    if abs(x - Ship.shot2x) < 11 and abs(y - Ship.shot2y) < 11{instance_destroy()}
	}
	with Boss{if y > -17{
	    if hit = 0{
	        if abs(x - Ship.shot2x) < 11 and abs(y - Ship.shot2y) < 11{hit = 1; exit}
	    }
	    if hit = 1{
	        if abs(x - Ship.shot2x) < 11 and abs(y - Ship.shot2y) < 11{if carrying = 1 and dive = 1{Ship.regain = 1; Ship.alarm[3] = 90; Ship.newshipy = Fighter.y; Ship.newshipx = Fighter.x; with Fighter{instance_destroy()}}; instance_destroy()}
	    }
	}}
	}
	}



}
