/// @description Initialize

function surface_check()	{
	if !surface_exists(surface)	{
		surface = surface_create(camera_width, camera_height);
		surface_set_target(surface);
		draw_clear_alpha(c_black, 0);
		surface_reset_target();
	}
}
function draw_sprite_tiled_progressive(_sprite_index, _image_index, _offset_x = 0, _offset_y = 0, _image_xscale = 1, _image_yscale = 1, _image_blend = c_white, _image_alpha = 1.0, _progression_step = 1) {
    var _scaled_sprite_width = sprite_get_width(_sprite_index) * _image_xscale;
    var _scaled_sprite_height = sprite_get_height(_sprite_index) * _image_yscale;

    var _horizontal_sprites = ceil(camera_width / _scaled_sprite_width) + 1;
    var _vertical_sprites = ceil(camera_height / _scaled_sprite_height) + 1;

    var _current_image_index = _image_index;
    var _count = 0;

    for (var _y = 0; _y < _vertical_sprites; _y++) {
        for (var _x = 0; _x < _horizontal_sprites; _x++) {
            var _draw_x = (_x * _scaled_sprite_width + _offset_x);
            var _draw_y = (_y * _scaled_sprite_height + _offset_y);
            draw_sprite_ext(_sprite_index, _current_image_index, _draw_x, _draw_y, _image_xscale, _image_yscale, 0, _image_blend, _image_alpha);
            _count++;
            if (_count >= _progression_step) {
                _current_image_index++;
                _count = 0;
            }
        }
    }
}
function draw_background_normal() {
    var _image_blend = merge_colour(c_black, c_maroon, wave(0.2, 1, 16, 0));
    draw_sprite_tiled_progressive(sprite_index, image_index, 0, 0, 1, 1, _image_blend, 1.0, 1);
    
    var _album_sprite = global.track_details_current.dynamic_sprite;
    var _sprite_width = sprite_get_width(_album_sprite);
    var _sprite_height = sprite_get_height(_album_sprite);
    var _room_aspect_ratio = room_width / room_height;
    var _sprite_aspect_ratio = _sprite_width / _sprite_height;
    var _scale_x, _scale_y;

    if (_sprite_aspect_ratio > _room_aspect_ratio) {
        _scale_x = room_width / _sprite_width;
        _scale_y = _scale_x;
    } else {
        _scale_y = room_height / _sprite_height;
        _scale_x = _scale_y;
    }

    var _scaled_width = _sprite_width * _scale_x;
    var _scaled_height = _sprite_height * _scale_y;
    var _offset_x = (room_width - _scaled_width) / 2;
    var _offset_y = (room_height - _scaled_height) / 2;

    gpu_set_blendmode(bm_add);
    shader_set(shdGrayscale);
    //draw_sprite_stretched(_album_sprite, 0, _offset_x, _offset_y, _scaled_width, _scaled_height);
	draw_sprite_stretched(_album_sprite, 0, 0, 0, room_width, room_height);
    gpu_set_blendmode(bm_normal);
    shader_reset();
}


camera = camera_get_default();
camera_width = camera_get_view_width(camera);
camera_height = camera_get_view_height(camera);
surface = -1;

image_speed = 0;
image_index = 0;
sprite_speed = 1 / 20;