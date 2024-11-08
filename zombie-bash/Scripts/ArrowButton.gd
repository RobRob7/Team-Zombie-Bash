extends AnimatedSprite3D

# perfect note hit state
var perfect = false

# good note hit state
var good = false

# okay note hit state
var okay = false

# the current note (perfect, good, okay)
var current_note = null

# variable input export var
@export var input = ""

# handles input on key presses
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		pass
	else:
	# if one of keys pressed (a, w, d or left, up, right)
		if event.is_action(input):
		# if one of keys pressed (a, w, d or left, up, right)
			if event.is_action_pressed(input, false):
			# if the current note is perfect, good, okay
				if current_note != null:
				# if perfect note
					if perfect:
					# increment score by 3
						get_parent().increment_score(3)
					# destroy the note
						current_note.destroy(3)
					elif good:
					# increment score by 2
						get_parent().increment_score(2)
					# destroy the note
						current_note.destroy(2)
					elif okay:
					# increment score by 1
						get_parent().increment_score(1)
					# destroy the note
						current_note.destroy(1)

				# reset performance note hit states, and current note
					_reset()
			# if current note is null
				else:
				# increment score by 0
					get_parent().increment_score(0)

		# if one of keys pressed (a, w, d or left, up, right)
			if event.is_action_pressed(input):
			# set frame of arrow button to state 1 (pressed state)
				frame = 1
		# if one of keys just released (a, w, d or left, up, right)
			elif event.is_action_released(input):
			# start timer
				$PushTimer.start()

# perfect note hit area
func _on_PerfectArea_area_entered(area):
	# perfect note hit criteria
	if area.is_in_group("note"):
		perfect = true

# just left perfect note hit area
func _on_PerfectArea_area_exited(area):
	# perfect note hit just passed criteria
	if area.is_in_group("note"):
		perfect = false

# good note hit area
func _on_GoodArea_area_entered(area):
	# good note hit criteria
	if area.is_in_group("note"):
		good = true

# just left good note hit area
func _on_GoodArea_area_exited(area):
	# good note hit just passed criteria
	if area.is_in_group("note"):
		good = false

# okay note hit area
func _on_OkayArea_area_entered(area):
	# okay note hit criteria
	if area.is_in_group("note"):
		okay = true
		current_note = area

# just left okay note hit area
func _on_OkayArea_area_exited(area):
	# okay note hit just passed criteria (also set current_note = null)
	if area.is_in_group("note"):
		okay = false
		current_note = null

# timer timeout
func _on_PushTimer_timeout():
	# set arrow button frame back to 0 (unpressed state)
	frame = 0

# reset performance note hit states, and current note
func _reset():
	current_note = null
	perfect = false
	good = false
	okay = false
