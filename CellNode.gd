extends MeshInstance2D
class_name CellNode

var cell: Cell = Cell.new()
var size: Vector2i

## Initializes the CellNode with a given Cell and size. Falls back to a new Cell if null is passed.
func _init(p_cell: Cell, p_size: Vector2i) -> void:
	if p_cell != null:
		cell = p_cell
	else:
		cell = Cell.new()
	mesh = QuadMesh.new()
	scale = p_size

## Sets the type of the underlying cell
func set_type(p_type: int) -> void:
	cell.set_type(p_type)

## Gets the type of the underlying cell
func get_type() -> int:
	return cell.get_type()

## Returns a string describing this CellNode and its associated cell
func _to_string() -> String:
	return "CellNode holding %s" % cell._to_string()

## Creates and returns a shader material that draws an outline around the cell's texture.
## Useful for visually distinguishing grid cells.
## @experimental: This function doesn't work as intended yet
func create_outline_shader(outline_size := 2.0, outline_color := Color(0, 0, 0, 1.0)) -> ShaderMaterial:
	var shader = Shader.new()
	shader.code = """
		shader_type canvas_item;

		uniform float outline_size = 2.0;
		uniform vec4 outline_color : hint_color = vec4(0, 0, 0, 1.0);

		void fragment() {
			vec4 base = texture(TEXTURE, UV);

			if (base.a < 0.1) {
				float alpha = 0.0;
				for (int x = -1; x <= 1; x++) {
					for (int y = -1; y <= 1; y++) {
						vec2 offset = vec2(x, y) * outline_size / textureSize(TEXTURE, 0);
						alpha = max(alpha, texture(TEXTURE, UV + offset).a);
					}
				}
				if (alpha > 0.1) {
					COLOR = outline_color;
				} else {
					discard;
				}
			} else {
				COLOR = base;
			}
		}
	"""

	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	shader_material.set_shader_parameter("outline_size", outline_size)
	shader_material.set_shader_parameter("outline_color", outline_color)

	return shader_material
