extends Node
class_name GridManager

@export var grid_size: Vector2i = Vector2i(16, 16)
@export var cell_size: Vector2i = Vector2i(16, 16)

var grid: Grid
var oldGrid

signal request_positions
signal initialized

func _ready() -> void:
	grid = Grid.new()

func _setup():
	grid.init(grid_size)
	grid.set_cell_type(Cell.Types.HEAD, Vector2i(floor(grid_size.x / 2), floor(grid.size.y / 2 ) ))
	print("Grid initialized.")
	print("Initial cell type at (0,0):", grid.get_cell(Vector2i(8, 8)).type)
	set_cell(Cell.Types.APPLE, Vector2i(0, 0))
# High-level setter
func set_cell(cell_type: Cell.Types, position: Vector2i) -> void:
	if not grid.is_in_bounds(position):
		push_warning("Attempted to place cell out of bounds at %s" % position)
		return

func get_cell(position: Vector2i) -> Cell:
	var cell = grid.get_cell(position)
	print(cell)
	return cell
	
