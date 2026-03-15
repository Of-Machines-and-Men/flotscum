extends RigidBody2D

@export var thrust_force: float = 2000.0

func _ready():
	gravity_scale = 0.0
	linear_damp = 2.0
	angular_damp = 4.0

func get_mouse_orientation():
	var mouse_pos = get_global_mouse_position()
	return (mouse_pos - global_position).normalized()

func _physics_process(_delta):
	var direction = get_mouse_orientation()
	
	# Rotate to face mouse (visual only, instant... Might want to add a delay?))
	rotation = direction.angle()
	
	# THRUSTING MAKES ME FEEL GOOD
	if Input.is_action_pressed("moveup"):
		apply_central_force(Vector2.UP * thrust_force)
	if Input.is_action_pressed("movedown"):
		apply_central_force(Vector2.DOWN * thrust_force)
	if Input.is_action_pressed("moveleft"):
		apply_central_force(Vector2.LEFT * thrust_force)
	if Input.is_action_pressed("moveright"):
		apply_central_force(Vector2.RIGHT * thrust_force)
