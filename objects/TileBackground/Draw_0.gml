/// @description Draw to Surface

surface_check();
surface_set_target(surface);
draw_background_normal();
surface_reset_target();

draw_surface_center_ext(surface, room_width / 2, room_height / 2, 1, 1, 0, c_white, 0.6);

gpu_set_blendmode(bm_add);
shader_set(shdGrayscale);
draw_sprite_stretched(album_sprite, 0, album_offset_x, album_offset_y, album_scaled_width, album_scaled_height);
gpu_set_blendmode(bm_normal);
shader_reset();