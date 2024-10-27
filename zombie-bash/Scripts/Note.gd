extends Area2D

# distance from spawned note/zombie to player vehicle (static Y)
var DIST_TO_TARGET = Global.TARGET_Y - Global.SPAWN_Y

# (x,y) spawn positions for each note/zombie
var LEFT_LANE_SPAWN = Vector2(Global.SPAWN_X[0], Global.SPAWN_Y)
var CENTRE_LANE_SPAWN = Vector2(Global.SPAWN_X[1], Global.SPAWN_Y)
var RIGHT_LANE_SPAWN = Vector2(Global.SPAWN_X[2], Global.SPAWN_Y)

# speed of note
var speed = 0

# note hit state
var hit = false


# ran only once, when node enters scene
func _ready():
	pass


# ran every frame
func _physics_process(delta):
	# if note not hit
	if !hit:
		# moving note y position further down
		global_position.y += speed * delta
		
		# if note exceeds y position of player vehicle
		if global_position.y > Global.TARGET_Y + 20:
			
			# free note resources
			queue_free()
			
			# reset combo
			get_parent().reset_combo()
	# if note hit
	else:
		# moving note further up
		$Node2D.global_position.y -= speed * delta


# initialize a lane
func initialize(lane):
	# if left lane
	if lane == 0:
		$AnimatedSprite2D.frame = 0
		global_position = LEFT_LANE_SPAWN
	# if middle lane
	elif lane == 1:
		$AnimatedSprite2D.frame = 1
		global_position = CENTRE_LANE_SPAWN
	# if right lane
	elif lane == 2:
		$AnimatedSprite2D.frame = 2
		global_position = RIGHT_LANE_SPAWN
	# invalid lane
	else:
		printerr("Invalid lane set for note: " + str(lane))
		return
	
	# speed of note to reach target (in 2 seconds)
	speed = DIST_TO_TARGET / 2.0


# called when note is to be destroyed
func destroy(score):
	# emit particles around note
	$CPUParticles2D.emitting = true

	# hide note sprite
	$AnimatedSprite2D.visible = false

	# start timer
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
	# free note node
	queue_free()
