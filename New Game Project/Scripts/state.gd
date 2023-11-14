extends Node

var current_health = 50
var max_health = 50
var damage = 20

var enemy_type
var defeated_enemy
var defeated_enemies = []

var playerx = null
var playery = null

func save_position(x, y):
	playerx = x
	playery = y


func remove_enemy():
	defeated_enemies.insert(0, defeated_enemy)
