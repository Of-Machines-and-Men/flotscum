class_name Entity
extends RigidBody2D

@export var thrust_force: float = 2000.0

func _ready():
	gravity_scale = 0.0
	linear_damp = 2.0
	angular_damp = 4.0

func get_mouse_orientation():
	var mouse_pos = get_global_mouse_position()
	return (mouse_pos - global_position).normalized()
