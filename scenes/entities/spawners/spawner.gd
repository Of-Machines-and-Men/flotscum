class_name Spawner
extends Node

@export var collectible_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var spawn_margin: float = 100.0
@export var max_entities: int = 20

var _timer: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("entities").size() >= max_entities:
		return
	_timer -= delta
	if _timer <= 0.0:
		_timer = spawn_interval
		_spawn()

func _spawn() -> void:
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return
	
	var viewport_rect = _get_viewport_rect_world(camera)
	var spawn_pos = _random_outside_rect(viewport_rect)
	
	var instance = collectible_scene.instantiate()
	get_parent().add_child(instance)
	instance.global_position = spawn_pos
	
func _get_viewport_rect_world(camera: Camera2D) -> Rect2:
	var viewport_size = get_viewport().get_visible_rect().size
	var top_left = camera.global_position - (viewport_size / 2)
	return Rect2(top_left, viewport_size)
	
func _random_outside_rect(rect: Rect2) -> Vector2:
	var side = randi() % 4
	var random_x_offset = randf_range(rect.position.x, rect.end.x)
	var random_y_offset = randf_range(rect.position.y, rect.end.y)
	match side:
		0: #top
			return Vector2(random_x_offset, rect.position.y - spawn_margin)
		1: #bottom
			return Vector2(random_x_offset, rect.end.y + spawn_margin)
		2: #left
			return Vector2(rect.position.x - spawn_margin, random_y_offset)
		3: #right
			return Vector2(rect.end.x + spawn_margin, random_y_offset)
	return Vector2.ZERO
