/// @description Dispose of dynamic elements

for (var _track_entry_index = 0; _track_entry_index < array_length(tracks_details_all); _track_entry_index ++)	{
	var _track_details_current = tracks_details_all[_track_entry_index];
	var _track_audio = _track_details_current.dynamic_stream;
	var _track_sprite = _track_details_current.dynamic_sprite;
	
	if (sprite_exists(_track_sprite))	{
		sprite_delete(_track_sprite);
		show_debug_message("Destroyed track sprite: " + string(_track_sprite));
	}
	if (audio_exists(_track_audio))	{
		audio_destroy_stream(_track_audio);
		show_debug_message("Destroyed track audio: " + string(_track_audio));
	}
}