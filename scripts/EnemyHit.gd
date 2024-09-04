extends State
class_name EnemyHit

@onready var animation_player = $"../../Marker2D/AnimationPlayer"

func Enter():
	if audio_manager:
		audio_manager.play_sound_custom("hit")
	else:
		print("AudioManager is not set in enemy hit.")
	animation_player.play("hit")

func Update(delta: float):
	pass
func Physics_Update(delta: float):
	pass

func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'hit':
		Transitioned.emit(self, 'EnemyWalking')
