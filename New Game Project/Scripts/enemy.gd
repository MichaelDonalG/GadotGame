extends CharacterBody2D


@export var move_speed : float = 20
@export var idle_time : float = randi_range(1,5)
@export var walk_time : float = randi_range(1,2)
@export var dialogue = ""
@export var enemy_type = "cow"
@export var enemy_num = 0

@onready var animation_tree = $AnimationTree
@onready var state_machince = animation_tree.get("parameters/playback")
@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var interactable = 0

var move_direction : Vector2 = Vector2.ZERO
var current_state = "idle"

func _ready():
	if(State.defeated_enemies.has(enemy_num)):
		queue_free()
	pick_new_state()
	$Interactable/CollisionShape2D.disabled = true
	await(get_tree().create_timer(2).timeout)
	$Interactable/CollisionShape2D.disabled = false
	


func _physics_process(_delta):
	if(current_state == "walk"):	
		velocity = move_direction * move_speed
		move_and_slide()

func select_new_direction():
	move_direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)
	
	if(move_direction.x < 0):
		sprite.flip_h = true
	elif (move_direction.x >0):
		sprite.flip_h = false

func pick_new_state():
	if(current_state == "idle"):
		state_machince.travel("Walk")
		current_state = "walk"
		select_new_direction()
		timer.start(walk_time)
	elif(current_state == "walk"):
		state_machince.travel("Idle")
		current_state = "idle"
		timer.start(idle_time)



func _on_timer_timeout():
	pick_new_state()


func _on_interactable_area_entered(area):
	State.save_position(position.x, position.y)
	State.enemy_type = enemy_type
	State.defeated_enemy = enemy_num
	get_tree().change_scene_to_file("res://Levels/battle.tscn")
