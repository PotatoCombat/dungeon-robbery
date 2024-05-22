extends Reference
class_name Move


enum Type {
	ATTACK = 1 << 0,
	DEFEND = 1 << 1,
	BUFF = 1 << 2,
	DEBUFF = 1 << 3,
	ESCAPE = 1 << 4,
	SLEEP = 1 << 5,
	STUN = 1 << 6,
	MISC = 1 << 7
}

var name: String
var type: int
var damage: int


func _init(_name = "", _type = 0, _damage = 0):
	name = _name
	type = _type
	damage = _damage

func get_name() -> String:
	return name

func get_damage() -> int:
	return damage

func get_type() -> int:
	return type

func is_type(value: int) -> bool:
	return (type & value) > 0
