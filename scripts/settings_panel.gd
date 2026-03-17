extends Panel

@onready var master_slider: HSlider = $VBoxContainer/HBoxContainer/MasterSlider
@onready var fullscreen_toggle: CheckBox = $VBoxContainer/HBoxContainer2/FullscreenToggle

func _ready() -> void:
	# Restore saved settings if they exist
	master_slider.value = AudioServer.get_bus_volume_db(0)
	fullscreen_toggle.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)

func _on_fullscreen_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
func _on_close_button_pressed() -> void:
	hide()  # or whatever node the panel actually is
