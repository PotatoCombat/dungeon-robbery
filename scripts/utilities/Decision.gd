extends Reference
class_name Decision


var weights = {}
var total_weights = 0


func _to_string():
	var result = []
	for option in weights:
		result.append("%s: %d" % [option, weights[option]])
	return "{" + ", ".join(result) + "}"

func size() -> int:
	return weights.size()

func add_option(option, weight: int = 1) -> void:
	weights[option] = weight
	total_weights += weight

func get_option(default_value = null):
	var roll = Game.rng.randi_range(1, total_weights)
	for option in weights:
		roll -= weights[option]
		if roll <= 0:
			return option
	return default_value
