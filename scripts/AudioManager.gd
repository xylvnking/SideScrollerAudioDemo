extends Node2D

### NOTES
## I don't know whether it's better to have resource paths or to have audio dropped right onto streams.
	## the former feels 'hardcoded' a bit much but the later feels 'brittle'.
@export var audio_bus: String = "Master"

# Dictionary for storing sound effect paths or preloaded resources
# Entries can be added in the Inspector
@export var sound_effects: Dictionary = {
	"attack": "res://assets/sounds/woosh8bit.wav",
	"hit": "res://assets/sounds/hurt.wav",
	"die": "res://assets/sounds/explosion.wav"
}

@export var default_footstep_sounds: Array[AudioStream] = []
var default_footstep_sounds_current_index: int = 0
@export var grass_footstep_sounds: Array[AudioStream] = []
var grass_footstep_sounds_current_index: int = 0
@export var wood_footstep_sounds: Array[AudioStream] = []
var wood_footstep_sounds_current_index: int = 0
@export var metal_footstep_sounds: Array[AudioStream] = []
var metal_footstep_sounds_current_index: int = 0

var material_sounds_indices = {
	"default": 0,
	"grass": 0,
	"wood": 0,
	"metal": 0
}

var material_sounds: Dictionary = {}
var current_material: String = "default"
@onready var surface_check_ray_cast_2d = $SurfaceCheckRayCast2D

@export var footstep_sounds: Array[AudioStream] = []
var current_footstep_index: int = 0
@export var footstep_sounds_volume: float = 0

@export var should_vary_footstep_pitches: bool = true
@export var max_distance: float = 1000
var footstep_pitch: float = 1


@export var metal_footstep_sounds_2: AudioStreamRandomizer

@export var base_sounds: Array[AudioStream] = []
var base_audio_player: AudioStreamPlayer2D
var base_timer: Timer
# Timer range for random intervals
@export var base_timer_low: float = 1.0
@export var base_timer_high: float = 5.0

func _ready():
	
	# Set up audio player for random base sounds
	material_sounds = {
		"default": default_footstep_sounds,
		"grass": grass_footstep_sounds,
		"wood": wood_footstep_sounds,
		"metal": metal_footstep_sounds
	}
	
	# Create the AudioStreamPlayer2D dynamically
	base_audio_player = AudioStreamPlayer2D.new()
	add_child(base_audio_player)
	# Create a Timer dynamically
	base_timer = Timer.new()
	base_timer.set_one_shot(true)
	add_child(base_timer)
	# Connect the timer timeout signal to the _on_base_timer_timeout function
	base_timer.timeout.connect(_on_base_timer_timeout)
	# Start the process of playing random sounds at intervals
	reset_timer_with_random_value()

func _on_base_timer_timeout():
	if base_sounds.size() == 0:
		#print("No base sounds available.")
		return

	# Pick a random sound from the array and play it
	var random_index = randi() % base_sounds.size()
	base_audio_player.stream = base_sounds[random_index]
	base_audio_player.play()

	# Reset the timer with a new random value
	reset_timer_with_random_value()

func reset_timer_with_random_value():
	var random_time = randf_range(base_timer_low, base_timer_high)
	base_timer.wait_time = random_time
	base_timer.start()

# Play sound with the option to use the reference node's position or a custom one
func play_sound(sound_name: String, volume: float = 0, custom_position: Vector2 = Vector2()):
	var sound_path = sound_effects.get(sound_name, null)
	
	if sound_path == null:
		print("Error: Sound not found: " + sound_name)
		return
	
	# Dynamically create a new AudioStreamPlayer2D node
	var audio_player = AudioStreamPlayer2D.new()
	add_child(audio_player)  # Add the audio player as a child node
	
	audio_player.stream = load(sound_path)  # Load the sound file
	audio_player.max_distance = max_distance
	
	if volume:
		audio_player.volume_db = volume
		
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

func play_looping_sound():
	pass

func play_material_landing():
	footstep_pitch = .5
	play_material_footstep()

func play_material_footstep():
	if surface_check_ray_cast_2d.is_colliding():
		#print(ray_cast_2d.get_collider())
		if surface_check_ray_cast_2d.get_collider().is_in_group("metal"):
			#print('it is metal dawg')
			current_material = 'metal'
			play_footstep_sound_for_material(current_material)
		if surface_check_ray_cast_2d.get_collider().is_in_group("grass"):
			#print('it is metal dawg')
			current_material = 'grass'
			play_footstep_sound_for_material(current_material)
		else:
			current_material = "default"
			
func play_footstep_sound_for_material(material: String = 'default'):
	var sounds_array = material_sounds[material]
	
	if sounds_array.size() == 0:
		return  # No sounds available for this material

# Get the current index for the material
	var current_index = material_sounds_indices[material]

# Select the sound at the current index
	#var sound = sounds_array[current_index]
	var sound = metal_footstep_sounds_2

# Play the selected sound
	var audio_player = AudioStreamPlayer2D.new()
	add_child(audio_player)
	audio_player.stream = sound
	audio_player.bus = audio_bus
	audio_player.max_distance = max_distance
	if footstep_sounds_volume:
		audio_player.volume_db = footstep_sounds_volume
	if should_vary_footstep_pitches:
		if current_index % 2 == 0:
			audio_player.pitch_scale = 1.01
		else:
			audio_player.pitch_scale = .9
	audio_player.pitch_scale *= footstep_pitch
	
	# Play sound
	audio_player.play()

	# Create a Timer to handle cleanup after playback
	var timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(sound.get_length())  # Set the wait time to the length of the sound
	add_child(timer)

	# Connect the timer's timeout signal to queue_free the audio player and itself
	timer.timeout.connect(func() -> void:
		audio_player.queue_free()
		timer.queue_free()
	)

	# Start the timer
	timer.start()
	
# Update the index to play the next sound, looping back to the start
	material_sounds_indices[material] = (current_index + 1) % sounds_array.size()
	footstep_pitch = 1
