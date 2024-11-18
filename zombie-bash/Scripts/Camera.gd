extends Camera3D

# variables to control shake intensity and duration
var shake_intensity = 0.0
var shake_duration = 0.0
var shake_decay = 0.1  # How fast the shake should decay

# original camera position
var original_transform: Transform3D

# variable for hard limit shake combo score
var shake_max_combo = 40

# variable to tune shake intensity
var shake_max_tune = 0.0004

# called only once, when node enters scene
func _ready():
	# store the original camera position
	original_transform = global_transform
	
	# connect combo_changed signal to start_camera_shake
	Global.combo_changed.connect(start_camera_shake)


# called every frame
func _process(delta):
	# check for shake duration set
	if shake_duration > 0:
		# apply random shake based on the intensity
		var shake_offset = Vector3(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		
		# adjust camera position while keeping rotation intact
		global_transform = Transform3D(
			original_transform.basis,
			original_transform.origin + shake_offset
		)

		# reduce the shake intensity over time
		shake_duration -= delta
		shake_intensity = lerp(shake_intensity, 0.0, shake_decay * delta)
	
	# shake duration over
	else:
		# reset the position when the shake is done
		global_transform = original_transform


# function to trigger the camera shake based on current combo
func start_camera_shake(combo: float):
	# if combo is less than shake_max_combo
	if combo < shake_max_combo:
		shake_intensity = combo * shake_max_tune
	# if combo > shake_max_combo, keep max shake_intensity
	else:
		shake_intensity = shake_max_combo * shake_max_tune
	
	# shake duration for a couple seconds
	shake_duration = 2.0
