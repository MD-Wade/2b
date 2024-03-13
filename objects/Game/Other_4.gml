

switch (room)	{
	case roomMenu:
		camera_init();
		break;

	case roomGame:
		song_load(global.track_details_current);
		camera_init();
		hands_create();
		room_fade_in = 1;
		break;
		
	case roomOffsetSound:
		camera_init();
		break;
		
	case roomOverworldDemo:
		camera_init();
		overworld_create_player();
		overworld_prepare_nodes();
		break;
}
