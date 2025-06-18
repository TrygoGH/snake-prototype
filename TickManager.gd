## Manages the game's tick timing, controlling how often game logic updates occur.
## Converts frame delta time into discrete ticks based on a target ticks per second (_tps).
extends Node
class_name TickManager

@export var _tps: int = 1  ## Target ticks per second
@onready var tick_rate := 1.0 / _tps  ## Duration of each tick in seconds
var _max_tps := 60  ## Maximum allowed ticks per second
var _currentTick := 0.0  ## Accumulator for fractional ticks
var currentTick := 0  ## Integer count of ticks elapsed
var oldTick := -1  ## Previous tick count for calculating tick deltas

## Initialize tick_rate based on _tps
func _ready():
	tick_rate = 1.0 / _tps

## Update tick counters based on elapsed frame time
func update_tick(delta):
	oldTick = currentTick
	_currentTick += (delta / tick_rate)
	currentTick = floor(_currentTick)  ## Convert accumulated fractional ticks to integer ticks

## Debug output of current tick rate
func _setup():
	print(tick_rate)
	print("tick_rate")

## Increase ticks per second, capped at _max_tps, and update tick_rate accordingly
func _on_difficulty_manager_increase_speed() -> void:
	print("increasing speed to: ", _tps + 1)
	if _tps < _max_tps:
		_tps += 1
	tick_rate = _calculate_tick_rate(_tps)
	
## Compute duration of a single tick given ticks per second
func _calculate_tick_rate(tps):
	return 1.0 / tps
	
## Returns the number of whole ticks elapsed since last check
func calculate_ticks() -> int:
	return currentTick - oldTick
