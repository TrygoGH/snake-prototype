extends Resource
class_name Cell

enum Types {
	EMPTY,
	HEAD,
	TAIL,
	APPLE,
}

var type: Types = Types.EMPTY

# Only one _init allowed; no parameters to keep duplication safe
func _init() -> void:
	type = Types.EMPTY

func init(p_type: Types) -> void:
	type = p_type

# Setter and getter
func get_type() -> Types:
	return type

func set_type(p_type: Types) -> void:
	type = p_type

func _to_string() -> String:
	return "Cell(%s)" % Types.keys()[type]
