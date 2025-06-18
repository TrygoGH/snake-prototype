extends Resource
class_name Grid

var size: Vector2i
var vectors: Array[CellVector] = []
var cell_positions: Dictionary[Cell, Vector2i]

## Initializes the Grid with an empty cell vector list
func _init() -> void:
	vectors = []

## Builds the grid structure with the specified size and maps each cell to its position
func init(p_size: Vector2i):
	size = p_size
	vectors.clear()
	for y in range(size.y):
		var cellVector = CellVector.new(size.x)
		var index = 0
		for cell in cellVector.cells:
			print(Vector2i(index, y))
			cell_positions.set(cell, Vector2i(index, y))
			index += 1
		vectors.append(cellVector)

## Returns the Cell at the given position if in bounds; null otherwise
func get_cell(pos: Vector2i) -> Cell:
	if not is_in_bounds(pos):
		return null
	return vectors[pos.y].get_cell(pos.x)

## Retrieves the grid position of a specific Cell instance
func get_cell_position(targetCell: Cell) -> Vector2i:
	return cell_positions.get(targetCell)

## Sets the type of the Cell at the given position; returns false if out of bounds
func set_cell_type(type: Cell.Types, pos: Vector2i) -> bool:
	if not is_in_bounds(pos):
		return false
	vectors[pos.y].set_cell_type(type, pos.x)
	return true

## Checks whether a given position is within the grid bounds
func is_in_bounds(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < size.x and pos.y >= 0 and pos.y < size.y

## Clears all cells in the grid, setting them to the specified type (default is EMPTY)
func clear(value: Cell.Types = Cell.Types.EMPTY) -> void:
	for vector in vectors:
		for i in range(vector.length):
			vector.get_cell(i).set_type(value)
