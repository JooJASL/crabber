extends Control

export(PackedScene) var arcade_game
export(PackedScene) var classic_game


func _on_Arcade_pressed():
	var res := get_tree().change_scene_to(arcade_game)
	if res != OK:
		print("Error changing scene to arcade_game")


func _on_Classic_pressed():
	var res := get_tree().change_scene_to(classic_game)
	if res != OK:
		print("Error changing scenes to classic_game")


func _on_Credits_pressed():
	pass # Replace with function body.


func _on_Settings_pressed():
	pass # Replace with function body.

