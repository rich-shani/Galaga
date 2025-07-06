function challenging() {
	Controller.list = ds_list_create()
	switch global.chall{
	    case 1:
	        path1 = Chall11; path2 = Chall12; path1flip = Chall11Flip; path2flip = Chall12Flip
	        ds_list_add(list,2); repeat 4 {ds_list_add(list,1)};
	        break;
	    case 2:
	        path1 = Chall21; path2 = Chall22; path1flip = Chall21Flip; path2flip = Chall22Flip
	        repeat 3 {ds_list_add(list,2)}; repeat 2 {ds_list_add(list,1)};
	        break;
	    case 3:
	        path1 = Chall31; path2 = Chall32; path1flip = Chall31Flip; path2flip = Chall32Flip
	        ds_list_add(list,1); repeat 2 {ds_list_add(list,2)}; repeat 2 {ds_list_add(list,1)};
	        break;
	    case 4:
	        path1 = Chall41; path2 = Chall42; path1flip = Chall41Flip; path2flip = Chall42Flip
	        ds_list_add(list,2); repeat 2 {ds_list_add(list,1)}; repeat 2 {ds_list_add(list,2)};
	        break;
	    case 5:
	        path1 = Chall51; path2 = Chall52; path1flip = Chall51Flip; path2flip = Chall52Flip
	        repeat 5 {ds_list_add(list,1)};
	        break;
	    case 6:
	        path1 = Chall61; path2 = Chall62; path1flip = Chall61Flip; path2flip = Chall62Flip
	        ds_list_add(list,1); repeat 2 {ds_list_add(list,2)}; repeat 2 {ds_list_add(list,1)};
	        break;
	    case 7:
	        path1 = Chall71; path2 = Chall72; path1flip = Chall71Flip; path2flip = Chall72Flip
	        repeat 5 {ds_list_add(list,1)};
	        break;
	    case 8:
	        path1 = Chall81; path2 = Chall82; path1flip = Chall81Flip; path2flip = Chall82Flip
	        ds_list_add(list,2); repeat 2 {ds_list_add(list,1)}; repeat 2 {ds_list_add(list,2)};
	        break;
	}



}
