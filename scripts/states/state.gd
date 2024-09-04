extends Node
class_name State

# https://youtu.be/ow_Lum-Agbs

signal Transitioned
@onready var default_audio_manager = get_node_or_null("/root/Path/To/AudioManager")
@export var audio_manager: Node2D

func _ready():
	# Use the exported audio_manager if set, otherwise use the default
	if audio_manager == null:
		audio_manager = default_audio_manager
	
	if !audio_manager:
		print("AudioManager is not set!!!!.")

func Enter():
	pass
	
func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	pass

func set_audio_manager(manager: Node2D):
	audio_manager = manager
