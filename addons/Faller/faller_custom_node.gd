tool
extends EditorPlugin

func _enter_tree():
    add_custom_type("Faller", "RigidBody2D", preload("faller.gd"), preload("faller_icon.png"))


func _exit_tree():
    remove_custom_type("Faller")