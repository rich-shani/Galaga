
function starscript(argument0) {
//	if Ship.alarm[2] > -1{back = back + abs(argument0)} else{if back > 0{back = back - abs(argument0)} else{back = 0}};
	if argument0 > 0{if irandom((12/argument0)-1) = 0 and back = 0{
	swit = 0; xrand = 0; yrand = 0; drand = 0; hrand = 0; srand = 0;
	xrand = irandom(room_width-8); drand = (irandom(3)*4) + (16*swit) + 100;
	hrand = irandom(240); srand = irandom(240);
	tile_add(bkgd_Star,0,0,8,8,xrand,yrand,drand);tile_set_blend(tile_layer_find(drand,xrand,yrand),make_color_hsv(hrand,srand,240))///biggest star
	tile_add(bkgd_Star,8,0,8,8,xrand,yrand,drand+1);tile_set_blend(tile_layer_find(drand+1,xrand,yrand),make_color_hsv(hrand,srand,240))///star
	tile_add(bkgd_Star,16,0,8,8,xrand,yrand,drand+2);tile_set_blend(tile_layer_find(drand+2,xrand,yrand),make_color_hsv(hrand,srand,240))///star
	tile_add(bkgd_Star,24,0,8,8,xrand,yrand,drand+3);tile_set_blend(tile_layer_find(drand+3,xrand,yrand),make_color_hsv(hrand,srand,240))///smallest star
	}}
	starcount = starcount + 1; if starcount = 24{starcount = 0};
	if starcount = 0{tile_layer_show(100);tile_layer_show(106);tile_layer_hide(111);tile_layer_hide(113);}
	if starcount = 3{tile_layer_hide(100);tile_layer_show(105);tile_layer_show(111);tile_layer_hide(114);}
	if starcount = 6{tile_layer_hide(101);tile_layer_show(104);tile_layer_show(110);tile_layer_hide(115);}
	if starcount = 9{tile_layer_hide(102);tile_layer_hide(104);tile_layer_show(109);tile_layer_show(115);}
	if starcount = 12{tile_layer_hide(103);tile_layer_hide(105);tile_layer_show(108);tile_layer_show(114);}
	if starcount = 15{tile_layer_show(103);tile_layer_hide(106);tile_layer_hide(108);tile_layer_show(113);}
	if starcount = 18{tile_layer_show(102);tile_layer_hide(107);tile_layer_hide(109);tile_layer_show(112);}
	if starcount = 21{tile_layer_show(101);tile_layer_show(107);tile_layer_hide(110);tile_layer_hide(112);}
	//
	if starcount = 0{tile_layer_show(16+100);tile_layer_show(16+106);tile_layer_hide(16+111);tile_layer_hide(16+113);}
	if starcount = 3{tile_layer_hide(16+100);tile_layer_show(16+105);tile_layer_show(16+111);tile_layer_hide(16+114);}
	if starcount = 6{tile_layer_hide(16+101);tile_layer_show(16+104);tile_layer_show(16+110);tile_layer_hide(16+115);}
	if starcount = 9{tile_layer_hide(16+102);tile_layer_hide(16+104);tile_layer_show(16+109);tile_layer_show(16+115);}
	if starcount = 12{tile_layer_hide(16+103);tile_layer_hide(16+105);tile_layer_show(16+108);tile_layer_show(16+114);}
	if starcount = 15{tile_layer_show(16+103);tile_layer_hide(16+106);tile_layer_hide(16+108);tile_layer_show(16+113);}
	if starcount = 18{tile_layer_show(16+102);tile_layer_hide(16+107);tile_layer_hide(16+109);tile_layer_show(16+112);}
	if starcount = 21{tile_layer_show(16+101);tile_layer_show(16+107);tile_layer_hide(16+110);tile_layer_hide(16+112);}
	//
	tile_layer_shift(100,0,argument0);tile_layer_shift(101,0,argument0);tile_layer_shift(102,0,argument0);tile_layer_shift(103,0,argument0);
	tile_layer_shift(104,0,argument0);tile_layer_shift(105,0,argument0);tile_layer_shift(106,0,argument0);tile_layer_shift(107,0,argument0);
	tile_layer_shift(108,0,argument0);tile_layer_shift(109,0,argument0);tile_layer_shift(110,0,argument0);tile_layer_shift(111,0,argument0);
	tile_layer_shift(112,0,argument0);tile_layer_shift(113,0,argument0);tile_layer_shift(114,0,argument0);tile_layer_shift(115,0,argument0);
	tile_layer_shift(116,0,argument0);tile_layer_shift(117,0,argument0);tile_layer_shift(118,0,argument0);tile_layer_shift(119,0,argument0);
	tile_layer_shift(120,0,argument0);tile_layer_shift(121,0,argument0);tile_layer_shift(122,0,argument0);tile_layer_shift(123,0,argument0);
	tile_layer_shift(124,0,argument0);tile_layer_shift(125,0,argument0);tile_layer_shift(126,0,argument0);tile_layer_shift(127,0,argument0);
	tile_layer_shift(128,0,argument0);tile_layer_shift(129,0,argument0);tile_layer_shift(130,0,argument0);tile_layer_shift(131,0,argument0);
	///
	if yset > -8{yset = yset - argument0} else{yset = -8};
	switcount = switcount + argument0
	if switcount > (room_height + 8)*2{
	    switcount = 0;
	    if swit = 0{
	        tile_layer_delete(116); tile_layer_delete(120); tile_layer_delete(124); tile_layer_delete(128);
	        tile_layer_delete(117); tile_layer_delete(121); tile_layer_delete(125); tile_layer_delete(129);
	        tile_layer_delete(118); tile_layer_delete(122); tile_layer_delete(126); tile_layer_delete(130);
	        tile_layer_delete(119); tile_layer_delete(123); tile_layer_delete(127); tile_layer_delete(131);
	        swit = 1; exit
	    }
	    if swit = 1{
	        tile_layer_delete(100); tile_layer_delete(104); tile_layer_delete(108); tile_layer_delete(112);
	        tile_layer_delete(101); tile_layer_delete(105); tile_layer_delete(109); tile_layer_delete(113);
	        tile_layer_delete(102); tile_layer_delete(106); tile_layer_delete(110); tile_layer_delete(114);
	        tile_layer_delete(103); tile_layer_delete(107); tile_layer_delete(111); tile_layer_delete(115);
	        swit = 0; exit
	    }
	}




}
