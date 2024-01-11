extends Node

var current_health = 50
var max_health = 50
var damage = 20

var enemy_type1
var enemy_type2


var enemy1:Resource
var enemy2:Resource

var defeated_enemy
var defeated_enemies = []

var playerx = null
var playery = null

func save_position(x, y):
	playerx = x
	playery = y


func remove_enemy():
	defeated_enemies.insert(0, defeated_enemy)

func load_enemy():
	enemy1 = load("res://Characters/"+enemy_type1+".tres")
	
	if  enemy_type2 != "null":
		enemy2 = load("res://Characters/"+enemy_type2+".tres")
