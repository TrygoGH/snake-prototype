extends Node2D
class_name Snake

var head_pos := Vector2i(8, 8)
var previous_head_pos := head_pos
var head_dir := Vector2i.ZERO
var length := 1
var positions: Array[Vector2i] = [head_pos]

enum directions {
	RIGHT,
	LEFT,
	UP,
	DOWN,
}

const direction_vectors := {
	"RIGHT": Vector2i(1,0),
	"LEFT": Vector2i(-1,0),
	"UP": Vector2i(0,-1),
	"DOWN": Vector2i(0,1),
}

var last_dir: directions = directions.UP
var last_key

## Initialization placeholder if needed.
func _setup():
	pass
	
## Sets the snake's head position to the center of the grid at game start.
func _start():
	var grid_size = Systems.grid_manager.grid_size
	head_pos = Vector2i(grid_size.x / 2, grid_size.y / 2)
	
## Per-frame update placeholder; actual movement happens in move_snake().
func _tick(delt):
	pass

## Updates the snake's head position based on the current direction.
func move_head():
	var newDirection = direction_vectors.UP
	match last_dir:
		directions.UP:
			newDirection = direction_vectors.UP
		directions.DOWN:
			newDirection = direction_vectors.DOWN
		directions.LEFT:
			newDirection = direction_vectors.LEFT
		directions.RIGHT:
			newDirection = direction_vectors.RIGHT
	
	previous_head_pos = head_pos
	head_pos += newDirection

## Moves the head first, then moves the body, and updates the positions list accordingly.
func move_snake():
	move_head()
	move_body()
	update_head_position()
	
## Moves each body part forward to follow the one before it.
func move_body():
	var max_index = positions.size() - 1
	for i in max_index:
		positions[max_index - i] = positions[max_index - i - 1]

## Updates the first position in the positions list to the current head position.
func update_head_position():
	positions[0] = head_pos
	
## Draws the snake on the grid by setting the appropriate cell types.
func draw():
	var grid_manager = Systems.grid_manager
	if positions.size() > 1:
		for position in positions:
			grid_manager.set_cell(Cell.Types.BODY, position)
	grid_manager.set_cell(Cell.Types.HEAD, head_pos)

## Adds a new segment to the snake's body at the previous head position.
func add_body_part():
	positions.append(Vector2i(previous_head_pos))
	print("snake pos: ", positions)
	length = positions.size()
	
## Updates snake direction based on arrow key input, avoiding repeated key processing.
func _turn_head_event_handler(event: InputEventKey):
	if event.keycode == KEY_UP and not event.keycode == last_key:
		last_key = event.keycode
		last_dir = directions.UP
	elif event.keycode == KEY_DOWN and not event.keycode == last_key:
		last_key = event.keycode
		last_dir = directions.DOWN
	elif event.keycode == KEY_LEFT and not event.keycode == last_key:
		last_key = event.keycode
		last_dir = directions.LEFT
	elif event.keycode == KEY_RIGHT and not event.keycode == last_key:
		last_key = event.keycode
		last_dir = directions.RIGHT
		
	print("Last arrow key pressed:", last_dir)

## Captures unhandled input events and passes key events to direction handler.
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		_turn_head_event_handler(event)
