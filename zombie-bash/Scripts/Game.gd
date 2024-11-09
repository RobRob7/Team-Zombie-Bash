extends Node

# current score
var score = 0

# current combo
var combo = 0

# current max combo
var max_combo = 0

# keeps track of total types of hits
var great = 0
var good = 0
var okay = 0
var missed = 0

# song bpm
@export var bpm = 115

# song position
var song_position = 0.0

# song position in beats
var song_position_in_beats = 0

# last spawned beat note
var last_spawned_beat = 0

# seconds per beat
var sec_per_beat = 60.0 / bpm

# number of notes to spawn per measure (1-4)
var spawn_1_beat = 0
var spawn_2_beat = 0
var spawn_3_beat = 1
var spawn_4_beat = 0

# lane chosen
var lane = 0

# random number
var rand = 0

# note
var note = load("res://Scenes/Note.tscn")

# instance of note
var instance


# ran only once, when node enters scene
func _ready():
	# hide paused screen
	
	# random seed set
	randomize()
	
	# play song with beat offset
	$Conductor.play_with_beat_offset(8)
	
	# play song from certain beat/point in song
	#$Conductor.play_from_beat(200, 8)
	
	# connect beat signal with _on_Conductor_beat
	Global.beat.connect(_on_Conductor_beat)
	
	# connect measure signal with _on_Conductor_measure
	Global.measure.connect(_on_Conductor_measure)


# on any input check
func _input(event):
	# if escape is pressed
	if event.is_action_pressed("escape"):
		# load main menu scene
		if get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn") != OK:
			print ("Error changing scene to MainMenu")


# # sets the number of spawn arrow notes for each measure
# func _on_Conductor_beat(position):
# 	song_position_in_beats = position
# 	if song_position_in_beats > 36:
# 		spawn_1_beat = 1
# 		spawn_2_beat = 1
# 		spawn_3_beat = 1
# 		spawn_4_beat = 1
# 	if song_position_in_beats > 98:
# 		spawn_1_beat = 2
# 		spawn_2_beat = 0
# 		spawn_3_beat = 1
# 		spawn_4_beat = 0
# 	if song_position_in_beats > 132:
# 		spawn_1_beat = 0
# 		spawn_2_beat = 2
# 		spawn_3_beat = 0
# 		spawn_4_beat = 2
# 	if song_position_in_beats > 162:
# 		spawn_1_beat = 2
# 		spawn_2_beat = 2
# 		spawn_3_beat = 1
# 		spawn_4_beat = 1
# 	if song_position_in_beats > 194:
# 		spawn_1_beat = 2
# 		spawn_2_beat = 2
# 		spawn_3_beat = 1
# 		spawn_4_beat = 2
# 	if song_position_in_beats > 228:
# 		spawn_1_beat = 0
# 		spawn_2_beat = 2
# 		spawn_3_beat = 1
# 		spawn_4_beat = 2
# 	if song_position_in_beats > 258:
# 		spawn_1_beat = 1
# 		spawn_2_beat = 2
# 		spawn_3_beat = 1
# 		spawn_4_beat = 2
# 	if song_position_in_beats > 288:
# 		spawn_1_beat = 0
# 		spawn_2_beat = 2
# 		spawn_3_beat = 0
# 		spawn_4_beat = 2
# 	if song_position_in_beats > 322:
# 		spawn_1_beat = 3
# 		spawn_2_beat = 2
# 		spawn_3_beat = 2
# 		spawn_4_beat = 1
# 	if song_position_in_beats > 388:
# 		spawn_1_beat = 1
# 		spawn_2_beat = 0
# 		spawn_3_beat = 0
# 		spawn_4_beat = 0
# 	if song_position_in_beats > 396:
# 		spawn_1_beat = 0
# 		spawn_2_beat = 0
# 		spawn_3_beat = 0
# 		spawn_4_beat = 0
# 	if song_position_in_beats > 404:
# 		Global.set_score(score)
# 		Global.combo = max_combo
# 		Global.great = great
# 		Global.good = good
# 		Global.okay = okay
# 		Global.missed = missed
# 		if get_tree().change_scene_to_file("res://Scenes/End.tscn") != OK:
# 			print ("Error changing scene to End")


# sets the number of spawn arrow notes for each measure
func _on_Conductor_beat(position):
	song_position_in_beats = position
	if song_position_in_beats > 36:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 98:
		spawn_1_beat = 2
		spawn_2_beat = 0
		spawn_3_beat = 1
		spawn_4_beat = 0
	if song_position_in_beats > 132:
		spawn_1_beat = 0
		spawn_2_beat = 2
		spawn_3_beat = 0
		spawn_4_beat = 2
	if song_position_in_beats > 162:
		spawn_1_beat = 2
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 194:
		spawn_1_beat = 2
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 2
	if song_position_in_beats > 228:
		spawn_1_beat = 0
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 2
	if song_position_in_beats > 258:
		spawn_1_beat = 1
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 2
	if song_position_in_beats > 288:
		spawn_1_beat = 0
		spawn_2_beat = 2
		spawn_3_beat = 0
		spawn_4_beat = 2
	if song_position_in_beats > 322:
		spawn_1_beat = 3
		spawn_2_beat = 2
		spawn_3_beat = 2
		spawn_4_beat = 1
	if song_position_in_beats > 388:
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
	if song_position_in_beats > 396:
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
	if song_position_in_beats > 404:
		Global.set_score(score)
		Global.combo = max_combo
		Global.great = great
		Global.good = good
		Global.okay = okay
		Global.missed = missed
		if get_tree().change_scene_to_file("res://Scenes/End.tscn") != OK:
			print ("Error changing scene to End")

func NoteMissedReaction():
	print("TEST")
	$NoteMissedLabel.text = "MISS"
	print("TEST1.5")
	await get_tree().create_timer(0.3).timeout
	print("TEST2")
	$NoteMissedLabel.text = ""
# spawns notes based on measure position
func _on_Conductor_measure(position):
	# if measure is 1
	if position == 1:
		# spawn notes
		_spawn_notes(spawn_1_beat)
	# if measure is 2
	elif position == 2:
		# spawn notes
		_spawn_notes(spawn_2_beat)
	# if measure is 3
	elif position == 3:
		# spawn notes
		_spawn_notes(spawn_3_beat)
	# if measure is 4
	elif position == 4:
		# spawn notes
		_spawn_notes(spawn_4_beat)


# will spawn notes in lanes
func _spawn_notes(to_spawn):
	# notes to spawn > 0
	if to_spawn > 0:
		# random lane (0, 1, 2)
		lane = randi() % 3

		# create instance of note
		instance = note.instantiate()

		# initialize instanced note with lane
		instance.initialize(lane)

		# add this instance note as a child
		add_child(instance)

	# notes to spawn > 1
	if to_spawn > 1:
		# while random number == lane number
		while rand == lane:
			# set random number to (0-2)
			rand = randi() % 3
		
		# lane is set to random number
		lane = rand

		# create instance of note
		instance = note.instantiate()

		# initialize instanced note with lane
		instance.initialize(lane)

		# add this instance note as a child
		add_child(instance)
	

# will increment score based on performance
func increment_score(scoreIncrementValue):
	# increment combo by 1 if scoreIncrementValue > 0
	if scoreIncrementValue > 0:
		combo += 1
	# reset combo to zero if scoreIncrementValue <= 0
	else:
		combo = 0
	
	# score increment value is 3 (great hit)
	if scoreIncrementValue == 3:
		great += 1
	# score increment value is 2 (good hit)
	elif scoreIncrementValue == 2:
		good += 1
	# score increment value is 1 (okay hit)
	elif scoreIncrementValue == 1:
		okay += 1
	# if by <= 0 (missed hit)
	else:
		missed += 1
	
	# increment score (factoring combo and scoreIncrementValue)
	score += scoreIncrementValue * combo

	# update score display
	$Label.text = str(score)

	# if combo > 0
	if combo > 0:
		# update combo text
		$Combo.text = str(combo) + " combo!"

		# if combo exceeds previous max combo
		if combo > max_combo:
			# set new max combo
			max_combo = combo
	# if combo <= 0
	else:
		# update combo text (none)
		$Combo.text = ""


# will reset combo count
func reset_combo():
	# set combo back to zero
	combo = 0

	# update combo text (none)
	$Combo.text = ""
