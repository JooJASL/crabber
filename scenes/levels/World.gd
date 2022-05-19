class_name GameWorlds
extends Node2D

## How much Player gains for surviving, per second. Defaults to 1. Can be negative.
export(int) var survival_value := 1
export(int) var player_initial_score := 0

onready var player := find_node("Player")

func _ready():
	player.survival_gain_rate = survival_value
	player.set_score(player_initial_score)
