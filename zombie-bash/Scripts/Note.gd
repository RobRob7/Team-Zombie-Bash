extends Area2D

const TARGET_Y = 164
const SPAWN_Y = -16
const DIST_TO_TARGET = TARGET_Y - SPAWN_Y

const LEFT_LANE_SPAWN = Vector2(120, SPAWN_Y)
const CENTRE_LANE_SPAWN = Vector2(160, SPAWN_Y)
const RIGHT_LANE_SPAWN = Vector2(200, SPAWN_Y)

var speed = 0
var hit = false

# ran once node enters scene
func _ready():
	pass

# ran every frame
func _physics_process(delta):
	
	# if note not hit
	if !hit:
		position.y += speed * delta
		
		# if note exceeds y position
		if position.y > 200:
			
			# free note resources
			queue_free()
			
			# reset combo
			get_parent().reset_combo()
	# if note hit
	else:
		$Node2D.position.y -= speed * delta

# initialize a lane
func initialize(lane):
	# if left lane
	if lane == 0:
		$AnimatedSprite2D.frame = 0
		position = LEFT_LANE_SPAWN
	# if middle lane
	elif lane == 1:
		$AnimatedSprite2D.frame = 1
		position = CENTRE_LANE_SPAWN
	# if right lane
	elif lane == 2:
		$AnimatedSprite2D.frame = 2
		position = RIGHT_LANE_SPAWN
	# invalid lane
	else:
		printerr("Invalid lane set for note: " + str(lane))
		return
	
	# speed of note
	speed = DIST_TO_TARGET / 2.0

# called when note is to be destroyed
func destroy(score):
	$CPUParticles2D.emitting = true
	$AnimatedSprite2D.visible = false
	$Timer.start()
	
	# note is hit
	hit = true
	
	# GREAT hit condition (display "GREAT")
	if score == 3:
		$Node2D/Label.text = "GREAT"
		$Node2D/Label.modulate = Color("f6d6bd")
	# GOOD hit condition (display "GOOD")
	elif score == 2:
		$Node2D/Label.text = "GOOD"
		$Node2D/Label.modulate = Color("c3a38a")
	# OKAY hit condition (display "OKAY")
	elif score == 1:
		$Node2D/Label.text = "OKAY"
		$Node2D/Label.modulate = Color("997577")

# on timer timeout for feedback labels, free resources
func _on_Timer_timeout():
	queue_free()
