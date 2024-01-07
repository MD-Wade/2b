// initialize

function execute_action(_in_action, _in_accuracy)	{
	TweenFire(id, EaseInSine, TWEEN_MODE_ONCE, true, 0, 0.4, "transition_interp", 0, 1);
	
	note_hit_type = _in_accuracy;
	with (Game)	{
		note_score_execute(_in_accuracy);
	}

	global.track_note_accuracy[_in_accuracy] ++;
	switch (_in_action)	{
		case 0:
			state_current = E_STATES_NOTE.COLLECTED;
			note_perfecting_start_x = x;
			note_perfecting_start_y = y;
			global.track_note_hit_count ++;
			if (_in_accuracy == E_NOTE_ACCURACY.PERFECT)	{
				state_tick = 0;
				state_tick_target = note_perfecting_time;
				state_current = E_STATES_NOTE.PERFECTING;
			}	
			break;
		case 1:
			state_current = E_STATES_NOTE.MISSED;
			break;
	}
}
function step_freefall() {
    if (global.track_time_current_ms > (note_time_ideal + global.note_hit_time[E_NOTE_ACCURACY.MISS])) {
        execute_action(1, E_NOTE_ACCURACY.MISS);
    }
    y += (global.track_note_speed_frame * global.delta_multiplier);

    var _ideal_time_difference = abs(global.track_time_current_ms - note_time_ideal);
    var _ideal_time_interp = 1 - clamp(_ideal_time_difference / global.note_hit_time[E_NOTE_ACCURACY.PERFECT], 0, 1);
	note_size = lerp(note_size_base, note_size_base * note_ideal_ratio, _ideal_time_interp);
}
function step_collected()	{
	image_alpha = lerp(1, 0, transition_interp);
	image_blend = merge_colour(c_white, global.note_hit_colour[note_hit_type], transition_interp);
	if (image_alpha <= 0)	{
		instance_destroy();
	}
}
function step_missed()	{
	image_alpha = approach(image_alpha, 0, 0.05);
	if (image_alpha <= 0)	{
		instance_destroy();
	}
}
function step_perfecting()	{
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
}
function return_accuracy() {
    var _note_time_diff = global.track_time_current_ms - note_time_ideal;
    var _note_time_current = abs(_note_time_diff);

    if (_note_time_current < (global.note_hit_time[E_NOTE_ACCURACY.PERFECT])) {
        return E_NOTE_ACCURACY.PERFECT;
    }
    else if (_note_time_current < (global.note_hit_time[E_NOTE_ACCURACY.GOOD])) {
        return E_NOTE_ACCURACY.GOOD;
    }
    else if (_note_time_current < (global.note_hit_time[E_NOTE_ACCURACY.OKAY])) {
        return E_NOTE_ACCURACY.OKAY;
    }
    else return E_NOTE_ACCURACY.MISS;
}
function draw_note()	{
	image_xscale = (note_size / sprite_get_width(sprite_index));
	image_yscale = (note_size / sprite_get_height(sprite_index));
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}

enum E_STATES_NOTE	{
	FREEFALL, COLLECTED, MISSED, PERFECTING
}
enum E_NOTE_ACCURACY	{
	MISS, OKAY, GOOD, PERFECT
}

note_type = 0;
note_time_ideal = undefined;
note_size_base = undefined;
note_ideal_ratio = 1.4;
note_perfecting_start_x = undefined;
note_perfecting_start_y = undefined;
note_perfecting_end_x = undefined;
note_perfecting_end_y = undefined;
note_perfecting_time = 0.12;

note_hit_type = E_NOTE_ACCURACY.MISS;

state_current = E_STATES_NOTE.FREEFALL;
state_tick = 0;
state_tick_target = 0;
transition_interp = 0;