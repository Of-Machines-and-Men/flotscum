extends Node

@onready var ambient_sound: AudioStreamPlayer2D = $AmbientSound

func _ready() -> void:
	ambient_sound.finished.connect(_on_ambient_finished)
	ambient_sound.play()

func _on_ambient_finished() -> void:
	ambient_sound.play()
