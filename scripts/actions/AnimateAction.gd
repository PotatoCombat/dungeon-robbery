extends Action
class_name AnimateAction


var user: Battler
var animation: String


func _init(_user: Battler = null, _animation = "") -> void:
	user = _user
	animation = _animation
	finished = false

func execute() -> void:
	if not user.has_animation(animation):
		Debug.error(self, "%s does not have %s animation" % [user.get_path(), animation])
		return
	var tween = create_tween()
	tween.tween_callback(user, "play_animation", [animation])
	tween.tween_callback(self, "finish").set_delay(0.5)
