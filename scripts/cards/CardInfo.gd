extends Reference
class_name CardInfo

enum Type {NONE, ATTACK, SKILL, POWER, STATUS, CURSE}
enum Scope {NONE = 0, USER = 1 << 0, ALLY = 1 << 1, FOE = 1 << 2, TEAM = 1 << 3, ALL = 1 << 4 - 1}

var name: String

var type = Type.NONE
var scope = Scope.NONE

var cast_effect = ""
var hit_effect = ""

var hits = 1
var random_targets = 0

var energy_cost = 0

var attack = 0
var defence = 0

var buffs = []
var debuffs = []
var effects = [] # draw, leech, unplayable, exhaust, ethereal

func _init(_name = "", _attack = 0, _defence = 0, _hits = 0):
	name = _name
	attack = _attack
	defence = _defence
	hits = _hits

func _to_string():
	return"%sMove(%s: attack=%d, defence=%d, hits=%d)" % ["" \
		, name \
		, attack \
		, defence \
		, hits \
	]

func get_name() -> String:
	return name

func get_type() -> int:
	return type

func get_scope() -> int:
	return scope

func set_scope(value: int) -> void:
	scope = value

func get_cast_effect() -> String:
	return cast_effect

func set_cast_effect(value: String) -> void:
	cast_effect = value

func get_hit_effect() -> String:
	return hit_effect

func set_hit_effect(value: String) -> void:
	hit_effect = value

func get_hits() -> int:
	return hits

func set_hits(value: int) -> void:
	hits = value

func get_random_targets() -> int:
	return random_targets

func set_random_targets(value: int) -> void:
	random_targets = value

func get_energy_cost() -> int:
	return energy_cost

func set_energy_cost(value: int) -> void:
	energy_cost = value

func get_attack() -> int:
	return attack

func set_attack(value: int) -> void:
	attack = value

func get_defence() -> int:
	return defence

func set_defence(value: int) -> void:
	defence = value
