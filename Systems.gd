extends Node

var grid_manager: GridManager
var game_manager: GameManager
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
	grid_manager = get_system_of_type(GridManager)
	game_manager = get_system_of_type(GameManager)
	
func get_system_of_type(target_type: Object):
	for system in _systems.values():
		if system.get_script() == target_type:
				return system
	return null
