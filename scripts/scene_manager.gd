class_name SceneManager
extends Node

@export var game_scenes: Array[PackedScene] = []

var last_scene: int = 0
var current_scene: int = 0

func load_scene(scene: int):
	last_scene = current_scene
	current_scene = scene
	get_tree().change_scene_to_packed(game_scenes[scene])
