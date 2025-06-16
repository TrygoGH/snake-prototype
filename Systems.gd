extends Node

var grid_manager: GridManager
var _systems: Dictionary[String, Node]

func init():
	_check_set_globals()
	
func add_system(node: Node):
	if not is_instance_valid(node):
		return
	_systems.set(node.name, node)

func get_system(systemName: String):
	return _systems.get(systemName)
	
func _check_set_globals():
	grid_manager = get_system("GridManager")
