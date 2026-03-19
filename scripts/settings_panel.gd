extends Panel

@onready var master_slider: HSlider = $VBoxContainer/HBoxContainer/MasterSlider
@onready var fullscreen_toggle: CheckBox = $VBoxContainer/HBoxContainer2/FullscreenToggle
@onready var confirm_sound: AudioStreamPlayer2D = $"../ConfirmSound"
@onready var nav_sound: AudioStreamPlayer2D = $"../NavSound"
@onready var deny_sound: AudioStreamPlayer2D = $"../DenySound"

func _ready() -> void:
	# Restore saved settings if they exist
	master_slider.value = AudioServer.get_bus_volume_db(0)
	fullscreen_toggle.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)

func _on_fullscreen_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		confirm_sound.play()
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		deny_sound.play()
		
func _on_button_mouse_entered() -> void:
	nav_sound.play()
	
func _on_close_button_pressed() -> void:
	deny_sound.play()
	hide()  # or whatever node the panel actually is
	
