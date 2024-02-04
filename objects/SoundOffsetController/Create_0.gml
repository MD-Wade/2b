enum E_AUDIO_SYNC_STATES {
	INIT, SYNC_TEST, FINISH
}
test_state = E_AUDIO_SYNC_STATES.INIT;

function step_sound_play()	{
	sound_timer += delta_time / 1000;
    if (sound_play_count < array_length(sound_timings)) {
		if (sound_timer >= sound_timings[sound_play_count])	{
	        audio_play_sound(sndSoundOffsetHigh, 1, false);
	        sound_play_count++;
		}
    }	else	{
		test_state = E_AUDIO_SYNC_STATES.FINISH;
	}
}
function step_input()	{
	if (keyboard_check_pressed(vk_space)) {
        var _input_time = sound_timer;
        var _nearest_sound_time;
        var _min_offset = sound_interval;

		var _valid_input = ((sound_play_count > beep_count_grace) and (sound_play_count < (beep_count_target - beep_count_grace)));
        for (var i = 0; i < array_length(sound_timings); i++) {
            var _current_offset = abs(_input_time - sound_timings[i]);
            if (_current_offset < _min_offset) {
                _min_offset = _current_offset;
                _nearest_sound_time = sound_timings[i];
            }
        }
			
		if (_valid_input)	{
			show_debug_message("Input Time: " + string(_input_time) + ", Nearest Sound Time: " + string(_nearest_sound_time) + ", Offset: " + string(_min_offset));
			beep_count_total_offset += _min_offset;
			beeps_counted ++;
		}
    }
}

sound_timer = 0;
sound_interval = 900;
sound_play_count = 0;
beep_count_grace = 2;
beep_count_target = 10;
beep_count_total_offset = 0;
sound_timer = 0;
sound_play_count = 0;
beep_count_total_offset = 0;
beeps_counted = 0;
sound_timings = [];

for (var i = 0; i < beep_count_target + beep_count_grace; i++) {
    sound_timings[i] = i * sound_interval;
}

intro_message =
"This is a test to determine the audio desync on your machine.\n" + 
"Press Space to Begin and try to time it with the beep sound.\n" + 
"The first few will be omitted from the test so you can use them to understand the rhythm.";
test_message = 
"Performing test ...";

if (global.save_object.setting_offset_audio_performed)	{
	room_goto(roomMenu);
}