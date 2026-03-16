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

func _physics_process(delta):
	if not _target_node:
		return
	
	var target_pos = _target_node.global_position
	var distance = global_position.distance_to(target_pos)
	var outside = distance - deadzone
	
	# Check how far outside the box the player is
	if outside > 0:
		var direction = (target_pos - global_position).normalized()
		var speed = clamp(outside * speed_ramp, min_speed, max_speed)
		global_position += direction * speed * delta
