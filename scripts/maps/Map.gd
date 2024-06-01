tool
extends Control
class_name Map


export var marker_speed = 1000.0

var nodes: Array
var edges: Dictionary

var graph: AStar2D

var current_node: MapNode

var marker_from_id: int
var marker_to_id: int
var marker_tween: SceneTreeTween

signal entered_node(node)


func _ready() -> void:
	load_nodes()
	load_edges()
	load_graph()
	load_marker(0)
	load_button()

func load_nodes() -> void:
	nodes = []
	for x in $Nodes.get_children():
		var node = x as MapNode
		node.connect("pressed", self, "select_node", [node])
		nodes.append(node)

func load_edges() -> void:
	edges = {}
	for x in $Paths.get_children():
		var edge = x as MapPath
		var from_id = edge.get_from_node().get_index()
		var to_id = edge.get_to_node().get_index()
		edges[Vector2(from_id, to_id)] = edge

func load_graph() -> void:
	graph = AStar2D.new()
	for x in nodes:
		var node = x as MapNode
		graph.add_point(node.get_index(), node.position)
	for x in edges:
		var edge = x as Vector2
		graph.connect_points(edge.x, edge.y)

func load_marker(id: int) -> void:
	var start_node = nodes[id] as MapNode
	set_current_node(start_node)
	set_marker_position(start_node.position)
	set_marker_from_id(id)
	set_marker_to_id(id)

func load_button() -> void:
	$Foreground/Button.connect("pressed", self, "emit_signal", ["entered_node", current_node])

func get_current_node() -> MapNode:
	return current_node

func set_current_node(value: MapNode) -> void:
	current_node = value
	$Foreground/Location.text = current_node.name

func get_marker_position() -> Vector2:
	return $Marker.position

func set_marker_position(point: Vector2) -> void:
	$Marker.position = point

func set_marker_from_id(id: int) -> void:
	marker_from_id = id

func set_marker_to_id(id: int) -> void:
	marker_to_id = id

func select_node(node: MapNode) -> void:
	var route = get_route(node)
	if route.empty():
		return
	set_current_node(node)
	move_marker(route)

func get_route(node: MapNode) -> PoolIntArray:
	var temp_id = nodes.size()

	graph.add_point(temp_id, get_marker_position())
	graph.connect_points(marker_from_id, temp_id)
	graph.connect_points(temp_id, marker_to_id)

	var result = graph.get_id_path(temp_id, node.get_index())

	graph.remove_point(temp_id)

	return result

func move_marker(route: PoolIntArray) -> void:
	if marker_tween:
		marker_tween.kill()
	marker_tween = create_tween()

	var start_position = get_marker_position()

	for i in range(1, route.size()):
		var id = route[i] as int
		var end_position = graph.get_point_position(id)
		var distance = (end_position - start_position).length()
		start_position = end_position
		marker_tween.tween_callback(self, "set_marker_to_id", [id])
		marker_tween.tween_property($Marker, "position", end_position, distance / marker_speed)
		marker_tween.tween_callback(self, "set_marker_from_id", [id])
