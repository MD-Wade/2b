function execute_input(_hand_input) {
    var _note_information = return_note_accuracy(_hand_input);

    if (instance_exists(_note_information[0])) {
        with (_note_information[0]) {
            execute_action(0, return_accuracy());
        }
    } else {
		with (Game)	{
			note_score_execute(E_NOTE_ACCURACY.MISS);
		}
    }
}
function return_note_accuracy(_hand_index_check) {
    var _return_id = noone;
    var _return_accuracy = -1;
    var _note_id = noone;
    var _note_lowest_current = (global.note_hit_time[E_NOTE_ACCURACY.MISS]);

    with (Note) {
        if (note_type == _hand_index_check) {
            var _note_lowest_check = abs(global.track_time_current_ms - note_time_ideal);
            if (_note_lowest_check <= _note_lowest_current) {
                _note_id = id;
                _note_lowest_current = _note_lowest_check;
            }
        }
    }

    if (instance_exists(_note_id)) {
        with (_note_id) {
            _return_id = _note_id;
            _return_accuracy = return_accuracy();
        }
    }

    return [_return_id, _return_accuracy];
}
function draw_hands()	{
	draw_set_colour(c_white);
	draw_set_alpha(0.5);
	for (var _hand_index = 0; _hand_index < global.track_note_hand_count; _hand_index ++)	{
		var _pos_x1 = hand_pos_x[_hand_index] - (hands_size / 2);
		var _pos_y1 = hand_pos_y[_hand_index] - (hands_size / 2);
		var _pos_x2 = hand_pos_x[_hand_index] + (hands_size / 2);
		var _pos_y2 = hand_pos_y[_hand_index] + (hands_size / 2);
		draw_rectangle_width(_pos_x1, _pos_y1, _pos_x2, _pos_y2, 4);
		draw_text(mean(_pos_x1, _pos_x2), mean(_pos_y1, _pos_y2), chr(hand_button[_hand_index]));
	}
	draw_set_alpha(1);
}
function init_hands()	{
	for (var _iteration = 0; _iteration < global.track_note_hand_count; _iteration ++)	{
		if (global.track_note_hand_count == 1) {
	        var _interp_value = 0.5;
	    } else {
	        var _interp_value = _iteration / (global.track_note_hand_count - 1);
	    }
		var _position_x_center = (x);
		var _position_y_center = (y);
		var _position_x_minimum = (_position_x_center - (hands_size  * 4));
		var _position_x_maximum = (_position_x_center + (hands_size * 4));
		var _position_y_main = (_position_y_center);
	
		// Hand Position
		hand_pos_x[_iteration] = lerp(_position_x_minimum, _position_x_maximum, _interp_value);
		hand_pos_y[_iteration] = _position_y_main;
		
		show_debug_message("Placed Hand " + string(_iteration) + " at (" + string(hand_pos_x[_iteration]) + ", " + string(hand_pos_y[_iteration]) + ").");
	}
	switch (global.track_note_hand_count)	{
		case 2:
			hand_button[0] = ord("S");
			hand_button[1] = ord("K");
			break;
		
		case 3:
			hand_button[0] = ord("S");
			hand_button[1] = vk_space;
			hand_button[2] = ord("K");
			break;
		
		case 4:
			hand_button[0] = ord("S");
			hand_button[1] = ord("D");
			hand_button[2] = ord("J");
			hand_button[3] = ord("K");
			break;
		
		case 5:
			hand_button[0] = ord("S");
			hand_button[1] = ord("D");
			hand_button[2] = vk_space;
			hand_button[3] = ord("J");
			hand_button[4] = ord("K");
			break;
	}
}

enum E_STATES_HANDS	{
	INTRO, NORMAL
}
state_current = E_STATES_HANDS.INTRO;
state_tick_target = 1500;
hands_size = 0;

init_hands();