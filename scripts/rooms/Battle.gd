extends Node
class_name Battle


enum State {
	NONE,
	BATTLE_START,
	NEXT_TURN,
	PLAYER_START,
	PLAYER_TURN,
	PLAYER_NEXT,
	PLAYER_END,
	ENEMY_START,
	ENEMY_TURN,
	ENEMY_NEXT,
	ENEMY_END,
	LOSE,
	WIN,
	BATTLE_END,
}

var state = State.NONE

var battler_queue = []


func _to_string():
	return "Battle"

func _ready():
	Game.battle.load_battlers($Players.get_children(), $Enemies.get_children())

#	$UI/Hand.connect("card_played", self, "select_card")
	$UI/EndTurnBtn.connect("pressed", self, "finish_input")

	load_battle()

func _physics_process(_delta: float) -> void:
	var next_state = get_next_state()
#	log_transition(state, next_state)
	if state != next_state:
		enter_state(next_state)

func get_next_state() -> int:
	if state == State.NONE:
		return state
	if state == State.BATTLE_END:
		return state
	if Game.actions.is_awaiting_input():
		return state
	if Game.actions.is_playing():
		return state
	if not Game.battle.is_player_alive():
		return State.LOSE
	if not Game.battle.are_enemies_alive():
		return State.WIN
	match state:
		State.BATTLE_START:
			return State.NEXT_TURN
		State.NEXT_TURN:
			return State.PLAYER_START
		State.PLAYER_START:
			return State.PLAYER_TURN
		State.PLAYER_TURN:
			return State.PLAYER_NEXT
		State.PLAYER_NEXT:
			if battler_queue.empty():
				return State.PLAYER_END
			else:
				return State.PLAYER_TURN
		State.PLAYER_END:
			return State.ENEMY_START
		State.ENEMY_START:
			return State.ENEMY_TURN
		State.ENEMY_TURN:
			return State.ENEMY_NEXT
		State.ENEMY_NEXT:
			if battler_queue.empty():
				return State.ENEMY_END
			else:
				return State.ENEMY_TURN
		State.ENEMY_END:
			return State.NEXT_TURN
		State.ENEMY_END:
			return State.NEXT_TURN
	return state

func enter_state(next_state: int) -> void:
	Debug.info(self, State.keys()[next_state])
	state = next_state
	match next_state:
		State.BATTLE_START:
			start_battle()
		State.NEXT_TURN:
			next_turn()
		State.PLAYER_START:
			start_player_turn()
		State.PLAYER_TURN:
			start_user_turn()
		State.PLAYER_NEXT:
			end_user_turn()
		State.PLAYER_END:
			end_turn()
		State.ENEMY_START:
			start_enemy_turn()
		State.ENEMY_TURN:
			start_user_turn()
		State.ENEMY_NEXT:
			end_user_turn()
		State.ENEMY_END:
			end_turn()
		State.LOSE:
			lose()
		State.WIN:
			win()
		State.BATTLE_END:
			end_battle()

func load_battle():
	enter_state(State.BATTLE_START)

func finish_input():
	if state == State.PLAYER_TURN and Game.actions.is_awaiting_input():
		var player = Game.battle.get_ally(0)
		var target = Game.battle.get_foe(0)
		Game.actions.push_back(Game.actions.animate(player, "attack"))
		Game.actions.push_back(Game.actions.damage(target, player, 11, "whack"))
		enter_state(State.PLAYER_NEXT)

func start_battle():
	Game.battle.set_turn(0)
	for user in Game.battle.get_battlers():
		user.init_powers()
		user.show_intent(false)
	$UI/EndTurnBtn.disabled = true

func next_turn():
	Game.battle.next_turn()
	if Game.battle.get_turn() == 1:
		Game.actions.push_back(Game.actions.banner("Start Battle"))
	else:
		Game.actions.push_back(Game.actions.banner("Player Turn (%d)" % Game.battle.get_turn()))
	$UI/EndTurnBtn.text = "End Turn"

func start_turn(allies: Array, foes: Array):
	Game.battle.set_allies(allies)
	Game.battle.set_foes(foes)

	battler_queue = allies.duplicate()

	for x in allies:
		var user = x as Battler
		user.before_turn()

func start_player_turn():
	for x in Game.battle.get_battlers():
		var user = x as Battler
		if user.is_playable():
			continue
		var move = user.get_next_move()
		if not move:
			continue
		user.update_intent(move)
		user.show_intent(true)

	start_turn(Game.battle.get_players(), Game.battle.get_enemies())

func start_enemy_turn():
	Game.actions.push_back(Game.actions.banner("Enemy Turn"))
	$UI/EndTurnBtn.text = "Enemy Turn"
	start_turn(Game.battle.get_enemies(), Game.battle.get_players())

func start_user_turn():
	var user = battler_queue.front() as Battler
	if user.is_playable():
		Game.actions.set_awaiting_input(true)
		$UI/EndTurnBtn.disabled = false
		# Draw cards
	else:
		user.execute_next_move()
		user.show_intent(false)

func end_user_turn():
	var user = battler_queue.pop_front() as Battler
	if user.is_playable():
		Game.actions.set_awaiting_input(false)
		$UI/EndTurnBtn.disabled = true
	Game.actions.push_back(Game.actions.wait(1.0))

func end_turn():
	for user in Game.battle.get_allies():
		user.after_turn()

func lose():
	Game.actions.push_back(Game.actions.lose_battle())

func win():
	Game.actions.push_back(Game.actions.win_battle())

func end_battle():
	Game.actions.push_back(Game.actions.banner("End Battle"))
