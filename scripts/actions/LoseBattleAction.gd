extends Action
class_name LoseBattleAction


func execute() -> void:
	for x in Game.battle.get_enemies():
		var battler = x as Battler
		battler.visible = false
	Game.actions.push_back(Game.actions.banner("Lose"))
