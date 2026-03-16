extends Camera2D

@export var target: NodePath
@export var box_size: Vector2 = Vector2(200, 150) # Deadzone
@export var min_speed: float = 50.0
@export var max_speed: float = 600.0
@export var speed_ramp: float = 3.0 # speed co-efficient

var _target_node: RigidBody2D

func _ready():
	_target_node = get_node(target)
	# Disable smoothing, we'll do it ourselves
	position_smoothing_enabled = false

func _physics_process(delta):
	if not _target_node:
		return
	
	var target_pos = _target_node.global_position
	var cam_pos = global_position
	var offset = target_pos - cam_pos
	
	# Check how far outside the box the player is
	var outside = Vector2.ZERO
	if abs(offset.x) > box_size.x:
		outside.x = offset.x - sign(offset.x) * box_size.x
	if abs(offset.y) > box_size.y:
		outside.y = offset.y - sign(offset.y) * box_size.y
	
	# Move faster the further outside the box the player is
	if outside.length() > 0:
		var speed = clamp(outside.length() * speed_ramp, min_speed, max_speed)
		global_position += outside.normalized() * speed * delta
