extends Node

@export var maximum_difficulty: float = 2.0

var current_difficulty: float = 0.0

func get_target_difficulty() -> float:
	if current_difficulty < maximum_difficulty:
		return randf_range(current_difficulty, maximum_difficulty)
	return min(current_difficulty, maximum_difficulty)

func notify_spawn(difficulty_modifier: float) -> void:
	current_difficulty += difficulty_modifier

func notify_death(difficulty_modifier: float) -> void:
	current_difficulty -= difficulty_modifier
