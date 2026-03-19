extends Control

@onready var settings_panel: Panel = $SettingsPanel
@onready var credits_panel: Panel = $CreditsPanel
@onready var confirm_sound: AudioStreamPlayer2D = $ConfirmSound
@onready var nav_sound: AudioStreamPlayer2D = $NavSound
@onready var deny_sound: AudioStreamPlayer2D = $DenySound

func _ready() -> void:
	settings_panel.hide()
	credits_panel.hide()

# Hover sounds
func _on_button_mouse_entered() -> void:
	nav_sound.play()


func _on_play_button_pressed() -> void:
	confirm_sound.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://scenes/levels/game_world.tscn")

func _on_settings_button_pressed() -> void:
	confirm_sound.play()
	credits_panel.hide()
	settings_panel.visible = !settings_panel.visible

func _on_credits_button_pressed() -> void:
	confirm_sound.play()
	settings_panel.hide()
	credits_panel.visible = !credits_panel.visible

func _on_quit_button_pressed() -> void:
	deny_sound.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()

func _on_close_pressed() -> void:
	deny_sound.play()
	settings_panel.hide()
	credits_panel.hide()
