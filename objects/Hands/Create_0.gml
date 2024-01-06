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
			if (state_current == E_STATES_NOTE.FREEFALL)	{
				var _note_lowest_check = abs(global.track_time_current_ms - note_time_ideal);
	            if (_note_lowest_check <= _note_lowest_current) {
	                _note_id = id;
	                _note_lowest_current = _note_lowest_check;
	            }
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
    var is_odd = global.track_note_hand_count % 2 != 0;
    var middle_index = (global.track_note_hand_count - 1) / 2;
    for (var hand_index = 0; hand_index < global.track_note_hand_count; hand_index++) {
        var width_multiplier = (is_odd && hand_index == middle_index) ? 2 : 1;
        var pos_x1 = hand_pos_x[hand_index] - (hands_size * width_multiplier / 2);
        var pos_y1 = hand_pos_y[hand_index] - (hands_size / 2);
        var pos_x2 = hand_pos_x[hand_index] + (hands_size * width_multiplier / 2);
        var pos_y2 = hand_pos_y[hand_index] + (hands_size / 2);
        draw_rectangle_width(pos_x1, pos_y1, pos_x2, pos_y2, 4);
        draw_text(mean(pos_x1, pos_x2), mean(pos_y1, pos_y2), chr(hand_button[hand_index]));
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
		var _position_x_minimum = (_position_x_center - (hands_size  * 3));
		var _position_x_maximum = (_position_x_center + (hands_size * 3));
		var _position_y_main = (_position_y_center);
	
		// Hand Position
		hand_pos_x[_iteration] = lerp(_position_x_minimum, _position_x_maximum, _interp_value);
		hand_pos_y[_iteration] = _position_y_main;
	}
	switch (global.track_note_hand_count)	{
		case 2:
			hand_button[0] = ord("A");
			hand_button[1] = ord("L");
			break;
		
		case 3:
			hand_button[0] = ord("A");
			hand_button[1] = vk_space;
			hand_button[2] = ord("L");
			break;
		
		case 4:
			hand_button[0] = ord("A");
			hand_button[1] = ord("S");
			hand_button[2] = ord("K");
			hand_button[3] = ord("L");
			break;
		
		case 5:
			hand_button[0] = ord("A");
			hand_button[1] = ord("S");
			hand_button[2] = vk_space;
			hand_button[3] = ord("K");
			hand_button[4] = ord("L");
			break;
			
		case 6:
			hand_button[0] = ord("A");
			hand_button[1] = ord("S");
			hand_button[2] = ord("D");
			hand_button[3] = ord("J");
			hand_button[4] = ord("K");
			hand_button[5] = ord("L");
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