class_name Player
extends KinematicBody2D

signal died()

# Amount of Player lives. Set to -69 to disable the label.
export(int) var lives := 3 setget set_lives
export(int) var speed = 200
export(float) var gravity = 90

onready var score_label := $CanvasLayer/GUI/Score

var survival_gain_rate := 1


var score := 0 setget set_score, get_score

func get_score():
	return score


func set_score(value):
	score = value
	score_label.text = str(score)


func _ready():
	if lives == -69:
		$CanvasLayer/GUI/Lives.hide()


func _physics_process(_delta):
	movement()
	wrap_around_screen()


func _input(event):
	if event is InputEventScreenTouch:
		_enable_android_controls()
	elif event is InputEventKey:
		_disable_android_controls()


func _disable_android_controls():
	$InputControl/Left.hide()
	$InputControl/Right.hide()


func _enable_android_controls():
	$InputControl/Left.show()
	$InputControl/Right.show()


func movement() -> Vector2:
	var input_direction := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		gravity
	)
	
	input_direction.x *= speed
	
	
	return move_and_slide(input_direction)


func wrap_around_screen() -> void:
	if global_position.x <= -20:
		global_position.x = OS.window_size.x
	
	if global_position.x >= OS.window_size.x + 20:
		global_position.x = 0


func _on_Collector_body_entered(body: Faller):
	if body is Faller:
		body.queue_free()
		body.special_effect(self)


func _on_ScoreTimer_timeout():
	set_score(score + survival_gain_rate)


func set_lives(value):
	if value < 0:
		emit_signal("died")
		value = 0
	
	lives = value
	$CanvasLayer/GUI/Lives.text = str(lives)
