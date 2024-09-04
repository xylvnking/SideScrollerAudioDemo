extends Resource
class_name CustomAudioResourceArray

@export var sounds: Array[CustomAudioResource]

## This value is added onto the volume, so use negative values to reduce it.
@export var add_to_pitch_scale: float = 0

## This value is added onto the volume, so use negative values to reduce it. Limited to 6db in the positive direction, to avoid accidentally setting a high number. This can be overriden in custom_audio_resource_array.gd
@export_range(-80.0, 6.0) var add_to_volume: float = 0.0  # Volume offset (limited to -80 dB to 6 dB)
