class_name RamAbility
extends DriftAbility

@export var ram_force: float = 500.0

func act(caller: Entity, delta: float) -> void:
	super.act(caller, delta)
	var prey = caller.get_closest_prey()
	if not prey:
		caller.trigger_decision("target lost")
		return
	var distance = caller.global_position.distance_to(prey.global_position)
	var direction = caller.global_position.direction_to(prey.global_position)
	if distance > caller.get_max_range():
		caller.apply_central_force(direction * engine_force * caller.mass)
	else:
		caller.apply_central_force(direction * ram_force * caller.mass)
