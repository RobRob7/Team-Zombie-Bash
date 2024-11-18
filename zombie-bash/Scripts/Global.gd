extends Node3D

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

# difficulty
# (0 = easy, 1 = medium, 2 = hard)
var difficulty = 0

# difficulty values
var difficulty_values = [
	2.0, 1.3, 0.9
]

# song dictionary (name to bpm)
var song_list = {
	"Curbi - What You Like [NCS Release].mp3" : 128,
	"RIOT - Pushing On [NCS Release].mp3" : 149,
	"Sippy, RIOT - Pump Up The Bassline [NCS Release].mp3" : 150
}

# default song
var currentSong = "Curbi - What You Like [NCS Release].mp3"

# bpm of song
var bpm = song_list[currentSong]

# song length in seconds
var songLengthSeconds = 0

# total number of notes/zombies spawned
var total_notes_spawned = 0

# will contain main volume value
var main_volume_value = 1.0

# 3D where notes are spawned on XZ plane (X as Y, Y as Z, Z as X)
# x position of arrow buttons on lane (the ones that are static)
var TARGET_X = 0.0

# x position where note is spawned
var SPAWN_X = 0.0

# z positions for note spawn
var SPAWN_Z = [0.0, 0.0, 0.0]

# XYZ position of player
var PLAYER_POS = Vector3(0, 0, 0)

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
	
	# debug output for high score values
	print("Highest score possible: " + str(high_score_max))
	print("Highest score possible (after tune): " + str(high_score_max * high_score_max_tune))
	
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
		
