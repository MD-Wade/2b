// move accordingly

switch (state_current)	{
	case E_STATES_NOTE.FREEFALL:
		if (global.track_time_current_ms > (note_time_ideal + global.note_hit_time[E_NOTE_ACCURACY.MISS]))	{
			execute_action(1, E_NOTE_ACCURACY.MISS);
		}

		y += (global.track_note_speed_frame * global.delta_multiplier);
		if (bbox_bottom > 0)	{
			image_angle = ((image_angle + (rotation_speed * global.delta_multiplier)) mod 360);
			if (return_accuracy() == E_NOTE_ACCURACY.PERFECT)	{
				image_blend = note_colour_perfect;
			}	else	{
				image_blend = note_colour_normal;
			}
		}
		break;

	case E_STATES_NOTE.COLLECTED:
		image_alpha = lerp(1, 0, transition_interp);
		image_blend = merge_colour(c_white, global.note_hit_colour[note_hit_type], transition_interp);
		if (image_alpha <= 0)	{
			instance_destroy();
		}
		break;
		
	case E_STATES_NOTE.MISSED:
		image_alpha = approach(image_alpha, 0, 0.05);
		if (image_alpha <= 0)	{
			instance_destroy();
		}
		break;
		
	case E_STATES_NOTE.PERFECTING:
		state_tick = approach(state_tick, state_tick_target, global.delta_current);
		if (state_tick >= state_tick_target)	{
			state_current = E_STATES_NOTE.COLLECTED;
			x = note_perfecting_end_x;
			y = note_perfecting_end_y;
		}	else	{
			var _tick_interp = (state_tick / state_tick_target);
			x = lerp(note_perfecting_start_x, note_perfecting_end_x, _tick_interp);
			y = lerp(note_perfecting_start_y, note_perfecting_end_y, _tick_interp);
		}
		break;
}