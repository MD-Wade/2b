switch (room)	{
	case roomInit:
		if (initialized_window and initialized_camera)	{
			room_goto(roomOffsetSound);
		}
		break;
		
	case roomGame:
		if keyboard_check_pressed(vk_escape)
			room_fade_manual = true;
		note_check_place();
		//input_volume_update();
		break;
}
