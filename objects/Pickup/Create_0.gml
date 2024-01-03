// initialize

function execute_action(_in_action, _in_accuracy)	{
	TweenFire(id, EaseInSine, TWEEN_MODE_ONCE, true, 0, 0.4, "transition_interp", 0, 1);
	
	note_hit_type = _in_accuracy;
	var _hand_reference = ((note_type == -1) ? 0 : 1);
	with (Game)	{
		note_score_execute(_hand_reference, _in_accuracy);
	}

	switch (_in_action)	{
		case 0:
			state_current = E_STATES_PICKUP.COLLECTED;
			break;
		case 1:
			state_current = E_STATES_PICKUP.MISSED;
			break;
	}
}
function return_accuracy()	{
	var _pickup_time_current = abs(global.track_time_current_ms - note_time_ideal);
	if (_pickup_time_current < (global.note_hit_time[E_NOTE_ACCURACY.PERFECT]))	{
		return E_NOTE_ACCURACY.PERFECT;
	}
	else if (_pickup_time_current < (global.note_hit_time[E_NOTE_ACCURACY.GOOD]))	{
		return E_NOTE_ACCURACY.GOOD;
	}
	else if (_pickup_time_current < (global.note_hit_time[E_NOTE_ACCURACY.OKAY]))	{
		return E_NOTE_ACCURACY.OKAY;
	}
	else return E_NOTE_ACCURACY.MISS;
}
function draw_pickup()	{
	var _circle_radius = wave(circle_radius_target, circle_radius_target * circle_radius_factor, circle_radius_time, 0);
	draw_set_colour(image_blend);
	draw_circle(x, y, _circle_radius, false);
	draw_set_colour(c_black);
	draw_circle(x, y, _circle_radius * circle_radius_factor, false);
}

enum E_STATES_PICKUP	{
	FREEFALL, COLLECTED, MISSED
}

enum E_NOTE_ACCURACY	{
	MISS, OKAY, GOOD, PERFECT
}

note_type = 0;
note_target = 0;
note_threshold = 0;
note_time_ideal = -1;

note_hit_type = E_NOTE_ACCURACY.MISS;

state_current = E_STATES_PICKUP.FREEFALL;
transition_interp = 0;

rotation_speed = 2;
circle_radius_target = 0;
circle_radius_factor = 0.90;
circle_radius_time = 0.5;

note_colour_perfect = c_aqua;
note_colour_normal = c_navy;