extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# called when back button is presseds
func _on_back_button_pressed() -> void:
	if get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn") != OK:
		print ("Error changing scene to MainMenu")
