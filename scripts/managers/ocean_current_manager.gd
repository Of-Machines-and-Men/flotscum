extends Node

func get_current_direction_at_location(_position: Vector2) -> Vector2:
	return Vector2(1.0, 0.5).normalized()

func get_current_strength_at_location(_position: Vector2) -> float:
	return 10.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
