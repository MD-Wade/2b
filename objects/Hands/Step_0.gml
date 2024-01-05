
switch (state_current)	{
	case E_STATES_HANDS.INTRO:
		if (global.track_time_current_ms > state_tick_target)	{
			state_current = E_STATES_HANDS.NORMAL;
		}
		break;

	case E_STATES_HANDS.NORMAL:
		for (var i = 0; i < 2; i ++)	{
			hand_trigger_input[i] = mouse_check_button_pressed(hand_trigger_button[i]);
			if (hand_trigger_input[i])	{
				execute_input(i);
			}
		}
		break;
}