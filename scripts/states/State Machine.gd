extends Node

@export var initial_state : State

var current_state : State
var states : Dictionary = {}
#@export var audio_manager: Node2D

# Parent state script (e.g., StateMachine.gd)



func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
			
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
			

			
func _process(delta):
	if current_state:
		current_state.Update(delta)
		
func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)
		

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	
	current_state = new_state

#############

##########


func change_state(new_state_name):
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	
	current_state = new_state
	
	#current_state = new_state
	#new_state.Enter()
	#match new_state:
		#"idle":
			## Idle state logic
			#pass
		#"damaged":
			## Play damaged animation or effect
			#pass
		#"dead":
			## Handle death (play death animation or effects)
			#pass
