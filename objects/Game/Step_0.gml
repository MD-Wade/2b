

switch (room)	{
	case roomInit:
		if (window_centered)	{
			room_goto_next();
		}
		break;
		
	case roomGame:
		note_check_place();
		break;
}
