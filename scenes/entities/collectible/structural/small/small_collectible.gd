class_name SmallCollectible
extends StructuralCollectible

func _ready() -> void:
	super._ready()
	sprite.scale = Vector2(0.5, 0.5)
	collider.scale = Vector2(0.5, 0.5)
