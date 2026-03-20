class_name HoldDistanceAbility
extends DriftAbility

func act(caller: Entity, delta: float) -> void:
	super.act(caller, delta)
	var prey = caller.get_priority_prey()
	if not prey:
		caller.trigger_decision("target lost")
	var distance = caller.global_position.distance_to(prey.global_position)
	var direction = caller.global_position.direction_to(prey.global_position)
	caller.turn_towards(direction)
	if distance > caller.get_max_range():
		caller.engage_engine(caller.get_motor_force())
	elif distance < caller.get_min_range():
		caller.engage_engine(-direction * caller.get_motor_force())
