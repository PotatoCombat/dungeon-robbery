extends Node2D
class_name Intent


var icons = {
	Move.Type.ATTACK | Move.Type.DEFEND: Color.purple,
	Move.Type.ATTACK: Color.red,
	Move.Type.DEFEND: Color.blue,
}

var default_icon = Color.white

func show_move(move: Move) -> void:
	assert(move != null)
	$Sprite.modulate = icons.get(move.get_type(), default_icon)
	$Value.text = str(move.get_damage())
	$Value.visible = move.is_type(Move.Type.ATTACK)
