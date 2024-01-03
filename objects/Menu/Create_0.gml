/// @description Initialize

function TrackDetails(_file_midi, _file_audio, _file_art, _file_info) constructor {
    function prepare_path(_file_path) {
        _file_path = string_replace_all(_file_path, "\\", "/");
        return _file_path;
    }
	
	function read_file(_file_path)	{
		var _file_handle = file_text_open_read(_file_path);
		var _file_string = "";
		while !file_text_eof(_file_handle)	{
			_file_string += file_text_readln(_file_handle);
		}
		return _file_string;
	}

    file_midi = prepare_path(_file_midi);
    file_audio = prepare_path(_file_audio);
    file_art = prepare_path(_file_art);
	file_info = prepare_path(_file_info);

    dynamic_stream = audio_create_stream(self.file_audio);
    dynamic_sprite = sprite_add(self.file_art, 1, false, false, 0, 0);
	
	var _json_string = read_file(file_info);
	track_info = json_parse(_json_string);
	track_name = track_info.track_name;
	track_author = track_info.track_author;
}

function scan_tracks()	{
	tracks_directory = working_directory + "Tracks";
	tracks_details_all = [];

	if (directory_exists(tracks_directory)) {
	    var _directory_filter = tracks_directory + "/*";
	    var _track_path = file_find_first(_directory_filter, fa_directory);
	    show_debug_message("_directoryFilter: " + _directory_filter);
	    show_debug_message("_trackPath: " + _track_path);

	    while (_track_path != "") {
	        var _track_path_full = tracks_directory + "/" + _track_path;
	        show_debug_message(_track_path_full);
	        var _file_midi = _track_path_full + "/notes.mid";
	        var _file_audio = _track_path_full + "/song.ogg";
	        var _file_art = _track_path_full + "/album.png";
			var _file_info = _track_path_full + "/info.json";

	        if not file_exists(_file_midi) {
	            show_debug_message("Missing MIDI");
	            continue;
	        }
	        if not file_exists(_file_audio) {
	            show_debug_message("Missing Audio Stream");
	            continue;
	        }
	        if not file_exists(_file_art) {
	            show_debug_message("Missing Art");
	            _file_art = undefined;
	        }
			if not file_exists(_file_info)	{
				show_debug_message("Missing Info JSON");
			}

			var _track_details = new TrackDetails(_file_midi, _file_audio, _file_art, _file_info);
			array_push(tracks_details_all, _track_details);
	        _track_path = file_find_next();
	    }
	    show_debug_message("Done parsing tracks.");
	    file_find_close();
	} else {
	    show_debug_message("Could not find Tracks.");
	}
}
function play_track(_track_details)	{
	with (Game)	{
		song_start(_track_details);
	}
}
function step_scroll()	{
	var _menu_scroll_input = (mouse_wheel_down() - mouse_wheel_up());
	menu_scroll_position = clamp(menu_scroll_position + _menu_scroll_input, 0, max(array_length(tracks_details_all) - 5, 0));
	camera_pos_y = lerp(camera_pos_y, menu_scroll_position * track_entry_height_border, 0.1);
	
	with (Game)	{
		camera_set_pos_y(camera_pos_y);
	}
}
function draw_track_entry(_offset_x, _offset_y, _track_details, _is_selected)	{
	var _pos_x = _offset_x;
	var _pos_y = _offset_y;
	var _text_scale_title = 1.0;
	var _text_scale_author = 0.5;
	var _sprite_pos_x = (_pos_x + (track_entry_border / 2));
	var _sprite_pos_y = (_pos_y + (track_entry_border / 2));
	var _text_title_pos_x = (_sprite_pos_x + track_entry_button_width + track_entry_border);
	var _text_title_pos_y = (_sprite_pos_y);
	var _text_author_pos_x = (_text_title_pos_x);
	var _text_author_pos_y = (_text_title_pos_y + (string_height(_track_details.track_name) * _text_scale_title));
	var _track_sprite = _track_details.dynamic_sprite;
	
	var _x1 = _pos_x;
	var _y1 = _pos_y;
	var _x2 = _pos_x + track_entry_width;
	var _y2 = _pos_y + track_entry_height;
	
	var _colour_background = merge_colour(c_black, c_dkgray, 0.2);
	var _colour_text_title = c_ltgray;
	var _colour_text_author = c_gray;
	
	if (_is_selected)	{
		_colour_background = c_dkgray;
		_colour_text_title = c_white;
		_colour_text_author = c_ltgray;
	}
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(fontScore);
	draw_set_colour(_colour_background);
	draw_rectangle(_x1, _y1, _x2, _y2, false);
	draw_set_colour(_colour_text_title);
	draw_text_transformed(_text_title_pos_x, _text_title_pos_y, _track_details.track_name, _text_scale_title, _text_scale_title, 0);
	draw_set_colour(_colour_text_author);
	draw_text_transformed(_text_author_pos_x, _text_author_pos_y, _track_details.track_author, _text_scale_author, _text_scale_author, 0);
	draw_set_colour(c_white);
	draw_sprite_stretched(_track_sprite, 0, _sprite_pos_x, _sprite_pos_y, track_entry_button_width, track_entry_button_height);
	return [_x1, _y1, _x2, _y2];
}
function draw_track_entry_all()	{
	var _track_count_total = array_length(tracks_details_all);
	var _track_entry_offset_y = 0;
	for (var _track_entry_index = 0; _track_entry_index < _track_count_total; _track_entry_index ++)	{
		var _track_details_current = tracks_details_all[_track_entry_index];
		var _track_is_selected = (_track_entry_index == track_entry_selected);
		var _offset_x = 0.0;
		
		if _track_is_selected	{
			_offset_x = wave(0.0, 2.0, 0.5, 0.0);
		}
		
		var _track_entry_pos_x = track_entry_pos_x + _offset_x;
		var _track_entry_pos_y = track_entry_pos_y + _track_entry_offset_y;
		
		var _track_entry_bbox = draw_track_entry(_track_entry_pos_x, _track_entry_pos_y, _track_details_current, _track_is_selected);
		if (point_in_rectangle(mouse_x, mouse_y, _track_entry_bbox[0], _track_entry_bbox[1], _track_entry_bbox[2], _track_entry_bbox[3]))	{
			track_entry_selected = _track_entry_index;
			if (mouse_check_button_pressed(mb_left))	{
				play_track(_track_details_current);
			}
		}

		_track_entry_offset_y += track_entry_height_border;
	}
}

track_entry_border = 4;
track_entry_button_width = 128;
track_entry_button_height = 128;
track_entry_width = ((room_width / 2.0) - (track_entry_border * 2));
track_entry_height = (track_entry_button_height + track_entry_border);
track_entry_height_border = (track_entry_height + track_entry_border);
track_entry_pos_x = (track_entry_border / 2);
track_entry_pos_y = (track_entry_border / 2);

track_entry_selected = undefined;

menu_scroll_position = 0.0;
camera_pos_y = 0;

scan_tracks();