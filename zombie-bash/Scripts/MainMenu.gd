extends Node

# slider interacted with (increases/decreases volume in db)
func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

# called when test button pressed (play sound for audio tuning purposes)
func _on_texture_button_pressed() -> void:
	$CanvasLayer/Main/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/TextureButton/AudioStreamPlayer.play()

# play button pressed (start game)
func _on_play_button_pressed() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db($CanvasLayer/Main/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HSlider.value))
	if get_tree().change_scene_to_file("res://Scenes/Game.tscn") != OK:
		print ("Error changing scene to Game")

# quit button pressed (close window)
func _on_quit_button_pressed() -> void:
	get_tree().quit()
