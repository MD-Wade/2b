var _draw_scale_x = display_get_gui_width() / surface_get_width(application_surface);
var _draw_scale_y = display_get_gui_height() / surface_get_height(application_surface);

if keyboard_check(vk_space)	{
	draw_surface_ext(application_surface, 0, 0, _draw_scale_x, _draw_scale_y, 0, c_white, 1);
}
else	{
	
	shader_set(shdBktGlitch);
	bktglitch_config_preset(BktGlitchPreset.D);
	bktglitch_set_jumble_resolution(0.2);
	bktglitch_set_jumble_speed(0.1);
	bktglitch_set_intensity(0.2);
	draw_surface_ext(application_surface, 0, 0, _draw_scale_x, _draw_scale_y, 0, c_white, 1);
	shader_reset();
}