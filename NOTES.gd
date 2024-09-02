extends Node

# https://gamedev.stackexchange.com/questions/202912/godot-parallax-background-is-not-covering-the-entire-screen
#FIXING PARALLAX NOT TILING

######
	
	#if not material_sounds.has(current_material):
		#print("Material not found: " + current_material)
		#return
#
	#var footstep_sounds = material_sounds[current_material]
	#if footstep_sounds.size() == 0:
		#print("No sounds available for material: " + current_material)
		#return
#
	## Play a random footstep sound from the array
	#var sound = footstep_sounds[randi() % footstep_sounds.size()]
	#var audio_player = AudioStreamPlayer2D.new()
	#add_child(audio_player)
	#audio_player.stream = sound
	#audio_player.play()
#
	## Queue free the audio player after the sound finishes
	#var sound_duration = audio_player.stream.get_length()
	#var timer = Timer.new()
	#timer.set_wait_time(sound_duration)
	#timer.set_one_shot(true)
	#add_child(timer)
	#
	#timer.start()
	#timer.timeout.connect(func() -> void:
		#audio_player.queue_free()
		#timer.queue_free()
	#)
	
	#####
	



#func play_footstep(): # should this have a material? how often do you NOT have footstep materials?
	#if footstep_sounds.size() == 0:
		#print("No footstep sounds available.")
		#return
	#
	## Get the next footstep sound
	#var sound = footstep_sounds[current_footstep_index]
	## Create and play the audio
	#var audio_player = AudioStreamPlayer2D.new()
	#add_child(audio_player)
	#audio_player.stream = sound
	#
	## Handles varying footstep pitch, useful to differentiate left-right if the source samples don't.
	#if should_vary_footstep_pitches:
		#if current_footstep_index % 2 == 0:
			#audio_player.pitch_scale = 1.05
		#else:
			#audio_player.pitch_scale = .95
	#
	#audio_player.max_distance = max_distance
	#
	#if footstep_sounds_volume:
		#audio_player.volume_db = footstep_sounds_volume
#
	#audio_player.play()
	#
	## Schedule removal after playing
	#var sound_duration = audio_player.stream.get_length()
	#var timer = Timer.new()
	#timer.set_wait_time(sound_duration)
	#timer.set_one_shot(true)
	#add_child(timer)
	#
	#timer.start()
	#timer.timeout.connect(func() -> void:
		#audio_player.queue_free()
		#timer.queue_free()
	#)
#
	## Update index to use the next sound
	#current_footstep_index = (current_footstep_index + 1) % footstep_sounds.size()
