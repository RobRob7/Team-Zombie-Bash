extends Area3D

# Distance from spawned note/zombie to player vehicle (static Y)
var DIST_TO_TARGET = Global.TARGET_X - Global.SPAWN_X

# (x, y) spawn positions for each note/zombie
var LEFT_LANE_SPAWN = Vector3(Global.SPAWN_X, 0.7, Global.SPAWN_Z[0])
var CENTRE_LANE_SPAWN = Vector3(Global.SPAWN_X, 0.7, Global.SPAWN_Z[1])
var RIGHT_LANE_SPAWN = Vector3(Global.SPAWN_X, 0.7, Global.SPAWN_Z[2])

# Speed of the note
var speed = 0

# Note hit state
var hit = false

# All zombie sprite animations
var zombie_sprite_frame = [
	"zombie1",
	"zombie2",
	"zombie3",
]


# Called once when the node enters the scene
func _ready():
	# random seed set
	randomize()
	
	# play random animation sprite
	var animationSprite = randi() % len(zombie_sprite_frame)
	match animationSprite:
		0:
			$Zombie.play("zombie1")
		1:
			$Zombie.play("zombie2")
		2:
			$Zombie.play("zombie3")


# Called every frame to update position
func _physics_process(delta):
	if !hit:
		# Move the note towards the player (adjust x position)
		global_position.x += speed * delta

		# Check if note has passed the target position
		if global_position.x < Global.TARGET_X - 1:
			get_parent().NoteMissedReaction()
			queue_free()  # Free resources
			get_parent().reset_combo()  # Reset combo
	else:
		# Move note further up if it has been hit
		$Node3D.global_position.x -= speed * delta


# Initialize a note instance in a specific lane
func initialize(lane):
	# Set position based on lane
	match lane:
		0:
			$AnimatedSprite3D.frame = 1
			global_position = LEFT_LANE_SPAWN
		1:
			$AnimatedSprite3D.frame = 1
			global_position = CENTRE_LANE_SPAWN
		2:
			$AnimatedSprite3D.frame = 1
			global_position = RIGHT_LANE_SPAWN
		_:
			printerr("Invalid lane set for zombie note: " + str(lane))
			return

	# Increase the speed to reach the target faster
	speed = DIST_TO_TARGET / Global.difficulty


# Called when the note is destroyed
func destroy(score):
	# Hide zombie sprite
	$Zombie.visible = false

	# Start feedback timer
	$Timer.start()
	
	# Mark note as hit
	hit = true
	
	# Display feedback based on score
	match score:
		3:
			$Node3D/Label3D.text = "GREAT"
			$Node3D/Label3D.modulate = Color("8B0000")
		2:
			$Node3D/Label3D.text = "GOOD"
			$Node3D/Label3D.modulate = Color("8B0000")
		1:
			$Node3D/Label3D.text = "OKAY"
			$Node3D/Label3D.modulate = Color("8B0000")


# Called when the timer for feedback labels times out, freeing resources
func _on_Timer_timeout():
	queue_free()
