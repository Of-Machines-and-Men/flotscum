class_name WanderAbility
extends DriftAbility

@export var wander_change_interval: float = 3.0

var _wander_direction: Vector2 = Vector2.ZERO
var _wander_timer: float = wander_change_interval

func act(caller: Entity, delta: float) -> void:
	super.act(caller, delta)
	var wander_force = engine_force * caller.mass
	_wander_timer -= delta
	if _wander_timer <= 0.0:
		_wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		_wander_timer = wander_change_interval
	caller.apply_central_force(_wander_direction * wander_force)
