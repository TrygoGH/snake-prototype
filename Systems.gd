extends Node

var grid_manager: GridManager
var game_manager: GameManager
var tick_manager: TickManager
var lifecycle_manager: LifeCycleManager
var systems_manager: SystemsManager

var _systems: Dictionary[String, Node]

func init():
	pass
	
func add_system(node: Node):
	print(node)
	if not is_instance_valid(node):
		return
	_systems.set(node.name, node)
	_check_set_globals()

func get_system(systemName: String):
	return _systems.get(systemName)
	
func _check_set_globals():
	grid_manager = get_system_of_type(GridManager)
	game_manager = get_system_of_type(GameManager)
	tick_manager = get_system_of_type(TickManager)
	lifecycle_manager = get_system_of_type(LifeCycleManager)
	
func get_system_of_type(target_type: Object):
	for system in _systems.values():
		if system.get_script() == target_type:
				return system
	return null

func clear():
	_systems.clear()
	_check_set_globals()
