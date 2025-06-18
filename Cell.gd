extends Resource
class_name Cell

enum Types {
	EMPTY,
	HEAD,
	TAIL,
	APPLE,
	BODY,
}

var type: Types = Types.EMPTY

## Default initializer; sets the cell to EMPTY type
func _init() -> void:
	type = Types.EMPTY

## Custom initializer to set the cell type manually
func init(p_type: Types) -> void:
	type = p_type

## Returns the current type of the cell
func get_type() -> Types:
	return type

## Sets the cell to a specific type
func set_type(p_type: Types) -> void:
	type = p_type

## Returns a string representation of the cell for debugging/logging
func _to_string() -> String:
	return "Cell(%s)" % Types.keys()[type]
