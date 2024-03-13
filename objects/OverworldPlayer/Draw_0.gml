/// @description Draw Guy

switch (state_current)	{
	case E_OVERWORLD_PLAYER_STATES.BASE:
		image_blend = c_white;
		draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		break;
	
	case E_OVERWORLD_PLAYER_STATES.MOVING:
		image_blend = c_ltgray;
		draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		break;
}