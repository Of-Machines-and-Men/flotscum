class_name DriftAbility
extends Ability

func act(caller: Entity, _delta: float):
	_apply_current_force(caller)

func _apply_current_force(target: Entity) -> void:
	var current_direction = _get_ocean_current_direction(target)
	var current_strength = _get_ocean_current_strength(target)
	var current_influence = 1.0 / target.mass
	target.apply_central_force(current_direction * current_strength * current_influence * target.mass)
	
func _get_ocean_current_direction(target: Entity) -> Vector2:
	return OceanCurrentManager.get_current_direction_at_location(target.global_position)

func _get_ocean_current_strength(target: Entity) -> float:
	return OceanCurrentManager.get_current_strength_at_location(target.global_position)
