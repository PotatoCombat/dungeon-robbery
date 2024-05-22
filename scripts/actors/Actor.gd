extends Node2D
class_name Actor

func has_animation(animation: String) -> bool:
	return $AnimationPlayer.has_animation(animation)

func play_animation(animation: String) -> void:
	$AnimationPlayer.play(animation)

func flip_x() -> void:
	$Graphics.scale.x *= -1

func get_top_position() -> Vector2:
	return $Positions/Top.global_position

func get_center_position() -> Vector2:
	return $Positions/Center.global_position

func get_bottom_position() -> Vector2:
	return $Positions/Bottom.global_position
