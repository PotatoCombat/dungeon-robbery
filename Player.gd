extends Node2D
class_name Player


export var health = 100
export var maxHealth = 100

export var block = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_updateHealthBar()
	_updateBlockBar()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func heal(amount):
	pass

func damage(amount):
	if block >= amount:
		block -= amount
	else:
		health -= amount - block
		block = 0

	_updateHealthBar()
	_updateBlockBar()

func block(amount):
	block += amount
	_updateBlockBar()

func _updateHealthBar():
	$HealthBar.text = str(health) + "/" + str(maxHealth)

func _updateBlockBar():
	$BlockBar.text = str(block)
	$BlockBar.visible = block > 0


func _on_TextureButton2_pressed():
	block(5)
