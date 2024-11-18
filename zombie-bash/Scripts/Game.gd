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

# song position
var song_position = 0.0
# song position in beats
var song_position_in_beats = 0

# last spawned beat note
var last_spawned_beat = 0

# seconds per beat
var sec_per_beat = 60.0 / Global.bpm

# number of beats in song
var total_song_beats = 0.0


# number of notes to spawn per measure (1-4)
var spawn_1_beat = 0
var spawn_2_beat = 0
var spawn_3_beat = 1
var spawn_4_beat = 0

# lane chosen
var lane = 0

# random number
var rand = 0

# note scene
var note = load("res://Scenes/Note.tscn")

# note scene instance
var instance


# ran only once, when node enters scene
func _ready():
	# debug song info output
	print("Song: " + str(Global.currentSong))
	print("BPM: " + str(Global.bpm))
	print("Song Length: " + str(Global.songLengthSeconds))
	
	# set song name and bpm strings
	$LaneSystem3D/SongName.text = "Song: " + str(Global.currentSong)
	$LaneSystem3D/SongBPM.text = "BPM: " + str(Global.bpm)
	
	# reset total notes spawned
	Global.total_notes_spawned = 0
	
	# set total number of beats in song being played
	total_song_beats = (Global.songLengthSeconds / 60.0) * Global.bpm
	
	# 3D where notes are spawned on XZ plane (X as Y, Y as Z, Z as X)
	# X position of player vehicle
	Global.TARGET_X = $LaneSystem3D/ArrowLeft.global_position.x
	# X position of note/zombie spawn
	Global.SPAWN_X = $LaneSystem3D.global_position.x
	
	# Z position of left lane note/zombie spawn
	Global.SPAWN_Z[0] = $LaneSystem3D/ArrowLeft.global_position.z
	
	# Z position of middle lane note/zombie spawn
	Global.SPAWN_Z[1] = $LaneSystem3D/ArrowUp.global_position.z
	
	# Z position of right lane note/zombie spawn
	Global.SPAWN_Z[2] = $LaneSystem3D/ArrowRight.global_position.z
	
	Global.PLAYER_POS = $LaneSystem3D/Player
	
	# random seed set
	randomize()
	
	# play song with beat offset
	$Conductor.play_with_beat_offset(8)
	
	# play song from certain beat/point in song
	#$Conductor.play_from_beat(350, 8)
	
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


# every beat, this is called, to spawn x notes per measure per beat range
func _on_Conductor_beat(position):
	song_position_in_beats = position
	if song_position_in_beats > total_song_beats / 10.0:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 2 * (total_song_beats / 10.0):
		spawn_1_beat = 2
		spawn_2_beat = 0
		spawn_3_beat = 1
		spawn_4_beat = 0
	if song_position_in_beats > 3 * (total_song_beats / 10.0):
		spawn_1_beat = 0
		spawn_2_beat = 2
		spawn_3_beat = 0
		spawn_4_beat = 2
	if song_position_in_beats > 4 * (total_song_beats / 10.0):
		spawn_1_beat = 2
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 5 * (total_song_beats / 10.0):
		spawn_1_beat = 2
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 2
	if song_position_in_beats > 6 * (total_song_beats / 10.0):
		spawn_1_beat = 0
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 2
	if song_position_in_beats > 7 * (total_song_beats / 10.0):
		spawn_1_beat = 1
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 2
	if song_position_in_beats > 8 * (total_song_beats / 10.0):
		spawn_1_beat = 0
		spawn_2_beat = 2
		spawn_3_beat = 0
		spawn_4_beat = 2
	if song_position_in_beats > 9 * (total_song_beats / 10.0):
		spawn_1_beat = 3
		spawn_2_beat = 2
		spawn_3_beat = 2
		spawn_4_beat = 1
	if song_position_in_beats > 9.5 * (total_song_beats / 10.0):
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
	if song_position_in_beats > total_song_beats - 12:
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
	if song_position_in_beats > total_song_beats:
		Global.set_score_grade(score)
		Global.combo = max_combo
		Global.great = great
		Global.good = good
		Global.okay = okay
		Global.missed = missed
		print(Global.total_notes_spawned)
		if get_tree().change_scene_to_file("res://Scenes/End.tscn") != OK:
			print ("Error changing scene to End")


func NoteMissedReaction():
	$LaneSystem3D/NoteMissedLabel.text = "MISS"
	await get_tree().create_timer(0.3).timeout
	$LaneSystem3D/NoteMissedLabel.text = ""
	
	
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
	# keep track of total notes spawned
	Global.total_notes_spawned += to_spawn
	
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
		reset_combo()
	
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
	$LaneSystem3D/Score.text = str(score)

	# if combo > 0
	if combo > 0:
		# update combo text
		$LaneSystem3D/Combo.text = str(combo) + " combo!"

		# if combo exceeds previous max combo
		if combo > max_combo:
			# set new max combo
			max_combo = combo
			
		# emit combo change signal
		Global.combo_changed.emit(combo)
	# if combo <= 0
	else:
		# update combo text (none)
		$LaneSystem3D/Combo.text = ""


# will reset combo count
func reset_combo():
	# set combo back to zero
	combo = 0

	# update combo text (none)
	$LaneSystem3D/Combo.text = ""
