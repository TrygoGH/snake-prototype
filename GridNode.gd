extends Node2D
class_name GridNode

var grid_size: Vector2i
var type_colors := {
	Cell.Types.EMPTY: Color(0.1, 0.1, 0.1, 0.5),  # dark gray
	Cell.Types.HEAD: Color(0.2, 0.8, 0.2, 1),   # green
	Cell.Types.TAIL: Color(0.1, 0.5, 0.1, 1),   # darker green
	Cell.Types.APPLE: Color(1, 0.2, 0.2, 1),    # red
	Cell.Types.BODY: Color(0.1, 0.5, 0.1, 1),    # red
}
var cellnodes: Array[CellNode]

func get_color_for_type(t: Cell.Types) -> Color:
	return type_colors.get(t, Color(1, 1, 1))  # fallback to white
	
func _ready():
	pass
	
func _create_cell_node(cell: Cell):
	var grid = Systems.grid_manager.grid
	var size = Systems.grid_manager.cell_size
	var position = grid.get_cell_position(cell) * 16
	print(position)
	var cellnode = CellNode.new(cell, size)
	cellnode.position = position
	cellnode.modulate = get_color_for_type(cellnode.cell.type)
	return cellnode
	
func _start():
	grid_size = Systems.grid_manager.grid_size
	_init_cells()
	print("STARTINGG")
	
func _init_cells():
	var grid = Systems.grid_manager.grid
	var position = Vector2i(0,0)
	print(grid.vectors.size(), "vectors")
	for cellVector in grid.vectors:
		cellVector = cellVector as CellVector
		for cell in cellVector.cells:
			cell = cell as Cell
			var cellnode = _create_cell_node(cell)
			cellnodes.append(cellnode)
			add_child(cellnode)

func _update_cellnodes():
	for cellnode in cellnodes:
		cellnode.modulate = get_color_for_type(cellnode.cell.type)

func _tick(delta):
	_update_cellnodes()
