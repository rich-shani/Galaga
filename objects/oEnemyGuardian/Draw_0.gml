switch (hitCount) {
	case 1:
		// Guardian is down to one live left ... change sprite
		if (global.ArcadeSprites) draw_sprite_ext(OG_sEnemyGuardianHit,image_index,x,y,1,1,image_angle,c_white,1);
		else draw_sprite_ext(sEnemyGuardianHit,image_index,x,y,1,1,image_angle,c_white,1);
		break;
	default:
		// otherwise, display standard Guardian sprite
		if (global.ArcadeSprites) draw_sprite_ext(OG_sEnemyGuardian,image_index,x,y,1,1,image_angle,c_white,1);
		else draw_sprite_ext(sEnemyGuardian,image_index,x,y,1,1,image_angle,c_white,1);
		break;
}