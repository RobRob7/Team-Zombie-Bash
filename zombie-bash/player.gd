extends CharacterBody3D



func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		self.set_position(Vector3(-4.5,0.8,-0.8))
	if Input.is_action_pressed("right"):
		self.set_position(Vector3(-4.5,0.8,0.8))
	if Input.is_action_pressed("up"):
		self.set_position(Vector3(-4.5,0.8,0))
