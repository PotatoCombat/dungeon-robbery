extends Node
class_name Level


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().create_timer(3.0).connect("timeout", $Battle, "load_battle")
	pass # Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if Input.is_action_just_pressed("ui_accept"):
#		print("PATO")
#		$Battle.load_battle()
