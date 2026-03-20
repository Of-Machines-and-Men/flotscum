class_name Rammer
extends Enemy

@export var ram_base_damage: int = 1
@export var ram_minimum_speed: float = 80.0
@export var ram_maximum_speed: float = 200.0
@export var ram_damage_multiplier: int = 5

func _ready() -> void:
	super._ready()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
func _on_damage_zone_entered(damage_receiver: Node) -> void:
	var damage_multiplier = _get_damage_multiplier(damage_receiver)
	if damage_multiplier > 0:
		on_apply_damage(ram_base_damage * damage_multiplier, damage_receiver)

func _get_relative_speed(relative_to: Node) -> float:
	if not relative_to:
		return 0.0
	return (relative_to.linear_velocity - linear_velocity).length()

func _get_damage_multiplier(target: Node) -> int:
	var speed_range: float = ram_maximum_speed - ram_minimum_speed
	var current_relative_speed = _get_relative_speed(target)
	if current_relative_speed > ram_minimum_speed:
		return floori(speed_range / (current_relative_speed - ram_minimum_speed) * ram_damage_multiplier)
	else:
		return 0
