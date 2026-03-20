# game_manager.gd
extends Node

func trigger_game_over() -> void:
	get_tree().paused = true
	get_tree().change_scene_to_file("res://scenes/ui/game_over.tscn")
