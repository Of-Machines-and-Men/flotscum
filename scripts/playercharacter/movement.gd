extends RigidBody2D

@export var thrust_force: float = 2000.0

func _ready():
	gravity_scale = 0.0
	linear_damp = 2.0
	angular_damp = 4.0

func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	# Rotate to face mouse (visual only, instant)
	rotation = direction.angle()
	
	# Always thrust toward mouse
	if Input.is_action_pressed("ui_up"):
		apply_central_force(direction * thrust_force)
