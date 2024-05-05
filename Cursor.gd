extends Sprite


const _max_results = 16
const _exclude = []
const _raycast_layer = 0x7FFFFFFF
const _collide_with_bodies = false
const _collide_with_areas = true

export var click_rotation = 0.25

var _space_state: Physics2DDirectSpaceState

var targets = {}
var target: CanvasItem

# Called when the node enters the scene tree for the first time.
func _ready():
	_space_state = get_world_2d().direct_space_state

func _input(event):
	if event is InputEventMouseMotion:
		set_position(event.position)
		show_system_mouse(event.position != position)
	
	if event.is_action_pressed("ui_accept") and not event.is_echo():
		_press()
	
	if event.is_action_released("ui_accept") and not event.is_echo():
		_release()

func _physics_process(_delta):
	var next_targets: Dictionary = _raycast()
	
	# Update exits
	for id in targets:
		if not next_targets.has(id):
			_exit(targets[id])
	
	# Update enters
	for id in next_targets:
		if not targets.has(id):
			_enter(next_targets[id])
	
	targets = next_targets
	target = _find_target()

func get_position() -> Vector2:
	return position

func set_position(point: Vector2) -> void:
	var viewport = get_viewport_rect()
	position.x = clamp(point.x, 0, viewport.size.x)
	position.y = clamp(point.y, 0, viewport.size.y)

func show_system_mouse(toggle: bool) -> void:
	if toggle:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _press():
	rotate(-click_rotation)
	if not target:
		return
	var parent = target.get_parent()
	if parent.has_signal("pressed"):
		parent.emit_signal("pressed")

func _release():
	rotate(click_rotation)
	if not target:
		return
	var parent = target.get_parent()
	if parent.has_signal("released"):
		parent.emit_signal("released")

func _exit(node: CollisionObject2D):
	var parent = node.get_parent()
	if parent.has_signal("exited"):
		parent.emit_signal("exited")

func _enter(node: CollisionObject2D):
	var parent = node.get_parent()
	if parent.has_signal("entered"):
		parent.emit_signal("entered")

func _raycast() -> Dictionary:
	var hits = _space_state.intersect_point(
		position,
		_max_results,
		_exclude,
		_raycast_layer,
		_collide_with_bodies,
		_collide_with_areas
	)
	var results = {}
	for hit in hits:
		results[hit["collider_id"]] = hit["collider"]
	return results

func _find_target() -> CollisionObject2D:
	if not targets:
		return null
	
	var values = targets.values()
	var collider: CollisionObject2D
	var result: CollisionObject2D = values[0]
	
	for i in range(1, values.size()):
		collider = values[i]
		if collider.z_index > result.z_index:
			result = collider
	return result
