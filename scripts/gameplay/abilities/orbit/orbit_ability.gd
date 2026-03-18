class_name OrbitAbility
extends DriftAbility


func act(caller: Entity, delta: float) -> void:
	super.act(caller, delta)
	var prey = caller.get_priority_prey()
	if not prey:
		caller.trigger_decision("target lost")
		return
	var distance = caller.global_position.distance_to(prey.global_position)
	var direction = caller.global_position.direction_to(prey.global_position)
	var preferred_distance = (caller.get_max_range() + caller.get_min_range()) / 2.0
	if distance > caller.get_max_range():
		caller.turn_towards(direction)
		caller.engage_engine(caller.motor_force)
	else:
		var perpendicular = Vector2(-direction.y, direction.x)
		var distance_correction = clamp((distance - preferred_distance) / preferred_distance, -1.0, 1.0)
		var desired_facing = (perpendicular + direction + distance_correction).normalized()
		caller.turn_towards(desired_facing)
		caller.engage_engine(caller.motor_force)
