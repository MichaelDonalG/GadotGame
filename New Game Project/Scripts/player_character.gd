extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0,1)
#parameters/Idle/blend_position

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

@onready var all_interactions = []
@onready var interactLabel = $InteractionComponents/InteractLabel

func _ready():
	update_animation_paramaeters(starting_direction)
	if (State.playerx != null):
		position.x = State.playerx
		position.y = State.playery
		State.playerx = null
		State.playery = null



#########################Player Movement#########################

func _physics_process(_delta):
	# Get input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	if Input.is_action_just_pressed("interact"):
		execute_interaction()
	
	update_animation_paramaeters(input_direction)
	
	#print(input_direction)
	# Update velocity
	velocity = input_direction * move_speed
	# Move and slide function uses velocity of character body to move character on map
	move_and_slide()
	
	pick_new_state()

func update_animation_paramaeters(move_inpt: Vector2):
	if(move_inpt != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_inpt)
		animation_tree.set("parameters/Idle/blend_position", move_inpt)


func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

#########################Inteactions#########################

func _on_interaction_area_area_entered(area):
	all_interactions.insert(0, area)
	update_interactions()


func _on_interaction_area_area_exited(area):
	all_interactions.erase(area)
	update_interactions()

func update_interactions():
	if all_interactions:
		interactLabel.text = all_interactions[0].interact_label
	else:
		interactLabel.text = ""

func execute_interaction():
	if all_interactions:
		var cur_interaction = all_interactions[0]
		match  cur_interaction.interact_type:
			"chest" : 
				interactLabel.text = "Empty..."
				

