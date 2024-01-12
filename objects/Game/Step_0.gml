switch (room)	{
	case roomInit:
		if (window_centered)	{
			room_goto_next();
		}
		break;
		
	case roomGame:
		if keyboard_check_pressed(vk_escape)
			room_fade_manual = true;
		note_check_place();
		break;
}
