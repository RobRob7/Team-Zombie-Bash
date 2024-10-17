extends AudioStreamPlayer

# beats per minute
@export var bpm := 75

# number of measures
@export var measures := 4

# holds current position in song
var song_position = 0.0

# holds current position in song in beats
var song_position_in_beats = 1

# holds seconds per beat
var sec_per_beat = 60.0 / bpm

# holds last reported beat
var last_reported_beat = 0

# holds number of beats before start of song
var beats_before_start = 0

# holds current measure
var measure = 1

# Determining how close to the beat an event is
var closest = 0
var time_off_beat = 0.0

# called when node enters scene
func _ready():
	
	# calculate seconds per beat
	sec_per_beat = 60.0 / bpm

# called each frame
func _physics_process(_delta):
	
	# check if song is playing
	if playing:
		
		# calculate current song position
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		
		# calculate true song position (account for latency)
		song_position -= AudioServer.get_output_latency()
		
		# calculate the song position in beats
		song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
		
		# call function
		_report_beat()

# reports beat and increments measure
func _report_beat():
	if last_reported_beat < song_position_in_beats:
		if measure > measures:
			measure = 1
		Global.beat.emit(song_position_in_beats)
		Global.measure.emit(measure)
		last_reported_beat = song_position_in_beats
		measure += 1

# plays song with beat offset
func play_with_beat_offset(num):
	beats_before_start = num
	$StartTimer.wait_time = sec_per_beat
	$StartTimer.start()

# plays song from desired beat (can be used to start game from further point in song)
func play_from_beat(beat, offset):
	play()
	seek(beat * sec_per_beat)
	beats_before_start = offset
	measure = beat % measures

# timeout for timer
func _on_StartTimer_timeout():
	song_position_in_beats += 1
	if song_position_in_beats < beats_before_start - 1:
		$StartTimer.start()
	elif song_position_in_beats == beats_before_start - 1:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() +
														AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()
	_report_beat()
