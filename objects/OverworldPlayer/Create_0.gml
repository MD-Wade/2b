enum E_OVERWORLD_PLAYER_STATES	{
	BASE, MOVING
}
function node_set(_node_instance_id)	{
	node_current = _node_instance_id;
	node_current_information = node_current.node_info;
	
	x = _node_instance_id.x;
	y = _node_instance_id.y;
}
function execute_movement(_target_node)	{
	move_pos_begin_x = node_current.x;
	move_pos_begin_y = node_current.y;
	move_pos_end_x = _target_node.x;
	move_pos_end_y = _target_node.y;
	move_end_node = _target_node;
	
	state_current = E_OVERWORLD_PLAYER_STATES.MOVING;
}
function step_input()	{
	input_up = keyboard_check_pressed(vk_up);
	input_left = keyboard_check_pressed(vk_left);
	input_down = keyboard_check_pressed(vk_down);
	input_right = keyboard_check_pressed(vk_right);
}

function step_movement_check() {
    if (input_up and not is_undefined(node_current_information.node_up)) {
        execute_movement(node_current_information.node_up);
    } else if (input_left and not is_undefined(node_current_information.node_left)) {
        execute_movement(node_current_information.node_left);
    } else if (input_down and not is_undefined(node_current_information.node_down)) {
        execute_movement(node_current_information.node_down);
    } else if (input_right and not is_undefined(node_current_information.node_right)) {
        execute_movement(node_current_information.node_right);
    }
}
function step_movement_moving()	{
	move_tick_current = approach(move_tick_current, move_duration, global.delta_current);
	move_tick_interp = (move_tick_current / move_duration);
	
	x = lerp(move_pos_begin_x, move_pos_end_x, move_tick_interp);
	y = lerp(move_pos_begin_y, move_pos_end_y, move_tick_interp);
	
	if (move_tick_current >= move_duration)	{
		move_tick_current = 0;
		state_current = E_OVERWORLD_PLAYER_STATES.BASE;
		node_set(move_end_node);
	}
}

state_current = E_OVERWORLD_PLAYER_STATES.BASE;
node_current = undefined;
node_current_information = undefined;

input_up = false;
input_left = false;
input_down = false;
input_right = false;
move_duration = 0.2;
move_tick_current = 0;
move_tick_interp = 0;
move_pos_begin_x = x;
move_pos_begin_y = y;
move_pos_end_x = x;
move_pos_end_y = y;
move_end_node = undefined;
tween_value = 0;