/// @description Clean Up

if surface_exists(surface)	{
	surface_free(surface);
	surface = -1;
}