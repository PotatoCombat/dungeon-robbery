tool
extends Line2D
class_name MapPath


export var _from: NodePath
export var _to: NodePath

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_from_position()
	update_to_position()
	update_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.editor_hint:
		update_from_position()
		update_to_position()
		update_label()

func update_from_position() -> void:
	if _from:
		set_point_position(0, get_from_node().position)

func update_to_position() -> void:
	if _to:
		set_point_position(1, get_to_node().position)

func update_label() -> void:
	$Label.set_visible(Engine.editor_hint)
	$Label.set_text(name)
	$Label.set_position(0.5 * (get_point_position(0) + get_point_position(1)))

func get_from_node() -> Node2D:
	return get_node(_from) as Node2D

func get_to_node() -> Node2D:
	return get_node(_to) as Node2D
