extends Node2D

### NOTES
# Further improvements
# Adding volume and pitch settings for individual footstep sets.
# custom resource or some way to load in footstep randomizer easier
	# since it would get tedious to do it for every enemy
	# maybe it does make sense to have it on the surface
	# but then either way one has to handle all cases of the other
		# and this makes more sense to me logically
	
@onready var surface_check_ray_cast_2d = $SurfaceCheckRayCast2D
@export var surface_check_ray_cast_2d_distance: float = 10

@export var footstep_audio_bus: String = "Master"
# Dictionary for storing sound effect paths or preloaded resources
# Entries can be added in the Inspector
@export var sound_effects: Dictionary = {
	"attack": "res://assets/sounds/woosh8bit.wav",
	"hit": "res://assets/sounds/hurt.wav",
	"die": "res://assets/sounds/explosion.wav"
}

@export var sound_effects_main: Array[CustomAudioResource]



var current_material: String = "default"

var footstep_material_sounds: Dictionary = {}
var footstep_pitch_flipflop: bool = false
var footstep_pitch: float = 1

@export var metal_footstep_sounds: AudioStreamRandomizer
@export var metal_grate_footstep_sounds: AudioStreamRandomizer
@export var metal_car_footstep_sounds: AudioStreamRandomizer
@export var grass_footstep_sounds: AudioStreamRandomizer
@export var concrete_footstep_sounds: AudioStreamRandomizer

@export var footstep_sounds_volume: float = 0

@export var should_vary_footstep_pitches: bool = true
@export var footstep_pitch_scale_modifier: float = 0

@export var max_distance: float = 1000

@export var base_sounds: Array[AudioStream] = []
var base_audio_player: AudioStreamPlayer2D
var base_timer: Timer
# Timer range for random intervals
@export var base_timer_low: float = 1.0
@export var base_timer_high: float = 5.0

func _ready():
	
	surface_check_ray_cast_2d.target_position.y = surface_check_ray_cast_2d_distance
	
	footstep_material_sounds = {
		"metal": metal_footstep_sounds,
		"metal_grate": metal_grate_footstep_sounds,
		"metal_car": metal_car_footstep_sounds,
		"grass": grass_footstep_sounds,
		"concrete": concrete_footstep_sounds,
	}
	
	# Set up audio player for random base sounds
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




# UNUSED????
# Play sound with the option to use the reference node's position or a custom one
#func play_sound(sound_name: String, volume: float = 0, custom_position: Vector2 = Vector2()):
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
	audio_player.finished.connect(func() -> void:
		audio_player.queue_free()
		)







func play_looping_sound():
	pass

func play_material_landing():
	footstep_pitch = .5
	play_material_footstep()

func play_material_footstep():
	if surface_check_ray_cast_2d.is_colliding():
		if surface_check_ray_cast_2d.get_collider().is_in_group("metal"):
			current_material = 'metal'
			play_footstep_sound_for_material(current_material)
			return
		if surface_check_ray_cast_2d.get_collider().is_in_group("metal_grate"):
			current_material = 'metal_grate'
			play_footstep_sound_for_material(current_material)
			return
		if surface_check_ray_cast_2d.get_collider().is_in_group("metal_car"):
			current_material = 'metal_car'
			play_footstep_sound_for_material(current_material)
			return
		if surface_check_ray_cast_2d.get_collider().is_in_group("grass"):
			current_material = 'grass'
			play_footstep_sound_for_material(current_material)
			return
		if surface_check_ray_cast_2d.get_collider().is_in_group("concrete"):
			current_material = 'concrete'
			play_footstep_sound_for_material(current_material)
			return
		else:
			print('this material type has either not been added, or the raycast is not reaching it')
			current_material = "default"
			#return
			
func play_footstep_sound_for_material(material: String = 'default'):
	
	# Selecting the stream(randomizer) according to the material passed in by play_material_footstep()
	var sound = footstep_material_sounds[material]
	if !sound:
		print("No audio has been provided for this material")
		footstep_pitch = 1
		return

	# Play the selected sound
	var audio_player = AudioStreamPlayer2D.new()
	add_child(audio_player)
	audio_player.stream = sound
	audio_player.bus = footstep_audio_bus
	audio_player.max_distance = max_distance
	
	if footstep_sounds_volume:
		audio_player.volume_db = footstep_sounds_volume
		
	# adds alternating pitch offset to footsteps 
	if should_vary_footstep_pitches:
		if footstep_pitch_flipflop:
			audio_player.pitch_scale = 1.05
			footstep_pitch_flipflop = false
		else:
			audio_player.pitch_scale = .95
			footstep_pitch_flipflop = true
	audio_player.pitch_scale *= footstep_pitch
	audio_player.pitch_scale += footstep_pitch_scale_modifier
	
	# Play sound
	audio_player.play()

	# Destroys the audio player node after it finished
	audio_player.finished.connect(func() -> void:
		audio_player.queue_free()
		)
	
	# Reseting footstep pitch, since if it's triggered on 'landing' it needs to be reset for regular footsteps
	footstep_pitch = 1
	
	
	
func get_audio_stream_by_name(sound_name: String) -> AudioStream:
	for sound in sound_effects_main:
		if sound.sound_name == sound_name:
			return sound.sound_stream
	return null

func play_sound_custom(sound_name: String) -> AudioStreamPlayer2D:

	var custom_sound
	
	# Check whether sound with that name exists and contains a stream
	for sound in sound_effects_main:
		if sound.sound_name == sound_name && sound.sound_stream != null:
			custom_sound = sound
	
	# If the name is wrong or there is no stream, print & return
	if !custom_sound:
		print("Sound not found: " + sound_name)
		return null
	

	if custom_sound.sound_stream != null:
		
		# Create an audio player for the specified sound
		var audio_player = AudioStreamPlayer2D.new()
		audio_player.stream = custom_sound.sound_stream
		add_child(audio_player)
		
		# Apply settings from custom resource
		if custom_sound.should_randomize_pitch == true:
			#audio_player.pitch_scale
			audio_player.pitch_scale = randf_range(1 - custom_sound.randomize_pitch_amount, 1 + custom_sound.randomize_pitch_amount)
		audio_player.max_distance = custom_sound.sound_max_distance
		audio_player.bus = custom_sound.sound_bus
		audio_player.volume_db = custom_sound.sound_volume
		audio_player.max_polyphony = custom_sound.sound_max_polyphony
		
		# Play the sound
		audio_player.play()
		
		# Remove the audio player once its finished
		audio_player.finished.connect(func() -> void:
			audio_player.queue_free()
		)
		
		# Sending a reference back allows scripts to access data about the sound
		# or connect to signals, often helpful to do something like queue_free()
		# when the sound is finished playing
		return audio_player
		
	else:
		print("Sound not found: " + sound_name)
		return null
