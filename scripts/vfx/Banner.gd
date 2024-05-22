extends Label
class_name Banner


# Called when the node enters the scene tree for the first time.
func _ready():
	set_opacity(0.0)

func display_text(value: String) -> void:
	text = value

func set_opacity(value: float) -> void:
	modulate.a = value

func fade_in(time: float = 0.0) -> SceneTreeTween:
	var tween: SceneTreeTween = create_tween()
	tween.tween_callback(self, "set_visible", [false])
	tween.tween_callback(self, "set_visible", [true]).set_delay(time)
	return tween

func fade_out(time: float = 0.0) -> SceneTreeTween:
	var tween: SceneTreeTween = create_tween()
	tween.tween_callback(self, "set_visible", [true])
	tween.tween_callback(self, "set_visible", [false]).set_delay(time)
	return tween
