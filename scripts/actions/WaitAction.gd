extends Action
class_name WaitAction


var time: float


func _init(_time = 0.0) -> void:
	time = _time
	finished = false

func execute() -> void:
	var tween = create_tween()
	tween.tween_callback(self, "finish").set_delay(time)
