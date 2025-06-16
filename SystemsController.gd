extends Node2D

@export var systems: Array[Node]

func _ready() -> void:
	for node in systems:
		Systems.add_system(node)
	Systems.init()
