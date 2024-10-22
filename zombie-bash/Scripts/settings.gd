extends Node

# ran only once, when node enters scene
func _ready():
	$Main/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HSlider.value = Global.main_volume_value

# slider interacted with (increases/decreases volume in db)
func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	Global.main_volume_value = value

# called when back button is pressed
func _on_back_button_pressed() -> void:
	if get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn") != OK:
		print ("Error changing scene to MainMenu")
