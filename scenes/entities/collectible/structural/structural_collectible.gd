class_name StructuralCollectible
extends Collectible

@export var sprites: Array[Texture2D] = []
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	super._ready()
	_randomise_sprite()

func _randomise_sprite() -> void:
	if sprites.is_empty():
		push_error("No sprites assigned!")
		return
	sprite.texture = sprites[randi() % sprites.size()]

func activate() -> void:
	pass
