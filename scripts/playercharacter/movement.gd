extends RigidBody2D

@export var thrust_force: float = 400.0
@export var torque_strength: float = 200.0
@export var orient_to_mouse: bool = true

func _physics_process(delta: float) -> void:
	# --- Orientation toward mouse ---
	if orient_to_mouse:
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - global_position).normalized()
		var target_angle = direction.angle()
		# Use torque to turn toward mouse
		var angle_diff = wrapf(target_angle - rotation, -PI, PI)
		apply_torque(angle_diff * torque_strength)

	# --- Thrust in facing direction (e.g. hold W or auto-move) ---
	if Input.is_action_pressed("ui_up"):
		var force_dir = Vector2.RIGHT.rotated(rotation)
		apply_central_force(force_dir * thrust_force)
