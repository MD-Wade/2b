function play_track(_track_details)	{
	with (Game)	{
		song_start(_track_details);
	}
}
function step_scroll()	{
	var _menu_scroll_input = (mouse_wheel_down() - mouse_wheel_up());
	var _menu_scroll_minimum = 0;
	var _menu_scroll_maximum = max(array_length(global.tracks_array_all) - 5, 0);
	
	if (_menu_scroll_input != 0)	{
		if !is_undefined(camera_tween_instance)	{
			TweenDestroy(camera_tween_instance);
		}
		menu_scroll_position = clamp(menu_scroll_position + _menu_scroll_input, _menu_scroll_minimum, _menu_scroll_maximum);
		var _camera_target_y = menu_scroll_position * track_entry_height_border;
		camera_tween_instance = TweenFire(id, camera_tween_type, TWEEN_MODE_ONCE, true, 0, camera_tween_duration, "camera_pos_y", camera_pos_y, _camera_target_y);  
	}
	with (Game)	{
		camera_set_pos_y(other.camera_pos_y);
	}
}
function draw_track_entry(_offset_x, _offset_y, _track_details, _is_selected)	{
	var _pos_x = _offset_x;
	var _pos_y = _offset_y;
	var _text_scale_title = 1.0;
	var _text_scale_author = 0.5;
	var _sprite_pos_x = (_pos_x + (track_entry_border / 2));
	var _sprite_pos_y = (_pos_y + (track_entry_border / 2));
	var _track_sprite = _track_details.dynamic_sprite;
	
	var _x1 = _pos_x;
	var _y1 = _pos_y;
	var _x2 = _pos_x + track_entry_width;
	var _y2 = _pos_y + track_entry_height;
	
	var _colour_background = merge_colour(c_black, c_dkgray, 0.2);
	var _colour_text_title = c_ltgray;
	var _colour_text_author = c_gray;
	
	if (_is_selected)	{
		var _colour_mix = max(wave(-4, 0.35, 1, 0), 0);
		_colour_background = merge_colour(c_dkgray, c_gray, _colour_mix);
		_colour_text_title = c_white;
		_colour_text_author = c_ltgray;
	}
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(fontScore);
	
	var _text_split_width = (track_entry_width - (track_entry_border * 2));
	var _title_height = string_height_ext(_track_details.track_name, -1, _text_split_width) * _text_scale_title;
	var _text_title_pos_x = (_sprite_pos_x + track_entry_button_width + track_entry_border);
	var _text_title_pos_y = (_sprite_pos_y);
	var _text_author_pos_x = (_text_title_pos_x);
	var _text_author_pos_y = (_text_title_pos_y + _title_height);
	
	draw_set_colour(_colour_background);
	draw_rectangle(_x1, _y1, _x2, _y2, false);
	draw_set_colour(_colour_text_title);
	draw_text_ext_transformed(_text_title_pos_x, _text_title_pos_y, _track_details.track_name, -1, _text_split_width, _text_scale_title, _text_scale_title, 0);
	draw_set_colour(_colour_text_author);
	draw_text_ext_transformed(_text_author_pos_x, _text_author_pos_y, _track_details.track_author, -1, _text_split_width, _text_scale_author, _text_scale_author, 0);
	draw_set_colour(c_white);
	draw_sprite_stretched(_track_sprite, 0, _sprite_pos_x, _sprite_pos_y, track_entry_button_width, track_entry_button_height);
	return [_x1, _y1, _x2, _y2];
}
function draw_track_entry_all()	{
	var _track_count_total = array_length(global.tracks_array_all);
	var _track_entry_offset_y = 0;
	for (var _track_entry_index = 0; _track_entry_index < _track_count_total; _track_entry_index ++)	{
		var _track_details_current = global.tracks_array_all[_track_entry_index];
		var _track_is_selected = (_track_entry_index == track_entry_selected);
		var _offset_x = 0.0;
		
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

track_entry_border = 8;
track_entry_button_width = 256;
track_entry_button_height = 256;
track_entry_width = (room_width - (track_entry_border * 2));
track_entry_height = (track_entry_button_height + track_entry_border);
track_entry_height_border = (track_entry_height + track_entry_border);
track_entry_pos_x = (track_entry_border / 2);
track_entry_pos_y = (track_entry_border / 2);

track_entry_selected = undefined;

menu_scroll_position = 0.0;
camera_pos_y = 0;
camera_tween_type = EaseInOutSine;
camera_tween_duration = 0.25;
camera_tween_instance = undefined;