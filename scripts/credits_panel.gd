extends Panel

@onready var nav_sound: AudioStreamPlayer2D = $"../NavSound"
@onready var deny_sound: AudioStreamPlayer2D = $"../DenySound"

func _on_button_mouse_entered() -> void:
	nav_sound.play()

func _on_close_button_pressed() -> void:
	deny_sound.play()
	hide()  # or whatever node the panel actually is
