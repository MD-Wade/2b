// initialize

#macro TIME_TRACK_GRACE_PERIOD 4000

function cleanup_stream()	{
	if audio_is_playing(song_instance)	{
		audio_stop_sound(song_instance);
	}
}
function cleanup_surfaces()	{
	if surface_exists(surface_main)	{
		surface_free(surface_main);
	}
	if surface_exists(surface_aux1)	{
		surface_free(surface_aux1);
	}
	if surface_exists(surface_aux2)	{
		surface_free(surface_aux2);
	}
	surface_main = -1;
	surface_aux1 = -1;
	surface_aux2 = -1;
}
function camera_init()	{
	view_enabled = true;
	view_visible[0] = true;
	
	camera_pos_x = 0;
	camera_pos_y = 0;
	camera_width = room_width;
	camera_height = room_height;
	camera = camera_get_default();
	camera_set_view_pos(camera, camera_pos_x, camera_pos_y);
	camera_set_view_size(camera, camera_width, camera_height);
	view_set_camera(0, camera);
	camera_apply(camera);
}
function camera_set_pos_x(_pos_x)	{
	camera_pos_x = _pos_x;
	camera_set_view_pos(camera, camera_pos_x, camera_pos_y);
	camera_apply(camera);
}
function camera_set_pos_y(_pos_y)	{
	camera_pos_y = _pos_y;
	camera_set_view_pos(camera, camera_pos_x, camera_pos_y);
	camera_apply(camera);
}
function camera_draw()	{
	camera_set_view_pos(camera, camera_pos_x, camera_pos_y);
	camera_set_view_size(camera, camera_width, camera_height);
	camera_apply(camera);
}
function note_score_execute(_note_accuracy)	{
	if midi_note_placed	{
		if not midi_note_placed_finished	{
			global.game_score += global.note_hit_score[_note_accuracy];
		}
	}
	audio_play_sound(global.note_hit_sound[_note_accuracy], 1, false);
}
function note_check_place() {
	show_debug_message(midi_note_placed);
	if (array_length(midi_note_timings) > 0)	{
		var _note_current = midi_note_timings[0];
		if !is_undefined(_note_current)	{
			while (global.track_time_current_ms > (_note_current.time_ms - midi_note_spawn_offset))	{
				_note_current = array_shift(midi_note_timings);
				if is_undefined(_note_current)	{
					break;
				}
				midi_note_placed = true;
				note_create(_note_current.hand_index, _note_current.time_ms);
			}
		}
	}	else	{
		midi_note_placed_finished = not instance_exists(Note);
		if (midi_note_placed_finished)	{
			room_fade_out = approach(room_fade_out, 1, 0.002);
	        audio_sound_gain(song_instance, 1 - room_fade_out, 0);
	        if (room_fade_out >= 1)	{
				song_finish();
	        }
		}
	}
    
}
function note_create(_type, _time_ms)	{
	var _note_time_remaining = ((global.track_time_current_ms - _time_ms) / 1000);
	var _perfect_pos_x = Hands.hand_pos_x[_type];
	var _perfect_pos_y = Hands.hand_pos_y[_type];
	var _pos_x = _perfect_pos_x;
	var _pos_y = _perfect_pos_y + (_note_time_remaining * global.track_note_speed_second);
	var _note_instance = instance_create_layer(_pos_x, _pos_y, "Notes", Note);

	_note_instance.note_type = _type;
	_note_instance.note_time_ideal = _time_ms;
	_note_instance.note_perfecting_end_x = _perfect_pos_x;
	_note_instance.note_perfecting_end_y = _perfect_pos_y;
	_note_instance.note_size_base = hands_size;
	_note_instance.note_size = hands_size;
}
function hands_init()	{
	hands_center_x = room_width * 0.5;
	hands_center_y = room_height * 0.75;
	hands_size = 96;
}
function hands_create()	{
	hands_init();
	hands = instance_create_layer(hands_center_x, hands_center_y, "Instances", Hands);
	with (hands)	{
		hands_size = other.hands_size;
		init_hands();
	}
	
}
function song_start(_track_details)	{
	global.track_details_current = _track_details;
	global.track_stream = audio_create_stream(_track_details.file_audio);
	room_goto(roomGame);
}
function song_load(_track_details)	{
	midi_note_placed = false;
	midi_note_placed_finished = false;
	song_load_midi(_track_details);
	song_load_bpm();
	song_load_notes();
}
function song_load_bpm()	{
	global.track_time_tempo_bpm = undefined;
	for (var _event_index = 0; _event_index < array_length(midi_information_events); _event_index ++)	{
		var _event = midi_information_events[_event_index];
		if (_event[1] == MIDI_E_BPM)	{
			global.track_time_tempo_bpm = _event[2];
		}
	}
	if is_undefined(global.track_time_tempo_bpm)	{
		show_error("Could not find BPM.", true);
	}
	
	global.track_time_tempo_bpms = (global.track_time_tempo_bpm / 60000);
	global.track_time_current_ms = (TIME_TRACK_GRACE_PERIOD * -1);
	global.track_time_ppq = 96;
	global.track_note_speed_second = 512;
	global.track_note_speed_frame = global.track_note_speed_second / game_get_speed(gamespeed_fps);
	midi_note_spawn_offset = (room_height / global.track_note_speed_second) * 1000;

	var _ticks_per_minute = global.track_time_tempo_bpm * global.track_time_ppq;
	global.track_time_tick_duration_seconds = (60) / _ticks_per_minute / global.track_time_playback_factor;
}
function song_load_midi(_track_details)	{
	midi_information_array = midi_read(_track_details.file_midi, false);
	midi_information_notes = midi_information_array[0];
	midi_information_events = midi_information_array[1];
}
function song_load_notes()	{
	midi_note_timings = [];

	var _unique_notes = {};
	for (var _note_index = 0; _note_index < array_length(midi_information_notes); _note_index ++) {
	    var _note_info = midi_information_notes[_note_index];
	    var _note_type = _note_info[1];
	    struct_set(_unique_notes, string(_note_type), "");
	}
	
	global.track_note_hand_count = 6;
	var _unique_notes_names = struct_get_names(_unique_notes);
	array_sort(_unique_notes_names, function(elm1, elm2) {
	    return real(elm1) - real(elm2);
	});
	
	var _note_to_index_mapping = {};
	var _unique_note_count = struct_names_count(_unique_notes);
	switch (_unique_note_count) {
	    case 1:
	        _note_to_index_mapping[$ _unique_notes_names[0]] = 0;
	        break;
	    case 2:
	        _note_to_index_mapping[$ _unique_notes_names[0]] = 0;
	        _note_to_index_mapping[$ _unique_notes_names[1]] = 5;
	        break;
	    case 3:
	        _note_to_index_mapping[$ _unique_notes_names[0]] = 0;
	        _note_to_index_mapping[$ _unique_notes_names[1]] = 3;
	        _note_to_index_mapping[$ _unique_notes_names[2]] = 5;
	        break;
	    case 4:
	        _note_to_index_mapping[$ _unique_notes_names[0]] = 0;
	        _note_to_index_mapping[$ _unique_notes_names[1]] = 2;
	        _note_to_index_mapping[$ _unique_notes_names[2]] = 3;
	        _note_to_index_mapping[$ _unique_notes_names[3]] = 5;
	        break;
	    case 5:
	        _note_to_index_mapping[$ _unique_notes_names[0]] = 0;
	        _note_to_index_mapping[$ _unique_notes_names[1]] = 1;
	        _note_to_index_mapping[$ _unique_notes_names[2]] = 2;
	        _note_to_index_mapping[$ _unique_notes_names[3]] = 3;
	        _note_to_index_mapping[$ _unique_notes_names[4]] = 5;
	        break;
	    case 6:
	        for (var _note_index = 0; _note_index < _unique_note_count; _note_index ++) {
				_note_to_index_mapping[$ _unique_notes_names[_note_index]] = _note_index;
	        }
	        break;
	}

	function NoteTime(_hand_index, _time_ms) constructor	{
		hand_index = _hand_index;
		time_ms = _time_ms;
	}

	for (var _note_index = 0; _note_index < array_length(midi_information_notes); _note_index ++)	{
		var _note_info = midi_information_notes[_note_index];
		var _note_time_start = (_note_info[0] * global.track_time_tick_duration_seconds);
		var _note_type = string(_note_info[1]);
	    var _note_hand_index = variable_struct_get(_note_to_index_mapping, _note_type);
        var _note_time = new NoteTime(_note_hand_index, _note_time_start * 1000);
        array_push(midi_note_timings, _note_time);
	}
	
	array_sort(midi_note_timings, function(note1, note2) {
        return note1.time_ms - note2.time_ms;
    });
	show_debug_message("Loaded this track (" + global.track_details_current.track_name + ")" + " with number of notes (" + string(array_length(midi_note_timings)) + ").");
}
function song_play_audio()	{
	song_instance = audio_play_sound(global.track_stream, 1, false);
	song_instance_cooked = false;
	audio_sound_pitch(song_instance, global.track_time_playback_factor);
}
function song_finish()	{
	song_instance_cooked = false;
	room_fade_out = 0;
	audio_destroy_stream(global.track_stream);
	room_goto(roomMenu);
}
function surface_check()	{
	if !surface_exists(surface_main)	{
		surface_main = surface_create(room_width, room_height);
		surface_set_target(surface_main);
		draw_clear_alpha(c_black, 0);
		surface_reset_target();
	}
	if !surface_exists(surface_aux1)	{
		surface_aux1 = surface_create(room_width, room_height);
		surface_set_target(surface_main);
		draw_clear_alpha(c_black, 0);
		surface_reset_target();
	}
	if !surface_exists(surface_aux2)	{
		surface_aux2 = surface_create(room_width, room_height);
		surface_set_target(surface_main);
		draw_clear_alpha(c_black, 0);
		surface_reset_target();
	}
}
function draw_score()	{
	var _pos_x = room_width / 2;
	var _pos_y = room_height - 16;
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	draw_set_colour(c_white);
	draw_set_font(fontScore);
	draw_text(_pos_x, _pos_y, "SCORE: " + string(global.game_score));
}
function draw_fade()	{
	room_fade_in = approach(room_fade_in, 0, 0.001 * global.delta_multiplier);
	draw_set_alpha(max(room_fade_out, room_fade_in));
	draw_set_colour(c_black);
	draw_rectangle(0, 0, room_width, room_height, false);
	draw_set_alpha(1);
}
function draw_render_game()	{
	surface_check();
	
	with (TileBackground)	{
		surface_check();
		shader_set(shdEarthboundBoth);
		shader_set_uniform_f(shader_get_uniform(shdEarthboundBoth, "speed"), 0.0001);
		shader_set_uniform_f(shader_get_uniform(shdEarthboundBoth, "frequency"), 4.0);
		shader_set_uniform_f(shader_get_uniform(shdEarthboundBoth, "size"), 0.01);
		shader_set_uniform_f(shader_get_uniform(shdEarthboundBoth, "time"), current_time);
		draw_surface_center_ext(surface, room_width / 2, room_height / 2, 1.5, 1.5, 0, c_white, 0.6);
		shader_reset();
	}
	
	surface_set_target(surface_main);
	draw_clear_alpha(c_black, 0);
	
	with (Note)	{
		draw_note();
	}
	
	with (Hands)	{
		draw_hands();
	}
	
	draw_score();
	surface_reset_target();
	
	var _draw_pos_direction = ((tween_tick / 12) mod 360);
	var _draw_pos_distance = wave(4, 32, 48, 0);
	var _draw_pos_x = lengthdir_x(_draw_pos_distance, _draw_pos_direction);
	var _draw_pos_y = wave(-64, 8, 20, 0);
	var _draw_pos_center_x = (_draw_pos_x + (room_width / 2));
	var _draw_pos_center_y = (_draw_pos_y + (room_height / 2));
	var _draw_scale = wave(1, 2, 30, 0);
	var _draw_angle = wave(-15, 15, 40, 0);
	
	surface_set_target(surface_aux2);
	
	draw_surface_clear_tick = approach(draw_surface_clear_tick, draw_surface_clear_target, global.delta_current);
	if (draw_surface_clear_tick >= draw_surface_clear_target)	{
		draw_set_colour(c_black);
		draw_set_alpha(draw_surface_clear_alpha);
		draw_rectangle(0, 0, room_width, room_height, false);
		draw_set_colour(c_white);
		draw_set_alpha(1.0);
		draw_surface_clear_tick = 0;
	}
	
	shader_set(shdEarthboundBoth);
	shader_set_uniform_f(shader_get_uniform(shdEarthboundBoth, "speed"), 0.0001);
	shader_set_uniform_f(shader_get_uniform(shdEarthboundBoth, "frequency"), 1.0);
	shader_set_uniform_f(shader_get_uniform(shdEarthboundBoth, "size"), wave(0, 4, 60, 0));
	shader_set_uniform_f(shader_get_uniform(shdEarthboundBoth, "time"), current_time + 20000);
	draw_surface_center_ext(surface_aux1, _draw_pos_center_x, _draw_pos_center_y, _draw_scale, _draw_scale, _draw_angle, c_white, 0.8);
	shader_set_uniform_f(shader_get_uniform(shdEarthboundBoth, "time"), current_time + 20500);
	draw_surface_ext(surface_main, 0, 0, 1, 1, 0, c_white, 0.8);
	shader_reset();
	surface_reset_target();
	
	draw_surface_ext(surface_aux2, 0, 0, 1.0, 1.0, 0.0, c_white, 0.16);
	draw_surface(surface_main, 0, 0);
	surface_copy(surface_aux1, 0, 0, surface_aux2);
}
function draw_render_game_normal()	{
	surface_check();
	
	with (TileBackground)	{
		surface_check();
		shader_set(shdEarthboundBoth);
		shader_set_uniform_f(shader_get_uniform(shdEarthboundBoth, "speed"), 0.0001);
		shader_set_uniform_f(shader_get_uniform(shdEarthboundBoth, "frequency"), 4.0);
		shader_set_uniform_f(shader_get_uniform(shdEarthboundBoth, "size"), 0.01);
		shader_set_uniform_f(shader_get_uniform(shdEarthboundBoth, "time"), current_time);
		draw_surface_center_ext(surface, room_width / 2, room_height / 2, 1.5, 1.5, 0, c_white, 0.6);
		shader_reset();
	}
	
	surface_set_target(surface_main);
	draw_clear_alpha(c_black, 0);
	
	with (Note)	{
		draw_note();
	}	
	with (Hands)	{
		draw_hands();
	}
	
	draw_score();
	surface_reset_target();
	draw_surface(surface_main, 0, 0);
}

randomize();

global.window_res_width = 1280;
global.window_res_height = 720;
global.window_res_upscale = 4;

global.delta_current = (1 / game_get_speed(gamespeed_fps));
global.delta_multiplier = (1);

global.note_hit_colour[E_NOTE_ACCURACY.MISS] = merge_colour(c_navy, c_white, 0.2);
global.note_hit_colour[E_NOTE_ACCURACY.OKAY] = merge_colour(c_navy, c_white, 0.4);
global.note_hit_colour[E_NOTE_ACCURACY.GOOD] = merge_colour(c_navy, c_white, 0.6);
global.note_hit_colour[E_NOTE_ACCURACY.PERFECT] = merge_colour(c_navy, c_white, 0.8);
global.note_hit_description[E_NOTE_ACCURACY.MISS] = "MISS";
global.note_hit_description[E_NOTE_ACCURACY.OKAY] = "OKAY";
global.note_hit_description[E_NOTE_ACCURACY.GOOD] = "GOOD";
global.note_hit_description[E_NOTE_ACCURACY.PERFECT] = "PERFECT";
global.note_hit_sound[E_NOTE_ACCURACY.MISS] = sndNoteMiss;
global.note_hit_sound[E_NOTE_ACCURACY.OKAY] = sndNoteOkay;
global.note_hit_sound[E_NOTE_ACCURACY.GOOD] = sndNoteGood;
global.note_hit_sound[E_NOTE_ACCURACY.PERFECT] = sndNotePerfect;
global.note_hit_score[E_NOTE_ACCURACY.MISS] = -100;
global.note_hit_score[E_NOTE_ACCURACY.OKAY] = 35;
global.note_hit_score[E_NOTE_ACCURACY.GOOD] = 80;
global.note_hit_score[E_NOTE_ACCURACY.PERFECT] = 100;
global.note_hit_time[E_NOTE_ACCURACY.MISS] = 300;
global.note_hit_time[E_NOTE_ACCURACY.OKAY] = 200;
global.note_hit_time[E_NOTE_ACCURACY.GOOD] = 150;
global.note_hit_time[E_NOTE_ACCURACY.PERFECT] = 100;

global.track_time_tempo_bpm = -1;
global.track_time_tempo_bpms = -1;
global.track_time_playback_factor = 1;
global.track_time_current_ms = 0;
global.track_note_hand_count = 0;
global.game_score = 0;

midi_information_notes = [];
midi_information_events = [];
midi_information_array =  [midi_information_notes, midi_information_events];
midi_note_timings = [];
midi_note_spawn_offset = undefined;
midi_note_placed = false;
midi_note_placed_finished = false;
room_fade_in = 0;
room_fade_out = 0;
surface_main = -1;
surface_aux1 = -1;
surface_aux2 = -1;
tween_tick = 0;
draw_surface_clear_tick = 0;
draw_surface_clear_target = 0.25;
draw_surface_clear_alpha = (0.01);
gui_scale_ratio_x = (global.window_res_upscale);
gui_scale_ratio_y = (global.window_res_upscale);
window_centered = true;
hands_center_x = room_width * 0.5;
hands_center_y = room_height * 0.75;
hands_size = 96;
delta_target = (1 / game_get_speed(gamespeed_fps));
delta_current = (delta_time / 1000000);
song_instance = -1;
song_instance_cooked = false;

depth = -1000;

application_surface_draw_enable(false);
window_set_size(global.window_res_width, global.window_res_height);
bktglitch_activate();
window_center();
surface_resize(application_surface, global.window_res_width * global.window_res_upscale, global.window_res_height * global.window_res_upscale);
display_set_gui_size(global.window_res_width, global.window_res_height);