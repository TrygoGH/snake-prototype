extends Node
class_name GameManager

signal snake_ate_food
signal game_over
signal start

@export var snake: Snake
var snake_pos: Vector2i
var food_pos: Vector2i
var is_game_over := false

func _setup():
	Engine.time_scale = 0

func _start():
	_spawn_food()
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
			Engine.time_scale = 1
			start.emit()

func _tick(float):
	snake._move_head()
	print(snake.head_pos, food_pos)
	if snake.head_pos == food_pos:
		snake_ate_food.emit()
		_spawn_food()
	if _check_snake_oob():
		is_game_over = true
		Engine.time_scale = 0
		get_tree().paused = true
		game_over.emit()
		
	
func _spawn_food():
	var grid_size = Systems.grid_manager.grid_size
	var rng = RandomNumberGenerator.new()
	var x = rng.randi_range(1, grid_size.x)
	var y = rng.randi_range(1, grid_size.y)
	var new_pos = Vector2i(x,y) - Vector2i(1, 1)
	Systems.grid_manager.set_cell(Cell.Types.APPLE, new_pos)
	
	food_pos = new_pos
	
func _check_snake_oob():
	var position = Vector2i(snake.head_pos)
	var max_grid_postions = Vector2i(Systems.grid_manager.grid_size) - Vector2i(1, 1)
	if position.x < 0 or position.y < 0:
		return true 
	if position.x > max_grid_postions.x or position.y > max_grid_postions.y:
		return true 
	return false
