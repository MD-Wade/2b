/*
 * Constants
*/
#macro MIDI_E_BPM "BPM CHANGE"
#macro MIDI_E_COPYRIGHT "COPYRIGHT NOTICE"
#macro MIDI_E_INSTRUMENT "INSTRUMENT CHANGE"
#macro MIDI_E_LYRIC "LYRIC"
#macro MIDI_E_MARKER "MARKER"
#macro MIDI_E_NAME "TRACK NAME"
#macro MIDI_E_TEXT "TEXT EVENT"

/**
 * @function midi_read
 * @description Read midi file
 * @param {String} _file - Midi file to read from
 * @param {Boolean} [_raw=false] - Specify if output should consist of raw events or not
 * @return {Array} Returns an array containing the note list and event list from the MIDI file.
 */
function midi_read(_file, _raw = false) {
    var _err_string = "Failed to read midi file: ";
    var _bin, _size, _hex_data, _action, _note_event_indices, _total_delta_time;

    if (_file != "") {
        _bin = file_bin_open(_file, 0);
        _size = file_bin_size(_bin);
        _hex_data = "";
        while (file_bin_position(_bin) < _size) {
            _hex_data += dec_to_hex(file_bin_read_byte(_bin));
        }
        file_bin_close(_bin);
    } else {
        show_error(_err_string + "nonexistent file", false);
        return 0;
    }

	if (string_copy(_hex_data, 0, 8) != "4D546864") {
		show_error(_err_string + "faulty header", false);
		return 0;
	}

	var _midi_events = [];
	var _midi_notes = [];

	var _action = "";
	var _note_event_indices = [];
	for (var _note_event_index = 0; _note_event_index < 150; _note_event_index ++) {
		_note_event_indices[_note_event_index] = [];
	}

	var _read_offset = 23;
	var _track_quantity = hex_to_dec(string_copy(_hex_data, _read_offset, 2));
	_read_offset += 6;

	while (_track_quantity > 0) {
		_read_offset += 16;
		_total_delta_time = 0;
		_track_quantity--;
	
		while (true) {
			var _byte_index = 2;
			var _delta_time_midi_bytes = [];

			while (true) {
				array_push(_delta_time_midi_bytes, hex_to_bin(string_copy(_hex_data, _read_offset + (_byte_index-2), 2)));
			
				if (string_copy(_delta_time_midi_bytes[array_length(_delta_time_midi_bytes)-1], 0, 1) == "0") {
					var _time_byte_index = 0;
					var _delta_time_binary = "";
					repeat (_byte_index / 2) {
						_delta_time_binary += "0";
					}
					repeat (_byte_index / 2) {
						_delta_time_binary += string_copy(_delta_time_midi_bytes[_time_byte_index], 2, 7);
						_time_byte_index ++;
					}
					_delta_time_midi_bytes = hex_to_dec(bin_to_hex(_delta_time_binary));
					_read_offset += _byte_index;
					break;
				}
				_byte_index += 2;
			}

			var _midi_status = string_copy(_hex_data, _read_offset, 1);
			var _midi_status_file = string_copy(_hex_data, _read_offset, 2);
			_total_delta_time += _delta_time_midi_bytes;
		
			if (_midi_status == "C" or _midi_status == "D" or _midi_status == "8" or _midi_status == "9" or _midi_status == "E" or _midi_status == "B" or _midi_status == "A") {
				_read_offset += 2;
				_action = _midi_status;
			} else if (_midi_status == "F") {
				_read_offset += 2;
				_action = "";
				var substatus = string_copy(_hex_data, _read_offset, 2);
				_read_offset += 2;
				if (substatus == "2F") {
					if (_raw) {
						array_push(_midi_events, [_total_delta_time, _midi_status_file, substatus, "N/A"]);
					} else {
						array_push(_midi_events, [_total_delta_time, "end of track", "N/A"]);
					}
					_read_offset += 2;
					break;
				}
				var l = string_copy(_hex_data, _read_offset, 2);
				_read_offset += 2;
				if (_raw) {
					array_push(_midi_events, [_total_delta_time, _midi_status_file, substatus, string_copy(_hex_data, _read_offset, hex_to_dec(l)*2)]);
				} else {
					if (substatus == "01") {
						array_push(_midi_events, [_total_delta_time, MIDI_E_TEXT, hex_to_text(string_copy(_hex_data, _read_offset, hex_to_dec(l)*2))]);
					}
					if (substatus == "04") {
						array_push(_midi_events, [_total_delta_time, MIDI_E_NAME, hex_to_text(string_copy(_hex_data, _read_offset, hex_to_dec(l)*2))]);
					}
					if (substatus == "05") {
						array_push(_midi_events, [_total_delta_time, MIDI_E_LYRIC, hex_to_text(string_copy(_hex_data, _read_offset, hex_to_dec(l)*2))]);
					}
					if (substatus == "06") {
						array_push(_midi_events, [_total_delta_time, MIDI_E_MARKER, hex_to_text(string_copy(_hex_data, _read_offset, hex_to_dec(l)*2))]);
					}
					if (substatus == "02") {
						array_push(_midi_events, [_total_delta_time, MIDI_E_COPYRIGHT, hex_to_text(string_copy(_hex_data, _read_offset, hex_to_dec(l)*2))]);
					}
					if (substatus == "51") {
						var _time_signature = (60000000 / hex_to_dec(string_copy(_hex_data, _read_offset, 6)));
						array_push(_midi_events, [_total_delta_time, MIDI_E_BPM, _time_signature]);
					}
				}
				_read_offset += hex_to_dec(l)*2;
			}
		
			if (_action == "C") {
				if (_raw) {
					array_push(_midi_events, [_total_delta_time, _midi_status_file, "N/A", string_copy(_hex_data, _read_offset, 2)]);
				} else {
					array_push(_midi_events, [_total_delta_time, MIDI_E_INSTRUMENT, hex_to_dec(string_copy(_hex_data, _read_offset, 2))]);
				}
				_read_offset += 2;
			} if (_action == "D") {
				if (_raw) {
					array_push(_midi_events, [_total_delta_time, _midi_status_file, "N/A", string_copy(_hex_data, _read_offset, 2)]);
				}
				_read_offset += 2;
			} else if (_action == "E" or _action == "A" or _action == "B") {
				if (_raw) {
					array_push(_midi_events, [_total_delta_time, _midi_status_file, string_copy(_hex_data, _read_offset, 2), string_copy(_hex_data, _read_offset+2, 2)]);
				}
				_read_offset += 4;
			} else if (_action == "9") {
				var note = hex_to_dec(string_copy(_hex_data, _read_offset, 2));
				_read_offset += 2;
				var velocity = hex_to_dec(string_copy(_hex_data, _read_offset, 2));
				_read_offset += 2;
				if (velocity > 0) {
					array_push(_midi_notes, [_total_delta_time, note, velocity, 0]);
					array_push(_note_event_indices[note], array_length(_midi_notes)-1);
				} else {
					_action = "8+";
				}
			} 
			if (_action == "8" or _action == "8+") {
				if (_action != "8+") {
					var note = hex_to_dec(string_copy(_hex_data, _read_offset, 2));
					_read_offset += 4;
				} else {
					_action = "9";
				}
                _midi_notes[array_length(_midi_notes) - 1][3] = _total_delta_time;
                array_delete(_note_event_indices[note], array_length(_note_event_indices[note]) - 1, 1);
			}
		}
	}

	return [_midi_notes, _midi_events];
}

/**
 * @function hex_to_dec
 * @description Converts a hexadecimal string to a decimal integer.
 * @param {String} _hex_string - The hexadecimal string to be converted.
 * @return {Number} The decimal representation of the input hexadecimal string.
 */
function hex_to_dec(_hex_string) {
    var _hex_upper = string_upper(_hex_string);
    var _decimal = 0;
    var _hex_chars = "0123456789ABCDEF";
    for (var _position = 1; _position <= string_length(_hex_upper); _position++) {
        _decimal = _decimal << 4 | (string_pos(string_char_at(_hex_upper, _position), _hex_chars) - 1);
    }
    return _decimal;
}

/**
 * @function bin_to_hex
 * @description Converts a binary string to a hexadecimal string.
 * @param {String} _binary_string - The binary string to be converted.
 * @return {String} The hexadecimal representation of the input binary string.
 */
function bin_to_hex(_binary_string) {
    var _hex = "";
    var _bin_padded;
    var _n = "0000101100111101000";
    var _h = "0125B6C937FEDA48";
    var _length = string_length(_binary_string);
    _bin_padded = string_repeat("0", 3 - (_length - 1) % 4) + _binary_string;
    for (var _position = 1; _position <= _length; _position += 4) {
        _hex += string_char_at(_h, string_pos(string_copy(_bin_padded, _position, 4), _n));
    }
    return _hex;
}

/**
 * @function dec_to_hex
 * @description Converts a decimal integer to a hexadecimal string.
 * @param {Number} _decimal - The decimal integer to be converted.
 * @return {String} The hexadecimal representation of the input decimal integer.
 */
function dec_to_hex(_decimal) {
    var _hex, _h, _byte, _high, _low;
    if (_decimal) _hex = "" else _hex = "00";
    _h = "0123456789ABCDEF";
    while (_decimal) {
        _byte = _decimal & 255;
        _high = string_char_at(_h, _byte div 16 + 1);
        _low = string_char_at(_h, _byte mod 16 + 1);
        _hex = _high + _low + _hex;
        _decimal = _decimal >> 8;
    }
    return _hex;
}

/**
 * @function hex_to_bin
 * @description Converts a hexadecimal string to a binary string.
 * @param {String} _hexadecimal - The hexadecimal string to be converted.
 * @return {String} The binary representation of the input hexadecimal string.
 */
function hex_to_bin(_hexadecimal) {
    var _bin = "";
    var _n = "0000101100111101000";
    var _h = "0125B6C937FEDA48";
    var _length = string_length(string_upper(_hexadecimal));
    for (var _position = 1; _position <= _length; _position++) {
        _bin += string_copy(_n, string_pos(string_char_at(string_upper(_hexadecimal), _position), _h), 4);
    }
    return _bin;
}

/**
 * @function hex_to_text
 * @description Converts a hexadecimal string to text.
 * @param {String} _hexadecimal - The hexadecimal string to be converted to text.
 * @return {String} The text representation of the input hexadecimal string.
 */
function hex_to_text(_hexadecimal) {
    var _text = "";
    for (var _i = 1; _i < string_length(_hexadecimal); _i += 2) {
        _text += chr(hex_to_dec(string_copy(_hexadecimal, _i, 2)));
    }
    return _text;
}