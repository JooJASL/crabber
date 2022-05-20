class_name Player
extends KinematicBody2D

signal died()

export(int) var speed = 200
export(float) var gravity = 9.8

var survival_gain_rate := 1

onready var score_label := $CanvasLayer/GUI/Score

var score := 0

func set_score(value):
	score = value
	score_label.text = str(score)

func get_score():
	return score

func _physics_process(delta):
	movement()


func movement() -> Vector2:
	var input_direction := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		gravity
	)
	
	input_direction.x *= speed
	
	
	return move_and_slide(input_direction)


func _on_Collector_body_entered(body: FallingItem):
	if body is FallingItem:
		body.queue_free()
		set_score(score + body.score_value)


func _on_ScoreTimer_timeout():
	print("scoretimer_timeout")
	set_score(score + survival_gain_rate)
