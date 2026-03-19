extends MeshInstance2D

@export var is_wake: bool = true

func _physics_process(delta: float) -> void:
	if is_wake and get_parent() is Entity:
		var parent = get_parent() as Entity

		rotation = parent.rotation - PI / 2

		# Fade in/out with speed
		var speed_factor = clamp(parent.linear_velocity.length() / 50.0, 0.0, 1.0)
		modulate.a = speed_factor
