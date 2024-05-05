extends Node2D


var health
var maxHealth

var block
var maxBlock = 999

var strength

var _tween: SceneTreeTween


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setMaxHealth(amount: int):
	maxHealth = amount

func reset():
	health = maxHealth
	block = 0
	_updateHealthBar()
	_updateBlockBar()

func damage(amount: int):
	if block < amount:
		health = clamp(health + block - amount, 0, maxHealth)
		block = 0
	else:
		block = clamp(block - amount, 0, maxBlock)
	_updateHealthBar()
	_updateBlockBar()

func addBlock(amount: int):
	block = clamp(block + amount, 0, maxBlock)
	_updateBlockBar()

func removeBlock(amount: int):
	block = clamp(block - amount, 0, maxBlock)
	_updateBlockBar()

func _updateBlockBar():
	$BlockBar.text = str(block)
	$BlockBar.visible = block > 0

	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property($BlockBar, "rect_scale", Vector2.ONE, 0.5) \
		.from(Vector2(2.5, 2.5)) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_EXPO)

func _updateHealthBar():
	if health > 0:
		$HealthBar.text = str(health) + "/" + str(maxHealth)
	else:
		$HealthBar.text = "Dead"
