class_name Interactable extends Area2D

@export var interact_label = "none"
@export var interact_type = "none"
@export var interact_value = "none"

@onready var interactable = 0
@onready var collision_box = $Sprite2D/StaticBody2D/CollisionShape2D


func _physics_process(delta):
	if Input.is_action_just_pressed("interact"):
		if interactable:
			$AnimationPlayer.play("opening")
			if (interact_type == "door"):
				collision_box.disabled = true
				get_tree().change_scene_to_file(interact_value)


func _on_area_entered(area):
	interactable = 1



func _on_area_exited(area):
	interactable = 0
