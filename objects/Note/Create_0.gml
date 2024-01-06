// initialize

function execute_action(_in_action, _in_accuracy)	{
	TweenFire(id, EaseInSine, TWEEN_MODE_ONCE, true, 0, 0.4, "transition_interp", 0, 1);
	
	note_hit_type = _in_accuracy;
	with (Game)	{
		note_score_execute(_in_accuracy);
	}

	switch (_in_action)	{
		case 0:
			state_current = E_STATES_NOTE.COLLECTED;
			note_perfecting_start_x = x;
			note_perfecting_start_y = y;
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
function return_accuracy() {
    var _note_time_diff = global.track_time_current_ms - note_time_ideal;
    var _note_time_current = abs(_note_time_diff);
    var _note_time_early_multiplier = _note_time_diff < 0 ? note_multiplier_early : note_multiplier_late;

    if (_note_time_current < (global.note_hit_time[E_NOTE_ACCURACY.PERFECT] * _note_time_early_multiplier)) {
        return E_NOTE_ACCURACY.PERFECT;
    }
    else if (_note_time_current < (global.note_hit_time[E_NOTE_ACCURACY.GOOD] * _note_time_early_multiplier)) {
        return E_NOTE_ACCURACY.GOOD;
    }
    else if (_note_time_current < (global.note_hit_time[E_NOTE_ACCURACY.OKAY] * _note_time_early_multiplier)) {
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
note_size = 0;
note_multiplier_early = 0.5;
note_multiplier_late = 1.0;
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