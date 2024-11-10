extends Node

# will contain song list button
var dropdown


# ran only once, when node enters scene
func _ready() -> void:
	# song list button
	dropdown = $CanvasLayer/Main/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/SongListButton
	
	# populate the dropdown list
	populate_song_dropdown_list(dropdown)
	
	# set inital default song
	Global.currentSong = dropdown.get_item_text(dropdown.get_selected())
	Global.bpm = Global.song_list[Global.currentSong]
	
	# debug output song info
	print(Global.currentSong)
	print(Global.bpm)
	

# called when start game button is pressed
func _on_start_button_pressed() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(Global.main_volume_value))
	if get_tree().change_scene_to_file("res://Scenes/Game.tscn") != OK:
		print ("Error changing scene to Game")
		

# function populates the dropdown list
func populate_song_dropdown_list(song_list_button : OptionButton):
	# loop through all songs
	for key in Global.song_list:
		# add song name to dropdown list
		song_list_button.add_item(key)


# called when song list option selected
func _on_song_list_button_item_selected(index: int) -> void:
	Global.currentSong = dropdown.get_item_text(index)
	Global.bpm = Global.song_list[Global.currentSong]
	print(dropdown.get_item_text(index))


# called when back button is pressed
func _on_back_button_pressed() -> void:
	if get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn") != OK:
		print ("Error changing scene to MainMenu")
