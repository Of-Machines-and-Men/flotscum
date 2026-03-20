class_name Spawner
extends Node

@export var spawnable_items: Array[SpawnerEntry] = []
@export var spawn_interval_min: float = 2.0
@export var spawn_interval_max: float = 5.0
@export var per_spawn_count_min: int = 1
@export var per_spawn_count_max: int = 10
@export var spawn_min_range: float = 2000.0
@export var spawn_max_range: float = 10000.0
@export var spawner_max_retries: int = 10
@export var max_entities: int = 20

var _current_spawn_interval: float = (spawn_interval_max - spawn_interval_min) / 2 + spawn_interval_min
var _spawn_attempts: int = 0
var _timer: float = 0.0

func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("entities").size() >= max_entities:
		return
	_timer -= delta
	if _timer <= 0.0:
		_current_spawn_interval = randf_range(spawn_interval_min, spawn_interval_max)
		_timer = _current_spawn_interval
		_spawn()

func _spawn() -> void:
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return
		
	var spawn_count = randi_range(int(per_spawn_count_min), int(per_spawn_count_max))
	_spawn_attempts = 0
	var target_difficulty = DifficultyManager.get_target_difficulty()
	if target_difficulty >= DifficultyManager.maximum_difficulty:
		return
	
	var spawned_entities = 0
	var spawnable_entities: Array[SpawnerEntry] = _get_valid_entries_by_difficulty(target_difficulty)
	while spawned_entities < spawn_count and spawnable_entities.size() and _spawn_attempts < spawner_max_retries:
		_spawn_attempts += 1
		var entry = _get_entry_by_weighted_roll(spawnable_entities)
		if entry && DifficultyManager.current_difficulty < target_difficulty:
			_spawn_entity(entry, camera)
			spawned_entities += 1
		spawnable_entities = _get_valid_entries_by_difficulty(target_difficulty)

func _get_total_entry_weight(entries: Array[SpawnerEntry]) -> float:
	var total_weight: float = 0.0
	for entry in entries:
		total_weight += entry.probability_weight
	return total_weight

func _get_entry_by_weighted_roll(entries: Array[SpawnerEntry]) -> SpawnerEntry:
	var roll = randf_range(0.0, _get_total_entry_weight(entries))
	var accumulator: float = 0.0
	for entry in entries:
		accumulator += entry.probability_weight
		if roll <= accumulator:
			return entry
	return null

func _get_valid_entries_by_difficulty(target_difficulty: float) -> Array[SpawnerEntry]:
	var valid_difficulty_weight = target_difficulty - DifficultyManager.current_difficulty
	var valid_entries: Array[SpawnerEntry] = []
	for entry in spawnable_items:
		if entry.difficulty_weight <= valid_difficulty_weight:
			valid_entries.append(entry)
	return valid_entries
	
func _spawn_entity(entry: SpawnerEntry, camera: Camera2D) -> void:
	var instance = entry.spawn_entity.instantiate()
	get_parent().add_child(instance)
	instance.global_position = _random_outside_view(camera)
	
func _random_outside_view(camera: Camera2D) -> Vector2:
	var random_distance = randf_range(spawn_min_range, spawn_max_range)
	var random_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	return camera.global_position + (random_distance * random_direction)
