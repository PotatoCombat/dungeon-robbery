extends Label
class_name Intent

var action: String
var type: String

var attack: int
var defend: int
var repeat: int

var nextActions = {}

func _ready():
	reset()

func reset():
	visible = false

	type = "None"
	attack = 0
	defend = 0
	repeat = 1

func update():
	visible = true
	
	var visuals = []

	if attack > 0:
		visuals.append("attack: " + str(attack))

	if defend > 0:
		visuals.append("defend")
	
	text = ", ".join(visuals)
