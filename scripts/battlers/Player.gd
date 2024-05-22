extends Battler
class_name Player


var move_chomp = Move.new("chomp", Move.Type.ATTACK, 11)
var move_bellow = Move.new("bellow", Move.Type.DEFEND | Move.Type.BUFF)
var move_thrash = Move.new("thrash", Move.Type.ATTACK | Move.Type.DEFEND, 7)


func get_localized_name() -> String:
	return "Player"

func get_initial_health() -> int:
	return 100

func get_initial_powers() -> Array:
	return []

func get_moves() -> Array:
	return [
		move_chomp,
		move_bellow,
		move_thrash,
	]

func get_decision() -> Decision:
	var decision: Decision = Decision.new()

	if Game.battle.get_turn() == 1 \
	or Game.battle.get_turn() > 1 and get_recent_moves(1).get(move_chomp) < 1:
		decision.add_option(move_chomp, 45)

	if Game.battle.get_turn() > 1 and get_recent_moves(1).get(move_bellow) < 1:
		decision.add_option(move_bellow, 35)

	if Game.battle.get_turn() > 1 and get_recent_moves(2).get(move_thrash) < 2:
		decision.add_option(move_thrash, 25)

	return decision

func chomp():
	var target = Game.battle.get_foe(0)
	Game.actions.push_back_all([
		Game.actions.animate(self, "attack"),
		Game.actions.damage(target, self, 11, "bite")
	])

func bellow():
	Game.actions.push_back_all([
		Game.actions.animate(self, "attack"),
#		Game.actions.sfx("bellow"),
		Game.actions.wait(0.5),
		Game.actions.add_block(self, 6)
	])

func thrash():
	var target = Game.battle.get_foe(0)
	Game.actions.push_back_all([
		Game.actions.animate(self, "attack"),
		Game.actions.damage(target, self, 7, "whack"),
		Game.actions.wait(0.5),
		Game.actions.add_block(self, 5)
	])
