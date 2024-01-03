if surface_exists(surface_main)	{
	surface_free(surface_main);
}
if surface_exists(surface_aux1)	{
	surface_free(surface_aux1);
}
if surface_exists(surface_aux2)	{
	surface_free(surface_aux2);
}
surface_main = -1;
surface_aux1 = -1;
surface_aux2 = -1;

switch (room)	{
	case roomGame:
		if (ds_exists(midi_information_notes, ds_type_list))	{
			ds_list_destroy(midi_information_notes);
		}
		if (ds_exists(midi_information_events, ds_type_list))	{
			ds_list_destroy(midi_information_notes);
		}
		break;
}