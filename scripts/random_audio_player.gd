extends Node

@onready var audio_stream_player_2d = $AudioStreamPlayer2D

@onready var timer = $Timer

@export var audio_file: AudioStream
@export var timer_low = 1
@export var timer_high = 5

func reset_timer_with_random_value():
	var random_time = randi_range(timer_low, timer_high)
	timer.wait_time = random_time
	timer.start()

func _ready():
	if audio_file:
		audio_stream_player_2d.stream = audio_file
	reset_timer_with_random_value()
	
func _on_timer_timeout():
	audio_stream_player_2d.play()
	reset_timer_with_random_value()
