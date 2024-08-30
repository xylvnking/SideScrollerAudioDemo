extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0
var direction = -1
var walking = true
var attacking = false
var target
var attackDamage = 50
var health = 100
var alive = true
var hit = false
#const attack_hitbox_default = -14,-11

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var attack_hitbox = $GhoulAttackHitboxArea/AttackHitbox
@onready var timer = $Timer
@onready var timer_hit = $TimerHit
@onready var collision_shape_2d_2 = $CollisionShape2D2
@onready var collision_shape_2d = $CollisionShape2D

func walk():
	animated_sprite.play("walk")

func attack():
	#attacking = true
	#print('attackin')
	animated_sprite.play("attack")
	#attack_hitbox.disabled = false

func take_damage(damage_amount):
	health -= damage_amount
	animated_sprite.play('hit')
	timer_hit.start()
	hit = true
	if health < 0:
		alive = false
		animation_player.play("death")

func finishAttack():
	attacking = false
	#attack_hitbox.disabled = true
	
func death():
	collision_shape_2d.disabled = true
	collision_shape_2d_2.disabled = true
	attacking = false
	attack_hitbox.disabled = true
	animated_sprite.play('death')
	alive = false
	timer.start()
	
func _physics_process(delta):
	# Add the gravity.
	
		
	if alive && !hit:
		if direction == -1:
			ray_cast_right.enabled = false
			ray_cast_left.enabled = true
		if direction == 1:
			ray_cast_right.enabled = true
			ray_cast_left.enabled = false
		if not is_on_floor():
			velocity.y += gravity * delta

		if ray_cast_right.is_colliding():
			target = ray_cast_right.get_collider()
			if target.is_in_group("player"):  # Ensure the player is in the "Player" group
				animation_player.play("attack")
				attacking = true
				if direction == -1:
					animated_sprite.flip_h = false
			else:
				direction = -1
				animated_sprite.flip_h = true
				attack_hitbox.position = Vector2(-14, -11)
		

		if ray_cast_left.is_colliding():
			
			target = ray_cast_left.get_collider()
			if target.is_in_group("player"):  # Ensure the player is in the "Player" group
				animation_player.play("attack")
				attacking = true
				
			else:
				direction = 1
				animated_sprite.flip_h = false
				attack_hitbox.position = Vector2(14, -11)
		
			
		if walking && not attacking:
			position.x += direction *  SPEED * delta
			animation_player.play("walk")

		move_and_slide()


func _on_ghoul_attack_hitbox_area_body_entered(body):
	if body.is_in_group("player"):  # Ensure the player is in the "Player" group
		body.take_damage(attackDamage)  # Call a method on the player, like take_damage
	#body.get_node("CollisionShape2D").queue_free()



func _on_timer_timeout():
	queue_free()



func _on_timer_hit_timeout():
	hit = false

