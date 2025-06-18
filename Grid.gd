extends Resource
class_name Grid

var size: Vector2i
var vectors: Array[CellVector] = []
var cell_positions: Dictionary[Cell, Vector2i]

func _init() -> void:
	vectors = []

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

func get_cell(pos: Vector2i) -> Cell:
	if not is_in_bounds(pos):
		return null
	return vectors[pos.y].get_cell(pos.x)

func get_cell_position(targetCell: Cell) -> Vector2i:
	return cell_positions.get(targetCell)
				
func set_cell_type(type: Cell.Types, pos: Vector2i) -> bool:
	if not is_in_bounds(pos):
		return false
	vectors[pos.y].set_cell_type(type, pos.x)
	return true

func is_in_bounds(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < size.x and pos.y >= 0 and pos.y < size.y

func clear(value: Cell.Types = Cell.Types.EMPTY) -> void:
	for vector in vectors:
		for i in range(vector.length):
			vector.get_cell(i).set_type(value)
