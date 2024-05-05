extends Control
class_name Hand


enum State {DEFAULT, CHOOSING, HOLDING, PLAY, END, ATTACK, SKILL, POWER}

enum Position {NONE, DROP_ZONE, CANCEL_ZONE}

export var max_cards = 10

export var fan_step: float = 4
export var fan_height: float = 40
export var fan_rotation: float = 4 # Degrees
export var fan_scale: float = 0.7

export var card_float_layer: int = 1
export var card_shrink_speed: float = 0.2
export var card_follow_speed: float = 20

var cards: Array

var state = State.DEFAULT

# Variables
var selected_card: Card
var cursor_target: Node
var cursor_position = Position.NONE

signal card_played(card)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var card: Card
	
	var slots = $Cards.get_children()
	for i in slots.size():
		card = slots[i].get_child(0)
		card.set_id(i)
		cards.append(card)
	
	for i in cards.size():
		card = cards[i]
		shrink_card(card)

func _physics_process(delta: float) -> void:
	# Update variables
	cursor_target = get_cursor_target() # Need to filter if disabled
	cursor_position = get_cursor_position()
	
	var next_state = get_next_state()
	log_transition(state, next_state)
	state = next_state
	
	run_state(delta)

func log_transition(from: int, to: int) -> void:
	if from == to:
		return
	print("%s%s [%s]: %-*s -> %-*s" % [ "" \
		, Time.get_time_string_from_system() \
		, name \
		, 8 , get_state_name(from) \
		, 8 , get_state_name(to) \
	])

func get_state_name(index: int) -> String:
	return State.keys()[index]

func get_next_state():
	match state:
		State.DEFAULT:
			if cursor_target is Card:
				return State.CHOOSING
		State.CHOOSING:
			if not cursor_target is Card:
				return State.DEFAULT
			if Input.is_action_just_pressed("ui_accept"):
				return State.HOLDING
		State.HOLDING:
			if Input.is_action_just_pressed("ui_cancel"):
				return State.DEFAULT
			if Input.is_action_just_pressed("ui_accept"):
				return State.DEFAULT
			if cursor_position == Position.DROP_ZONE:
				return State.ATTACK
		State.ATTACK:
			if cursor_position == Position.CANCEL_ZONE:
				return State.DEFAULT
			if Input.is_action_just_pressed("ui_cancel"):
				return State.DEFAULT
			if Input.is_action_just_pressed("ui_accept"):
				if cursor_position == Position.DROP_ZONE:
					return State.PLAY
		State.PLAY:
			return State.DEFAULT
	return state

func run_state(delta: float):
	match state:
		State.DEFAULT:
			if selected_card:
				shrink_card(selected_card, card_shrink_speed)
				select_card(null)
				$Line2D.visible = false
		State.CHOOSING:
			if selected_card != cursor_target:
				if selected_card:
					shrink_card(selected_card, card_shrink_speed)
				expand_card(cursor_target)
				select_card(cursor_target)
		State.HOLDING:
			selected_card.move_towards(Cursor.position, delta * card_follow_speed)
		State.ATTACK:
			selected_card.move_towards($Line2D.get_point_position(0), delta * card_follow_speed)
			$Line2D.visible = true
			$Line2D.set_point_position(1, Cursor.position)
		State.PLAY:
			$Line2D.visible = false
			emit_signal("card_played", selected_card)

func get_cursor_target() -> Node:
	return Cursor.target.get_parent() if Cursor.target else null

func get_cursor_position() -> int:
	if is_within_drop_zone(Cursor.position):
		return Position.DROP_ZONE
	if is_within_cancel_zone(Cursor.position):
		return Position.CANCEL_ZONE
	return Position.NONE

func is_within_drop_zone(point: Vector2) -> bool:
	var y = point.y - $DropZone.rect_global_position.y
	return 0 <= y and y <= $DropZone.rect_size.y

func is_within_cancel_zone(point: Vector2) -> bool:
	var y = point.y - $CancelZone.rect_global_position.y
	return 0 <= y and y <= $CancelZone.rect_size.y

func select_card(card: Card):
	selected_card = card

func expand_card(card: Card, time: float = 0):
	card.offset(Vector2.ZERO, time)
	card.rotate(0, time)
	card.scale(1, time)
	card.set_z_index(card_float_layer)

func shrink_card(card: Card, time: float = 0):
	card.offset(get_shrink_offset(card.get_id()), time)
	card.rotate(get_shrink_rotation(card.get_id()), time)
	card.scale(fan_scale, time)
	card.set_z_index(-max_cards + card.get_id())

func get_shrink_offset(slot: int):
	return Vector2(0, fan_step * pow(0.5 * (1 - cards.size()) + slot, 2) + fan_height)

func get_shrink_rotation(slot: int):
	return fan_rotation * (0.5 * (1 - cards.size()) + slot)
