extends Node2D
class_name Enemy

var action = ""
var actionCount = 1
#var condition: Condition

var _tween: SceneTreeTween
var startPosition: Vector2

signal tween_started()
signal tween_completed()

# Called when the node enters the scene tree for the first time.
func _ready():
	init()

func init():
	$Stats.setMaxHealth(100)
	$Stats.reset()
	
	startPosition = position

func damage(amount):
	var prevHealth = $Stats.health
	$Stats.damage(amount)
	if $Stats.health < prevHealth:
		_knockBack()

func _chargeForward():
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "position:x", startPosition.x - 32, 0.1) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_QUAD)
	_tween.tween_property(self, "position:x", startPosition.x, 0.2) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_QUAD)

func _knockBack():
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "position:x", startPosition.x + 8, 0.05) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_QUAD)
	_tween.tween_property(self, "position:x", startPosition.x, 0.2) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_QUAD)

func startTurn():
	emit_signal("tween_started")
	$Stats.removeBlock($Stats.block)
	_chargeForward()
	Game.battle.player.damage($Intent.attack)
	#yield(get_tree().create_timer(0.4), "timeout")
	$Stats.addBlock($Intent.defend)
	yield(get_tree().create_timer(0.4), "timeout")
	emit_signal("tween_completed")

func endTurn():
	pass

func chooseAction():
	$Intent.reset()
	
	if Game.battle.turn == 1:
		action = "chomp"
	
	else:
		var options = {
			"chomp": 45,
			"bellow": 35,
			"thrash": 25
		}
		
		match action:
			"chomp":
				options.erase(action)
			"bellow":
				options.erase(action)
			"thrash":
				if actionCount == 2:
					options.erase(action)
		
		var total = 0
		for option in options:
			total += options[option]
			options[option] = total

		var choice = Game.rng.randi_range(1, total)
		for option in options:
			if choice <= options[option]:
				if action == option:
					actionCount += 1
				else:
					actionCount = 1
				action = option
				break
	
	call(action)
	$Intent.update()

func chomp():
	$Intent.action = "chomp"
	$Intent.attack = 11
	
	$Intent.nextActions = {
		"bellow": 35,
		"thrash": 25
	}

func bellow():
	$Intent.action = "bellow"
	$Intent.defend = 6
	
	$Intent.nextActions = {
		"chomp": 45,
		"thrash": 25
	}

func thrash():
	$Intent.action = "thrash"
	$Intent.attack = 7
	$Intent.defend = 5
	
	$Intent.nextActions = {
		"chomp": 45,
		"bellow": 35
	}
	if actionCount < 2:
		$Intent.nextActions["thrash"] = 25
