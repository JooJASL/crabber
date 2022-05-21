## GameWorlds
# The manager of the game loop. Handles both instancing falling items, as well as all the timers and the 
# system of increasing difficulty.
class_name GameWorlds
extends Node2D
tool # So editor warnings become enabled.

# difficulty_scaler describes by how much the spawning intervals for
# both types of items will be changed. 
#
# Although not intended, negative values can be used to increase interval of spawns.
export(float) var difficulty_scaler := 0.2
export(float) var start_game_interval := 3.0
export(float) var upper_spawn_interval := 3.0
export(float) var downer_spawn_interval := 3.0
export(float, 0, 1) var randomize_spawn_intervals := 0.25


# How much Player gains for surviving, per second. Defaults to 1. Can be negative.
export(int) var survival_value := 1
export(int) var player_initial_lives := 3
export(int) var player_initial_score := 0


export(PackedScene) var upper_scene
export(PackedScene) var downer_scene


var difficulty_timer: Timer
var start_timer: Timer
var downer_timer: Timer
var upper_timer: Timer


onready var player := find_node("Player")


func _ready():
	randomize()
	player.survival_gain_rate = survival_value
	player.score = player_initial_score
	
	downer_timer = Timer.new()
	downer_timer.wait_time = rand_range(downer_spawn_interval - (downer_spawn_interval * 0.25), downer_spawn_interval + (downer_spawn_interval * randomize_spawn_intervals))
	downer_timer.connect("timeout", self, "spawn_downer")
	add_child(downer_timer)
	
	upper_timer = Timer.new()
	upper_timer.wait_time = rand_range(upper_spawn_interval - (upper_spawn_interval * 0.25), upper_spawn_interval + (upper_spawn_interval * randomize_spawn_intervals))	
	upper_timer.connect("timeout", self, "spawn_upper")
	add_child(upper_timer)

	difficulty_timer = Timer.new()
	difficulty_timer.wait_time = 15
	difficulty_timer.connect("timeout", self, "increase_difficulty")
	add_child(difficulty_timer)
	
	new_game()


func new_game() -> void:
	player.score = player_initial_score
	player.lives = player_initial_lives
	player.global_position = $StartPosition.global_position
	_countdown(3)


func start_game() -> void:
	player.get_node("ScoreTimer").start()
	upper_timer.start()
	downer_timer.start()


## spawn_downer spawns falling objects that either decrease the player's score
## and other negative stuff.
func spawn_downer():
	var downer = downer_scene.instance()
	
	downer.global_position.x = rand_range(0, OS.get_real_window_size().x - 50) # 50 arbitrary
	downer.global_position.y = rand_range(10, 50) # arbitrary numbersr
	add_child(downer)
	
	downer_timer.wait_time = rand_range(downer_spawn_interval - (downer_spawn_interval * 0.25), downer_spawn_interval + (downer_spawn_interval * 0.25))
	


## spawn_upper spawns falling objects that either increase the score of the
## player or are helpful in some other way.
func spawn_upper():
	var upper = upper_scene.instance()
	
	upper.global_position.x = rand_range(0, OS.get_real_window_size().x - 50) # the 50 is arbitrary
	upper.global_position.y = rand_range(10, 80) # arbitrary numbersr
	add_child(upper)
	
	upper_timer.wait_time = rand_range(upper_spawn_interval - (upper_spawn_interval * 0.25), upper_spawn_interval + (upper_spawn_interval * 0.25))	
	

func increase_difficulty() -> void:
	upper_spawn_interval -= difficulty_scaler
	downer_spawn_interval -= difficulty_scaler


func _countdown(seconds: float):
	$CountdownLabel.text = str(seconds)

	if $CountdownLabel.visible == false:
		$CountdownLabel.show()
	
	if seconds <= 0:
		$CountdownLabel.hide()
		start_game()
		return	
	
	yield(get_tree().create_timer(seconds), "timeout")
	_countdown(seconds - 1)


func _on_ItemDestroyer_body_entered(body):
	body.queue_free()


func _get_configuration_warning():
	if get_node_or_null("StartPosition") == null:
		return "A StartPosition (Position2D) node is required."
	
	if upper_scene == null:
		return "Must select a scene to be \"upper\""
	
	if downer_scene == null:
		return "Must select a scene to be \"downer\""
	
	if get_node_or_null("CountdownLabel") == null:
		return "Must have a label named 'CountdownLabel'"
			
	return "" # if nothing's wrong.





