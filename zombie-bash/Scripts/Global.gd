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
var bpm = 128

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
	
	# higher score possible (assuming avg_combo and highest_key_hit_performance)
	var avg_combo = 45
	var highest_key_hit_performance = 3
	var high_score_max = total_notes_spawned * (highest_key_hit_performance + highest_key_hit_performance * avg_combo)
	
	# the score ranges for each grade letter
	var score_ranges = [0.95, 0.90, 0.85, 0.80, 0.75, 0.70, 0.65, 0.60, 0.55, 0.50, 0.45, 0.40]
	
	# tuning value to highest score possible
	var high_score_max_tune = 0.9
	
	print(high_score_max)
	print(high_score_max * high_score_max_tune)
	
	# set grade based on score
	if score > score_ranges[0] * (high_score_max_tune * high_score_max):
		grade = "A+"
	elif score > score_ranges[1] * (high_score_max_tune * high_score_max):
		grade = "A"
	elif score > score_ranges[2] * (high_score_max_tune * high_score_max):
		grade = "A-"
	elif score > score_ranges[3] * (high_score_max_tune * high_score_max):
		grade = "B+"
	elif score > score_ranges[4] * (high_score_max_tune * high_score_max):
		grade = "B"
	elif score > score_ranges[5] * (high_score_max_tune * high_score_max):
		grade = "B-"
	elif score > score_ranges[6] * (high_score_max_tune * high_score_max):
		grade = "C+"
	elif score > score_ranges[7] * (high_score_max_tune * high_score_max):
		grade = "C"
	elif score > score_ranges[8] * (high_score_max_tune * high_score_max):
		grade = "C-"
	elif score > score_ranges[9] * (high_score_max_tune * high_score_max):
		grade = "D+"
	elif score > score_ranges[10] * (high_score_max_tune * high_score_max):
		grade = "D"
	elif score > score_ranges[11] * (high_score_max_tune * high_score_max):
		grade = "D-"
	else:
		grade = "F"
		
