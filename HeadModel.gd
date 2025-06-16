extends Node2D

func tick(delta):
	position += Vector2(10, 0);


func _on_tick(delta) -> void:
	tick(delta)

func _process(delta):
	pass
