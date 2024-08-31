extends CharacterBody2D

# flip offset sprite
# https://youtu.be/rydahiHyUvI


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var health = 100
var attack_damage = 60


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $Marker2D/AnimatedSprite2D

@onready var marker_2d = $Marker2D
@onready var animation_player = $AnimationPlayer
@onready var ray_cast_2d = $PlayerCollision/RayCast2D

var attacking = false
var jumping = false

func take_damage(damage_amount):
	health -= damage_amount
	animation_player.play('hit')
	attacking = false
	if health < 0:
		#queue_free()
		get_tree().reload_current_scene()
	print(health)

func play_attack_1_anim():
	animated_sprite.play("attack_1")
	attacking = true
func stop_attack_1_anim():
	attacking = false

func play_attack_2_anim():
	animated_sprite.play("attack_main")
	attacking = true
func stop_attack_2_anim():
	attacking = false
func handle_jump():
	#animated_sprite.play("jump")
	velocity.y = JUMP_VELOCITY
	#print('whynojump')
	
func heal():
	health = 100
	print("healed")
	
func _ready():
	animated_sprite.play("wake")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		jumping = false
		velocity.y += gravity * delta
	
	#if Input.is_action_just_pressed("attack_1") && is_on_floor():
		#animation_player.play("attack_1")
	#if Input.is_action_just_pressed("attack_2") && is_on_floor():
		#animation_player.play("attack_2")
	if Input.is_action_just_pressed("attack_secondary"):
		#animation_player.play("attack_secondary")
		#attacking = true
		pass
	if Input.is_action_just_pressed("attack_main"):
		animation_player.play("attack_main")
		attacking = true

	# Handle jump.
	if Input.is_action_just_pressed("jump") && !attacking:
		if ray_cast_2d.is_colliding() or is_on_floor():
			jumping = true
			animation_player.play("jump")
			if ray_cast_2d.is_colliding():
				pass
				#print('yeh collide')
		#velocity.y = JUMP_VELOCITY
		#print('jumpin')

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction && attacking && !is_on_floor():
		velocity.x = direction * SPEED
	elif direction && !attacking && is_on_floor():
		velocity.x = direction * SPEED
	elif direction && !is_on_floor():
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	#if direction && !attacking && is_on_floor():
		#animation_player.play("walk")
	#elif !attacking && is_on_floor():
		#animation_player.play('idle')
		
		
	if is_on_floor() && !attacking && !jumping:
		if velocity.x == 0:
			animation_player.play("idle")
		else:
			animation_player.play("walk")

	
		
	if direction > 0 && attacking == false:
		marker_2d.scale.x=1
		#animated_sprite.flip_h = false
	elif direction < 0 && attacking == false:
		marker_2d.scale.x=-1
		#animated_sprite.flip_h = true
	


	move_and_slide()





func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):  # Ensure the player is in the "Player" group
		body.take_damage(attack_damage)  # Call a method on the player, like take_damage
	#body.get_node("CollisionShape2D").queue_free()


func _on_animation_player_animation_finished(anim_name):
	animation_player.play('idle')
	

