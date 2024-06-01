tool
extends Node2D
class_name MapNode


enum Icon {DEFAULT, HOUSE, CAVE, CAMPFIRE, TREASURE}

const ICONS = {
	Icon.DEFAULT: Vector2(9, 1),
	Icon.HOUSE: Vector2(5, 6),
	Icon.CAVE: Vector2(4, 7),
	Icon.CAMPFIRE: Vector2(7, 6),
	Icon.TREASURE: Vector2(7, 1),
}

export(Icon) var icon setget set_icon

signal pressed()
signal released()

func _ready() -> void:
	update_label()
	$Button2D.connect("pressed", self, "emit_signal", ["pressed"])
	$Button2D.connect("released", self, "emit_signal", ["released"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.editor_hint:
		update_label()

func set_icon(value: int) -> void:
	icon = value
	$Icon.set_frame_coords(ICONS.get(value, ICONS.get(Icon.DEFAULT)))

func update_label() -> void:
	$Label.set_visible(Engine.editor_hint)
	$Label.set_text(name)
