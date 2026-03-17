extends ColorRect

@onready var _material: ShaderMaterial = material

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_material.set_shader_parameter("viewport_size", get_viewport_rect().size)

func _process(_delta: float) -> void:
	var camera = get_viewport().get_camera_2d()
	if camera:
		_material.set_shader_parameter("camera_position", camera.global_position)
