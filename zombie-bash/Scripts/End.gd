extends Node2D

# set the score labels
func _ready():
	$End/CanvasLayer/Control/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GradeNumber.text = Global.grade
	$End/CanvasLayer/Control/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ScoreNumber.text = str(Global.score)
	$End/CanvasLayer/Control/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ComboNumber.text = str(Global.combo)
	$End/CanvasLayer/Control/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GreatNumber.text = str(Global.great)
	$End/CanvasLayer/Control/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GoodNumber.text = str(Global.good)
	$End/CanvasLayer/Control/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/OkayNumber.text = str(Global.okay)
	$End/CanvasLayer/Control/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/MissedNumber.text = str(Global.missed)
	
	# play end YAY sound
	$AudioStreamPlayer.stream = load("res://Sounds/Audio/endYAY.mp3")
	$AudioStreamPlayer.play()
	

# play again pressed (replay level)
func _on_play_again_button_pressed() -> void:
	if get_tree().change_scene_to_file("res://Scenes/Game.tscn") != OK:
			print ("Error changing scene to Game")

# back to menu pressed (quit to main menu)
func _on_back_to_menu_button_pressed() -> void:
	if get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn") != OK:
			print ("Error changing scene to Menu")
