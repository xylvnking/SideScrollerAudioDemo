extends State
class_name EnemyDeath
@onready var animation_player = $"../../Marker2D/AnimationPlayer"
@onready var ghoul_v_2 = $"../.."
@onready var collision_shape_2d = $"../../CollisionShape2D"

func Enter():
	animation_player.play('death')
	ghoul_v_2.gravity_enabled = false
	ghoul_v_2.velocity.x = 0
	collision_shape_2d.set_deferred("disabled",true)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'death':
		ghoul_v_2.queue_free()
		pass
