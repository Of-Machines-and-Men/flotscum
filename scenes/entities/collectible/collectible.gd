class_name Collectible
extends Entity

@export var drift_force: float = 5.0
@export var drift_interval: float = 2.0

var _drift_timer: float = 0.0
var _drift_direction: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	_randomise_drift()
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if is_attached:
		return
	_drift_timer -= delta
	if _drift_timer <= 0.0:
		_randomise_drift()
	apply_central_force(_drift_direction * drift_force)
	
func _randomise_drift() -> void:
	_drift_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	_drift_timer = drift_interval
	
func on_absorbed(absorber: Node) -> void:
	super.on_absorbed(absorber)
	activate()
	
func activate() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
