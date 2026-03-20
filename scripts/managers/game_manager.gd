extends Node

func trigger_game_over() -> void:
	var game_over = preload("res://scenes/levels/UI/game_over.tscn").instantiate()
	
	var canvas = CanvasLayer.new()
	canvas.layer = 100  # render ABOVE pixelation shader
	canvas.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().root.add_child(canvas)
	canvas.add_child(game_over)
	
	game_over.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
