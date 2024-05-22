extends Node2D
class_name Battler


const ANIM_IDLE = "idle"
const ANIM_ATTACK = "attack"

export var playable = false

var next_move: Move
var move_history = []

signal selected(battler)
signal triggered_action(battler)


# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

# Virtual
func get_localized_name() -> String:
	return "Battler"

# Virtual
func get_initial_health() -> int:
	return 100

# Virtual
func get_initial_powers() -> Array:
	return []

# Virtual
func get_moves() -> Array:
	return []

# Virtual
func get_decision() -> Decision:
	return Decision.new()

func reset():
	set_id(get_localized_name())

	var initial_health = get_initial_health()
	set_max_health(initial_health)
	set_health(initial_health)
	set_block(0)

func init_powers() -> void:
	for power in get_initial_powers():
		Game.actions.push_back(Game.actions.banner(name + " + " + power))

func is_playable() -> bool:
	return playable

func set_playable(value: bool) -> void:
	playable = value

func get_id() -> String:
	return $Stats.get_id()

func set_id(value: String) -> String:
	return $Stats.set_id(value)

func get_max_health() -> int:
	return $Stats.get_max_health()

func set_max_health(value: int) -> void:
	$Stats.set_max_health(value)

func get_health() -> int:
	return $Stats.get_health()

func set_health(value: int) -> void:
	$Stats.set_health(value)

func reset_health() -> void:
	$Stats.reset_health()

func get_block() -> int:
	return $Stats.get_block()

func set_block(value: int) -> void:
	$Stats.set_block(value)

func add_block(value: int) -> void:
	$Stats.add_block(value)

func show_intent(switch: bool) -> void:
	$Intent.set_visible(switch)

func update_intent(move: Move) -> void:
	$Intent.show_move(move)

func has_animation(animation: String) -> bool:
	return $Actor.has_animation(animation)

func play_animation(animation: String) -> void:
	$Actor.play_animation(animation)

func before_turn() -> void:
	# Relax (lose block)
	set_block(0)
	pass

func after_turn() -> void:
	pass

func get_recent_moves(n: int) -> Dictionary:
	var result = {}
	for move in get_moves():
		result[move] = 0

	for i in range(move_history.size() - n, move_history.size()):
		var move = move_history[i] as Move
		if move:
			result[move] += 1

	return result

func get_next_move() -> Move:
	if is_playable():
		return null
	next_move = get_decision().get_option() as Move
	move_history.append(next_move)
	return next_move

func execute_next_move() -> void:
	if is_playable():
		return
	if not next_move:
		return
	call(next_move.get_name())
	next_move = null

func damage(amount: int):
	var new_health = get_health() - clamp(amount - get_block(), 0, amount)
	var new_block = clamp(get_block() - amount, 0, get_block()) as int
	set_block(new_block)
	set_health(new_health)
	Game.actions.push_front(Game.actions.animate(self, "hit"))
#	var blocked = clamp(health + block - amount, 0, max_health) as int
#
#	if block < amount:
#		health = clamp(health + block - amount, 0, max_health) as int
#		block = 0
#	else:
#		block = clamp(block - amount, 0, BLOCK_CAP) as int
##		Game.actions.push_front(blocked)
##		Game.actions.push_front(hit)
#		Game.actions.push_front(Game.actions.animate(self, "hit"))
	pass

#func relax():
#	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
#	tween.tween_callback($Stats, "remove_block", [$Stats.get_block()])
#	tween.tween_property($Graphics/AnimatedSprite, "modulate", Color.white, 0.5).from(Color.yellow)
#	return tween
#
#func hit(amount = 0) -> SceneTreeTween:
#	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
##	tween.tween_callback($Stats, "damage", [amount])
#	tween.tween_property($Graphics, "position", Vector2.ZERO, 0.5).from(Vector2(-get_direction() * 64, 0))
#	return tween
#
#func attack(target: Actor) -> SceneTreeTween:
#	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
#	tween.tween_property(self, "position", Vector2.ZERO, 0.5).from(Vector2(get_direction() * 64, 0))
#	return tween
#
#func defend(amount = 0) -> SceneTreeTween:
#	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
#	tween.tween_callback($Stats, "add_block", [amount])
#	tween.tween_property($Graphics/AnimatedSprite, "modulate", Color.white, 0.5).from(Color.aqua)
#	return tween

func select() -> void:
	emit_signal("selected", self)

func trigger_action() -> void:
	emit_signal("triggered_action", self)
	Game.actions.next()
