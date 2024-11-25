extends CharacterBody3D

# will run every frame
func _physics_process(delta: float) -> void:
	# move player model to respective lane
	if Input.is_action_pressed("left"):
		self.set_position(Vector3(Global.PLAYER_POS.global_position.x, Global.PLAYER_POS.global_position.y, Global.SPAWN_Z[0]))
	if Input.is_action_pressed("up"):
		self.set_position(Vector3(Global.PLAYER_POS.global_position.x, Global.PLAYER_POS.global_position.y, Global.SPAWN_Z[1]))
	if Input.is_action_pressed("right"):
		self.set_position(Vector3(Global.PLAYER_POS.global_position.x, Global.PLAYER_POS.global_position.y, Global.SPAWN_Z[2]))
