extends State
class_name EnemyAttacking

@export var enemy: CharacterBody2D

@onready var ray_cast_right = $"../../CollisionShape2D/ray_cast_right"
@onready var ray_cast_left = $"../../CollisionShape2D/ray_cast_left"
@onready var animation_player = $"../../Marker2D/AnimationPlayer"
@onready var pre_attack_hitbox = $"../../Marker2D/Area2D/PreAttackHitbox"
@onready var attack_hitbox = $"../../Marker2D/Area2D/AttackHitbox"

var player_in_range = false


func Enter():
	animation_player.play('attack')
	player_in_range = true
	enemy.velocity.x = 0

func Update(delta: float):
	pass
		
func Physics_Update(delta: float):
	animation_player.play('attack')

func Exit():
	player_in_range = false
	animation_player.stop()


func _on_animation_player_animation_finished(anim_name):
	Transitioned.emit(self, 'EnemyWalking')


func _on_area_2d_body_entered(body):
	#if bdbody.take_damage(50)
	pass