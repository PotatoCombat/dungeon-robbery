extends Control
class_name Card


export var id: int

var _tween_count = 0
var _offset_tween: SceneTreeTween
var _scale_tween: SceneTreeTween
var _rotate_tween: SceneTreeTween


func get_id() -> int:
	return id

func set_id(value: int) -> void:
	id = value

func get_z_index() -> int:
	return $Area2D.z_index

func set_z_index(value: int):
	$Area2D.z_index = value
	VisualServer.canvas_item_set_z_index(get_canvas_item(), value)

func is_enabled():
	return $Area2D/CollisionShape2D.disabled

func set_enabled(switch: bool):
	$Area2D/CollisionShape2D.disabled = !switch

func get_center_position() -> Vector2:
	return $Center.global_position

func set_center_position(point: Vector2) -> void:
	rect_global_position = point - $Center.position

func move_towards(point: Vector2, delta: float) -> void:
	set_center_position(get_center_position().linear_interpolate(point, delta))

func offset(amount: Vector2 = Vector2.ZERO, time: float = 0):
	_on_tween_started(_offset_tween)
	_offset_tween = create_tween().set_trans(Tween.TRANS_QUAD)
	_offset_tween.tween_property(self, "rect_position", amount, time)
	_offset_tween.tween_callback(self, "_on_tween_completed")

func scale(amount: float, time: float = 0):
	_on_tween_started(_scale_tween)
	_scale_tween = create_tween().set_trans(Tween.TRANS_QUAD)
	_scale_tween.tween_property(self, "rect_scale", Vector2.ONE * amount, time)
	_scale_tween.tween_callback(self, "_on_tween_completed")

func rotate(degrees: float, time: float = 0):
	_on_tween_started(_rotate_tween)
	_rotate_tween = create_tween().set_trans(Tween.TRANS_QUAD)
	_rotate_tween.tween_property(self, "rect_rotation", degrees, time)
	_rotate_tween.tween_callback(self, "_on_tween_completed")

func _on_tween_started(tween: SceneTreeTween):
	if tween and tween.is_running():
		tween.kill()
	else:
		_tween_count += 1
	set_enabled(false)

func _on_tween_completed(enable: bool = true):
	_tween_count -= 1
	if _tween_count == 0:
		set_enabled(enable)
