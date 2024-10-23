extends Button



func _on_pressed_play() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(Global.main_volume_value))
	if get_tree().change_scene_to_file("res://Scenes/Game.tscn") != OK:
		print ("Error changing scene to Game")

	
