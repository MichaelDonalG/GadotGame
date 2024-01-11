extends Control

signal textbox_closed

var enemy1 = State.enemy1
var enemy2 = State.enemy2

var enemyX = -70
var enemyY = 60

var current_player_health = 0
var enemy1_health = 0
var enemy2_health = 0
var is_defending = false
var paused = 0

func _ready():
	
	
	####SET PLAYER START####
	set_health($PlayerPanel/PlayerData/ProgressBar, State.current_health, State.max_health) 
	
	current_player_health = State.current_health
	
	####SET PLAYER COMPLETE####
	####SET ENEMY START####
	set_health($EnemyContainer/VBoxContainer/ProgressBar, enemy1.health, enemy1.health)
	$EnemyContainer/AttackEnemy1.texture_normal = enemy1.texture
	
	enemy1_health = enemy1.health
	
	
	if enemy2 != null:
		enemyY = enemyY/5
		$EnemyContainer2.position = Vector2(enemyX, enemyY*5)
		
		set_health($EnemyContainer2/VBoxContainer/ProgressBar, enemy2.health, enemy2.health)
		$EnemyContainer2/AttackEnemy2.texture_normal = enemy2.texture
		
		enemy2_health = enemy2.health
		
		$EnemyContainer2/VBoxContainer/ProgressBar.visible = true
	
	$EnemyContainer.position = Vector2(enemyX,enemyY)
	####SET ENEMY COMPLETE####
	$TextBox.hide()
	$ActionsPanel.hide()
	
	display_text("A wild %s appears!" % enemy1.name)
	

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
	
	####ENEMY 1 ATTACKS####
	if enemy1_health > 0:
		
		display_text("%s attacks" % enemy1.name)
		await get_tree().create_timer(1.0). timeout
		
		if is_defending:
			is_defending = false
			current_player_health = max(0, current_player_health - enemy1.damage/2)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
			
			$player/AnimationPlayer.play("player_damaged")
			paused = 0
			await($player/AnimationPlayer.animation_finished)
		else:
			current_player_health = max(0, current_player_health - enemy1.damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
			
			$player/AnimationPlayer.play("player_damaged")
			paused = 0
			await($player/AnimationPlayer.animation_finished)
	
	####ENEMY 2 ATTACKS####
	if enemy2_health > 0:
		display_text("%s attacks" % enemy2.name)
		await get_tree().create_timer(1.0). timeout
		
		if is_defending:
			is_defending = false
			current_player_health = max(0, current_player_health - enemy2.damage/2)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
			
			$player/AnimationPlayer.play("player_damaged")
			paused = 0
			await($player/AnimationPlayer.animation_finished)
		else:
			current_player_health = max(0, current_player_health - enemy2.damage)
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
	paused = 1
	display_text("Choose target")
	$EnemyContainer/AttackEnemy1.disabled = false
	$EnemyContainer2/AttackEnemy2.disabled = false

func _on_defend_pressed():
	is_defending = true
	
	display_text("You defend")
	paused = 1
	await get_tree().create_timer(1.0). timeout
	
	enemy_turn()


func _on_attack_enemy_1_pressed():
	####ATTACK COMMENCES####
	display_text("You attack")
	await get_tree().create_timer(1.0). timeout
	
	enemy1_health = max(0, enemy1_health - State.damage)
	set_health($EnemyContainer/VBoxContainer/ProgressBar, enemy1_health, enemy1.health)
	
	$AnimationPlayer.play("enemy1_damaged")
	await($AnimationPlayer.animation_finished)
	
	if enemy1_health <= 0:
		display_text("Enemy defeated!")
		$AnimationPlayer.play("enemy1_died")
		await($AnimationPlayer.animation_finished)
		$EnemyContainer.hide()
	
	
	check_if_victory()


func _on_attack_enemy_2_pressed():
	####ATTACK COMMENCES####
	display_text("You attack")
	await get_tree().create_timer(1.0). timeout
	
	enemy2_health = max(0, enemy2_health - State.damage)
	set_health($EnemyContainer2/VBoxContainer/ProgressBar, enemy2_health, enemy2.health)
	
	$AnimationPlayer.play("enemy2_damaged")
	await($AnimationPlayer.animation_finished)
	
	if enemy2_health <= 0:
		display_text("Enemy defeated!")
		$AnimationPlayer.play("enemy2_died")
		await($AnimationPlayer.animation_finished)
		$EnemyContainer2.hide()
	
	check_if_victory()


func check_if_victory():
	if enemy1_health <=0 && enemy2_health <= 0:
		State.current_health = current_player_health
		State.remove_enemy()
		get_tree().change_scene_to_file("res://Levels/game_level.tscn")
	else:
		enemy_turn()
