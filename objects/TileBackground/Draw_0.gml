/// @description Draw to Surface

surface_check();
surface_set_target(surface);
draw_background_normal();
surface_reset_target();

draw_surface_center_ext(surface, room_width / 2, room_height / 2, 1, 1, 0, c_white, 0.6);