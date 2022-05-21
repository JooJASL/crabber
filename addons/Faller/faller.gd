class_name Faller
extends RigidBody2D


export(int) var damage := 0
export(int) var collection_value := 3


func special_effect(player):
    player.lives -= damage
    player.score += collection_value
