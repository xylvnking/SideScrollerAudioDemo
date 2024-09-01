extends State
class_name EnemyHit

#@export var enemy: CharacterBody2D
@onready var animation_player = $"../../Marker2D/AnimationPlayer"
#@onready var audio_manager = $"../../AudioManager"

#@export var audio_manager: Node2D

#func _ready():
	#var parent_state_machine = get_parent()
	#if parent_state_machine and parent_state_machine.has_method("audio_manager"):
		#audio_manager = parent_state_machine.audio_manager
	#else:
		#print("AudioManager reference is not available.")
		
func Enter():
	if audio_manager:
		audio_manager.play_sound("hit", -16)
	else:
		print("AudioManager is not set in enemy hit.")
	
	animation_player.play("hit")
	#print('been hit')
	#audio_manager.play_sound('hit')
	
func Update(delta: float):
	pass
func Physics_Update(delta: float):
	pass


func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'hit':
		Transitioned.emit(self, 'EnemyWalking')
