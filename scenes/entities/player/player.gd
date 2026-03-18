class_name Player
extends Entity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	add_to_group("player")

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_rotate_towards_mouse()
	_apply_input_force()
	
func _apply_input_force() -> void:
	var input = Vector2(
		Input.get_axis("moveleft", "moveright"),
		Input.get_axis("moveup", "movedown")
	).normalized()
	
	if input != Vector2.ZERO:
		apply_central_force(input * motor_force)

func _rotate_towards_mouse() -> void:
	var mouse_pos = get_global_mouse_position()
	var target_direction = global_position.direction_to(mouse_pos)
	turn_towards(target_direction)
