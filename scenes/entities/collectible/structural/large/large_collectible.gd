class_name LargeCollectible
extends StructuralCollectible

func _ready() -> void:
	collider.scale = Vector2(2.0, 2.0)
	super._ready()
