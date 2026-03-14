class_name Entity
extends RigidBody2D

var is_attached: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func on_absorbed(absorber: Node) -> void:
	if is_attached:
#		we can handle collisions with hostiles here
		return
	is_attached = true
	freeze = true
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	reparent(absorber, true)
