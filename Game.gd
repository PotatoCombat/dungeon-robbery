extends Node


var battle: Battle
var rng: RandomNumberGenerator


# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	rng.seed = hash("rpg")

func _input(event):
	if _is_key_pressed(event, KEY_QUOTELEFT):
		# Do something
		pass
	
	if _is_key_pressed(event, KEY_SPACE):
		# Do something
		var node: CanvasItem = battle.get_node("UI/Hand/Cards/Slot-5")
		node.visible = !node.visible
#		node.set_enabled(!node.is_enabled())
		pass

func _is_key_pressed(event: InputEvent, scancode: int):
	return Input.is_key_pressed(scancode) and event.is_pressed() and not event.is_echo()
