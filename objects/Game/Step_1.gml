switch (room)	{
	case roomGame:
		global.delta_current = (delta_time / 1000000);
		global.delta_multiplier = (global.delta_current / delta_target);
		tween_tick += global.delta_multiplier;
		global.track_time_current_ms += (global.delta_current * 1000);

		if not song_instance_cooked	{
			if (global.track_time_current_ms >= 0)	{
				song_play_audio();
				song_instance_cooked = true;
			}
		}
		break;
}