extends Node
class_name BattleManager

var turn = 0

var card: Card
var targets: Array

var players: Array
var enemies: Array

var allies: Array
var foes: Array

func _to_string():
	return "BattleManager"

func select_card(value: Card):
#	print(card.name + " " + str(card.get_id()))
	card = value

func select_targets(value: Array):
#	print(enemy.name)
	targets = value

func select_random_foe():
	targets = [get_foe(0)]

func get_turn() -> int:
	return turn

func set_turn(value: int) -> void:
	turn = value

func next_turn() -> void:
	turn += 1

func load_battlers(_players: Array, _enemies: Array):
	players = _players
	enemies = _enemies
	allies = _players
	foes = _enemies

	for x in _players:
		var battler = x as Battler
		battler.connect("selected", self, "select_targets", [battler])

	for x in _enemies:
		var battler = x as Battler
		battler.connect("selected", self, "select_targets", [battler])

func get_battlers() -> Array:
	var result = []
	result.append_array(players)
	result.append_array(enemies)
	return result

func get_players() -> Array: # Array[Battler]
	return players

func get_enemies() -> Array: # Array[Battler]
	return enemies

func get_allies() -> Array: # Array[Battler]
	return allies

func get_foes() -> Array: # Array[Battler]
	return foes

func get_player(index: int = 0) -> Battler:
	return players[index]

func get_enemy(index: int = 0) -> Battler:
	return enemies[index]

func get_ally(index: int = 0) -> Battler:
	return allies[index]

func get_foe(index: int = 0) -> Battler:
	return foes[index]

func set_player(index: int, battler: Battler) -> void:
	players[index] = battler

func set_enemy(index: int, battler: Battler) -> void:
	enemies[index] = battler

func set_ally(index: int, battler: Battler) -> void:
	allies[index] = battler

func set_foe(index: int, battler: Battler) -> void:
	foes[index] = battler

func set_allies(battlers: Array) -> void:
	allies = battlers

func set_foes(battlers: Array) -> void:
	foes = battlers

func remove_player(index: int) -> Battler:
	var battler = players[index]
	players[index] = null
	return battler

func remove_enemy(index: int) -> Battler:
	var battler = enemies[index]
	enemies[index] = null
	return battler

func remove_ally(index: int) -> Battler:
	var battler = allies[index]
	allies[index] = null
	return battler

func remove_foe(index: int) -> Battler:
	var battler = foes[index]
	foes[index] = null
	return battler

func is_player_alive() -> bool:
	return get_player().get_health() > 0

func are_enemies_alive() -> bool:
	for i in enemies.size():
		var battler = enemies[i] as Battler
		if battler.get_health() > 0:
			return true
	return false
