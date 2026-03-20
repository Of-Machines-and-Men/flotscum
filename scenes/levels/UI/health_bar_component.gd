extends Node2D

@export var bar_width: float = 50.0
@export var bar_height: float = 6.0
@export var offset: Vector2 = Vector2(0, -40)  # above the entity

var max_health: int = 1
var current_health: int = 1

func _process(_delta: float) -> void:
	# Counteract parent rotation to stay upright
	global_rotation = 0.0
	global_position = get_parent().global_position + offset
	
func _ready() -> void:
	position = offset

func setup(base_health: int, curr_health: int) -> void:
	max_health = base_health
	current_health = curr_health
	queue_redraw()

func update_health(curr_health: int) -> void:
	current_health = max(curr_health, 0)
	queue_redraw()

func _draw() -> void:
	# Background (red)
	draw_rect(Rect2(-bar_width / 2, 0, bar_width, bar_height), Color.RED)
	
	# Foreground (green)
	var fill = (float(current_health) / float(max_health)) * bar_width
	draw_rect(Rect2(-bar_width / 2, 0, fill, bar_height), Color.GREEN)
	
	# Border
	draw_rect(Rect2(-bar_width / 2, 0, bar_width, bar_height), Color.BLACK, false, 1.0)
