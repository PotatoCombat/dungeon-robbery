extends Action
class_name DamageRandomAction


var user: Battler
var amount: int


func _init(_user: Battler = null, _amount = 0) -> void:
	user = _user
	amount = _amount

func execute() -> void:
	var target = Game.battle.get_foe(0)
	Game.actions.push_front(DamageAction.new(target, user, amount))
