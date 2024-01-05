// initialize

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
function note_score_execute(_hand_index, _note_accuracy)	{
	var _text_tween_colour = global.note_hit_colour[_note_accuracy];
	global.game_score += global.note_hit_score[_note_accuracy];
	audio_play_sound(global.note_hit_sound[_note_accuracy], 1, false);

	with (Hands)	{
		hand_trigger_text_colour[_hand_index] = _text_tween_colour;
		hand_trigger_text_string[_hand_index] = global.note_hit_description[_note_accuracy];
		if TweenExists(hand_trigger_text_tween_id[_hand_index])	{
			TweenDestroy(hand_trigger_text_tween_id[_hand_index]);
		}
		hand_trigger_text_tween_id[_hand_index] = TweenFire(id, EaseOutBack, TWEEN_MODE_BOUNCE, true, 0, 0.35,
			TPArray(hand_trigger_text_colour_tween, _hand_index), 0, 1,
			TPArray(hand_trigger_text_scale, _hand_index), 1, 1.10
		);
	}
}
function song_start(_track_details)	{
	global.track_file_midi = _track_details.file_midi;
	global.track_stream = audio_create_stream(_track_details.file_audio);
	room_goto(roomGame);
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
	
	with (Pickup)	{
		draw_pickup();
	}
	
	with (Hands)	{
		draw_hands();
		draw_hands_text();
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
	draw_set_colour(c_black);
	draw_set_alpha(2/255);
	draw_rectangle(0, 0, room_width, room_height, false);
	draw_set_colour(c_white);
	draw_set_alpha(1.0);
	shader_set(shdEarthboundBoth);
	shader_set_uniform_f(shader_get_uniform(shdEarthboundBoth, "speed"), 0.0001);
	shader_set_uniform_f(shader_get_uniform(shdEarthboundBoth, "frequency"), 1.0);
	shader_set_uniform_f(shader_get_uniform(shdEarthboundBoth, "size"), wave(0, 4, 60, 0));
	shader_set_uniform_f(shader_get_uniform(shdEarthboundBoth, "time"), current_time);
	draw_surface_center_ext(surface_aux1, _draw_pos_center_x, _draw_pos_center_y, _draw_scale, _draw_scale, _draw_angle, c_white, 0.8);
	shader_set_uniform_f(shader_get_uniform(shdEarthboundBoth, "time"), current_time + 500);
	draw_surface_ext(surface_main, 0, 0, 1, 1, 0, c_white, 0.8);
	shader_reset();
	surface_reset_target();
	
	draw_surface_ext(surface_aux2, 0, 0, 1.0, 1.0, 0.0, c_white, 0.16);
	draw_surface(surface_main, 0, 0);
	surface_copy(surface_aux1, 0, 0, surface_aux2);
}

randomize();


global.window_res_width = 1280;
global.window_res_height = 720;
global.window_res_upscale = 1;

application_surface_draw_enable(false);
window_set_size(global.window_res_width * global.window_res_upscale, global.window_res_height * global.window_res_upscale);
bktglitch_activate();
window_center();
surface_resize(application_surface, global.window_res_width, global.window_res_height);

window_centered = true;
delta_target = (1 / game_get_speed(gamespeed_fps));
delta_current = (delta_time / 1000000);
global.delta_multiplier = (delta_current / delta_target);

function game_execute_song_tempo_calculate()	{
	global.song_time_tempo_bpms = (global.song_time_tempo_bpm / 60000);
	global.note_hit_time[E_NOTE_ACCURACY.MISS] = (200);
	global.note_hit_time[E_NOTE_ACCURACY.OKAY] = (150);
	global.note_hit_time[E_NOTE_ACCURACY.GOOD] = (100);
	global.note_hit_time[E_NOTE_ACCURACY.PERFECT] = (70);
}

global.song_time_tempo_bpm = -1;
global.song_time_tempo_bpms = -1;
global.track_time_current_ms = 0;

global.game_glitch_intensity = 1.0;
global.game_points_possible = 0;

global.note_hit_colour[E_NOTE_ACCURACY.MISS] = merge_colour(c_navy, c_white, 0.2);
global.note_hit_colour[E_NOTE_ACCURACY.OKAY] = merge_colour(c_navy, c_white, 0.4);
global.note_hit_colour[E_NOTE_ACCURACY.GOOD] = merge_colour(c_navy, c_white, 0.6);
global.note_hit_colour[E_NOTE_ACCURACY.PERFECT] = merge_colour(c_navy, c_white, 0.8);
global.note_hit_description[E_NOTE_ACCURACY.MISS] = "MISS";
global.note_hit_description[E_NOTE_ACCURACY.OKAY] = "OKAY";
global.note_hit_description[E_NOTE_ACCURACY.GOOD] = "GOOD";
global.note_hit_description[E_NOTE_ACCURACY.PERFECT] = "PERFECT";
global.note_hit_score[E_NOTE_ACCURACY.MISS] = -100;
global.note_hit_score[E_NOTE_ACCURACY.OKAY] = 35;
global.note_hit_score[E_NOTE_ACCURACY.GOOD] = 80;
global.note_hit_score[E_NOTE_ACCURACY.PERFECT] = 100;
global.note_hit_sound[E_NOTE_ACCURACY.MISS] = sndNoteMiss;
global.note_hit_sound[E_NOTE_ACCURACY.OKAY] = sndNoteOkay;
global.note_hit_sound[E_NOTE_ACCURACY.GOOD] = sndNoteGood;
global.note_hit_sound[E_NOTE_ACCURACY.PERFECT] = sndNotePerfect;

global.song_time_playback_factor = 1;

global.game_score = 0;

room_fade_in = 0;
room_fade_out = 0;
surface_main = -1;
surface_aux1 = -1;
surface_aux2 = -1;
tween_tick = 0;
depth = -1000;