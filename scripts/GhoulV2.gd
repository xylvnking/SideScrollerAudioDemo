extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0
var health = 100
var state_machine


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation_player = $Marker2D/AnimationPlayer
@onready var marker_2d = $Marker2D
@onready var ray_cast_right = $CollisionShape2D/ray_cast_right
@onready var ray_cast_left = $CollisionShape2D/ray_cast_left

var direction = -1

func _ready():
	# Assuming the state machine is a child node of the enemy
	state_machine = $State  # Adjust the path if necessary

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#if velocity.length() > 0:
		#animation_player.play("walk")
	#
	
	if velocity.x > 0:
		marker_2d.scale.x=1
	elif velocity.x < 0:
		marker_2d.scale.x=-1
	else:
		pass

	#position.x += direction *  SPEED * delta
	#velocity.x = direction * SPEED
	
	#if ray_cast_right.is_colliding():
		#direction = -1
	#if ray_cast_left.is_colliding():
		#direction = 1
	
	move_and_slide()

func take_damage(damage_amount):
	#print('should take damage')
	health -= damage_amount
	#if health <= 0:
		#die()
	#else:
	#state_machine.current_state.Transitioned.emit(self, "EnemyHit")  # Calls state change from state machine script
	state_machine.change_state("EnemyHit")

func die():
	#state_machine.change_state("dead")  # Switches to dead state
	queue_free()  # Destroys the enemy
