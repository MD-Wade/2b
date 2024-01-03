/// @description Draw Surface

if !surface_exists(surfaceIndex)	{
	if surfaceBufferRendered	{
		surfaceIndex = surface_create(RoomWidth, RoomHeight);
		buffer_set_surface(surfaceBuffer, surfaceIndex, 0);
	}	else	{
		surfaceIndex = surface_create(RoomWidth, RoomHeight);
		var _spriteWidth = sprite_get_width(sprite_index);
		var _spriteHeight = sprite_get_height(sprite_index);
		surface_set_target(surfaceIndex);
		draw_clear_alpha(c_black, 0);
		for (var xx = 0; xx < RoomWidth; xx ++)	{
			for (var yy = 0; yy < RoomHeight; yy ++)	{
				draw_sprite(sprite_index, 0, xx * _spriteWidth, yy * _spriteHeight);
			}
		}
		surface_reset_target();
		buffer_get_surface(surfaceBuffer, surfaceIndex, 0);
		surfaceBufferRendered = true;
	}
}

if backgroundVisible	{
	var _offsetDirection = wave(-180, 180, 24, 0);
	var _offsetX = lengthdir_x(RoomWidth * 0.1, _offsetDirection);
	var _offsetY = lengthdir_y(RoomHeight * 0.1, _offsetDirection);
	shader_set(shdEarthboundBoth);
	shader_set_uniform_f(uniTime, current_time);
	draw_surface_ext(surfaceIndex, 0, 0, 1, 1, 0, c_white, Cutscene.image_alpha * 0.2);
	draw_surface_ext(surfaceIndex, (RoomWidth * -1) + _offsetX, (RoomHeight * -1) + _offsetY, 2, 2, 0, c_white, Cutscene.image_alpha * 0.1);
	shader_reset();
}