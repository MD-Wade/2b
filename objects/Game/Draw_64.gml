shader_set(shdBktGlitch);
bktglitch_config_preset(BktGlitchPreset.D);
bktglitch_set_jumble_resolution(0.2);
bktglitch_set_jumble_speed(0.1);
bktglitch_set_intensity(0.2);
draw_surface_ext(application_surface, 0, 0, 1 / gui_scale_ratio_x, 1 / gui_scale_ratio_y, 0, c_white, 1);
shader_reset();