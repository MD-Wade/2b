function NodeInformation(_node_name, _instance_id) constructor	{
	node_name = _node_name;
	node_instance = _instance_id;
	node_name_up = undefined;
	node_name_left = undefined;
	node_name_down = undefined;
	node_name_right = undefined;
	node_up = undefined;
	node_left = undefined;
	node_down = undefined;
	node_right = undefined;
	
	function set_node_start(_node_instance_id)	{
		global.overworld_node_start = _node_instance_id;
	}
	function set_node_name_up(_node_name_up)	{
		self.node_name_up = _node_name_up;
	}
	function set_node_name_left(_node_name_left)	{
		self.node_name_left = _node_name_left;
	}
	function set_node_name_down(_node_name_down)	{
		self.node_name_down = _node_name_down;
	}
	function set_node_name_right(_node_name_left)	{
		self.node_name_right = _node_name_left;
	}
	function set_node_up(_node_up)	{
		self.node_up = _node_up;
	}
	function set_node_left(_node_left)	{
		self.node_left = _node_left;
	}
	function set_node_down(_node_down)	{
		self.node_down = _node_down;
	}
	function set_node_right(_node_right)	{
		self.node_right = _node_right;
	}

	function add_node()	{
		var _instance_id = self.node_instance;
		with (Game)	{
			array_push(overworld_node_array, _instance_id);
		}
	}
	
	add_node();
}