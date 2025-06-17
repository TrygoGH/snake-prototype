extends Node

signal increase_speed

@export var timer: Timer

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func _setup():
	timer.start()
	
func _start():
	Systems.game_manager.snake_ate_food.connect(
		func(): 
			_increase_difficulty()
	)
	
func _increase_difficulty():
	increase_speed.emit()

func _on_timer_timeout():
	pass
