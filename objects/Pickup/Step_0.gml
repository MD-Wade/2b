// move accordingly


switch (state_current)	{
	case E_STATES_PICKUP.FREEFALL:
		if (global.track_time_current_ms > (note_time_ideal + global.note_hit_time[E_NOTE_ACCURACY.MISS]))	{
			execute_action(1, E_NOTE_ACCURACY.MISS);
		}

		y += (global.song_note_speed_second * global.delta_multiplier);
		if (bbox_bottom > 0)	{
			image_angle = ((image_angle + (rotation_speed * global.delta_multiplier)) mod 360);
			if (return_accuracy() == E_NOTE_ACCURACY.PERFECT)	{
				image_blend = note_colour_perfect;
			}	else	{
				image_blend = note_colour_normal;
			}
		}
		break;

	case E_STATES_PICKUP.COLLECTED:
		x = lerp(note_pos_base_x, Hands.hand_target_x, transition_interp);
		y = lerp(note_pos_base_y, Hands.hand_target_y, transition_interp);
		image_alpha = lerp(1, 0, transition_interp);
		image_blend = merge_colour(c_white, global.note_hit_colour[note_hit_type], transition_interp);
		if (image_alpha <= 0)	{
			instance_destroy();
		}
		break;
		
	case E_STATES_PICKUP.MISSED:
		image_alpha = approach(image_alpha, 0, 0.05);
		if (image_alpha <= 0)	{
			instance_destroy();
		}
		break;
}