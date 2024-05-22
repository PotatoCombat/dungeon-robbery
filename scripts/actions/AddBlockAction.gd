extends Action
class_name AddBlockAction


var user: Battler
var amount: int


func _init(_user: Battler = null, _amount = 0) -> void:
	user = _user
	amount = _amount

func execute() -> void:
	user.add_block(amount)
