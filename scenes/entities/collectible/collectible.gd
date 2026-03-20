class_name Collectible
extends Entity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	if health_bar:
		health_bar.hide()
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
func _on_attach(absorber: Node) -> void:
	super._on_attach(absorber)
	activate()
	if health_bar:
		health_bar.show()
	
func activate() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
