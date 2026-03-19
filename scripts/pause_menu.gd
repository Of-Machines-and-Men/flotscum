extends Control

@onready var pause_panel: Panel = $PausePanel
@onready var vbox: VBoxContainer = $PausePanel/VBoxContainer
@onready var settings_panel: Panel = $SettingsPanel
@onready var confirm_sound: AudioStreamPlayer2D = $ConfirmSound
@onready var nav_sound: AudioStreamPlayer2D = $NavSound
@onready var deny_sound: AudioStreamPlayer2D = $DenySound

func _ready() -> void:
	pause_panel.hide()
	settings_panel.hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func toggle_pause() -> void:
	var paused = !get_tree().paused
	get_tree().paused = paused
	pause_panel.visible = paused
	vbox.show()
	settings_panel.hide()
	
func _input(event):
	if event.is_action_pressed("ui_cancel"): #escape by default
		if settings_panel.visible:
			settings_panel.hide()
			vbox.show()
		else:
			toggle_pause()
	
func _on_button_mouse_entered() -> void:
	nav_sound.play()
	
func _on_resume_button_pressed() -> void:
	toggle_pause()
	confirm_sound.play()
	
func _on_settings_button_pressed() -> void:
	vbox.hide()
	settings_panel.show()
	confirm_sound.play()

func _on_quit_button_pressed() -> void:
	deny_sound.play()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/levels/UI/main_menu.tscn")
	
func _on_close_button_pressed() -> void:
	settings_panel.hide()
	deny_sound.play()
	vbox.show()
