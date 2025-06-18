## Manages the lifecycle of nodes by calling their _setup, _start, and _tick methods at appropriate times.
## Scans all nodes in the current scene and organizes them based on which lifecycle methods they implement.
##
## NOTE: Currently, this manager does NOT support automatically adding new nodes to the lifecycle system
## after initialization. Adding support for dynamic node registration should be implemented in the future.
extends Node
class_name LifeCycleManager

const _lifecycle_methods: Dictionary[String, String] = {
	"setup": "_setup",
	"start": "_start",
	"tick": "_tick",
}

var _lifecycle_nodes: Dictionary[String, Array] = {
	"setup": [],
	"start": [],
	"tick": [],
}

var _all_nodes: Array[Node]

## Called when the node is ready: caches all nodes in the current scene,
## sorts them into lifecycle categories, and then defers calling setup and start methods.
func _ready():
	print("trying")
	_cache_all_nodes(get_tree().current_scene)
	var currentNodes = _all_nodes.duplicate()
	for node in currentNodes:
		_add_node_lifecycles(node)
	_start_lifecycle_methods.call_deferred()

## Called each physics frame: updates tick timing and calls _tick methods as needed.
func _physics_process(delta: float) -> void:
	var tick_manager = Systems.tick_manager
	tick_manager.update_tick(delta)
	var ticks = tick_manager.calculate_ticks()
	for i in ticks:
		_call_tick(delta)
		
## Calls all _setup methods, then all _start methods on registered nodes.
func _start_lifecycle_methods():
	_call_setup()
	_call_start()

func call_tick(delta):
	_call_tick(delta)

## Calls _setup on all nodes registered for setup lifecycle.
func _call_setup():
	print(_lifecycle_nodes.setup)
	for node in _lifecycle_nodes.setup:
		node = node as Node
		node._setup()

## Calls _start on all nodes registered for start lifecycle.
func _call_start():
	for node in _lifecycle_nodes.start:
		node = node as Node
		node._start()
		
## Calls _tick(delta) on all nodes registered for tick lifecycle, skipping invalid instances.
func _call_tick(delta):
	for node in _lifecycle_nodes.tick:
		if not is_instance_valid(node):
			continue
		node = node as Node
		node._tick(delta)

## Recursively caches all nodes under the given node into _all_nodes array.
func _cache_all_nodes(node: Node):
	if not is_instance_valid(node):
		return
	_all_nodes.append(node)
	for child in node.get_children():
		_cache_all_nodes(child)
		
## Checks if the node has the given lifecycle method implemented and is valid.
func _has_lifecycle_method(node: Node, method: String):
	if not is_instance_valid(node):
		return false
	if not _lifecycle_methods.values().has(method):
		return false
	if not node.has_method(method):
		return false
		
	print(method)
	return true
	
## Adds the node to all lifecycle categories it implements.
func _add_node_lifecycles(node: Node):
	_add_setup_lifecycle(node)
	_add_start_lifecycle(node)
	_add_tick_lifecycle(node)
	
## Adds node to the setup lifecycle list if it implements _setup.
func _add_setup_lifecycle(node: Node) -> bool:
	if not _has_lifecycle_method(node, _lifecycle_methods.setup):
		return false
	var nodes = _lifecycle_nodes.setup as Array[Node]
	nodes.append(node)
	return true
		
## Adds node to the start lifecycle list if it implements _start.
func _add_start_lifecycle(node: Node) -> bool:
	if not _has_lifecycle_method(node, _lifecycle_methods.start):
		return false
	var nodes = _lifecycle_nodes.start as Array[Node]
	nodes.append(node)
	return true

## Checks if a method on a node has a parameter with a specific name (not currently used).
func _check_node_function_has_parameter(node, methodName, argName) -> bool:
	for methodDict in node.get_method_list():
		if methodDict.name == methodName:
			var args = methodDict.args as Array[Dictionary]
			if args.size() == 1:
				print(args[0].name)
				if args[0].name == argName:
					return true
					
	return false

## Adds node to the tick lifecycle list if it implements _tick with exactly one argument.
func _add_tick_lifecycle(node: Node) -> bool:
	if not _has_lifecycle_method(node, _lifecycle_methods.tick):
		return false
	var isValidArgs = node._tick.get_argument_count() == 1
	#var isValidArgs = _check_node_function_has_parameter(node, _lifecycle_methods.tick, "delta")
	if not isValidArgs:
		return false
	var nodes = _lifecycle_nodes.tick as Array[Node]
	nodes.append(node)
	return true
