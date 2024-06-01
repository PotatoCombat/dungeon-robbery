extends Node
class_name ScreenManager


func show_splash() -> void:
	load_screen("SplashScreen")

func show_title() -> void:
	load_screen("TitleScreen")

func show_story() -> void:
	load_screen("StoryScreen")

func show_map() -> void:
	load_screen("MapScreen")

func show_battle() -> void:
	load_screen("BattleScreen")

func load_screen(id: String, in_transition = "", out_transition = "") -> void:
	$Blackout.set_mouse_filter(Control.MOUSE_FILTER_STOP)
	if in_transition:
		$AnimationPlayer.play(in_transition)
		yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene(get_screen_path(id))
	if out_transition:
		$AnimationPlayer.play(out_transition)
		yield($AnimationPlayer, "animation_finished")
	$Blackout.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)

func get_screen_path(id: String) -> String:
	return "res://scripts/screens/%s.tscn" % [id]
