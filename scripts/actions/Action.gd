extends Node
class_name Action


var finished = true

var type: String
var script_name: String


func _to_string() -> String:
	return get_script_name()

# Virtual
func execute():
	pass

func is_finished() -> bool:
	return finished

func finish() -> void:
	finished = true

func get_type() -> String:
	if not type:
		var regex = RegEx.new()
		regex.compile("\\w+(?=(Action|_action).gd)")
		type = regex.search(get_script().get_path()).get_string()
	return type

func get_script_name() -> String:
	if not script_name:
		var regex = RegEx.new()
		regex.compile("\\w+(?=.gd)")
		script_name = regex.search(get_script().get_path()).get_string()
	return script_name
