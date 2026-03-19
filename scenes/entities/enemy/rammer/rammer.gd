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
