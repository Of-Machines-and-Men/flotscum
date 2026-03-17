extends Camera2D

@export var target: NodePath
@export var deadzone: float = 150.0
@export var min_speed: float = 250.0
@export var max_speed: float = 1000.0
@export var speed_ramp: float = 7.0 # speed co-efficient

var _target_node: RigidBody2D

func _ready():
	_target_node = get_node(target)
	# Disable smoothing, we'll do it ourselves
	position_smoothing_enabled = false
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_ON

func _process(delta):
	if not _target_node:
		return
	
	var target_pos = _target_node.global_position
	var distance = global_position.distance_to(target_pos)
	var outside = distance - deadzone
	
	# Check how far outside the box the player is
	if outside > 0:
		var direction = (target_pos - global_position).normalized()
		var speed = clamp(outside * speed_ramp, min_speed, max_speed)
		var desired_pos = global_position + direction * speed * delta
		# Lerp toward desired position instead of snapping
		global_position = lerp(global_position, desired_pos, 0.2)
