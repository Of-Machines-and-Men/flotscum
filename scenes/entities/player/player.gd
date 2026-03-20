class_name Player
extends Entity

@onready var swim_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	add_to_group("player")
	
func _on_death() -> void:
	super._on_death()  # still runs the base death logic
	GameManager.trigger_game_over()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_rotate_towards_mouse()
	_apply_input_force()
	_play_swim_sound()

func _apply_input_force() -> void:
	var input = Vector2(
		Input.get_axis("moveleft", "moveright"),
		Input.get_axis("moveup", "movedown")
	).normalized()
	
	if input != Vector2.ZERO:
		apply_central_force(input * get_motor_force())

func _rotate_towards_mouse() -> void:
	var mouse_pos = get_global_mouse_position()
	var target_direction = global_position.direction_to(mouse_pos)
	turn_towards(target_direction)

func _play_swim_sound() -> void:
	var is_moving = linear_velocity.length() > 10.0
	
	if is_moving and not swim_sound.playing:
		swim_sound.play()
	elif not is_moving and swim_sound.playing:
		swim_sound.stop()
