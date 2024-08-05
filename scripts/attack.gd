class_name Attack
extends Area2D

@onready var melee_area_animated_sprite: AnimatedSprite2D = $melee_area_attack
@onready var melee_precise_animated_sprite: AnimatedSprite2D
@onready var ranged_area_animated_sprite: AnimatedSprite2D

#@onready var melee_area: Area2D = $melee_area
#@onready var melee_precise

#@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_player_player_attacks(attack_info):
	pass
