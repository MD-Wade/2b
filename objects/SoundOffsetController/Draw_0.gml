draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fontScore);
draw_set_colour(c_white);

switch (test_state)	{
	case E_AUDIO_SYNC_STATES.INIT:
		draw_text(8, 8, intro_message);
		break;
		
	case E_AUDIO_SYNC_STATES.SYNC_TEST:
		draw_text(8, 8, test_message);
		break;
}