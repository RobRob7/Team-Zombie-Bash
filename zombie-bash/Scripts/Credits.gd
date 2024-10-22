extends Node

# called when back button is pressed
func _on_back_button_pressed() -> void:
	if get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn") != OK:
		print ("Error changing scene to MainMenu")
