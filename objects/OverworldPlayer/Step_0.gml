switch (state_current)	{
	case E_OVERWORLD_PLAYER_STATES.BASE:
		step_input();
		step_movement_check();
		break;
		
	case E_OVERWORLD_PLAYER_STATES.MOVING:
		step_input();
		step_movement_moving();
		break;
}

depth = -y;
tween_value += global.delta_current;