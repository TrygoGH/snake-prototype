extends Node

signal increase_speed

@export var timer: Timer

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func _setup():
	timer.start()
	
func _increase_difficulty():
	if(timer.wait_time > 1):
		timer.wait_time -= 1
	increase_speed.emit()

func _on_timer_timeout():
	_increase_difficulty()
