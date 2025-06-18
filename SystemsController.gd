## Manages initialization and clearing of multiple system nodes.
## Provides methods to add a list of systems to the global Systems registry,
## clear all systems, and initialize systems on ready.
extends Node
class_name SystemsManager

@export var systems: Array[Node]

func _ready() -> void:
	init()

## Clears all systems registered in the global Systems autoload.
func clear_systems():
	Systems.clear()

## Adds each system node from the given list to the global Systems autoload.
func add_systems_from_list(systems: Array[Node]):
	for node in systems:
		Systems.add_system(node)

## Initializes the systems by adding all exported systems to the global Systems autoload.
func init():
	add_systems_from_list(systems)
