extends Node2D

# Dictionary for storing sound effect paths or preloaded resources
@export var sound_effects: Dictionary = {
	"attack": "res://assets/sounds/woosh8bit.wav",
	"hit": "res://assets/sounds/hurt.wav",
	"die": "res://assets/sounds/explosion.wav"
}

# Export variable to assign the node whose position will be used
@export var reference_node: Node2D

# Play sound with the option to use the reference node's position or a custom one
func play_sound(sound_name: String, custom_position: Vector2 = Vector2()):
	print('want to play sound!!!')
	var sound_path = sound_effects.get(sound_name, null)
	
	if sound_path == null:
		print("Error: Sound not found: " + sound_name)
		return
	
	# Dynamically create a new AudioStreamPlayer2D node
	var audio_player = AudioStreamPlayer2D.new()
	add_child(audio_player)  # Add the audio player as a child node
	
	audio_player.stream = load(sound_path)  # Load the sound file
	
	# Play the sound
	audio_player.play()
	
	# Schedule the node to be removed after the sound is finished
	var sound_duration = audio_player.stream.get_length()  # Get sound length in seconds
	var timer = Timer.new()
	timer.set_wait_time(sound_duration)
	timer.set_one_shot(true)
	add_child(timer)

	timer.start()
	timer.timeout.connect(func() -> void:
		audio_player.queue_free()
		timer.queue_free()
	)

	print("Playing sound: " + sound_name)
