function execute_input(_hand_input) {
    var _hand_index = ((_hand_input == 0) ? -1 : 1);
    var _note_information = return_note_accuracy(_hand_index);

    if (instance_exists(_note_information[0])) {
        with (_note_information[0]) {
            execute_action(0, return_accuracy());
        }
    } else {
		with (Game)	{
			note_score_execute(_hand_input, E_NOTE_ACCURACY.MISS);
		}
    }
}
function return_note_accuracy(_hand_index) {
    var _return_id = noone;
    var _return_accuracy = -1;

    var _pickup_id = noone;
    var _pickup_lowest_current = (global.note_hit_time[E_NOTE_ACCURACY.MISS]);

    with (Pickup) {
        if (note_type == _hand_index) {
            var _pickup_lowest_check = abs(global.track_time_current_ms - note_time_ideal);
            if (_pickup_lowest_check <= _pickup_lowest_current) {
                _pickup_id = id;
                _pickup_lowest_current = _pickup_lowest_check;
            }
        }
    }

    if (instance_exists(_pickup_id)) {
        with (_pickup_id) {
            _return_id = _pickup_id;
            _return_accuracy = return_accuracy();
        }
    }

    return [_return_id, _return_accuracy];
}
function draw_hands()	{
	draw_set_colour(c_white);
	draw_set_alpha(0.5);
	for (var i = 0; i < 2; i ++)	{
		var _pos_x1 = hand_trigger_pos_x[i] - (hand_trigger_size / 2);
		var _pos_y1 = hand_trigger_pos_y[i] - (hand_trigger_size / 2);
		var _pos_x2 = hand_trigger_pos_x[i] + (hand_trigger_size / 2);
		var _pos_y2 = hand_trigger_pos_y[i] + (hand_trigger_size / 2);
	
		draw_rectangle_width(_pos_x1, _pos_y1, _pos_x2, _pos_y2, 4);
	}
	draw_set_alpha(1);
}
function draw_hands_text()	{
	draw_set_font(fontAccuracy);
	draw_set_halign(fa_right);
	draw_set_valign(fa_middle);
	var _colour_base = merge_colour(hand_trigger_text_colour[0], c_white, hand_trigger_text_colour_tween[0]);
	var _colour_shadow = merge_colour(_colour_base, c_black, 0.8);
	draw_set_colour(_colour_shadow);
	draw_text_transformed(hand_trigger_text_x[0] - 2, hand_trigger_text_y[0] + 1, hand_trigger_text_string[0], hand_trigger_text_scale[0], hand_trigger_text_scale[0], 0);
	draw_set_colour(_colour_base);
	draw_text_transformed(hand_trigger_text_x[0], hand_trigger_text_y[0], hand_trigger_text_string[0], hand_trigger_text_scale[0], hand_trigger_text_scale[0], 0);

	draw_set_halign(fa_left);
	draw_set_valign(fa_middle);
	var _colour_base = merge_colour(hand_trigger_text_colour[1], c_white, hand_trigger_text_colour_tween[1]);
	var _colour_shadow = merge_colour(_colour_base, c_black, 0.8);
	draw_set_colour(_colour_shadow);
	draw_text_transformed(hand_trigger_text_x[1] + 2, hand_trigger_text_y[1] + 1, hand_trigger_text_string[1], hand_trigger_text_scale[1], hand_trigger_text_scale[1], 0);
	draw_set_colour(_colour_base);
	draw_text_transformed(hand_trigger_text_x[1], hand_trigger_text_y[1], hand_trigger_text_string[1], hand_trigger_text_scale[1], hand_trigger_text_scale[1], 0);
}

enum E_STATES_HANDS	{
	INTRO, NORMAL
}
state_current = E_STATES_HANDS.INTRO;

hand_target_x = (room_width / 2);
hand_target_y = ((room_height / 4) * 3);

hand_size = 128;
hand_trigger_size = hand_size * 0.75;

hand_trigger_pos_x[0] = (room_width / 2) - (hand_size / 2);
hand_trigger_pos_y[0] = ((room_height / 4) * 3);
hand_trigger_button[0] = mb_left;

hand_trigger_pos_x[1] = (room_width / 2) + (hand_size * 0.65);
hand_trigger_pos_y[1] = ((room_height / 4) * 3);
hand_trigger_button[1] = mb_right;

hand_trigger_text_x[0] = hand_trigger_pos_x[0] - (hand_trigger_size * 0.75);
hand_trigger_text_y[0] = hand_trigger_pos_y[0];
hand_trigger_text_colour[0] = c_dkgray;
hand_trigger_text_colour_tween[0] = 1;
hand_trigger_text_scale[0] = 1;
hand_trigger_text_string[0] = "--";
hand_trigger_text_tween_id[0] = -1;

hand_trigger_text_x[1] = hand_trigger_pos_x[1] + (hand_trigger_size * 0.75);
hand_trigger_text_y[1] = hand_trigger_pos_y[1];
hand_trigger_text_colour[1] = c_dkgray;
hand_trigger_text_colour_tween[1] = 1;
hand_trigger_text_scale[1] = 1;
hand_trigger_text_string[1] = "--";
hand_trigger_text_tween_id[1] = -1;