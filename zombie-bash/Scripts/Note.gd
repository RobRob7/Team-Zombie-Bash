extends Area3D

# Distance from spawned note/zombie to player vehicle (static Y)
var DIST_TO_TARGET = Global.TARGET_X - Global.SPAWN_X

# (x, y) spawn positions for each note/zombie
var LEFT_LANE_SPAWN = Vector3(Global.SPAWN_X, Global.SPAWN_Y, Global.SPAWN_Z[0])
var CENTRE_LANE_SPAWN = Vector3(Global.SPAWN_X, Global.SPAWN_Y, Global.SPAWN_Z[1])
var RIGHT_LANE_SPAWN = Vector3(Global.SPAWN_X, Global.SPAWN_Y, Global.SPAWN_Z[2])

# Speed of the note
var speed = 0

# Note hit state
var hit = false

# Load the new ZombieNote scene
var zombie_note_scene = preload("res://Scenes/ZombieNote.tscn")

# Called once when the node enters the scene
func _ready():
	print("Note ready: Initial position is ", position)

# Called every frame to update position
func _physics_process(delta):
	if !hit:
		# Move the note towards the player (adjust x position)
		position.x += speed * delta
		# Debug print the position to monitor movement
		print("Note position (x): ", position.x, " Target X: ", Global.TARGET_X, " Speed: ", speed)
		# Check if note has passed the target position
		if position.x < Global.TARGET_X - 1.0:  # Loosen the margin
			print("Note missed: Position X is ", position.x)
			get_parent().NoteMissedReaction()
			queue_free()  # Free resources
			get_parent().reset_combo()  # Reset combo
	else:
		# Move note further up if it has been hit
		$ZombieNote/Node2D.position.x -= speed * delta

# Initialize a note instance in a specific lane
func initialize(lane):
	# Create an instance of the ZombieNote scene
	var zombie_note_instance = zombie_note_scene.instantiate()
	
	# Add the instance to the current scene
	add_child(zombie_note_instance)
	
	# Set position based on lane
	match lane:
		0:
			zombie_note_instance.position = LEFT_LANE_SPAWN
		1:
			zombie_note_instance.position = CENTRE_LANE_SPAWN
		2:
			zombie_note_instance.position = RIGHT_LANE_SPAWN
		_:
			printerr("Invalid lane set for zombie note: " + str(lane))
			return

	# Increase the speed to reach the target faster
	speed = DIST_TO_TARGET / 1.0
	print("Note initialized at lane ", lane, " with speed ", speed)

# Called when the note is destroyed
func destroy(score):
	# Hide zombie and arrow sprites
	$ZombieNote/ZombieSprite.visible = false
	$ZombieNote/ArrowSprite.visible = false

	# Start feedback timer
	$ZombieNote/Timer.start()
	
	# Mark note as hit
	hit = true
	
	# Display feedback based on score
	match score:
		3:
			$ZombieNote/Node2D/Label.text = "GREAT"
			$ZombieNote/Node2D/Label.modulate = Color("f6d6bd")
		2:
			$ZombieNote/Node2D/Label.text = "GOOD"
			$ZombieNote/Node2D/Label.modulate = Color("c3a38a")
		1:
			$ZombieNote/Node2D/Label.text = "OKAY"
			$ZombieNote/Node2D/Label.modulate = Color("997577")

# Called when the timer for feedback labels times out, freeing resources
func _on_Timer_timeout():
	queue_free()
