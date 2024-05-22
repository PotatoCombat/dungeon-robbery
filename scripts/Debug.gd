extends Node


signal debug(scancode)


func _input(event):
	if not OS.is_debug_build():
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		emit_signal("debug", event.scancode)

func info(object: Object, message: String) -> void:
	print(format_message(object, message))

func warn(object: Object, message: String) -> void:
	printerr(format_message(object, message))
	push_warning(message)

func error(object: Object, message: String) -> void:
	printerr(format_message(object, message))
	push_error(message)

func format_message(object: Object, message: String) -> String:
	return "%s: (%s) %s" % [Time.get_time_string_from_system(), object, message]
