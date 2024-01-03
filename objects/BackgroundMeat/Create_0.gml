/// @description Initialize

RoomWidth = room_width;
RoomHeight = room_height;

surfaceIndex = -1;
surfaceBuffer = buffer_create(RoomWidth * RoomHeight * 4, buffer_grow, 1);
surfaceBufferRendered = false;
uniTime = shader_get_uniform(shdEarthboundBoth, "time");
backgroundVisible = true;