// move accordingly

switch (state_current)	{
	case E_STATES_NOTE.FREEFALL:
		step_freefall();
		break;

	case E_STATES_NOTE.COLLECTED:
		step_collected();
		break;
		
	case E_STATES_NOTE.MISSED:
		step_missed();
		break;
		
	case E_STATES_NOTE.PERFECTING:
		step_perfecting();
		break;
}