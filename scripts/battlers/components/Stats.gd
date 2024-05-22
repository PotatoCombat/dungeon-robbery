extends Node2D
class_name Stats


const HEALTH_CAP: int = 999
const BLOCK_CAP: int = 999

var id: String

var max_health: int = HEALTH_CAP
var health: int = HEALTH_CAP
var block: int


func get_id() -> String:
	return id

func set_id(value: String) -> void:
	id = value
	$Name.text = value

func show_id(switch: bool) -> void:
	$Name.visible = switch

func get_max_health() -> int:
	return max_health

func set_max_health(value: int) -> void:
	max_health = value
	update_health_bar()

func get_health() -> int:
	return health

func set_health(value: int) -> void:
	health = value
	update_health_bar()

func reset_health() -> void:
	health = max_health
	update_health_bar()

func get_block() -> int:
	return block

func set_block(value: int) -> void:
	block = value
	update_block_bar()

func add_block(value: int) -> void:
	block += value
	update_block_bar()

func update_health_bar() -> void:
	if health > 0:
		$HealthBar.text = "%d / %d" % [health, max_health]
	else:
		$HealthBar.text = "Dead"

func update_block_bar() -> void:
	$BlockBar.text = str(block)
	$BlockBar.visible = block > 0


#var health: int
#var max_health: int
#
#var _block_tween: SceneTreeTween
#
#
#func set_actor_name(value: String) -> void:
#	$Name.text = value
#
#func set_max_health(amount: int):
#	max_health = amount
#
#func reset():
#	health = max_health
#	block = 0
#	_update_health_bar()
#	_update_block_bar()
#
#func heal(amount: int):
#	if health == 0:
#		return
#	health = clamp(health + amount, 0, max_health) as int
#	_update_health_bar()
#
#func damage(amount: int):
#	if block < amount:
#		health = clamp(health + block - amount, 0, max_health) as int
#		block = 0
#	else:
#		block = clamp(block - amount, 0, BLOCK_CAP) as int
#	_update_health_bar()
#	_update_block_bar()
#
#func add_block(amount: int):
#	block = clamp(block + amount, 0, BLOCK_CAP) as int
#	_update_block_bar()
#
#func remove_block(amount: int):
#	block = clamp(block - amount, 0, BLOCK_CAP) as int
#	_update_block_bar()
#
#func _update_health_bar():
#	if health > 0:
#		$HealthBar.text = str(health) + "/" + str(max_health)
#	else:
#		$HealthBar.text = "Dead"
#
#func _update_block_bar():
#	$BlockBar.text = str(block)
#	$BlockBar.visible = block > 0
#
#	if _block_tween:
#		_block_tween.kill()
#	_block_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
#	_block_tween.tween_property($BlockBar, "rect_scale", Vector2.ONE, 0.5).from(Vector2(2.5, 2.5))
