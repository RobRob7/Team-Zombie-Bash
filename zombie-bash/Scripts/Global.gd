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

# will contain main volume value
var main_volume_value = 1.0

# y position of arrow buttons on lane (the ones that are static)
var TARGET_Y = 0.0

# y position where note is spawned
var SPAWN_Y = 0.0

# x positions for note spawn
var SPAWN_X = [0.0, 0.0, 0.0]

# will set the score for end screen stats
func set_score(new):
	# update latest score
	score = new

	# set grade depending on score
	if score > 250000:
		grade = "A+"
	elif score > 200000:
		grade = "A"
	elif score > 150000:
		grade = "A-"
	elif score > 130000:
		grade = "B+"
	elif score > 115000:
		grade = "B"
	elif score > 100000:
		grade = "B-"
	elif score > 85000:
		grade = "C+"
	elif score > 70000:
		grade = "C"
	elif score > 55000:
		grade = "C-"
	elif score > 40000:
		grade = "D+"
	elif score > 30000:
		grade = "D"
	elif score > 20000:
		grade = "D-"
	else:
		grade = "F"
		
