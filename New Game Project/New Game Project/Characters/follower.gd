extends CharacterBody2D



@onready var state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(_delta):
	move_and_slide()
	
	pick_new_state()


func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
