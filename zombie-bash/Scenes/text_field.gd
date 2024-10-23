extends TextEdit


func _on_text_changed() -> void:
	Global.currentSong = "res://Sounds/" + self.get_text()
