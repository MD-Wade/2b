/// @description Destroy Buffer and Surface

if surface_exists(surfaceIndex)	{
	surface_free(surfaceIndex);
}

buffer_delete(surfaceBuffer);