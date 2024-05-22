extends Action
class_name DamageAction


var target: Battler
var user: Battler
var amount: int
var image: String


func _init(_target: Battler = null, _user: Battler = null, _amount = 0, _image = "") -> void:
	target = _target
	user = _user
	amount = _amount
	image = _image

func execute() -> void:
	target.damage(amount)

#func damage(target: Actor, amount: int, source: Actor) -> Action:
#	var action = Action.new("damage")
#	source.attack(action.tween, target)
#	target.hit(action.tween, amount)
#	return action
#	return
#	# Add enemy wind-up (telegraphing)
#	for x in move.get_hits():
#		for i in targets.size():
#			var target = targets[i] as Actor
#			if not target:
#				continue
#			if move.get_attack() > 0:
#				push_actor_tween(user, Action.ATTACK, [target])
#				push_actor_tween(target, Action.HIT, [move.get_attack()])
#			if move.get_defence() > 0:
#				push_actor_tween(user, Action.DEFEND, [move.get_defence()])
#	# Add enemy wind-down
