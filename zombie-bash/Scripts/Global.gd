extends Node2D

# signal: reports song position in beats on every beat
signal beat(position)

# signal: reports measure of song on every beat
signal measure(position)

# signal: reports the new combo
signal combo_changed(new_combo)

# stats tracked during game
var score = 0
var combo = 0
var great = 0
var good = 0
var okay = 0
var missed = 0
var grade = "NA"

# bpm of song
@export var bpm = 115

# song length in seconds
var songLengthSeconds = 0

# total number of notes/zombies spawned
var total_notes_spawned = 0

# will contain main volume value
var main_volume_value = 1.0

# y position of arrow buttons on lane (the ones that are static)
var TARGET_Y = 0.0

# y position where note is spawned
var SPAWN_Y = 0.0

# x positions for note spawn
var SPAWN_X = [0.0, 0.0, 0.0]

# will set the score grade for end screen stats
func set_score_grade(new):
	# update latest score
	score = new
	
	# higher score possible
	var high_score = total_notes_spawned * 125
	
	# set grade based on score
	if score > 13*(high_score - (high_score * 1.0/13.0)) / 13:
		grade = "A+"
	elif score > 12*(high_score - (high_score * 1.0/13.0)) / 13:
		grade = "A"
	elif score > 11*(high_score - (high_score * 1.0/13.0)) / 13:
		grade = "A-"
	elif score > 10*(high_score - (high_score * 1.0/13.0)) / 13:
		grade = "B+"
	elif score > 9*(high_score - (high_score * 1.0/13.0)) / 13:
		grade = "B"
	elif score > 8*(high_score - (high_score * 1.0/13.0)) / 13:
		grade = "B-"
	elif score > 7*(high_score - (high_score * 1.0/13.0)) / 13:
		grade = "C+"
	elif score > 6*(high_score - (high_score * 1.0/13.0)) / 13:
		grade = "C"
	elif score > 5*(high_score - (high_score * 1.0/13.0)) / 13:
		grade = "C-"
	elif score > 4*(high_score - (high_score * 1.0/13.0)) / 13:
		grade = "D+"
	elif score > 3*(high_score - (high_score * 1.0/13.0)) / 13:
		grade = "D"
	elif score > 2*(high_score - (high_score * 1.0/13.0)) / 13:
		grade = "D-"
	else:
		grade = "F"
		
