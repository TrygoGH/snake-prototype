## Manages difficulty progression over time by emitting an increase_speed signal.
## Uses a Timer to periodically trigger difficulty checks and connects to snake events
## to increase difficulty dynamically.
extends Node

signal increase_speed

@export var timer: Timer

## Connect the timer's timeout signal to the handler.
func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

## Start the timer when the lifecycle setup is called.
func _setup():
	timer.start()
	
## Connect to the snake_ate_food signal on game start to increase difficulty on eating food.
func _start():
	Systems.game_manager.snake_ate_food.connect(
		func(): 
			_increase_difficulty()
	)
	
## Emit increase_speed signal to notify listeners that difficulty should increase.
func _increase_difficulty():
	increase_speed.emit()

## Handler for timer timeout (currently empty).
func _on_timer_timeout():
	pass
