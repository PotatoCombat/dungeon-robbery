extends Node
class_name ActionManager


var current: Action
var queue = []

var awaiting_input: bool


func _to_string():
	return "ActionManager"

func _process(_delta: float):
	if current and current.is_finished():
		current.queue_free()
		current = null
		if queue.empty():
			print_queue()
	if not current and not queue.empty():
		print_queue()
		current = pop_front()
		current.execute()

func is_playing() -> bool:
	return current != null

func is_awaiting_input() -> bool:
	return awaiting_input

func set_awaiting_input(value: bool) -> void:
	awaiting_input = value

func flush():
	queue = []

func pop_front() -> Action:
	return queue.pop_front() as Action

func push_front(action: Action) -> void:
	queue.push_front(action)
	action.set_name(action.get_type())
	add_child(action)
	move_child(action, 0)

func push_front_all(actions: Array) -> void:
	for i in range(actions.size() - 1, -1, -1):
		push_front(actions[i])

func push_back(action: Action) -> void:
	queue.push_back(action)
	action.set_name(action.get_type())
	add_child(action)

func push_back_all(actions: Array) -> void:
	for action in actions:
		push_back(action)

func next() -> void:
	pass

func print_queue() -> void:
	var actions = []
	for x in queue:
		var action = x as Action
		actions.push_back(action.get_type())
	Debug.info(self, "[" + ", ".join(actions) + "]")

func debug(text: String) -> Action:
	return DebugAction.new(text)

func add_block(user: Battler, amount: int) -> Action:
	return AddBlockAction.new(user, amount)

func animate(user: Battler, animation: String) -> Action:
	return AnimateAction.new(user, animation)

func banner(text: String) -> Action:
	return BannerAction.new(text)

func damage(target: Battler, user: Battler, amount: int, image: String) -> Action:
	return DamageAction.new(target, user, amount, image)

func end_turn() -> Action:
	return EndTurnAction.new()

func win_battle() -> Action:
	return WinBattleAction.new()

func lose_battle() -> Action:
	return LoseBattleAction.new()

func wait(time = 0.0) -> Action:
	return WaitAction.new(time)
