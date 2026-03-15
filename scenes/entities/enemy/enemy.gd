class_name Enemy
extends Entity

@export var move_force: float = 50.0
@export var detection_radius: float = 200.0

var _target: Node2D = null

func find_target() -> void:
	_target = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	find_target()

func _physics_process(_delta: float) -> void:
	if is_attached:
		return
	if not _target:
		find_target()
		return
	var distance = global_position.distance_to(_target.global_position)
	var direction = global_position.direction_to(_target.global_position)
	if distance < detection_radius:
		apply_central_force(direction * move_force)
