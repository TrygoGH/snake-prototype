extends Node
class_name GameManager

signal snake_ate_food
signal game_over
signal start

@export var snake: Snake
var food_pos: Vector2i
var previous_head_pos: Vector2i
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
	_clear_grid()
	_draw_food()
	snake.move_snake()
	snake.draw()
	if snake.head_pos == food_pos:
		snake_ate_food.emit()
		snake.add_body_part()
		print(snake.positions)
		_spawn_food()
		
	if _check_snake_oob():
		_game_over()
		
	if _check_snake_self_collision():
		_game_over()
		
	print(_check_back_turn())
	if _check_back_turn():
		_game_over()
		
	previous_head_pos = snake.previous_head_pos

func _draw_food():
		Systems.grid_manager.set_cell(Cell.Types.APPLE, food_pos)

func _clear_grid():
	Systems.grid_manager.clear_grid()
	
func _spawn_food():
	var grid_size = Systems.grid_manager.grid_size
	var rng = RandomNumberGenerator.new()
	var x = rng.randi_range(1, grid_size.x)
	var y = rng.randi_range(1, grid_size.y)
	var new_pos = Vector2i(x,y) - Vector2i(1, 1)
	
	food_pos = new_pos
	
func _check_snake_oob():
	var position = Vector2i(snake.head_pos)
	var max_grid_postions = Vector2i(Systems.grid_manager.grid_size) - Vector2i(1, 1)
	if position.x < 0 or position.y < 0:
		return true 
	if position.x > max_grid_postions.x or position.y > max_grid_postions.y:
		return true 
	return false
	
func _game_over():
	is_game_over = true
	Systems.lifecycle_manager.process_mode = Node.PROCESS_MODE_DISABLED
	game_over.emit()
	
func _check_snake_self_collision():
	var body_positions = snake.positions.duplicate()
	body_positions.remove_at(0)
	for position in body_positions:
		print("body position: ", position)
		if position == snake.head_pos:
			return true
	return false
	
func _check_back_turn():
	print("presv", previous_head_pos, snake.head_pos)
	if snake.length <= 1:
		return false
	return snake.head_pos == previous_head_pos

func _input(event):
	if event.is_action_pressed("reload_game"):
		_handle_reload(event)
		
func _handle_reload(event):
	if is_game_over:
		_reload_game()
		
func _reload_game():
	get_tree().reload_current_scene()
