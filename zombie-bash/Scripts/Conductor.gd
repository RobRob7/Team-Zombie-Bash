extends AudioStreamPlayer

# beats per minute
@export var bpm := 75

# number of measures
@export var measures := 4

# holds current position in song
var song_position = 0.0

# holds current position in song in beats
var song_position_in_beats = 1

# holds number of seconds per beat
var sec_per_beat
# = 60.0 / bpm

# holds last reported beat
var last_reported_beat = 0

# holds number of beats before start of song
var beats_before_start = 0

# holds current measure
var measure = 1

# Determining how close to the beat an event is
#var closest = 0
#var time_off_beat = 0.0

# called when node enters scene
func _ready():
	# calculate seconds per beat
	sec_per_beat = 60.0 / bpm
	self.stream = load(Global.currentSong)
	setSongLength()
	

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
		
		# report the beat
		_report_beat()
		
func setSongLength():
	Global.songLengthSeconds = self.stream.get_length()

# reports beat
func _report_beat():
	# if the last reported beat is < song position in beats
	if last_reported_beat < song_position_in_beats:
		# if current measure is greater than total measures
		if measure > measures:
			# reset measure to 1
			measure = 1
		# emit beat signal with argument song_position_in_beats
		Global.beat.emit(song_position_in_beats)

		# emit measure with argument measure
		Global.measure.emit(measure)

		# update last_reported_beat with song_position_in_beats
		last_reported_beat = song_position_in_beats

		# increment measure by 1
		measure += 1

# plays song with beat offset
func play_with_beat_offset(num):
	# number of beats before start
	beats_before_start = num

	# set wait time to sec_per_beat
	$StartTimer.wait_time = sec_per_beat

	# start timer
	$StartTimer.start()
	

# plays song from desired beat (can be used to start game from further point in song)
func play_from_beat(beat, offset):
	# play audio stream
	play()

	# start audio stream from beat * sec_per_beat
	seek(beat * sec_per_beat)

	# beats before the start of song
	beats_before_start = offset

	# set current measure
	measure = beat % measures

# timeout for timer
func _on_StartTimer_timeout():
	# increment song_position_in_beats by 1
	song_position_in_beats += 1

	# if song_position_in_beats < beats_before_start - 1
	if song_position_in_beats < beats_before_start - 1:
		# start timer
		$StartTimer.start()
	# elif song_position_in_beats == beats_before_start - 1
	elif song_position_in_beats == beats_before_start - 1:
		# timer wait time set
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency())

		# start timer
		$StartTimer.start()
	# if song_position_in_beats > beats_before_start - 1
	else:
		# play audio stream
		play()

		# stop timer
		$StartTimer.stop()
	
	# report the beat
	_report_beat()
