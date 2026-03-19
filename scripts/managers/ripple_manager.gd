extends MeshInstance2D

func _physics_process(delta: float) -> void:
	if get_parent() is Entity:
		var parent = get_parent() as Entity
		
		# Ripple always shows but intensifies with speed
		var speed_factor = clamp(parent.linear_velocity.length() / 30.0, 0.2, 1.0)
		modulate.a = speed_factor
		
		# Scale ripple with speed — bigger wake when moving faster
		var scale_factor = lerp(0.8, 1.3, speed_factor)
		scale = Vector2(scale_factor, scale_factor)
