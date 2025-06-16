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

func _ready():
	print("trying")
	_cache_all_nodes(get_tree().current_scene)
	var currentNodes = _all_nodes.duplicate()
	for node in currentNodes:
		_add_node_lifecycles(node)
	_start_lifecycle_methods.call_deferred()

func _start_lifecycle_methods():
	_call_setup()
	_call_start()

func call_tick(delta):
	_call_tick(delta)

func _call_setup():
	print(_lifecycle_nodes.setup)
	for node in _lifecycle_nodes.setup:
		node = node as Node
		node._setup()

func _call_start():
	for node in _lifecycle_nodes.start:
		node = node as Node
		node._start()
		
func _call_tick(delta):
	for node in _lifecycle_nodes.tick:
		if not is_instance_valid(node):
			continue
		node = node as Node
		node._tick(delta)

func _cache_all_nodes(node: Node):
	if not is_instance_valid(node):
		return
	_all_nodes.append(node)
	for child in node.get_children():
		_cache_all_nodes(child)
		
func _has_lifecycle_method(node: Node, method: String):
	if not is_instance_valid(node):
		return false
	if not _lifecycle_methods.values().has(method):
		return false
	if not node.has_method(method):
		return false
		
	print(method)
	return true
	
func _add_node_lifecycles(node: Node):
	_add_setup_lifecycle(node)
	_add_start_lifecycle(node)
	_add_tick_lifecycle(node)
	
func _add_setup_lifecycle(node: Node) -> bool:
	if not _has_lifecycle_method(node, _lifecycle_methods.setup):
		return false
	var nodes = _lifecycle_nodes.setup as Array[Node]
	nodes.append(node)
	return true
		
func _add_start_lifecycle(node: Node) -> bool:
	if not _has_lifecycle_method(node, _lifecycle_methods.start):
		return false
	var nodes = _lifecycle_nodes.start as Array[Node]
	nodes.append(node)
	return true

func _check_node_function_has_parameter(node, methodName, argName) -> bool:
	for methodDict in node.get_method_list():
		if methodDict.name == methodName:
			var args = methodDict.args as Array[Dictionary]
			if args.size() == 1:
				print(args[0].name)
				if args[0].name == argName:
					return true
					
	return false

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
