function draw_circle_width(_x, _y, _radius, _thickness, _segments)	{
	var _increment_value = 360 / _segments;
	draw_primitive_begin(pr_trianglestrip);
	for (var _increment = 0; _increment <= 360; _increment += _increment_value)	{
	    draw_vertex(_x + lengthdir_x(_radius, _increment), _y + lengthdir_y(_radius, _increment));
		draw_vertex(_x + lengthdir_x(_radius + _thickness, _increment),  _y + lengthdir_y(_radius + _thickness, _increment));
	}
	draw_primitive_end();
}
function draw_surface_center_ext(surface, cx, cy, xscale, yscale, rot, color, alpha)	{
    var mx = surface_get_width(surface) / 2;
    var my = surface_get_height(surface) / 2;
    var mat = matrix_get(matrix_world);
    matrix_stack_push(matrix_build(cx, cy, 0, 0, 0, rot, 1, 1, 1));
    matrix_stack_push(matrix_build(0, 0, 0, 0, 0, 0, xscale, yscale, 1));
    matrix_set(matrix_world, matrix_stack_top());
    draw_surface_ext(surface, -mx, -my, 1, 1, 0, color, alpha);
    matrix_stack_pop();
    matrix_stack_pop();
    matrix_set(matrix_world, mat);
}

function draw_rectangle_width(_x1, _y1, _x2, _y2, _width) {
    draw_line_width(_x1 - (_width / 2), _y1, _x2 + (_width / 2), _y1, _width);
    draw_line_width(_x2, _y1, _x2, _y2, _width);
    draw_line_width(_x2 + (_width / 2), _y2, _x1 - (_width / 2), _y2, _width);
    draw_line_width(_x1, _y2, _x1, _y1, _width);
}
