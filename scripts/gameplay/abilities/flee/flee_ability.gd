class_name FleeAbility
extends DriftAbility

func act(caller: Entity, delta: float) -> void:
	super.act(caller, delta)
	var predator = caller.get_priority_predator()
	if not predator:
		caller.trigger_decision("reached safety")
		return
	var direction = -caller.global_position.direction_to(predator.global_position)
	caller.turn_towards(direction)
	caller.engage_engine(caller.motor_force)
