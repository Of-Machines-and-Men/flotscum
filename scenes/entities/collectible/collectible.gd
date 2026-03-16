class_name Collectible
extends Entity

@export var drift_force: float = 5.0
@export var drift_interval: float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
func _on_absorbed(absorber: Node) -> void:
	super._on_absorbed(absorber)
	activate()
	
func activate() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
