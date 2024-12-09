extends Area3D

signal note_entered_lane(lane: String)
signal note_exited_lane(lane: String)

var DIST_TO_TARGET = Global.TARGET_X - Global.SPAWN_X

var LEFT_LANE_SPAWN = Vector3(Global.SPAWN_X, 0.7, Global.SPAWN_Z[0])
var CENTRE_LANE_SPAWN = Vector3(Global.SPAWN_X, 0.7, Global.SPAWN_Z[1])
var RIGHT_LANE_SPAWN = Vector3(Global.SPAWN_X, 0.7, Global.SPAWN_Z[2])

var speed = 0
var hit = false

var zombie_sprite_frame = [
	"zombie1",
	"zombie2",
	"zombie3",
]

func _ready():
	randomize()
	var animationSprite = randi() % len(zombie_sprite_frame)
	match animationSprite:
		0: $Zombie.play("zombie1")
		1: $Zombie.play("zombie2")
		2: $Zombie.play("zombie3")

func _physics_process(delta):
	if !hit:
		global_position.x += speed * delta
		if global_position.x < Global.TARGET_X - 1:
			emit_signal("note_exited_lane", get_lane_name())
			get_parent().NoteMissedReaction()
			queue_free()
			get_parent().reset_combo()
	else:
		$Node3D.global_position.x -= speed * delta

func initialize(lane):
	match lane:
		0:
			$AnimatedSprite3D.frame = 1
			global_position = LEFT_LANE_SPAWN
			emit_signal("note_entered_lane", "left")
		1:
			$AnimatedSprite3D.frame = 1
			global_position = CENTRE_LANE_SPAWN
			emit_signal("note_entered_lane", "up")
		2:
			$AnimatedSprite3D.frame = 1
			global_position = RIGHT_LANE_SPAWN
			emit_signal("note_entered_lane", "right")
		_:
			printerr("Invalid lane set for zombie note: " + str(lane))
			return

	speed = DIST_TO_TARGET / Global.difficulty

func destroy(score):
	$Zombie.visible = false
	$Timer.start()
	hit = true
	match score:
		3: $Node3D/Label3D.text = "GREAT"
		2: $Node3D/Label3D.text = "GOOD"
		1: $Node3D/Label3D.text = "OKAY"

func _on_Timer_timeout():
	queue_free()

func get_lane_name() -> String:
	if global_position.z == Global.SPAWN_Z[0]:
		return "left"
	elif global_position.z == Global.SPAWN_Z[1]:
		return "up"
	elif global_position.z == Global.SPAWN_Z[2]:
		return "right"
	return ""
