extends State
class_name EnemyWalking

@export var enemy: CharacterBody2D
@export var move_speed := 10.0
@onready var ray_cast_right = $"../../CollisionShape2D/ray_cast_right"
@onready var ray_cast_left = $"../../CollisionShape2D/ray_cast_left"
@onready var animation_player = $"../../Marker2D/AnimationPlayer"

var move_direction : Vector2
var wander_time : float

var direction = -1
const SPEED = 50.0
const JUMP_VELOCITY = -400.0

func randomize_wander():
	#print('waling around aimlessly...')
	wander_time = randf_range(1, 3)
	
	
func Enter():
	randomize_wander()
	
func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()
		
func Physics_Update(delta: float):
	if ray_cast_right.is_colliding():
		direction = -1
	if ray_cast_left.is_colliding():
		direction = 1
	if enemy:
		enemy.position.x += direction *  SPEED * delta
		enemy.velocity.x = direction * SPEED
	if enemy.velocity.length() > 0:
		animation_player.play("walk")
		

# you need to change the state to 'hit' whenever it takes damage from the player - do you implement that in every state it can be hit during? feels dumb
	


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		Transitioned.emit(self, 'EnemyAttacking')