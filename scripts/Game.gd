extends Node


var rng: RandomNumberGenerator

var actions: ActionManager
var battle: BattleManager
var vfx: VfxManager
#var hand: Hand


# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	rng.seed = hash("rpg")

	actions = $Actions
	battle = $Battle
	vfx = $Vfx
