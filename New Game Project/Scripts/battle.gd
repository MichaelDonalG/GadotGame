extends Control

signal textbox_closed

var enemy:Resource = load("res://"+State.enemy_type+".tres")

var current_player_health = 0
var current_enemy_health = 0
var is_defending = false
var paused = 0

func _ready():
	set_health($PlayerPanel/PlayerData/ProgressBar, State.current_health, State.max_health) 
	set_health($EnemyContainer/VBoxContainer/ProgressBar, enemy.health, enemy.health)
	$EnemyContainer/TextureRect.texture = enemy.texture
	
	current_player_health = State.current_health
	current_enemy_health = enemy.health
	
	$TextBox.hide()
	$ActionsPanel.hide()
	
	display_text("A wild %s appears!" % enemy.name)
	

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health


func _input(event):
	if (Input.is_action_just_pressed("interact") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $TextBox.visible and paused == 0:
		$TextBox.hide()
		$ActionsPanel.show()

func display_text(text):
	$TextBox.show()
	$TextBox/Text.text = text


func enemy_turn():
	display_text("%s attacks" % enemy.name)
	await get_tree().create_timer(1.0). timeout
	
	if is_defending:
		is_defending = false
		current_player_health = max(0, current_player_health - enemy.damage/2)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
		
		$player/AnimationPlayer.play("player_damaged")
		paused = 0
		await($player/AnimationPlayer.animation_finished)
	else:
		current_player_health = max(0, current_player_health - enemy.damage)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
		
		$player/AnimationPlayer.play("player_damaged")
		paused = 0
		await($player/AnimationPlayer.animation_finished)


func _on_run_pressed():
	display_text("Got away safely")
	await(get_tree().create_timer(0.5).timeout)
	State.current_health = current_player_health
	get_tree().change_scene_to_file("res://Levels/game_level.tscn")


func _on_attack_pressed():
	display_text("You attack")
	paused = 1
	await get_tree().create_timer(1.0). timeout
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($EnemyContainer/VBoxContainer/ProgressBar, current_enemy_health, enemy.health)
	
	$AnimationPlayer.play("enemy_damaged")
	await($AnimationPlayer.animation_finished)
	
	if current_enemy_health <= 0:
		display_text("Enemy defeated!")
		$AnimationPlayer.play("enemy_died")
		await($AnimationPlayer.animation_finished)
		State.current_health = current_player_health
		State.remove_enemy()
		get_tree().change_scene_to_file("res://Levels/game_level.tscn")
	
	enemy_turn()


func _on_defend_pressed():
	is_defending = true
	
	display_text("You defend")
	paused = 1
	await get_tree().create_timer(1.0). timeout
	
	enemy_turn()
