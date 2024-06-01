extends Node


func _ready() -> void:
	$Control/PlayButton/Button.connect("pressed", self, "play")

func play() -> void:
	Game.screen.show_story()
