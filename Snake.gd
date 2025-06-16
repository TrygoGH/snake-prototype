extends Node2D

var head_pos := Vector2i(8, 8)
var head_dir := Vector2i.ZERO
enum directions{
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

func _setup():
	pass
	
func _start():
	var grid_size = Systems.grid_manager.grid_size
	head_pos = Vector2i(grid_size.x / 2, grid_size.y / 2)
	
func _tick(delt):
	_move_head()

func _move_head():
	var oldCell: Cell = Systems.grid_manager.get_cell(head_pos)
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
			
	head_pos += newDirection
	var newCell: Cell = Systems.grid_manager.get_cell(head_pos)
	
	if is_instance_valid(oldCell):
		oldCell.set_type(Cell.Types.EMPTY)
	if is_instance_valid(oldCell):
		newCell.set_type(Cell.Types.HEAD)
		
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

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		_turn_head_event_handler(event)
