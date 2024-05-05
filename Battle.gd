extends Node
class_name Battle

var turn = 1

var player: Player
var enemies: Array

#var hand: Hand

var tweens = 0

signal turn_completed()

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.battle = self
	
	$UI/Hand.connect("card_played", self, "test")
	setup()
	startTurn()

func test(card: Card):
	print(card.name + " " + str(card.get_id()))

func setup():
	$UI/Banner.visible = false

	turn = 0
	
	player = $Player
	
	enemies = []
	enemies.append($Slime)
	enemies.append($Slime2)
	
	var enemy: Enemy
	for i in enemies.size():
		enemy = enemies[i]
		enemy.connect("tween_started", self, "_on_Enemy_tween_started")
		enemy.connect("tween_completed", self, "_on_Enemy_tween_completed")
	
#	cards = []
	#cards.append($UI/Cards/Card1)
	#cards.append($UI/Cards/Card2)

func startTurn():
	turn += 1
	
	var enemy: Enemy
	for i in enemies.size():
		enemy = enemies[i]
		enemy.endTurn()
		enemy.chooseAction()
	
	#player.startTurn()
	
	$UI/EndTurnBtn.text = "End Turn"
	$UI/EndTurnBtn.disabled = false
	
#	var card: CardSlot
#	for i in cards.size():
#		card = cards[i]
#		card.setEnabled(true)


func endTurn():
#	var card: CardSlot
#	for i in cards.size():
#		card = cards[i]
#		card.setEnabled(false)
	
	$UI/EndTurnBtn.text = "Enemy Turn"
	$UI/EndTurnBtn.disabled = true
	
	#player.endTurn()
	
	var enemy: Enemy
	for i in enemies.size():
		enemy = enemies[i]
		enemy.startTurn()
		yield(self, "turn_completed")
	
	startTurn()

func _on_EndTurnBtn_pressed():
	endTurn()

func changeState():
	pass

func _on_Enemy_tween_started():
	tweens += 1

func _on_Enemy_tween_completed(): 
	tweens -= 1
	if tweens == 0:
		emit_signal("turn_completed")

func basic_attack():
	var enemy: Enemy = Game.battle.enemies[0]
	enemy.damage(5)

func basic_defend():
	Game.battle.player.block(5)

func _on_Relic1_pressed():
	var enemy: Enemy
	for i in enemies.size():
		enemy = enemies[i]
		enemy.init()
