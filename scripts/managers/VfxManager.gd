extends Node
class_name VfxManager


var banner: Banner


# Called when the node enters the scene tree for the first time.
func _ready():
	banner = $Banner

func _to_string():
	return "VfxManager"
