class_name MediumCollectible
extends StructuralCollectible

func _ready() -> void:
	sprites = []  # will be filled from inspector
	super._ready()
	scale = Vector2(1, 1)  # scales everything — sprite, collider, all children
