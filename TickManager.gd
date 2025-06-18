extends Node
class_name TickManager

signal tick
signal initialized

@export var _tps: int = 1
@onready var tick_rate := 1.0 / _tps
var _max_tps := 60
var _currentTick := 0.0
var currentTick := 0
var oldTick := -1
var test = 0

func _ready():
	tick_rate = 1.0 / _tps
	pass
	
func update_tick(delta):
	oldTick = currentTick
	_currentTick += (delta/tick_rate)
	currentTick = floor(_currentTick)
	
func _setup():
	print(tick_rate)
	print("tick_rate")

func _on_difficulty_manager_increase_speed() -> void:
	print("increasing speed to: ", _tps + 1)
	if(_tps < _max_tps):
		_tps += 1
	tick_rate = _calculate_tick_rate(_tps)
	
func _calculate_tick_rate(tps):
	return 1.0 / tps
	
func calculate_ticks() -> int:
	return currentTick - oldTick
