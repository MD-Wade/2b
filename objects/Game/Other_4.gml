

switch (room)	{
	case roomMenu:
		camera_init();
		break;

	case roomGame:
		room_fade_in = 1;

		var _hands_instance = instance_create_depth(0, 0, -50, Hands);
		var _note_spawn_x, _note_spawn_y;
		_note_spawn_x[0] = _hands_instance.hand_trigger_pos_x[0];
		_note_spawn_x[1] = _hands_instance.hand_trigger_pos_x[1];
		_note_spawn_y = _hands_instance.hand_trigger_pos_y[0];
		var _note_threshold = _hands_instance.hand_trigger_size;

		midi_information_array = midi_read(global.track_file_midi, false);
		midi_information_notes = midi_information_array[0];
		midi_information_events = midi_information_array[1];
		song_id = audio_play_sound(global.track_stream, 1, false);
		audio_sound_pitch(song_id, global.song_time_playback_factor);

		global.song_time_tempo_bpm = -1;
		for (var i = 0; i < array_length(midi_information_events); i ++)	{
			var _event_index = midi_information_events[i];
			if (_event_index[1] == MIDI_E_BPM)	{
				global.song_time_tempo_bpm = _event_index[2];
			}
		}
		if (global.song_time_tempo_bpm == -1)	{
			show_error("Could not find BPM.", true);
		}

		camera_init();

		game_execute_song_tempo_calculate();
		global.track_time_current_ms = 0;
		global.song_time_ppq = 96;
		global.song_note_speed_frame = 512;
		global.song_note_speed_second = global.song_note_speed_frame / game_get_speed(gamespeed_fps);

		var ticks_per_minute = global.song_time_tempo_bpm * global.song_time_ppq;
		global.song_time_tick_length = 60 / ticks_per_minute / global.song_time_playback_factor;

		for (var i = 0; i < array_length(midi_information_notes); i ++)	{
			var _note_index = midi_information_notes[i];
			var _note_time_start = (_note_index[0] * global.song_time_tick_length) + audio_sound_get_track_position(song_id);
			var _note_type = ((_note_index[1] == 60) ? -1 : 1);
			global.game_points_possible += 100;

			if (_note_type == -1)	{
				var _note_x_start = _note_spawn_x[0];
			}	else	{
				var _note_x_start = _note_spawn_x[1];
			}

			var _note_x = _note_x_start;
			var _note_y = (_note_spawn_y - ((_note_time_start * global.song_note_speed_frame)));
			var _pickup_id = instance_create_depth(_note_x, _note_y, -35, Pickup);

			_pickup_id.note_type = _note_type;
			_pickup_id.note_threshold = _note_threshold;
			_pickup_id.note_target = _note_spawn_y;
			_pickup_id.note_time_ideal = (_note_time_start * 1000);
			_pickup_id.note_pos_base_x = _note_x;
			_pickup_id.note_pos_base_y = _note_spawn_y;
			_pickup_id.circle_radius_target = Hands.hand_size / 4.0;
		}
		break;	
}
