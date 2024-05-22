extends Action
class_name BannerAction


var text: String
var amount: int


func _init(_text = "") -> void:
	text = _text
	finished = false

func execute() -> void:
	var tween = create_tween()
	tween.tween_callback(Game.vfx.banner, "display_text", [text])
	tween.tween_method(Game.vfx.banner, "set_opacity", 0.0, 1.0, 0.25)
	tween.tween_method(Game.vfx.banner, "set_opacity", 1.0, 0.0, 0.25).set_delay(0.5)
	tween.tween_callback(self, "finish")
