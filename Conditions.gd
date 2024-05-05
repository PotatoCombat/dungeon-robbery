extends Reference


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

class Condition:
	func check():
		return true

class MaxConsecutiveCondition extends Condition:
	var _count: int

	func _init(count: int = 0):
		_count = count
		pass

	func check():
		return false
