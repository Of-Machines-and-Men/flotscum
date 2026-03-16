class_name Entity
extends RigidBody2D

var is_attached: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity_scale = 0.0
	add_to_group("entities")
	pass # Replace with function body.
	
func _physics_process(delta: float) -> void:
	if is_attached:
		return
	_apply_current_force()

func _apply_current_force() -> void:
	var current_direction = _get_ocean_current_direction()
	var current_strength = _get_ocean_current_strength()
	var current_influence = 1.0 / mass
	apply_central_force(current_direction * current_strength * current_influence)
	
func _get_ocean_current_direction() -> Vector2:
	if Engine.has_singleton("OceanCurrentManager"):
		return OceanCurrentManager.get_current_direction_at_location(global_position)
	else:
		return Vector2(0.0, 0.0).normalized()

func _get_ocean_current_strength() -> float:
	if Engine.has_singleton("OceanCurrentManager"):
		return OceanCurrentManager.get_current_strength_at_location(global_position)
	else:
		return 0.0

func on_absorbed(absorber: Node) -> void:
	if is_attached:
#		we can handle collisions with hostiles here
		return
	is_attached = true
	freeze = true
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	reparent(absorber, true)
