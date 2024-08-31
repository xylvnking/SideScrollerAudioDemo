extends State
class_name EnemyHit

@export var enemy: CharacterBody2D
@onready var animation_player = $"../../Marker2D/AnimationPlayer"
@onready var audio_manager = $"../../AudioManager"

func Enter():
	animation_player.play("hit")
	print('been hit')
	audio_manager.play_sound('hit')
	
func Update(delta: float):
	pass
func Physics_Update(delta: float):
	pass


func _on_animation_player_animation_finished(anim_name):
	print(anim_name)
	#Transitioned.emit(self, 'EnemyWalking')
