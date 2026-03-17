class_name Ability
extends Resource

@export var engine_force: float = 100.0
@export var aggression: float = 0

func on_activated(_caller: Entity) -> void:
	pass
	
func on_deactivated(_caller: Entity) -> void:
	pass
	
func act(_caller: Entity, _delta: float) -> void:
	pass
