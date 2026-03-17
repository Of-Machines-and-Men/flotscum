extends Node

# Mirror shader values exactly
const CURRENT_A_DIR := Vector2(0.7, 0.3)
const CURRENT_B_DIR := Vector2(-0.3, 0.7)
const CURRENT_A_SPEED := 0.2
const CURRENT_B_SPEED := 0.1
const CURRENT_A_FREQUENCY := 0.2
const CURRENT_B_FREQUENCY := 0.15
const WAVE_SCALE := 1.0

@export var current_strength: float = 20.0

var _time: float = 0.0

func _process(delta: float) -> void:
	_time += delta

func _get_speed_a() -> float:
	return CURRENT_A_SPEED * (sin(_time * CURRENT_A_FREQUENCY) * 0.5 + 0.5)

func _get_speed_b() -> float:
	return CURRENT_B_SPEED * (sin(_time * CURRENT_B_FREQUENCY) * 0.5 + 0.5)

func _get_position_strength(world_pos: Vector2) -> float:
	# Approximate noise texture variation using layered sin
	var uv = world_pos / get_viewport().get_visible_rect().size
	var wave_a = sin(uv.x * WAVE_SCALE * 10.0 + _time * _get_speed_a())
	var wave_b = sin(uv.y * WAVE_SCALE * 10.0 + _time * _get_speed_b())
	return (max(wave_a, wave_b) * 0.5 + 0.5)  # remap to 0-1

func get_current_direction_at_location(_world_pos: Vector2) -> Vector2:
	var current_a = CURRENT_A_DIR.normalized() * _get_speed_a()
	var current_b = CURRENT_B_DIR.normalized() * _get_speed_b()
	return (current_a + current_b).normalized()

func get_current_strength_at_location(world_pos: Vector2) -> float:
	return current_strength * _get_position_strength(world_pos)
