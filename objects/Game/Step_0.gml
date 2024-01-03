delta_current = (delta_time / 1000000);
global.delta_multiplier = (delta_current / delta_target);

tween_tick += global.delta_multiplier;

switch (room)	{
	case roomInit:
		if (window_centered)	{
			room_goto_next();
		}
		break;
		
	case roomGame:
		global.track_time_current_ms += (delta_time / 1000);
		
		if (!instance_exists(Pickup))	{
			room_fade_out = approach(room_fade_out, 1, 0.002);
			audio_sound_gain(song_id, 1 - room_fade_out, 0);
			if (room_fade_out >= 1)	{
				room_fade_out = 0;
				room_goto(roomMenu);
			}
		}
		break;
}
