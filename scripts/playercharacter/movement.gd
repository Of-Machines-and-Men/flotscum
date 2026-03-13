extends RigidBody2D

@export var thrust_force: float = 2000.0
@export var strafe_force: float = 1500.0

func _ready():
	gravity_scale = 0.0
	linear_damp = 2.0
	angular_damp = 4.0

func get_mouse_orientation():
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	var strafe = direction.rotated(PI / 2) # So the idea is that it grabs each direction to left and right. Which are strafe directions, the only issue is - this is tank control-like....
	return {"direction": direction, "strafe": strafe}

func _physics_process(delta):
	var orient = get_mouse_orientation()
	var direction = orient["direction"]
	var strafe = orient["strafe"]
	
	# Rotate to face mouse (visual only, instant... Might want to add a delay?))
	rotation = direction.angle()
	
	# THRUSTING MAKES ME FEEL GOOD
	if Input.is_action_pressed("ui_up"):
		apply_central_force(direction * thrust_force)
		
	if Input.is_action_pressed("ui_down"):
		apply_central_force(-direction * thrust_force)
		
	# STRAFING MAKE ME - feel not as good, but - FEEL GOOD
	if Input.is_action_pressed("ui_left"):
		apply_central_force(-strafe * strafe_force)
	if Input.is_action_pressed("ui_right"):
		apply_central_force(strafe * strafe_force)
