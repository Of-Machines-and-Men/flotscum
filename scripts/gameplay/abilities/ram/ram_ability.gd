class_name RamAbility
extends DriftAbility

@export var ram_speed_multiplier: float = 3.0

var _ram_engaged: bool = false

func act(caller: Entity, delta: float) -> void:
	super.act(caller, delta)
	var prey = caller.get_closest_prey()
	if not prey:
		caller.trigger_decision("target lost")
		return
	var distance = caller.global_position.distance_to(prey.global_position)
	var direction = caller.global_position.direction_to(prey.global_position)
	if distance > caller.get_max_range():
		_ram_engaged = false
		caller.turn_towards(direction)
		caller.engage_engine(caller.motor_force)
	elif not caller.is_facing(direction, 0.5) and not _ram_engaged:
		caller.turn_towards(direction)
	else:
		caller.engage_engine(caller.motor_force * ram_speed_multiplier)
