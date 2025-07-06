if global.lvl > 0 and rank > 0{
///ones
if rank = onerank{
    if one > 4{tile_add(bkgd_Rank,16,0,16,32,440-(16*rank),544,-10)}
    else{tile_add(bkgd_Rank,0,0,16,32,440-(16*rank),544,-10)}
}
if rank = onerank - 1{tile_add(bkgd_Rank,0,0,16,32,440-(16*rank),544,-10)}
if rank = onerank - 2{tile_add(bkgd_Rank,0,0,16,32,440-(16*rank),544,-10)}
if rank = onerank - 3{tile_add(bkgd_Rank,0,0,16,32,440-(16*rank),544,-10)}
if rank = onerank - 4{tile_add(bkgd_Rank,0,0,16,32,440-(16*rank),544,-10)}
///tens
if tenrank > 0 and rank = onerank + tenrank{
    if ten > 4{tile_add(bkgd_Rank,128,0,32,32,440-(32*rank)+((onerank)*16),544,-10);}
    if ten = 3 
    or ten = 4{tile_add(bkgd_Rank,96,0,32,32,440-(32*rank)+((onerank)*16),544,-10);}
    if ten = 2{tile_add(bkgd_Rank,64,0,32,32,440-(32*rank)+((onerank)*16),544,-10);}
    if ten = 1{tile_add(bkgd_Rank,32,0,32,32,440-(32*rank)+((onerank)*16),544,-10);}
}
if tenrank > 1 and rank = onerank + tenrank - 1{
    if ten = 9 
    or ten = 8{tile_add(bkgd_Rank,96,0,32,32,440-(32*rank)+((onerank)*16),544,-10);}
    if ten = 7{tile_add(bkgd_Rank,64,0,32,32,440-(32*rank)+((onerank)*16),544,-10);}
    if ten = 6
    or ten = 4{tile_add(bkgd_Rank,32,0,32,32,440-(32*rank)+((onerank)*16),544,-10);}
}
if tenrank > 2 and rank = onerank + tenrank - 2{
    if ten = 9{tile_add(bkgd_Rank,32,0,32,32,440-(32*rank)+((onerank)*16),544,-10);}
}
///hundreds
if rank > tenrank + onerank{tile_add(bkgd_Rank,128,0,32,32,440-(32*rank)+((onerank)*16),544,-10)}

rank = rank - 1; if global.challcount > 0 and start = 0{sound_play(GRank)}; alarm[1] = 7

};
if rank = 0{nextlevel = 2; alarm[10] = 50};

