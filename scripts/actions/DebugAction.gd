extends Action
class_name DebugAction


var text: String


func _init(_text = "") -> void:
	text = _text

func execute() -> void:
	Debug.info(self, text)
