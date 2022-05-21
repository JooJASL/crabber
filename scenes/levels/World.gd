class_name GameWorlds
extends Node2D
tool # So editor warnings become enabled.

# difficulty_scaler describes by how much the spawning intervals for
# both types of items will be changed. 
#
# Although not intended, negative values can be used to increase interval of spawns.
export(float) var difficulty_scaler := 0.3
export(float) var start_game_interval := 3.0
export(float) var upper_spawn_interval := 3.0
export(float) var downer_spawn_interval := 3.0
export(float, 0, 1) var randomize_spawn_intervals := 0.25


# How much Player gains for surviving, per second. Defaults to 1. Can be negative.
export(int) var survival_value := 1
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
	player.set_score(player_initial_score)
	

	# Setting up timers. Programatically so it's less work making more levels.
	start_timer = Timer.new()
	start_timer.wait_time = start_game_interval
	start_timer.one_shot = true
	start_timer.connect("timeout", self, "start_game")
	add_child(start_timer)
	
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
	print("new_game")
	player.score = 0
	player.global_position = $StartPosition.global_position
	_countdown(start_timer.wait_time)
	start_timer.start()


func start_game() -> void:
	print("start_game timeout")
	player.get_node("ScoreTimer").start()
	upper_timer.start()
	downer_timer.start()


## spawn_downer spawns falling objects that either decrease the player's score
## and other negative stuff.
func spawn_downer():
	print("spawn_downer timeout")
	var downer = downer_scene.instance()
	
	downer.global_position.x = rand_range(0, OS.get_real_window_size().x - 50) # 50 arbitrary
	downer.global_position.y = rand_range(10, 50) # arbitrary numbersr
	add_child(downer)
	
	downer_timer.wait_time = rand_range(downer_spawn_interval - (downer_spawn_interval * 0.25), downer_spawn_interval + (downer_spawn_interval * 0.25))
	


## spawn_upper spawns falling objects that either increase the score of the
## player or are helpful in some other way.
func spawn_upper():
	print("spawn_upper timeout")	
	var upper = upper_scene.instance()
	
	upper.global_position.x = rand_range(0, OS.get_real_window_size().x - 50) # the 50 is arbitrary
	upper.global_position.y = rand_range(10, 80) # arbitrary numbersr
	add_child(upper)
	
	upper_timer.wait_time = rand_range(upper_spawn_interval - (upper_spawn_interval * 0.25), upper_spawn_interval + (upper_spawn_interval * 0.25))	
	

func increase_difficulty() -> void:
	upper_spawn_interval -= difficulty_scaler
	downer_spawn_interval -= difficulty_scaler



func _countdown(seconds: float):
	
	if $CountdownLabel.visible == false:
		$CountdownLabel.show()
		
	$CountdownLabel.text = str(seconds)
	
	
	if seconds <= 0:
		$CountdownLabel.hide()
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





