## Autoload singleton that acts as the central registry and manager for all game systems.
## This script is globally accessible throughout the project and provides a reliable way
## to access systems instead of storing direct references, which may become invalid
## when scenes are replaced or systems are removed.
##
## Holds references to key system nodes like GridManager, GameManager, etc.,
## provides methods to add, retrieve, and clear systems,
## and updates global references for convenient access.
extends Node

var grid_manager: GridManager
var game_manager: GameManager
var tick_manager: TickManager
var lifecycle_manager: LifeCycleManager
var systems_manager: SystemsManager
var scene_manager: SceneManager
var game_data: GameData

var _systems: Dictionary[String, Node]

func init():
	pass
	
## Adds a system node to the internal dictionary keyed by its name,
## and updates global system references.
func add_system(node: Node):
	print(node)
	if not is_instance_valid(node):
		return
	_systems.set(node.name, node)
	_check_set_globals()

## Retrieves a system node by its string name.
func get_system(systemName: String):
	return _systems.get(systemName)
	
## Updates global references by finding system nodes by their script type.
func _check_set_globals():
	grid_manager = get_system_of_type(GridManager)
	game_manager = get_system_of_type(GameManager)
	tick_manager = get_system_of_type(TickManager)
	lifecycle_manager = get_system_of_type(LifeCycleManager)
	scene_manager = get_system_of_type(SceneManager)
	systems_manager = get_system_of_type(SystemsManager)
	game_data = get_system_of_type(GameData)
	
## Returns the first system node whose script matches the requested type.
func get_system_of_type(target_type: Object):
	for system in _systems.values():
		if system.get_script() == target_type:
			return system
	return null

## Clears all registered systems and updates globals accordingly.
func clear():
	_systems.clear()
	_check_set_globals()
