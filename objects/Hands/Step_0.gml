
switch (state_current)	{
	case E_STATES_HANDS.NORMAL:
		for (var _hand_index = 0; _hand_index < global.track_note_hand_count; _hand_index ++)	{
			hand_input[_hand_index] = keyboard_check_pressed(hand_button[_hand_index]);
			if (hand_input[_hand_index])	{
				execute_input(_hand_index);
			}
		}
		break;
}