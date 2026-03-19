class_name Rammer
extends Enemy

@export var max_swing_angle: float = 25.0
@export var max_net_distance: float = 40.0 

@onready var net: StaticBody2D = $"Net Attach Point/Net"
@onready var attach_point: Marker2D = $"Net Attach Point"

func _ready() -> void:
	super._ready()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_constrain_net()

func _constrain_net() -> void:
	var attach_pos = attach_point.global_position
	var back_dir = Vector2.LEFT.rotated(rotation)  # adjust LEFT/RIGHT to match your sprite
	var target_pos = attach_pos + back_dir * max_net_distance
	net.global_position = net.global_position.lerp(target_pos, 0.3)
	net.rotation = lerp_angle(net.rotation, rotation, 0.3)
