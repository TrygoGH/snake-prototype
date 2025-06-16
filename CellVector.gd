extends Resource
class_name CellVector

var length: int
var cells: Array[Cell] = []

func _init(p_length: int) -> void:
	length = p_length
	cells = []
	for i in range(length):
		cells.append(Cell.new())

func get_cell(index: int) -> Cell:
	if index < 0 or index >= length:
		return null
	return cells[index]

func set_cell_type(type: Cell.Types, index: int) -> bool:
	if index < 0 or index >= length:
		return false
	cells[index].set_type(type)
	return true

func _to_string() -> String:
	var cell_strings := []
	for cell in cells:
		cell_strings.append(Cell.Types.keys()[cell.get_type()])
	return "[%s]" % String(", ").join(cell_strings)
