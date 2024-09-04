extends Node2D

@onready var audio_manager = $AudioManager
@onready var collision_shape_2d = $Main/Area2D/CollisionShape2D
@onready var sprite_2d = $Main/Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):  # Ensure the player is in the "Player" group
		sprite_2d.visible = false
		collision_shape_2d.set_deferred("disabled",true)
		body.heal()
		#audio_manager.play_sound_custom("consumed")
		var audio_player = audio_manager.play_sound_custom("consumed")
		audio_player.finished.connect(func() -> void:
			queue_free()
		)
