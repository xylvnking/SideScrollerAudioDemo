extends Node
class_name State

# https://youtu.be/ow_Lum-Agbs

signal Transitioned

func Enter():
	pass
	
func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	pass

#func on_child_transition(state, new_state_name):
	#if state != current_state:
		#return
	#
	#var new_state = states.get(new_state_name.to_lower())
	#if !new_state:
		#return
		#
	#if current_state:
		#current_state.exit()
		#
	#new_state.enter()
	#
	#current_state = new_state
