extends Node
class_name SystemsManager
@export var systems: Array[Node]

func _ready() -> void:
	init()
	
func clear_systems():
	Systems.clear()

func add_systems_from_list(systems: Array[Node]):
	for node in systems:
		Systems.add_system(node)

func init():
	add_systems_from_list(systems)
