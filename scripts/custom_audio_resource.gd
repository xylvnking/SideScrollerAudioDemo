extends Resource
class_name CustomAudioResource

# https://youtu.be/vzRZjM9MTGw

@export var sound_stream: AudioStream
@export var sound_name: String
@export var sound_volume: int = 0
@export var sound_bus: String = "master"
@export var sound_pitch: float = 1
@export var sound_max_distance: int = 2000
@export var should_randomize_pitch: bool = false
@export var randomize_pitch_amount: float = 0.05
@export var sound_max_polyphony: int = 1
