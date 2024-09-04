extends CharacterBody2D


const JUMP_VELOCITY = -400.0
var health = 100
var state_machine

@onready var audio_manager = $AudioManager

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation_player = $Marker2D/AnimationPlayer
@onready var marker_2d = $Marker2D
@onready var ray_cast_right = $CollisionShape2D/ray_cast_right
@onready var ray_cast_left = $CollisionShape2D/ray_cast_left
var gravity_enabled: bool = true

var direction = -1

func _ready():
	# Assuming the state machine is a child node of the enemy
	state_machine = $State  # Adjust the path if necessary

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() && gravity_enabled:
		velocity.y += gravity * delta
	
	if velocity.x > 0:
		marker_2d.scale.x=1
	elif velocity.x < 0:
		marker_2d.scale.x=-1
	else:
		pass

	move_and_slide()

func take_damage(damage_amount):
	health -= damage_amount
	if health <= 0:
		state_machine.change_state("EnemyDeath")
	else:
		state_machine.change_state("EnemyHit")
